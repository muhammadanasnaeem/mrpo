package model
{
	import businessobjects.BondBO;
	import businessobjects.ExchangeBO;
	import businessobjects.MarketBO;
	import businessobjects.SymbolBO;
	import businessobjects.SymbolOrderLimitBO;
	
	import common.Constants;
	import common.Messages;
	import common.States;
	
	import components.ComboBoxItem;
	
	import controller.ModelManager;
	import controller.ProfileManager;
	import controller.WindowManager;
	
	import flash.external.ExternalInterface;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.messaging.ChannelSet;
	import mx.messaging.Consumer;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.channels.StreamingAMFChannel;
	import mx.messaging.config.ServerConfig;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.LSListener;
	import services.QWClient;
	
	import view.MarketScheduleControl;

	public class ExchangeModel implements IModel
	{
		private var isDirty_:Boolean=true;

		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}

		private var selectedExchangeID_:Number=-1;

		[Bindable]
		public function get selectedExchangeID():Number
		{
			return selectedExchangeID_;
		}

		public function set selectedExchangeID(value:Number):void
		{
			selectedExchangeID_=value;
		}

		private var exchanges_:ArrayList=new ArrayList();

		[Bindable]
		public function get exchanges():ArrayList
		{
			return exchanges_;
		}

		public function set exchanges(value:ArrayList):void
		{
			exchanges_=value;
		}

		public function ExchangeModel()
		{
		}

		public function execute():void
		{
			QWClient.getInstance().getExchanges();
			isDirty=false;
		}

		public function getexchangeMarkets(internalExchangeID:Number):ArrayList
		{
			var markets:ArrayList=new ArrayList();
			for (var j:int=0; j < exchanges.length; ++j)
			{
				var ex:ExchangeBO=exchanges.getItemAt(j) as ExchangeBO;
				if (ex.INTERNAL_EXCHANGE_ID == internalExchangeID)
				{
					for (var i:int=0; i < ex.markets.length; ++i)
					{
						var obj:Object=ex.markets.getItemAt(i);
						//var cbi:ComboBoxItem = new ComboBoxItem(obj.MARKET_ID.toString(), obj.MARKET_CODE);
						var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_MARKET_ID.toString(), obj.MARKET_CODE);
						markets.addItem(cbi);
					}

					break;
				}
			}
			return markets;
		}

		public function onResult(event:ResultEvent):void
		{
			try
			{
				var modelManager:ModelManager=ModelManager.getInstance();
				var ebo:ExchangeBO=null;
				if (event.result)
				{
					if (event.result.length)
					{
						for each (var obj:Object in event.result)
						{
							ebo=fillExchangeBO(obj, new ExchangeBO());
							exchanges.addItem(ebo);
							modelManager.distinctModel.exchanges.put(ebo.EXCHANGE_CODE, ebo.EXCHANGE_ID.toString());
						}
					}
					else
					{
						ebo=fillExchangeBO(event.result, new ExchangeBO());
						exchanges.addItem(ebo);
						modelManager.distinctModel.exchanges.put(ebo.EXCHANGE_CODE, ebo.EXCHANGE_ID.toString());
					}

					modelManager.remainingOrdersModel.isDirty=true;
					//ModelManager.getInstance().remainingOrdersModel.isInit = true;

					// added on 2/2/2011 to empty Market Watch Window before profile loading
//					modelManager.marketWatchModel.clearMarketWatchWindow();

					//modified on 13/12/2010 to resolve empty exchange list on relogin  
					ProfileManager.getInstance().loadProfile();
					modelManager.updateRemainingOrders();
					modelManager.exchangeScheduleModel.isDirty=true;
					modelManager.updateExchangeSchedule();
				}
				// Start : temp added for BlazeDS
//			var myStreamingAMF:AMFChannel = new StreamingAMFChannel("my-streaming-amf", "/QWService/messagebroker/streamingamf");
//			
//			//var myStreamingAMF:AMFChannel = ServerConfig.getChannel("my-streaming-amf") as StreamingAMFChannel;
//			//myStreamingAMF.
//			var channelSet:ChannelSet = new ChannelSet();
//			channelSet.addChannel(myStreamingAMF);
//			
//			var consumer:Consumer = new Consumer();
//			consumer.channelSet = channelSet;
//			consumer.destination = "annFeedDestination";//itemName;
//			consumer.addEventListener
//				(MessageEvent.MESSAGE, WindowManager.getInstance().viewManager.marketSchedule.handleMarketMessageBlazeDS);
//			consumer.addEventListener
//				(MessageFaultEvent.FAULT, WindowManager.getInstance().viewManager.marketSchedule.handleMarketMessageFaultBlazeDS);
//			consumer.subscribe();

				// End : temp added for BlazeDS

				var itemNameUser:String="USER_" + modelManager.userID;
				var announcementItemGroup:Array=new Array();
				var announcementItemGroupStr:String="";
				announcementItemGroup.push(itemNameUser);
				announcementItemGroupStr+=itemNameUser;
				announcementItemGroup.push("Market_Message");
				announcementItemGroupStr+="Market_Message";
				for (var i:uint=0; i < modelManager.exchangeModel.exchanges.length; ++i)
				{
					var e:ExchangeBO=modelManager.exchangeModel.exchanges.getItemAt(i) as ExchangeBO;
					announcementItemGroup.push("EXCHANGE_" + e.INTERNAL_EXCHANGE_ID);
					announcementItemGroupStr+="EXCHANGE_" + e.INTERNAL_EXCHANGE_ID;
				}

				LSListener.getInstance().subscribeItem(
					announcementItemGroup,
					LSListener.fieldSchemaMarketMessage,
					LSListener.getInstance().lsClientMarketMessage,
					WindowManager.getInstance().viewManager.marketSchedule.handleMarketMessage);
				if (!ModelManager.getInstance().subscribedItems.hasKey(announcementItemGroupStr))
				{
					ModelManager.getInstance().subscribedItems.put(announcementItemGroupStr, announcementItemGroupStr);
					ExternalInterface.call("subscribeItem", Constants.ANNOUNCEMENT_FEED_DATA_ADAPTER, "tblAnnouncements_1", announcementItemGroup, "fieldSchemaMarketMessage", "handleMarketMessage", ProfileManager.getInstance().userName, ProfileManager.getInstance().password);
				}
			}
			catch (e:Error)
			{
				trace('' + e.toString());
			}
			CursorManager.removeBusyCursor();
		}

		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}

		public function getExchangeID(internalExchangeID:Number):Number
		{
			var exchangeID:Number=-1;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.INTERNAL_EXCHANGE_ID == internalExchangeID)
				{
					exchangeID=ex.EXCHANGE_ID;
					break;
				}
			}
			return exchangeID;
		}

		public function getExchangeCode(internalExchangeID:Number):String
		{
			var exchangeName:String="";
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.INTERNAL_EXCHANGE_ID == internalExchangeID)
				{
					exchangeName=ex.EXCHANGE_CODE;
					break;
				}
			}
			return exchangeName;
		}

		// added on 12/1/2011
		public function getExchangeByID(exchangeID:Number):String
		{
			var exchangeName:String="";
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.EXCHANGE_ID == exchangeID)
				{
					exchangeName=ex.EXCHANGE_CODE;
					break;
				}
			}
			return exchangeName;
		}

		public function getInternalExchangeID(exchangeID:Number):Number
		{
			var internalExchangeID:Number;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.EXCHANGE_ID == exchangeID)
				{
					internalExchangeID=ex.INTERNAL_EXCHANGE_ID;
					break;
				}
			}
			return internalExchangeID;
		}

		public function getMarketID(internalExchangeID:Number, internalMarketID:Number):Number
		{
			var marketID:Number=-1;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.INTERNAL_MARKET_ID == internalMarketID)
						{
							marketID=mkt.MARKET_ID;
							break;
						}
					}
				}
			}
			return marketID;
		}

		public function getMarketState(internalExchangeID:Number, internalMarketID:Number):Number
		{
			var mktState:Number=-1;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.INTERNAL_MARKET_ID == internalMarketID)
						{
							mktState=mkt.STATE;
							break;
						}
					}
				}
			}
			return mktState;
		}

		//addded on 22/12/2010
		public function getMarket(internalExchangeID:Number, internalMarketID:Number):MarketBO
		{
			var marketBO:MarketBO=null;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.INTERNAL_MARKET_ID == internalMarketID)
						{
							marketBO=mkt;
							break;
						}
					}
				}
			}
			return marketBO;
		}

		public function setMarketState(internalExchangeID:Number, internalMarketID:Number, mktState:Number):void
		{
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.INTERNAL_MARKET_ID == internalMarketID)
						{
							mkt.STATE=mktState;
							break;
						}
					}
				}
			}
		}

		public function getMarketCode(internalExchangeID:Number, internalMarketID:Number):String
		{
			var marketName:String="";
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.INTERNAL_MARKET_ID == internalMarketID)
						{
							marketName=mkt.MARKET_CODE;
							break;
						}
					}
				}
			}
			return marketName;
		}

		public function getMarketCodeBYId(exchangeID:Number, marketID:Number):String
		{
			var marketName:String="";
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.EXCHANGE_ID == exchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.MARKET_ID == marketID)
						{
							marketName=mkt.MARKET_CODE;
							break;
						}
					}
				}
			}
			return marketName;
		}

		public function getInternalMarketId(exchangeID:Number, marketID:Number):Number
		{
			var internalMarketId:Number;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.EXCHANGE_ID == exchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.MARKET_ID == marketID)
						{
							internalMarketId=mkt.INTERNAL_MARKET_ID;
							break;
						}
					}
				}
			}
			return internalMarketId;
		}

		public function getSymbol(internalExchangeID:Number, internalMarketID:Number, internalSymbolID:Number):Object
		{
			var symbolBO:Object=null;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.INTERNAL_MARKET_ID == internalMarketID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
//								var sBO:String = symbol.SYMBOL.toUpperCase();
//								if(sBO == internalSymbolID)
//								{
//									symbolBO=symbol;
//									break;
//								}
								if (symbol.INTERNAL_SYMBOL_ID == internalSymbolID)
								{
									symbolBO=symbol;
									break;
								}
								try
								{
									WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text=WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text=WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text=WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text=WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text=WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.eventLog.txtSymbol.text=WindowManager.getInstance().viewManager.eventLog.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text=WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text=WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text=WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text=WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text.toUpperCase()
									WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text=WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text=WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text.toUpperCase();
								}
								catch(e:Error)
								{
									trace(e.message);
								}
							}
						}
					}
				}
			}
			return symbolBO;
		}

		//Start : added on 13/12/2010		
		public function getSymbolDetail(exchangeID:Number, marketID:Number, symbolID:Number):Object
		{
			var symbolBO:Object=null;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.EXCHANGE_ID == exchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.MARKET_ID == marketID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
								if (symbol.SYMBOL_ID == symbolID)
								{
									symbolBO=symbol;
									break;
								}
							}
						}
					}
				}
			}
			return symbolBO;
		}

		//End : added on 13/12/2010

		public function getSymbolByCode(internalExchangeID:Number, internalMarketID:Number, symbolCode:String,fromTextField:Boolean=false):Object
		{
			var symbolBO:Object=null;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.INTERNAL_MARKET_ID == internalMarketID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
								var sBO:String = symbol.SYMBOL.toUpperCase();
								
								if (symbol.SYMBOL == symbolCode)
								{
									symbolBO=symbol;
									break;
								}
								if(sBO == symbolCode)
								{
									symbolBO=symbol;
									break;
								}
								try
								{
									WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text=WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text=WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text=WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text=WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text=WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.eventLog.txtSymbol.text=WindowManager.getInstance().viewManager.eventLog.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text=WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text=WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text=WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text=WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text.toUpperCase()
									WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text=WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text=WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text.toUpperCase();
								}
								catch(e:Error)
								{
									trace(e.message);
								}
							}
						}
					}
				}
			}
			return symbolBO;
		}

		public function getSymbolID(internalExchangeID:Number, internalMarketID:Number, internalSymbolID:Number):Number
		{
			var symbolID:Number=-1;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.INTERNAL_MARKET_ID == internalMarketID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
								if (symbol.INTERNAL_SYMBOL_ID == internalSymbolID)
								{
									symbolID=symbol.SYMBOL_ID;
									break;
								}
								
							}
						}
					}
				}
			}
//			try
//			{
//				WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text=WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text=WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text=WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text=WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text=WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.eventLog.txtSymbol.text=WindowManager.getInstance().viewManager.eventLog.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text=WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text=WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text=WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text=WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text.toUpperCase()
//				WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text=WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text.toUpperCase();
//				WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text=WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text.toUpperCase();
//			}
//			catch(e:Error)
//			{
//				trace(e.message);
//			}
			return symbolID;
		}

		public function getInternalSymbolIDByCode(internalExchangeID:Number, internalMarketID:Number, symbolCode:String):Number
		{
			var internalSymbolID:Number=-1;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.INTERNAL_MARKET_ID == internalMarketID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
								var sO:String = symbol.SYMBOL.toUpperCase();
								if (symbol.SYMBOL == symbolCode)
								{
									internalSymbolID=symbol.INTERNAL_SYMBOL_ID;
									break;
								}
								if(sO == symbolCode)
								{
									internalSymbolID=symbol.INTERNAL_SYMBOL_ID;
									break;
								}
							}
						}
					}
				}
			}
			return internalSymbolID;
		}

		public function getSymbolCode(internalExchangeID:Number, internalMarketID:Number, internalSymbolID:Number):String
		{
			var symbolCode:String="";
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.INTERNAL_MARKET_ID == internalMarketID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
//								var sBO:String = symbol.SYMBOL.toUpperCase();
//								if(sBO == internalSymbolID)
//								{
//									symbolCode=symbol.SYMBOL;
//									break;
//								}
								if (symbol.INTERNAL_SYMBOL_ID == internalSymbolID)
								{
									symbolCode=symbol.SYMBOL;
									break;
								}
								try
								{
									WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text=WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text=WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text=WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text=WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text=WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.eventLog.txtSymbol.text=WindowManager.getInstance().viewManager.eventLog.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text=WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text=WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text=WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text=WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text.toUpperCase()
									WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text=WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text=WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text.toUpperCase();
								}
								catch(e:Error)
								{
									trace(e.message);
								}
							}
						}
					}
				}
			}
			return symbolCode;
		}

		public function getSymbolState(internalExchangeID:Number, internalMarketID:Number, internalSymbolID:Number):String
		{
			var symbolState:String="";
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.INTERNAL_MARKET_ID == internalMarketID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
								if (symbol.INTERNAL_SYMBOL_ID == internalSymbolID)
								{
									symbolState=symbol.STATE;
									break;
								}
								try
								{
									WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text=WindowManager.getInstance().viewManager.buyOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text=WindowManager.getInstance().viewManager.sellOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text=WindowManager.getInstance().viewManager.cancelOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text=WindowManager.getInstance().viewManager.changeOrder.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text=WindowManager.getInstance().viewManager.liveSymbolChart.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.eventLog.txtSymbol.text=WindowManager.getInstance().viewManager.eventLog.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text=WindowManager.getInstance().viewManager.symbolBrowser.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text=WindowManager.getInstance().viewManager.orderLimitControl.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text=WindowManager.getInstance().viewManager.symbolStateControl.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text=WindowManager.getInstance().viewManager.bestPrices.txtSymbol.text.toUpperCase()
									WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text=WindowManager.getInstance().viewManager.bestOrders.txtSymbol.text.toUpperCase();
									WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text=WindowManager.getInstance().viewManager.symbolSummary.txtSymbol.text.toUpperCase();
								}
								catch(e:Error)
								{
									trace(e.message);
								}
							}
						}
					}
				}
			}
			return symbolState;
		}

		public function setSymbolState(internalExchangeID:Number, internalMarketID:Number, internalSymbolID:Number, symbolState:String):void
		{
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.INTERNAL_MARKET_ID == internalMarketID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
								if (symbol.INTERNAL_SYMBOL_ID == internalSymbolID)
								{
									symbol.STATE=States.getSymbolState(symbolState);
									break;
								}
							}
						}
					}
				}
			}
		}

		public function setSymbolOrderLimit(symbolOrderLimit:SymbolOrderLimitBO):void
		{
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == symbolOrderLimit.INTERNAL_EXCHANGE_ID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.INTERNAL_MARKET_ID == symbolOrderLimit.INTERNAL_MARKET_ID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
								if (symbol.INTERNAL_SYMBOL_ID == symbolOrderLimit.INTERNAL_SYMBOL_ID)
								{
									if (symbolOrderLimit.LIMIT_TYPE == "0") // Price
									{
										symbol.UPPER_CIRCUIT_BREAKER_LIMIT=symbolOrderLimit.UPPER_LIMIT;
										symbol.LOWER_CIRCUIT_BREAKER_LIMIT=symbolOrderLimit.LOWER_LIMIT;
									}
									else if (symbolOrderLimit.LIMIT_TYPE == "1") // Value
									{
										symbol.UPPER_ORDER_VALUE_LIMIT=symbolOrderLimit.UPPER_LIMIT;
										symbol.LOWER_ORDER_VALUE_LIMIT=symbolOrderLimit.LOWER_LIMIT;
									}
									else if (symbolOrderLimit.LIMIT_TYPE == "2") // Volume
									{
										symbol.UPPER_ORDER_VOLUME_LIMIT=symbolOrderLimit.UPPER_LIMIT;
										symbol.LOWER_ORDER_VOLUME_LIMIT=symbolOrderLimit.LOWER_LIMIT;
									}
									break;
								}
							}
						}
					}
				}
			}
		}

		// added on 23/2/2011
		public function isBondMarket(internalExchangeID:Number, internalMarketID:Number):Boolean
		{
			var flag:Boolean=false;
			var symbolBO:Object=null;
			for (var i:int=0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO=exchanges.getItemAt(i) as ExchangeBO;
				if (ex.markets && ex.markets.length && (ex.INTERNAL_EXCHANGE_ID == internalExchangeID))
				{
					for (var j:int=0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO=ex.markets.getItemAt(j) as MarketBO;
						if (mkt.symbols && mkt.symbols.length && (mkt.INTERNAL_MARKET_ID == internalMarketID))
						{
							for (var k:int=0; k < mkt.symbols.length; ++k)
							{
								var symbol:SymbolBO=mkt.symbols.getItemAt(k) as SymbolBO;
								if (symbol.SYMBOL_TYPE == "Bond")
								{
									flag=true;
								}
								return flag;
							}
						}
					}
				}
			}
			return flag;
		}

		/*public function updateMarketSchedule(internalExchangeID:Number, internalMarketID:Number, schedule:Vector):void
		{
			for (var i:int = 0; i < exchanges.length; ++i)
			{
				var ex:ExchangeBO = exchanges.getItemAt(i) as ExchangeBO;
				if ( ex.markets && ex.markets.length && ( ex.INTERNAL_EXCHANGE_ID == internalExchangeID ) )
				{
					for (var j:int = 0; j < ex.markets.length; ++j)
					{
						var mkt:MarketBO = ex.markets.getItemAt(j) as MarketBO;
						if ( mkt.INTERNAL_MARKET_ID == internalMarketID )
						{
							//mkt.schedule = schedule;
						}
					}
				}
			}
		}*/

		private function fillExchangeBO(obj:Object, ex:ExchangeBO):ExchangeBO
		{
			var mbo:MarketBO=null;
			ex.EXCHANGE_CODE=obj.EXCHANGE_CODE;
			ex.EXCHANGE_ID=obj.EXCHANGE_ID;
			ex.EXCHANGE_NAME=obj.EXCHANGE_NAME;
			ex.INTERNAL_EXCHANGE_ID=obj.INTERNAL_EXCHANGE_ID;
			ex.STATE=States.getExchangeStateID(obj.STATE);
			if (obj.markets_ && (obj.markets_.length || obj.markets_.length == 0))
			{
				for each (var o:Object in obj.markets_)
				{
					mbo=fillMarketBO(o, new MarketBO());
					ex.markets.addItem(mbo);
					ModelManager.getInstance().distinctModel.markets.put(mbo.MARKET_CODE, mbo.MARKET_ID.toString());
				}
			}
			else
			{
				mbo=fillMarketBO(obj.markets_, new MarketBO());
				ex.markets.addItem(mbo);
				ModelManager.getInstance().distinctModel.markets.put(mbo.MARKET_CODE, mbo.MARKET_ID.toString());
			}

			return ex;
		}

		private function fillMarketBO(obj:Object, mkt:MarketBO):MarketBO
		{
			mkt.INTERNAL_EXCHANGE_ID=selectedExchangeID;
			mkt.ENTRY_DATETIME=obj.ENTRY_DATETIME;
			mkt.INTERNAL_MARKET_ID=obj.INTERNAL_MARKET_ID;
			mkt.ISVALID=obj.ISVALID;
			mkt.MARKET_CODE=obj.MARKET_CODE;
			mkt.MARKET_DESC=obj.MARKET_DESC;
			mkt.MARKET_ID=obj.MARKET_ID;
			mkt.STATE=States.getMarketStateID(obj.STATE);
			mkt.USER_ID=obj.USER_ID;
			var sbo:SymbolBO=null;
			var bbo:BondBO=null;

			if (obj.symbols_ && (obj.symbols_.length || obj.symbols_.length == 0))
			{
				for each (var o:Object in obj.symbols_)
				{
					if (o.SYMBOL_TYPE == "Bond")
					{
						bbo=fillBondBO(o, new BondBO());
						mkt.symbols.addItem(bbo);
						mkt.bonds.addItem(bbo);
						ModelManager.getInstance().distinctModel.symbols.put(bbo.SYMBOL, bbo.SYMBOL_ID.toString());
					}
					else
					{
						sbo=fillSymbolBO(o, new SymbolBO());
						mkt.symbols.addItem(sbo);
						ModelManager.getInstance().distinctModel.symbols.put(sbo.SYMBOL, sbo.SYMBOL_ID.toString());
					}
				}
			}
			else
			{
				if (o.SYMBOL_TYPE == "Bond")
				{
					bbo=fillBondBO(obj.symbols_, new BondBO());
					mkt.symbols.addItem(bbo);
					mkt.bonds.addItem(bbo);
					ModelManager.getInstance().distinctModel.symbols.put(bbo.SYMBOL, bbo.SYMBOL_ID.toString());
				}
				else
				{
					sbo=fillSymbolBO(obj.symbols_, new SymbolBO());
					mkt.symbols.addItem(sbo);
					ModelManager.getInstance().distinctModel.symbols.put(sbo.SYMBOL, sbo.SYMBOL_ID.toString());
				}
			}
			return mkt;
		}

		private function fillSymbolBO(obj:Object, symbol:SymbolBO):SymbolBO
		{
			symbol.SYMBOL_TYPE=obj.SYMBOL_TYPE;
			symbol.BOARD_LOT=obj.BOARD_LOT;
			symbol.COMPANY_ID=obj.COMPANY_ID;
			symbol.EPS=obj.EPS;
			symbol.FIFTY_TWO_WEEK_HIGH=obj.FIFTY_TWO_WEEK_HIGH;
			symbol.FIFTY_TWO_WEEK_LOW=obj.FIFTY_TWO_WEEK_LOW;
			symbol.INTERNAL_SYMBOL_ID=obj.INTERNAL_SYMBOL_ID;
			symbol.ISPOSTED=obj.ISPOSTED;
			symbol.LOWER_ALERT_LIMIT=obj.LOWER_ALERT_LIMIT;
			symbol.LOWER_CIRCUIT_BREAKER_LIMIT=obj.LOWER_CURCIT_BREAKER_LIMIT;
			symbol.LOWER_ORDER_VALUE_LIMIT=obj.LOWER_ORDER_VALUE_LIMIT;
			symbol.LOWER_ORDER_VOLUME_LIMIT=obj.LOWER_ORDER_VOLUME_LIMIT;
			symbol.MARKET_ID=obj.MARKET_ID;
			symbol.PE_RATIO=obj.PE_RATIO;
			//symbol.STATE = obj.STATE = "Active";
			symbol.STATE=obj.STATE;
			symbol.STATUS=obj.STATUS;
			symbol.SYMBOL=obj.SYMBOL;
			symbol.SYMBOL_ID=obj.SYMBOL_ID;
			symbol.TICK_SIZE=obj.TICK_SIZE;
			symbol.UPPER_ALERT_LIMIT=obj.UPPER_ALERT_LIMIT;
			symbol.UPPER_CIRCUIT_BREAKER_LIMIT=obj.UPPER_CURCIT_BREAKER_LIMIT;
			symbol.UPPER_ORDER_VALUE_LIMIT=obj.UPPER_ORDER_VALUE_LIMIT;
			symbol.UPPER_ORDER_VOLUME_LIMIT=obj.UPPER_ORDER_VOLUME_LIMIT;

			return symbol;
		}

		private function fillBondBO(obj:Object, bond:BondBO):BondBO
		{
			bond=fillSymbolBO(obj, bond) as BondBO;
			bond.IRR=obj.IRR;
			bond.AIRR=obj.AIRR;
			bond.baseRate=obj.baseRate;
			bond.spreadRate=obj.spreadRate;
			bond.couponRate=obj.couponRate;
			bond.discountRate=obj.discountRate;

			bond.nextCouponDate=obj.nextCouponDate;
			bond.issueDate=obj.issueDate;
			bond.maturityDate=obj.maturityDate;
			bond.daysToMaturity = obj.maturityDays;

			return bond;
		}
	}
}
