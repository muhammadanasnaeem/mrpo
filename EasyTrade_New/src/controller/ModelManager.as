package controller
{
	import assets.skins.BorderSkinClass;
	import assets.skins.BuyCancelButton;
	import assets.skins.BuyOkButton;
	import assets.skins.CancelButtonOverSkin;
	import assets.skins.SellOkButtonOverSkin;
	import assets.skins.borderContainerSkin;
	
	import businessobjects.BestMarketAndSymbolSummaryBO;
	import businessobjects.BondBO;
	import businessobjects.Bulletin;
	import businessobjects.CancelAllOrdersBO;
	import businessobjects.MarketStateInfo;
	import businessobjects.OrderBO;
	import businessobjects.SymbolBO;
	import businessobjects.SymbolBrowserBO;
	import businessobjects.SymbolOrderLimitBO;
	import businessobjects.SymbolStateInfo;
	
	import common.Constants;
	import common.HashMap;
	import common.Messages;
	import common.ReasonMessages;
	import common.States;
	
	import components.EZCurrencyFormatter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.setTimeout;
	
	import flexlib.mdi.events.MDIWindowEvent;
	
	import model.BestMarketAndSymbolSummaryModel;
	import model.BestOrdersModel;
	import model.BestPricesModel;
	import model.BrokerModel;
	import model.BulletinModel;
	import model.DistinctModel;
	import model.EventLogModel;
	import model.ExchangeModel;
	import model.ExchangeScheduleModel;
	import model.ExchangeStatsModel;
	import model.IModel;
	import model.LastDayRemainingOrdersModel;
	import model.MarketSummaryModel;
	import model.MarketWatchModel;
	import model.NetPositionModel;
	import model.OrderModel;
	import model.OrderTypesModel;
	import model.QuickOrdersModel;
	import model.RemainingOrdersModel;
	import model.RiskInformationModel;
	import model.SymbolBrowserModel;
	import model.SymbolOrderLimitModel;
	import model.SymbolSummaryModel;
	import model.SymbolTradeHistoryModel;
	import model.UserProfileModel;
	import model.UserTradeHistoryModel;
	import model.YieldModel;
	import model.feeds.NewsTickerFeedModel;
	import model.feeds.SymbolTickerFeedModel;
	
	import mx.collections.HierarchicalData;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	import mx.graphics.SolidColor;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	import mx.managers.FocusManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.OrdererClient;
	import services.QWClient;
	
	import spark.components.TextInput;
	import spark.primitives.Rect;
	
	import view.EventLog;
	import view.MarketSchedule;
	import view.Order;
	import view.SellOrder;
	import view.UserTradeHistory;

	public class ModelManager extends EventDispatcher
	{
		//private var models_:Array = new Array();
		[Bindable] public var buyFlag:Boolean = true;
		
		[Bindable] public var sellFlag:Boolean = true;
		public var changebooleanFlag:Boolean = true;
		public var cancelbooleanFlag:Boolean = true;
		/////////////////////User ID///////////////////
		private var userID_:Number=-1;

		public function get userID():Number
		{
			return userID_;
		}

		public function set userID(value:Number):void
		{
			userID_=value;
		}

		/////////////////////Broker ID///////////////////
		private var brokerID_:Number=-1;

		public function get brokerID():Number
		{
			return brokerID_;
		}

		public function set brokerID(value:Number):void
		{
			brokerID_=value;
		}

		/////////////////////Default Exchange ID///////////////////
		private var defaultExchangeID_:Number=-1;

		public function get defaultExchangeID():Number
		{
			return defaultExchangeID_;
		}

		public function set defaultExchangeID(value:Number):void
		{
			defaultExchangeID_=value;
		}

		///////////////////// The Application Object ///////////////////
		private var easyTradeApp_:EasyTradeApp;

		public function get easyTradeApp():EasyTradeApp
		{
			return easyTradeApp_;
		}

		public function set easyTradeApp(value:EasyTradeApp):void
		{
			easyTradeApp_=value;
		}


		/********************************* Models *********************************/

		/////////////////////User Profile Model///////////////////
		private var userProfileModel_:UserProfileModel=new UserProfileModel();

		[Bindable]
		public function get userProfileModel():UserProfileModel
		{
			return userProfileModel_;
		}

		public function set userProfileModel(value:UserProfileModel):void
		{
			userProfileModel_=value;
		}

		/////////////////////Exchange Model///////////////////
		private var exchangeModel_:ExchangeModel=new ExchangeModel();

		[Bindable]
		public function get exchangeModel():ExchangeModel
		{
			return exchangeModel_;
		}

		public function set exchangeModel(value:ExchangeModel):void
		{
			exchangeModel_=value;
		}

		/////////////////////Exchange Stats Model///////////////////
		private var exchangeStatsModel_:ExchangeStatsModel=new ExchangeStatsModel();

		[Bindable]
		public function get exchangeStatsModel():ExchangeStatsModel
		{
			return exchangeStatsModel_;
		}

		public function set exchangeStatsModel(value:ExchangeStatsModel):void
		{
			exchangeStatsModel_=value;
		}

		/////////////////////Market Model///////////////////
		//private var marketModel_:MarketModel = new MarketModel();
		//[Bindable]
		//public function get marketModel():MarketModel
		//{
		//	return marketModel_;
		//}
		//public function set marketModel(value:MarketModel):void
		//{
		//	marketModel_ = value;
		//}

		/////////////////////Market Model///////////////////
		private var orderTypesModel_:OrderTypesModel=new OrderTypesModel();

		[Bindable]
		public function get orderTypesModel():OrderTypesModel
		{
			return orderTypesModel_;
		}

		public function set orderTypesModel(value:OrderTypesModel):void
		{
			orderTypesModel_=value;
		}

		/////////////////////Symbol Summary Model///////////////////
		private var symbolSummaryModel_:SymbolSummaryModel=new SymbolSummaryModel();

		[Bindable]
		public function get symbolSummaryModel():SymbolSummaryModel
		{
			return symbolSummaryModel_;
		}

		public function set symbolSummaryModel(value:SymbolSummaryModel):void
		{
			symbolSummaryModel_=value;
		}

		/////////////////////Market Summary Model///////////////////
		private var marketSummaryModel_:MarketSummaryModel=new MarketSummaryModel();

		[Bindable]
		public function get marketSummaryModel():MarketSummaryModel
		{
			return marketSummaryModel_;
		}

		public function set marketSummaryModel(value:MarketSummaryModel):void
		{
			marketSummaryModel_=value;
		}

		/////////////////////Net Position Model///////////////////
		private var netPositionModel_:NetPositionModel=new NetPositionModel();

		[Bindable]
		public function get netPositionModel():NetPositionModel
		{
			return netPositionModel_;
		}

		public function set netPositionModel(value:NetPositionModel):void
		{
			netPositionModel_=value;
		}

		/////////////////////Best Market and Symbol Summary Model///////////////////
		private var bestMarketAndSymbolSummaryModel_:BestMarketAndSymbolSummaryModel=new BestMarketAndSymbolSummaryModel();

		[Bindable]
		public function get bestMarketAndSymbolSummaryModel():BestMarketAndSymbolSummaryModel
		{
			return bestMarketAndSymbolSummaryModel_;
		}

		public function set bestMarketAndSymbolSummaryModel(value:BestMarketAndSymbolSummaryModel):void
		{
			bestMarketAndSymbolSummaryModel_=value;
		}

		/////////////////////Symbol Model///////////////////
		private var symbolBrowserModel_:SymbolBrowserModel=new SymbolBrowserModel();

		[Bindable]
		public function get symbolBrowserModel():SymbolBrowserModel
		{
			return symbolBrowserModel_;
		}

		public function set symbolBrowserModel(value:SymbolBrowserModel):void
		{
			symbolBrowserModel_=value;
		}

		/////////////////////Market Watch Model///////////////////
		private var marketWatchModel_:MarketWatchModel=new MarketWatchModel();

		[Bindable]
		public function get marketWatchModel():MarketWatchModel
		{
			return marketWatchModel_;
		}

		public function set marketWatchModel(value:MarketWatchModel):void
		{
			marketWatchModel_=value;
		}

		//////////////////////Quick Orders Model//////////////////////
		private var quickOrdershModel_:QuickOrdersModel=new QuickOrdersModel();

		[Bindable]
		public function get quickOrdersModel():QuickOrdersModel
		{
			return quickOrdershModel_;
		}

		public function set quickOrdersModel(value:QuickOrdersModel):void
		{
			quickOrdershModel_=value;
		}

		/////////////////////Distinct Model///////////////////
		private var distinctModel_:DistinctModel=new DistinctModel();

		[Bindable]
		public function get distinctModel():DistinctModel
		{
			return distinctModel_;
		}

		public function set distinctModel(value:DistinctModel):void
		{
			distinctModel_=value;
		}

		/////////////////////Exchange Schedule Model///////////////////
		private var exchangeScheduleModel_:ExchangeScheduleModel=new ExchangeScheduleModel();

		[Bindable]
		public function get exchangeScheduleModel():ExchangeScheduleModel
		{
			return exchangeScheduleModel_;
		}

		public function set exchangeScheduleModel(value:ExchangeScheduleModel):void
		{
			exchangeScheduleModel_=value;
		}

		/////////////////////Remaining Orders Model///////////////////
		private var remainingOrdersModel_:RemainingOrdersModel=new RemainingOrdersModel();

		[Bindable]
		public function get remainingOrdersModel():RemainingOrdersModel
		{
			return remainingOrdersModel_;
		}
		
		public function set remainingOrdersModel(value:RemainingOrdersModel):void
		{
			remainingOrdersModel_=value;
		}
		////////////////////// Risk Information Model /////////////////////////
		private var riskInformationModel_:RiskInformationModel=new RiskInformationModel;
		[Bindable]
		public function get riskInformationModel():RiskInformationModel
		{
			return riskInformationModel_;
		}
		
		public function set riskInformationModel(value:RiskInformationModel):void
		{
			riskInformationModel_ = value;
		}
		/////////////////////Last Day Remaining Orders Model///////////////////
		private var lastDayRemainingOrdersModel_:LastDayRemainingOrdersModel=new LastDayRemainingOrdersModel();

		[Bindable]
		public function get lastDayRemainingOrdersModel():LastDayRemainingOrdersModel
		{
			return lastDayRemainingOrdersModel_;
		}

		public function set lastDayRemainingOrdersModel(value:LastDayRemainingOrdersModel):void
		{
			lastDayRemainingOrdersModel_=value;
		}

		/////////////////////User Trade History Model///////////////////
		private var userTradeHistoryModel_:UserTradeHistoryModel=new UserTradeHistoryModel();

		[Bindable]
		public function get userTradeHistoryModel():UserTradeHistoryModel
		{
			return userTradeHistoryModel_;
		}

		public function set userTradeHistoryModel(value:UserTradeHistoryModel):void
		{
			userTradeHistoryModel_=value;
		}

		/////////////////////Symbol Trade History Model///////////////////
		private var symbolTradeHistoryModel_:SymbolTradeHistoryModel=new SymbolTradeHistoryModel();

		[Bindable]
		public function get symbolTradeHistoryModel():SymbolTradeHistoryModel
		{
			return symbolTradeHistoryModel_;
		}

		public function set symbolTradeHistoryModel(value:SymbolTradeHistoryModel):void
		{
			symbolTradeHistoryModel_=value;
		}

		/////////////////////Event Log Model///////////////////
		private var eventLogModel_:EventLogModel=new EventLogModel();

		[Bindable]
		public function get eventLogModel():EventLogModel
		{
			return eventLogModel_;
		}

		public function set eventLogModel(value:EventLogModel):void
		{
			eventLogModel_=value;
		}

		/////////////////////Best Orders Model///////////////////
		private var bestOrdersModel_:BestOrdersModel=new BestOrdersModel();

		[Bindable]
		public function get bestOrdersModel():BestOrdersModel
		{
			return bestOrdersModel_;
		}

		public function set bestOrdersModel(value:BestOrdersModel):void
		{
			bestOrdersModel_=value;
		}    

		/////////////////////Best Prices Model///////////////////
		private var bestPricesModel_:BestPricesModel=new BestPricesModel();

		[Bindable]
		public function get bestPricesModel():BestPricesModel
		{
			return bestPricesModel_;   
		}   

		public function set bestPricesModel(value:BestPricesModel):void
		{
			bestPricesModel_=value;
		}

		/////////////////////Submit Order Model///////////////////
		private var orderModel_:OrderModel=new OrderModel();

		[Bindable]
		public function get orderModel():OrderModel
		{
			return orderModel_;
		}

		public function set orderModel(value:OrderModel):void
		{
			orderModel_=value;
		}

		/////////////////////Symbol Order Limit Model///////////////////
		private var symbolOrderLimitModel_:SymbolOrderLimitModel=new SymbolOrderLimitModel();

		[Bindable]
		public function get symbolOrderLimitModel():SymbolOrderLimitModel
		{
			return symbolOrderLimitModel_;
		}

		public function set symbolOrderLimitModel(value:SymbolOrderLimitModel):void
		{
			symbolOrderLimitModel_=value;
		}

		/////////////////////Bulletin Model///////////////////
		private var bulletinModel_:BulletinModel=new BulletinModel();

		[Bindable]
		public function get bulletinModel():BulletinModel
		{
			return bulletinModel_;
		}

		public function set bulletinModel(value:BulletinModel):void
		{
			bulletinModel_=value;
		}

		/////////////////////Symbol Ticker Feed Model///////////////////
		private var symbolTickerFeedModel_:SymbolTickerFeedModel=new SymbolTickerFeedModel();

		[Bindable]
		public function get symbolTickerFeedModel():SymbolTickerFeedModel
		{
			return symbolTickerFeedModel_;
		}

		public function set symbolTickerFeedModel(value:SymbolTickerFeedModel):void
		{
			symbolTickerFeedModel_=value;
		}

		/////////////////////News Ticker Feed Model///////////////////
		private var newsTickerFeedModel_:NewsTickerFeedModel=new NewsTickerFeedModel();

		[Bindable]
		public function get newsTickerFeedModel():NewsTickerFeedModel
		{
			return newsTickerFeedModel_;
		}

		public function set newsTickerFeedModel(value:NewsTickerFeedModel):void
		{
			newsTickerFeedModel_=value;
		}

		/////////////////////Yield Model///////////////////
		private var yieldModel_:YieldModel=new YieldModel();

		[Bindable]
		public function get yieldModel():YieldModel
		{
			return yieldModel_;
		}

		public function set yieldModel(value:YieldModel):void
		{
			yieldModel_=value;
		}

		/////////////////////Broker Model///////////////////
		private var brokerModel_:BrokerModel=new BrokerModel();

		[Bindable]
		public function get brokerModel():BrokerModel
		{
			return brokerModel_;
		}

		public function set brokerModel(value:BrokerModel):void
		{
			brokerModel_=value;
		}

		public var subscribedItems:HashMap=new HashMap();
		////////////////////////////////////////
		private static var instance:ModelManager=new ModelManager();


		public var orderType:String;

		public var txtMessage:String="";

		///////////////////////////////////////////////////////////////
		public function ModelManager()
		{
			if (instance)
			{
				throw new Error("ModelManager can only be accessed through ModelManager.getInstance()");
			}
		}

		///////////////////////////////////////////////////////////////
		public static function getInstance():ModelManager
		{
			return instance;
		}

		///////////////////////////////////////////////////////////////
		//init
		public function init():void
		{
			exchangeModel_.execute();
		/*models_.push(exchangeModel_);
		models_.push(flagsModel_);
		models_.push(remainingOrdersModel_);
		models_.push(userTradeHistoryModel_);
		models_.push(symbolBrowserModel_);
		models_.push(marketWatchModel_);
		models_.push(exchangeScheduleModel_);
		models_.push(bestOrdersModel_);
		models_.push(bestPricesModel_);*/
		}

		//////////////////////////////// CRUD ///////////////////////////////
		/**
		 * Login method
		 */

		public function Login(userName:String, password:String):void
		{
			userProfileModel.userName=userName;
			userProfileModel.password=password;
			userProfileModel.execute();
		}

		/**
		 * This method is also called when the best orders window gains focus
		 * if event is null then it is being called for the first time
		 * else it is a result of MDIWindowEvent.
		 */
		public function updateBestOrders():void
		{
			if (bestOrdersModel_.isDirty && WindowManager.getInstance().viewManager.bestOrders.internalExchangeID > -1 && WindowManager.getInstance().viewManager.bestOrders.internalMarketID > -1 && WindowManager.getInstance().viewManager.bestOrders.symbolID > -1)
			{
				bestOrdersModel_.execute();
			}
		}

		/**
		 * Best Prices
		 */
		public function updateBestPrices():void
		{
			if (bestPricesModel_.isDirty && WindowManager.getInstance().viewManager.bestPrices.internalExchangeID > -1 && WindowManager.getInstance().viewManager.bestPrices.internalMarketID > -1 && WindowManager.getInstance().viewManager.bestPrices.symbolID > -1)
			{
				bestPricesModel_.execute();
			}
		}

		/**
		 *
		 */
		public function updateSymbolSummary():void
		{
			if (WindowManager.getInstance().viewManager.symbolSummary.internalExchangeID > -1 && WindowManager.getInstance().viewManager.symbolSummary.internalMarketID > -1 && WindowManager.getInstance().viewManager.symbolSummary.internalSymbolID > -1)
			{
				symbolSummaryModel_.execute();
			}
		}

		/**
		 *
		 */
		public function updateSymbolBrowser():void
		{
			// commented on 21/12/2010	
//			if (
//				WindowManager.getInstance().viewManager.symbolBrowser.internalExchangeID > -1 &&
//				WindowManager.getInstance().viewManager.symbolBrowser.internalMarketID > -1
//			)
			{
				symbolBrowserModel_.execute();
			}
		}

		/**
		 *
		 * This method is also called when the remaining orders window gains focus
		 * for the first time or when an order is succesfully placed in which case
		 * the event object will be null.
		 */
		public function updateRemainingOrders():void
		{
			//if (remainingOrdersModel_.isDirty)
			//{
			remainingOrdersModel_.execute();
			//}
		}

		public function updateLastDayRemainingOrders():void
		{

			lastDayRemainingOrdersModel.execute();

		}

		public function updateUserTradeHistory():void
		{
			//if (userTradeHistoryModel_.isDirty)
			//{
			userTradeHistoryModel.execute();
			//}
		}

		public function updateSymbolTradeHistory():void
		{
			try
			{
				var windowManager:WindowManager=WindowManager.getInstance();
				if (windowManager.viewManager.liveSymbolChart.internalExchangeID > -1 && windowManager.viewManager.liveSymbolChart.internalMarketID > -1 && windowManager.viewManager.liveSymbolChart.internalSymbolID > -1)
				{
					symbolTradeHistoryModel.execute();
				}
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}

		public function cancelAllOrders(cao:CancelAllOrdersBO):void
		{
			OrdererClient.getInstance().cancelAllOrders(cao);
		}

		public function onCancelAllOrdersResult(event:ResultEvent):void
		{
			ModelManager.getInstance().orderModel.isDirty=true;
			CursorManager.removeBusyCursor();
			ModelManager.getInstance().updateRemainingOrders();
		}

		public function onCancelAllOrdersFault(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Alert.show(event.fault.message, ResourceManager.getInstance().getString('marketwatch','error'));
		}

		public function updateEventLog():void
		{
			eventLogModel_.execute();
		}
		
		public function updateRiskInformation():void
		{
//			riskInformationModel_.execute();
		}

		public function updateExchangeSchedule():void
		{
			exchangeScheduleModel_.execute();
		}

		public function updateExchangeStats():void
		{
			if (WindowManager.getInstance().viewManager.exchangeStats.internalExchangeID > -1)
			{
				exchangeStatsModel_.execute();
			}
		}

		public function getBestMarketAndSymbolSummary(exchangeID:Number, marketID:Number, symbolID:Number, symbolName:String, isInternalID:Boolean=true):void
		{
			var exID:Number=-1;
			var mktID:Number=-1;

			if (isInternalID)
			{
				exID=exchangeModel.getExchangeID(exchangeID);
				mktID=exchangeModel.getMarketID(exchangeID, marketID);
			}
			else
			{
				exID=exchangeID;
				mktID=marketID;
			}

//			Start : modified on 20/12/2010 to fix scenarios when new request not send to server in case data is already in map
//			var key:String = exID.toString() + "_" + mktID.toString() + "_" + symbolID;
//			if ( !bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.hasKey( key ) )
//			{
//				bestMarketAndSymbolSummaryModel.exchangeID = exID;
//				bestMarketAndSymbolSummaryModel.marketID = mktID;
//				bestMarketAndSymbolSummaryModel.symbolName = symbolName;
//				bestMarketAndSymbolSummaryModel.symbolID = symbolID;
//				bestMarketAndSymbolSummaryModel.execute();
//			}
//			else
//			{
//				var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO = bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
//
//				var windowManager:WindowManager = WindowManager.getInstance();
//				windowManager.viewManager.marketWatch.updateMarketWatchView(bestMarketAndSymbolSummary);
//				windowManager.viewManager.buyOrder.updateOrderView(bestMarketAndSymbolSummary);
//				windowManager.viewManager.sellOrder.updateOrderView(bestMarketAndSymbolSummary);
//			}

			bestMarketAndSymbolSummaryModel.exchangeID=exID;
			bestMarketAndSymbolSummaryModel.marketID=mktID;
			bestMarketAndSymbolSummaryModel.symbolName=symbolName;
			bestMarketAndSymbolSummaryModel.symbolID=symbolID;
			bestMarketAndSymbolSummaryModel.execute();
//			End : modified on 20/12/2010 to fix scenarios when new request not sent to server in case data is already in map			
		}
		
		
		///////////////////////////////////
		public  function buycancelButton_clickHandler(event:MouseEvent):void
		{
			var buyOrder:Order=WindowManager.getInstance().viewManager.buyOrder;
			if(event != null)
			{
				buyOrder.txtVolume.text = '';
				buyOrder.txtPrice.text = '';
				buyOrder.txtAccount.text = '';
				buyOrder.txtMsg.text = '';
			}
		}
		/*
		 * 
		This method is called when the user clicks the ok button 
		
		
		*/
		public function submitBuyOrderOnClick(event:MouseEvent):void
		{
			var buyOrder:Order=WindowManager.getInstance().viewManager.buyOrder;
			if(event == null || buyOrder.txtSymbol.text == '' || buyOrder.txtVolume.text == '' ||
				buyOrder.txtPrice.text == '' || buyOrder.txtAccount.text == '')
			{
				Alert.show(ResourceManager.getInstance().getString('marketwatch','plzfilltheReqFields'),ResourceManager.getInstance().getString('marketwatch','error'));
//				buyOrder.txtMsg.text = ResourceManager.getInstance().getString('marketwatch','plzfilltheReqFields')+' ';
				return;	
			}
			buyOrder.txtSymbol.text=buyOrder.txtSymbol.text.toUpperCase();
			buyOrder.txtMsg.text="";
			txtMessage="";
			// Start : added on 22/12/2010
			if (buyOrder.isFirstSubmission && buyOrder.focusManager.getFocus() == buyOrder.txtVolume && buyOrder.txtSymbol.text != "")
			{
				var exchangeId:Number=exchangeModel.getExchangeID(buyOrder.internalExchangeID);
				var marketId:Number=exchangeModel.getMarketID(buyOrder.internalExchangeID, buyOrder.internalMarketID);
				
				var symbolId:Number=(exchangeModel.getSymbolByCode(buyOrder.internalExchangeID, buyOrder.internalMarketID, buyOrder.txtSymbol.text) as SymbolBO).SYMBOL_ID;
				var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
				var delimRegExp:RegExp=/,/g;
				var volume:Number=new Number(buyOrder.txtVolume.text.replace(delimRegExp, ""));
				
				if (exchangeId > -1 && marketId > -1 && symbolId > -1)
				{
					var key:String=exchangeId + "_" + marketId + "_" + symbolId;
					
					
					var symbol:SymbolBO=ModelManager.getInstance().exchangeModel.getSymbolDetail(exchangeId, marketId, symbolId) as SymbolBO;
					if (volume < symbol.LOWER_ORDER_VOLUME_LIMIT || volume > symbol.UPPER_ORDER_VOLUME_LIMIT)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volLimitsAre')+' ' + symbol.LOWER_ORDER_VOLUME_LIMIT + " - " + symbol.UPPER_ORDER_VOLUME_LIMIT;
						buyOrder.txtMsg.text=txtMessage;
						return;
					}
					
					if (!((volume / symbol.BOARD_LOT) is uint))
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volLotSize')+' ' + symbol.BOARD_LOT;
						buyOrder.txtMsg.text=txtMessage;
						return;
					}
					
					if (ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.hasKey(key))
					{
						var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO=ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
						
						
						if (bestMarketAndSymbolSummary)
						{
							if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE > -1 && buyOrder.txtPrice.text == "")
							{
								buyOrder.txtPrice.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE.toString());
								return;
							}
							else if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE > -1 && buyOrder.txtPrice.text == "")
							{
								buyOrder.txtPrice.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE.toString());
								return;
							}
							
						}
					}
				}
			}
			// End : added on 22/12/2010
			var marketState:Number=ModelManager.getInstance().exchangeModel.getMarketState(buyOrder.internalExchangeID, buyOrder.internalMarketID);
			/*if (marketState != States.MARKET_STATES.PreOpen ||
			marketState != States.MARKET_STATES.Open)
			{
			buyOrder.txtMsg.text = "Market state not valid.";
			buyOrder.isFirstSubmission = true;
			}
			else */
			if (validateOrder(buyOrder))
			{
				if (buyOrder.isFirstSubmission)
				{
					var unit:String=ResourceManager.getInstance().getString('marketwatch','share');
					var isBond:Boolean=ModelManager.getInstance().exchangeModel.isBondMarket(buyOrder.internalExchangeID, buyOrder.internalMarketID);
					if (isBond)
						unit=ResourceManager.getInstance().getString('marketwatch','bond');
					buyOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','buy')+' ';
					buyOrder.txtMsg.text+=buyOrder.txtVolume.text;
					buyOrder.txtMsg.text+=" " + unit;
					buyOrder.txtMsg.text+="s "+ResourceManager.getInstance().getString('marketwatch','of')+' ';
					buyOrder.txtMsg.text+=buyOrder.txtSymbol.text;
					buyOrder.txtMsg.text+=' '+ResourceManager.getInstance().getString('marketwatch','at')+' ';
					buyOrder.txtMsg.text+=buyOrder.txtPrice.text;
					buyOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','per') + unit + ResourceManager.getInstance().getString('marketwatch','?');
					if (buyOrder.txtDiscVol.text.length > 0 && !isNaN(parseInt(buyOrder.txtDiscVol.text)))
					{
						buyOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','discVolis')+' ' + buyOrder.txtDiscVol.text;
					}
					buyOrder.isFirstSubmission=false;
				}
				else
				{
					if(buyFlag == false)
					{
						return;
					}
					buyFlag = false;
					orderModel_.orderBO=new OrderBO();
					orderModel_.orderBO.SIDE="buy";
					orderModel_.fillOrderBO(buyOrder);
					// added on 3/01/2011
					orderModel_.orderBO.REF_NO="";
					orderModel_.execute();
//					CursorManager.setCursor(Mouse, CursorManagerPriority.HIGH, 200, 300);
					//					Alert.show("Buy Order Successful",Messages.INFORMATION);
					buyOrder.isFirstSubmission=true;
					buyOrder.txtVolume.setFocus();
//					CursorManager.setCursor(Mouse, CursorManagerPriority.HIGH, 200, 300);
				}
			}
			else
			{
				// modified on 7/1/2011
				if (txtMessage != "")
				{
					buyOrder.txtMsg.text=txtMessage;
					txtMessage="";
				}
				else
				{
//					buyOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','plzCorrctInpt');
				}
				
				buyOrder.isFirstSubmission=true;
			}
		}
		/**
		 *
		 * This method is called when the user hits the Enter key
		 * on Buy Orders screen.
		 */
		public function submitBuyOrder(event:KeyboardEvent):void
		{
			if (event.keyCode != 13)
			{
				return;
			}
			
			var buyOrder:Order=WindowManager.getInstance().viewManager.buyOrder;
			buyOrder.txtSymbol.text=buyOrder.txtSymbol.text.toUpperCase();
			buyOrder.txtMsg.text="";
			txtMessage="";
			// Start : added on 22/12/2010
			if (buyOrder.isFirstSubmission && buyOrder.focusManager.getFocus() == buyOrder.txtVolume && buyOrder.txtSymbol.text != "")
			{
				var exchangeId:Number=exchangeModel.getExchangeID(buyOrder.internalExchangeID);
				var marketId:Number=exchangeModel.getMarketID(buyOrder.internalExchangeID, buyOrder.internalMarketID);

				var symbolId:Number=(exchangeModel.getSymbolByCode(buyOrder.internalExchangeID, buyOrder.internalMarketID, buyOrder.txtSymbol.text) as SymbolBO).SYMBOL_ID;
				var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
				var delimRegExp:RegExp=/,/g;
				var volume:Number=new Number(buyOrder.txtVolume.text.replace(delimRegExp, ""));

				if (exchangeId > -1 && marketId > -1 && symbolId > -1)
				{
					var key:String=exchangeId + "_" + marketId + "_" + symbolId;


					var symbol:SymbolBO=ModelManager.getInstance().exchangeModel.getSymbolDetail(exchangeId, marketId, symbolId) as SymbolBO;
					if (volume < symbol.LOWER_ORDER_VOLUME_LIMIT || volume > symbol.UPPER_ORDER_VOLUME_LIMIT)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volLimitsAre')+" " + symbol.LOWER_ORDER_VOLUME_LIMIT + " - " + symbol.UPPER_ORDER_VOLUME_LIMIT;
						buyOrder.txtMsg.text=txtMessage;
						return;
					}

					if (!((volume / symbol.BOARD_LOT) is uint))
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volLotSize')+" " + symbol.BOARD_LOT;
						buyOrder.txtMsg.text=txtMessage;
						return;
					}

					if (ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.hasKey(key))
					{
						var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO=ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;


						if (bestMarketAndSymbolSummary)
						{
							if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE > -1 && buyOrder.txtPrice.text == "")
							{
								buyOrder.txtPrice.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE.toString());
								return;
							}
							else if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE > -1 && buyOrder.txtPrice.text == "")
							{
								buyOrder.txtPrice.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE.toString());
								return;
							}

						}
					}
				}
			}
			// End : added on 22/12/2010
			var marketState:Number=ModelManager.getInstance().exchangeModel.getMarketState(buyOrder.internalExchangeID, buyOrder.internalMarketID);
			/*if (marketState != States.MARKET_STATES.PreOpen ||
				marketState != States.MARKET_STATES.Open)
			{
				buyOrder.txtMsg.text = "Market state not valid.";
				buyOrder.isFirstSubmission = true;
			}
			else */
			if (validateOrder(buyOrder))
			{
				if (buyOrder.isFirstSubmission)
				{
					var unit:String=ResourceManager.getInstance().getString('marketwatch','share');
					var isBond:Boolean=ModelManager.getInstance().exchangeModel.isBondMarket(buyOrder.internalExchangeID, buyOrder.internalMarketID);
					if (isBond)
						unit=ResourceManager.getInstance().getString('marketwatch','bond');
					buyOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','buy')+" ";
					buyOrder.txtMsg.text+=buyOrder.txtVolume.text;
					buyOrder.txtMsg.text+=" " + unit;
					buyOrder.txtMsg.text+="s" +ResourceManager.getInstance().getString('marketwatch','of')+" ";
					buyOrder.txtMsg.text+=buyOrder.txtSymbol.text;
					buyOrder.txtMsg.text+="  "+ResourceManager.getInstance().getString('marketwatch','at')+' ' ;
					buyOrder.txtMsg.text+=buyOrder.txtPrice.text;
					buyOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','per')+' ' + unit + ResourceManager.getInstance().getString('marketwatch','?');
					if (buyOrder.txtDiscVol.text.length > 0 && !isNaN(parseInt(buyOrder.txtDiscVol.text)))
					{
						buyOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','discVolis')+' ' + buyOrder.txtDiscVol.text;
					}
					buyOrder.isFirstSubmission=false;
				}
				else
				{
					if(buyFlag == false)
					{
						return;
					}
					buyFlag = false;
					orderModel_.orderBO=new OrderBO();
					orderModel_.orderBO.SIDE="buy";
					orderModel_.fillOrderBO(buyOrder);
					// added on 3/01/2011
					orderModel_.orderBO.REF_NO="";
					orderModel_.execute();
//					Alert.show("Buy Order Successful",Messages.INFORMATION);
					buyOrder.isFirstSubmission=true;
					buyOrder.txtVolume.setFocus();
//					CursorManager.setCursor(Mouse, CursorManagerPriority.HIGH, 200, 300);
				}
			}
			else
			{
				// modified on 7/1/2011
				if (txtMessage != "")
				{
					buyOrder.txtMsg.text=txtMessage;
					txtMessage="";
				}
				else
				{
//					buyOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','plzCorrctInpt');
				}

				buyOrder.isFirstSubmission=true;
			}
		}

		/**
		 *
		 * This method is called when the user hits the Enter key
		 * on Sell Orders screen.
		 */
		public function submitSellOrder(event:KeyboardEvent):void
		{
			if (event.keyCode != 13)
			{
				return;
			}
			var sellOrder:SellOrder=WindowManager.getInstance().viewManager.sellOrder;
			sellOrder.txtSymbol.text=sellOrder.txtSymbol.text.toUpperCase();
			sellOrder.txtMsg.text="";
			txtMessage="";

			var delimRegExp:RegExp=/,/g;
			var volume:Number=new Number(sellOrder.txtVolume.text.replace(delimRegExp, ""));
			// Start : added on 23/12/2010
			if (sellOrder.isFirstSubmission && sellOrder.focusManager.getFocus() == sellOrder.txtVolume && sellOrder.txtSymbol.text != "")
			{
				var exchangeId:Number=exchangeModel.getExchangeID(sellOrder.internalExchangeID);
				var marketId:Number=exchangeModel.getMarketID(sellOrder.internalExchangeID, sellOrder.internalMarketID);

				var symbolId:Number=(exchangeModel.getSymbolByCode(sellOrder.internalExchangeID, sellOrder.internalMarketID, sellOrder.txtSymbol.text) as SymbolBO).SYMBOL_ID;
				var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
				if (exchangeId > -1 && marketId > -1 && symbolId > -1)
				{
					var key:String=exchangeId + "_" + marketId + "_" + symbolId;

					var symbol:SymbolBO=ModelManager.getInstance().exchangeModel.getSymbolDetail(exchangeId, marketId, symbolId) as SymbolBO;


					if (volume < symbol.LOWER_ORDER_VOLUME_LIMIT || volume > symbol.UPPER_ORDER_VOLUME_LIMIT)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volLimitsAre')+" " + symbol.LOWER_ORDER_VOLUME_LIMIT + " - " + symbol.UPPER_ORDER_VOLUME_LIMIT;
						sellOrder.txtMsg.text=txtMessage;
						return;
					}

					if (!((volume / symbol.BOARD_LOT) is uint))
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volLimitsAre')+" " + symbol.BOARD_LOT;
						sellOrder.txtMsg.text=txtMessage;
						return;
					}



					if (ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.hasKey(key))
					{
						var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO=ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;


						if (bestMarketAndSymbolSummary)
						{
							if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE > -1 && sellOrder.txtPrice.text == "")
							{
								sellOrder.txtPrice.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE.toString());
								return;
							}
							else if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE > -1 && sellOrder.txtPrice.text == "")
							{
								sellOrder.txtPrice.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE.toString());
								return;
							}
						}
					}
				}
			}
			// End : added on 23/12/2010

			var marketState:Number=ModelManager.getInstance().exchangeModel.getMarketState(sellOrder.internalExchangeID, sellOrder.internalMarketID);
			/*if (marketState != States.MARKET_STATES.PreOpen ||
				marketState != States.MARKET_STATES.Open)
			{
				sellOrder.txtMsg.text = "Market state not valid.";
				sellOrder.isFirstSubmission = true;
			}
			else */
			if (validateOrder1(sellOrder))
			{
				if (sellOrder.isFirstSubmission)
				{
					var unit:String=ResourceManager.getInstance().getString('marketwatch','share');
					var isBond:Boolean=ModelManager.getInstance().exchangeModel.isBondMarket(sellOrder.internalExchangeID, sellOrder.internalMarketID);
					if (isBond)
						unit=ResourceManager.getInstance().getString('marketwatch','bond');
					sellOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','sell')+" ";
					sellOrder.txtMsg.text+=sellOrder.txtVolume.text;
					sellOrder.txtMsg.text+=" " + unit;
					sellOrder.txtMsg.text+="s"+ ResourceManager.getInstance().getString('marketwatch','of')+" ";
					sellOrder.txtMsg.text+=sellOrder.txtSymbol.text;
					sellOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','at')+' ';
					sellOrder.txtMsg.text+=sellOrder.txtPrice.text;
					sellOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','per')+' ' + unit + ResourceManager.getInstance().getString('marketwatch','?');
					if (sellOrder.txtDiscVol.text.length > 0 && !isNaN(parseInt(sellOrder.txtDiscVol.text)))
					{
						sellOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','discVolis')+' ' + sellOrder.txtDiscVol.text;
					}
					sellOrder.isFirstSubmission=false;
				}
				else
				{
					if(sellFlag == false)
					{
						return;
					}
					sellFlag = false;
					orderModel_.orderBO=new OrderBO();
					orderModel_.orderBO.SIDE="sell";
					orderModel_.fillOrderBO1(sellOrder);
					// added on 3/01/2011
					orderModel_.orderBO.REF_NO="";
					orderModel_.execute();
//					CursorManager.setCursor(Mouse, CursorManagerPriority.HIGH, 200, 300);
					sellOrder.isFirstSubmission=true;
				}
			}
			else
			{
				// modified on 7/1/2011
				if (txtMessage != "")
				{
					sellOrder.txtMsg.text=txtMessage;
					txtMessage="";
				}
				else
				{
//					sellOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','plzCorrctInpt');
				}
				sellOrder.isFirstSubmission=true;
			}
		}
		/*
		 *This method is called when the user clicks ok button on sell order window 
		*/
		
		public function onSubmitSellOrderOnClick(event:MouseEvent):void
		{
			var sellOrder:SellOrder=WindowManager.getInstance().viewManager.sellOrder;
			if(event == null || sellOrder.txtSymbol.text == '' || sellOrder.txtVolume.text == '' ||
				sellOrder.txtPrice.text == '' || sellOrder.txtAccount.text == '')
			{
//				sellOrder.txtMsg.text = ResourceManager.getInstance().getString('marketwatch','plzfilltheReqFields');
				Alert.show(ResourceManager.getInstance().getString('marketwatch','plzfilltheReqFields'),ResourceManager.getInstance().getString('marketwatch','error'));
				return;
			}
			sellOrder.txtSymbol.text=sellOrder.txtSymbol.text.toUpperCase();
			sellOrder.txtMsg.text="";
			txtMessage="";
			
			var delimRegExp:RegExp=/,/g; 
			var volume:Number=new Number(sellOrder.txtVolume.text.replace(delimRegExp, ""));
			// Start : added on 23/12/2010
			if (sellOrder.isFirstSubmission && sellOrder.focusManager.getFocus() == sellOrder.txtVolume && sellOrder.txtSymbol.text != "")
			{
				var exchangeId:Number=exchangeModel.getExchangeID(sellOrder.internalExchangeID);
				var marketId:Number=exchangeModel.getMarketID(sellOrder.internalExchangeID, sellOrder.internalMarketID);
				
				var symbolId:Number=(exchangeModel.getSymbolByCode(sellOrder.internalExchangeID, sellOrder.internalMarketID, sellOrder.txtSymbol.text) as SymbolBO).SYMBOL_ID;
				var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
				if (exchangeId > -1 && marketId > -1 && symbolId > -1)
				{
					var key:String=exchangeId + "_" + marketId + "_" + symbolId;
					
					var symbol:SymbolBO=ModelManager.getInstance().exchangeModel.getSymbolDetail(exchangeId, marketId, symbolId) as SymbolBO;
					
					
					if (volume < symbol.LOWER_ORDER_VOLUME_LIMIT || volume > symbol.UPPER_ORDER_VOLUME_LIMIT)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volLimitsAre')+" " + symbol.LOWER_ORDER_VOLUME_LIMIT + " - " + symbol.UPPER_ORDER_VOLUME_LIMIT;
						sellOrder.txtMsg.text=txtMessage;
						return;
					}
					
					if (!((volume / symbol.BOARD_LOT) is uint))
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volLotSize')+" " + symbol.BOARD_LOT;
						sellOrder.txtMsg.text=txtMessage;
						return;
					}
					
					
					
					if (ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.hasKey(key))
					{
						var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO=ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
						
						
						if (bestMarketAndSymbolSummary)
						{
							if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE > -1 && sellOrder.txtPrice.text == "")
							{
								sellOrder.txtPrice.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE.toString());
								return;
							}
							else if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE > -1 && sellOrder.txtPrice.text == "")
							{
								sellOrder.txtPrice.text=moneyFormatter.format(bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE.toString());
								return;
							}
						}
					}
				}
			}
			// End : added on 23/12/2010
			
			var marketState:Number=ModelManager.getInstance().exchangeModel.getMarketState(sellOrder.internalExchangeID, sellOrder.internalMarketID);
			/*if (marketState != States.MARKET_STATES.PreOpen ||
			marketState != States.MARKET_STATES.Open)
			{
			sellOrder.txtMsg.text = "Market state not valid.";
			sellOrder.isFirstSubmission = true;
			}
			else */
			if (validateOrder1(sellOrder))
			{
				if (sellOrder.isFirstSubmission)
				{
					var unit:String=ResourceManager.getInstance().getString('marketwatch','share');
					var isBond:Boolean=ModelManager.getInstance().exchangeModel.isBondMarket(sellOrder.internalExchangeID, sellOrder.internalMarketID);
					if (isBond)
						unit=ResourceManager.getInstance().getString('marketwatch','bond');
					sellOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','sell')+" ";
					sellOrder.txtMsg.text+=sellOrder.txtVolume.text;
					sellOrder.txtMsg.text+=" " + unit;
					sellOrder.txtMsg.text+="s" +ResourceManager.getInstance().getString('marketwatch','of')+" ";
					sellOrder.txtMsg.text+=sellOrder.txtSymbol.text;
					sellOrder.txtMsg.text+=' ' +ResourceManager.getInstance().getString('marketwatch','at')+" "
					sellOrder.txtMsg.text+=sellOrder.txtPrice.text;
					sellOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','per')+' ' + unit + ResourceManager.getInstance().getString('marketwatch','?');
					if (sellOrder.txtDiscVol.text.length > 0 && !isNaN(parseInt(sellOrder.txtDiscVol.text)))
					{
						sellOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','discVolis')+' ' + sellOrder.txtDiscVol.text;
					}
					sellOrder.isFirstSubmission=false;
				}
				else
				{
					if(sellFlag == false)
					{
						return;
					}
					sellFlag = false;
					orderModel_.orderBO=new OrderBO();
					orderModel_.orderBO.SIDE="sell";
					orderModel_.fillOrderBO1(sellOrder);
					// added on 3/01/2011
					orderModel_.orderBO.REF_NO="";
					orderModel_.execute();
//					CursorManager.setCursor(Mouse, CursorManagerPriority.HIGH, 200, 300);
					sellOrder.isFirstSubmission=true;
//					CursorManager.setCursor(Mouse, CursorManagerPriority.HIGH, 200, 00);
				}
			}
			else
			{
				// modified on 7/1/2011
				if (txtMessage != "")
				{
					sellOrder.txtMsg.text=txtMessage;
					txtMessage="";
				}
				else
				{
//					sellOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','plzCorrctInpt');
				}
				sellOrder.isFirstSubmission=true;
			}
		}
		public function submitChangeOrder(event:KeyboardEvent):void
		{
			ModelManager.getInstance().updateRemainingOrders();
			
			if (event.keyCode != 13)
			{
				return;
			}
			var changeOrder:Order=WindowManager.getInstance().viewManager.changeOrder;
			WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
			WindowManager.getInstance().changeOrderWindow.setStyle("borderColor", 0x909090);
			WindowManager.getInstance().changeOrderWindow.setStyle("borderWeight", 1);
			ModelManager.getInstance().updateRemainingOrders();
			
			if (validateOrder(changeOrder))
			{
				if (changeOrder.isFirstSubmission)
				{
					var unit:String=ResourceManager.getInstance().getString('marketwatch','share');
					var isBond:Boolean=ModelManager.getInstance().exchangeModel.isBondMarket(changeOrder.internalExchangeID, changeOrder.internalMarketID);
					if (isBond)
						unit=ResourceManager.getInstance().getString('marketwatch','bond');

					if (changeOrder.isNgtdPanelExpanded)
					{
						changeOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','accept')+' ';
					}
					else
					{
						changeOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','change')+" ";
					}
					if (changeOrder.side == "sell")
					{
						changeOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','sell')+" ";
						var rect:Rect = new Rect();
						var myFillo:LinearGradient=new LinearGradient();
						myFillo.rotation=90;
						var myFillColoro:GradientEntry=new GradientEntry(0xff8eba);
						myFillColoro.ratio=0.10;
						var myFillColors1:GradientEntry=new GradientEntry(0xfe498c);
						myFillColors1.ratio=0.90;
						myFillo.entries=[myFillColoro, myFillColors1];
						changeOrder.bondPanel.backgroundFill=myFillo;
						
						
						
						
						var myFill2327:SolidColor=new SolidColor();
						myFill2327.color=0xbe3267;
						myFill2327.alpha=1;
						changeOrder.bcMain.backgroundFill=myFill2327;
						
						WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderWeight", 1);
						
						changeOrder.stdTopLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.topStdRt.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdRgt.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdBottom.setStyle("strokeColor", 0xbb3769);
						changeOrder.addLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.addRgt.setStyle("strokeColor", 0xbb3769);
						changeOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.additionalDetailsRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.bondPanelBottomRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataTopLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataTopRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataBottomRule.setStyle("strokeColor", 0xbb3769);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						changeOrder.setStyle("borderVisible", true);
						changeOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						changeOrder.setStyle("borderThicknessTop", 2);
						changeOrder.setStyle("color", Constants.TITLE_COLOR);
						changeOrder.okButton.setStyle("skinClass", SellOkButtonOverSkin);
						changeOrder.cancelButton.setStyle("skinClass", CancelButtonOverSkin);
						//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
						//						cancelOrder.setStyle("backgroundColor", 0xbe3267);
					}
					else if (changeOrder.side == "buy")
					{
						changeOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','buy');
						
						
						
							var myFill2:LinearGradient=new LinearGradient();
							myFill2.rotation=90;
							var myFillColor3:GradientEntry=new GradientEntry(0x94d9fa);
							myFillColor3.ratio=0.10;
							var myFillColor4:GradientEntry=new GradientEntry(0x5fc3f4);
							myFillColor4.ratio=0.90;
							myFill2.entries=[myFillColor3, myFillColor4];
							changeOrder.bondPanel.backgroundFill=myFill2;
						
						var myFill2324:SolidColor=new SolidColor();
						myFill2324.color=0x0c70a2;
						myFill2324.alpha=1;
						changeOrder.bcMain.backgroundFill=myFill2324;
						//						cancelOrder.grpFields.backgroundFill=myFill232;
						WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderWeight", 1);
						
						changeOrder.stdTopLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.topStdRt.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdRgt.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdBottom.setStyle("strokeColor", 0x51bbef);
						changeOrder.addLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.addRgt.setStyle("strokeColor", 0x51bbef);
						changeOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.additionalDetailsRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.bondPanelBottomRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataTopLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataTopRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataBottomRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.okButton.setStyle("skinClass", BuyOkButton);
						changeOrder.cancelButton.setStyle("skinClass", BuyCancelButton);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderWeight", 1);
						changeOrder.setStyle("borderVisible", true);
						changeOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						changeOrder.setStyle("borderThicknessTop", 2);
						changeOrder.setStyle("color", Constants.TITLE_COLOR);
					}
					changeOrder.txtMsg.text+=changeOrder.txtVolume.text;
					changeOrder.txtMsg.text+=" " + unit;
					changeOrder.txtMsg.text+="s" +ResourceManager.getInstance().getString('marketwatch','of')+" ";
					changeOrder.txtMsg.text+=changeOrder.txtSymbol.text;
					changeOrder.txtMsg.text+=' ' +ResourceManager.getInstance().getString('marketwatch','at')+" "
					changeOrder.txtMsg.text+=changeOrder.txtPrice.text;
					changeOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','per')+' ' + unit + ResourceManager.getInstance().getString('marketwatch','?');
					if (changeOrder.txtDiscVol.text.length > 0 && !isNaN(parseInt(changeOrder.txtDiscVol.text)))
					{
						changeOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','discVolis')+' ' + changeOrder.txtDiscVol.text;
					}
					changeOrder.isFirstSubmission=false;
				}
				else
				{
					orderModel_.orderBO=new OrderBO();
					for(var i:int = 0 ; i < 10 && ModelManager.getInstance().changebooleanFlag == false ; i++ )
					{
						setTimeout(launchAlert2, 1000);
					}
					function launchAlert2():void
					{
						
					}
					orderModel_.fillOrderBO(changeOrder);
					orderModel_.orderBO.PUBLIC_ORDER_STATE="Change";
					// added on 4/1/2011
					orderModel_.orderBO.REF_NO=orderModel_.REF_NO;
					orderModel_.REF_NO="";
					// added on 12/1/2011
					orderModel_.orderBO.CLIENT_ID=orderModel_.CLIENT_ID;
					orderModel_.CLIENT_ID=-1;

					var tempOrderBO:OrderBO=remainingOrdersModel.getOrderBOByOrderNumber(new Number(changeOrder.txtOrderNum.text));
					if (tempOrderBO)
					{
						orderModel_.orderBO.PREVIOUS_VOLUME=tempOrderBO.VOLUME;
						orderModel_.orderBO.PREVIOUS_PRICE=tempOrderBO.PRICE;
					}

					if (orderModel_.orderBO.IS_NEGOTIATED)
					{
						orderModel_.orderBO.USER_ID=orderModel_.USER_ID;
						orderModel_.orderBO.SENDER_USER_ID=orderModel_.USER_ID;
						orderModel_.USER_ID=-1;
						orderModel_.orderBO.TYPE="negotiated";

						orderModel_.orderBO.BROKER_ID=orderModel_.BROKER_ID;
						orderModel_.BROKER_ID=-1;
					}
					if (changeOrder.isNgtdPanelExpanded)
					{
						if (changeOrder.side == "sell")
						{
							orderModel_.sellOrderAccept();
								//submitSellOrder(event);
						}
						else
						{
							orderModel_.buyOrderAccept();
								//submitBuyOrder(event);
						}
					}
					else
					{
						orderModel_.changeOrder();
					}
					changeOrder.isFirstSubmission=true;
				}
			}
			else
			{
				// modified on 7/1/2011
				if (txtMessage != "")
				{
					changeOrder.txtMsg.text=txtMessage;
					txtMessage="";
				}
				else
				{
//					changeOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','plzCorrctInpt');
				}
				changeOrder.isFirstSubmission=true;
			}
		}
		////////////////////////////////////////////
		public function submitChangeOrderOkClcikHandler(event:MouseEvent):void
		{
			ModelManager.getInstance().updateRemainingOrders();
			var changeOrderWindow:Order = WindowManager.getInstance().viewManager.changeOrder;
			if (event == null || changeOrderWindow.txtOrderNum.text == '')
			{
//				changeOrderWindow.txtMsg.text = ResourceManager.getInstance().getString('marketwatch','plzfilltheReqFields')+' ';
				Alert.show(ResourceManager.getInstance().getString('marketwatch','plzfilltheReqFields'),ResourceManager.getInstance().getString('marketwatch','error'));
				return;
			}
			var changeOrder:Order=WindowManager.getInstance().viewManager.changeOrder;
			WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
			WindowManager.getInstance().changeOrderWindow.setStyle("borderColor", 0x909090);
			WindowManager.getInstance().changeOrderWindow.setStyle("borderWeight", 1);
			ModelManager.getInstance().updateRemainingOrders();
			for(var i:int = 0 ; i < 10 && ModelManager.getInstance().changebooleanFlag == false ; i++ )
			{
				setTimeout(launchAlert1, 3000);
			}
			function launchAlert1():void
			{
				//				Alert.show('aaa');
			}
			if (validateOrder(changeOrder))
			{
				if (changeOrder.isFirstSubmission)
				{
					var unit:String=ResourceManager.getInstance().getString('marketwatch','share');
					var isBond:Boolean=ModelManager.getInstance().exchangeModel.isBondMarket(changeOrder.internalExchangeID, changeOrder.internalMarketID);
					if (isBond)
						unit=ResourceManager.getInstance().getString('marketwatch','bond');
					
					if (changeOrder.isNgtdPanelExpanded)
					{
						changeOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','accept')+" ";
					}
					else
					{
						changeOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','change')+" ";
					}
					if (changeOrder.side == "sell")
					{
						changeOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','sell');
						var rect:Rect = new Rect();
						var myFillo:LinearGradient=new LinearGradient();
						myFillo.rotation=90;
						var myFillColoro:GradientEntry=new GradientEntry(0xff8eba);
						myFillColoro.ratio=0.10;
						var myFillColors1:GradientEntry=new GradientEntry(0xfe498c);
						myFillColors1.ratio=0.90;
						myFillo.entries=[myFillColoro, myFillColors1];
						changeOrder.bondPanel.backgroundFill=myFillo;
						
						
						
						
						var myFill2327:SolidColor=new SolidColor();
						myFill2327.color=0xbe3267;
						myFill2327.alpha=1;
						changeOrder.bcMain.backgroundFill=myFill2327;
						
						WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderWeight", 1);
						
						changeOrder.stdTopLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.topStdRt.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdRgt.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.stdBottom.setStyle("strokeColor", 0xbb3769);
						changeOrder.addLeft.setStyle("strokeColor", 0xbb3769);
						changeOrder.addRgt.setStyle("strokeColor", 0xbb3769);
						changeOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.additionalDetailsRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.bondPanelBottomRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataTopLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataTopRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataLeftRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataRightRule.setStyle("strokeColor", 0xbb3769);
						changeOrder.marketDataBottomRule.setStyle("strokeColor", 0xbb3769);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						changeOrder.setStyle("borderVisible", true);
						changeOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						changeOrder.setStyle("borderThicknessTop", 2);
						changeOrder.setStyle("color", Constants.TITLE_COLOR);
						changeOrder.okButton.setStyle("skinClass", SellOkButtonOverSkin);
						changeOrder.cancelButton.setStyle("skinClass", CancelButtonOverSkin);
						//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
						//						cancelOrder.setStyle("backgroundColor", 0xbe3267);
					}
					else if (changeOrder.side == "buy")
					{
						changeOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','buy');
						
						
						
						var myFill2:LinearGradient=new LinearGradient();
						myFill2.rotation=90;
						var myFillColor3:GradientEntry=new GradientEntry(0x94d9fa);
						myFillColor3.ratio=0.10;
						var myFillColor4:GradientEntry=new GradientEntry(0x5fc3f4);
						myFillColor4.ratio=0.90;
						myFill2.entries=[myFillColor3, myFillColor4];
						changeOrder.bondPanel.backgroundFill=myFill2;
						
						var myFill2324:SolidColor=new SolidColor();
						myFill2324.color=0x0c70a2;
						myFill2324.alpha=1;
						changeOrder.bcMain.backgroundFill=myFill2324;
						//						cancelOrder.grpFields.backgroundFill=myFill232;
						WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderWeight", 1);
						
						changeOrder.stdTopLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.topStdRt.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdRgt.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.stdBottom.setStyle("strokeColor", 0x51bbef);
						changeOrder.addLeft.setStyle("strokeColor", 0x51bbef);
						changeOrder.addRgt.setStyle("strokeColor", 0x51bbef);
						changeOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.additionalDetailsRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.bondPanelBottomRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataTopLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataTopRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataLeftRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataRightRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.marketDataBottomRule.setStyle("strokeColor", 0x51bbef);
						changeOrder.okButton.setStyle("skinClass", BuyOkButton);
						changeOrder.cancelButton.setStyle("skinClass", BuyCancelButton);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().changeOrderWindow.setStyle("borderWeight", 1);
						changeOrder.setStyle("borderVisible", true);
						changeOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						changeOrder.setStyle("borderThicknessTop", 2);
						changeOrder.setStyle("color", Constants.TITLE_COLOR);
					}
					changeOrder.txtMsg.text+=changeOrder.txtVolume.text;
					changeOrder.txtMsg.text+=" " + unit;
					changeOrder.txtMsg.text+="s" +ResourceManager.getInstance().getString('marketwatch','of')+" ";
					changeOrder.txtMsg.text+=changeOrder.txtSymbol.text;
					changeOrder.txtMsg.text+=' ' +ResourceManager.getInstance().getString('marketwatch','at')+" "
					changeOrder.txtMsg.text+=changeOrder.txtPrice.text;
					changeOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','per')+' ' + unit + ResourceManager.getInstance().getString('marketwatch','?');
					if (changeOrder.txtDiscVol.text.length > 0 && !isNaN(parseInt(changeOrder.txtDiscVol.text)))
					{
						changeOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','discVolis')+' ' + changeOrder.txtDiscVol.text;
					}
					changeOrder.isFirstSubmission=false;
				}
				else
				{
					orderModel_.orderBO=new OrderBO();
					for(var ii:int = 0 ; ii < 10 && ModelManager.getInstance().changebooleanFlag == false ; ii++ )
					{
						setTimeout(launchAlert, 1000);
					}
					function launchAlert():void
					{
						
					}
					orderModel_.fillOrderBO(changeOrder);
					orderModel_.orderBO.PUBLIC_ORDER_STATE="Change";
					// added on 4/1/2011
					orderModel_.orderBO.REF_NO=orderModel_.REF_NO;
					orderModel_.REF_NO="";
					// added on 12/1/2011
					orderModel_.orderBO.CLIENT_ID=orderModel_.CLIENT_ID;
					orderModel_.CLIENT_ID=-1;
					
					var tempOrderBO:OrderBO=remainingOrdersModel.getOrderBOByOrderNumber(new Number(changeOrder.txtOrderNum.text));
					if (tempOrderBO)
					{
						orderModel_.orderBO.PREVIOUS_VOLUME=tempOrderBO.VOLUME;
						orderModel_.orderBO.PREVIOUS_PRICE=tempOrderBO.PRICE;
					}
					
					if (orderModel_.orderBO.IS_NEGOTIATED)
					{
						orderModel_.orderBO.USER_ID=orderModel_.USER_ID;
						orderModel_.orderBO.SENDER_USER_ID=orderModel_.USER_ID;
						orderModel_.USER_ID=-1;
						orderModel_.orderBO.TYPE="negotiated";
						
						orderModel_.orderBO.BROKER_ID=orderModel_.BROKER_ID;
						orderModel_.BROKER_ID=-1;
					}
					if (changeOrder.isNgtdPanelExpanded)
					{
						if (changeOrder.side == "sell")
						{
							orderModel_.sellOrderAccept();
							//submitSellOrder(event);
						}
						else
						{
							orderModel_.buyOrderAccept();
							//submitBuyOrder(event);
						}
					}
					else
					{
						orderModel_.changeOrder();
					}
					changeOrder.isFirstSubmission=true;
				}
			}
			else
			{
				// modified on 7/1/2011
				if (txtMessage != "")
				{
					changeOrder.txtMsg.text=txtMessage;
					txtMessage="";
				}
				else
				{
//					changeOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','plzCorrctInpt');
				}
				changeOrder.isFirstSubmission=true;
			}
		}

		public function submitCancelOrder(event:KeyboardEvent):void
		{
			ModelManager.getInstance().updateRemainingOrders();
			if (event.keyCode != 13)
			{
				return;
			}
			var cancelOrder:Order=WindowManager.getInstance().viewManager.cancelOrder;
			WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
			WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
			WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
			// modified on 5/1/2011
			if (validateOrder(cancelOrder, true))
			{
				if (cancelOrder.isFirstSubmission)
				{
					var unit:String=ResourceManager.getInstance().getString('marketwatch','share');
					var isBond:Boolean=ModelManager.getInstance().exchangeModel.isBondMarket(cancelOrder.internalExchangeID, cancelOrder.internalMarketID);
					if (isBond)
						unit=ResourceManager.getInstance().getString('marketwatch','bond');
					if (cancelOrder.isNgtdPanelExpanded)
					{
						cancelOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','reject');
					}
					else
					{
						cancelOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','cancel');
					}

					if (cancelOrder.side == "sell")
					{
						cancelOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','sell');
						var rect:Rect = new Rect();
						var myFill:LinearGradient=new LinearGradient();
						myFill.rotation=90;
						var myFillColor:GradientEntry=new GradientEntry(0xff8eba);
						myFillColor.ratio=0.10;
						var myFillColor1:GradientEntry=new GradientEntry(0xfe498c);
						myFillColor1.ratio=0.90;
						myFill.entries=[myFillColor, myFillColor1];
						cancelOrder.bondPanel.backgroundFill=myFill;





						var myFill232:SolidColor=new SolidColor();
						myFill232.color=0xbe3267;
						myFill232.alpha=1;
						cancelOrder.bcMain.backgroundFill=myFill232;
						
						WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
						
						cancelOrder.stdTopLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.topStdRt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdRgt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdBottom.setStyle("strokeColor", 0xbb3769);
						cancelOrder.addLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.addRgt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.additionalDetailsRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.bondPanelBottomRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataTopLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataTopRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataBottomRule.setStyle("strokeColor", 0xbb3769);
//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						cancelOrder.setStyle("borderVisible", true);
						cancelOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						cancelOrder.setStyle("borderThicknessTop", 2);
						cancelOrder.setStyle("color", Constants.TITLE_COLOR);
						cancelOrder.okButton.setStyle("skinClass", SellOkButtonOverSkin);
						cancelOrder.cancelButton.setStyle("skinClass", CancelButtonOverSkin);
//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
//						cancelOrder.setStyle("backgroundColor", 0xbe3267);
					}
					else if (cancelOrder.side == "buy")
					{
						cancelOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','buy');
						var myFill2:LinearGradient=new LinearGradient();
						myFill2.rotation=90;
						var myFillColor3:GradientEntry=new GradientEntry(0x94d9fa);
						myFillColor3.ratio=0.10;
						var myFillColor4:GradientEntry=new GradientEntry(0x5fc3f4);
						myFillColor4.ratio=0.90;
						myFill2.entries=[myFillColor3, myFillColor4];
						cancelOrder.bondPanel.backgroundFill=myFill2;



						var myFill2324:SolidColor=new SolidColor();
						myFill2324.color=0x0c70a2;
						myFill2324.alpha=1;
						cancelOrder.bcMain.backgroundFill=myFill2324;
//						cancelOrder.grpFields.backgroundFill=myFill232;
						WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
						
						cancelOrder.stdTopLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.topStdRt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdRgt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdBottom.setStyle("strokeColor", 0x51bbef);
						cancelOrder.addLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.addRgt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.additionalDetailsRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.bondPanelBottomRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataTopLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataTopRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataBottomRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.okButton.setStyle("skinClass", BuyOkButton);
						cancelOrder.cancelButton.setStyle("skinClass", BuyCancelButton);
//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
						cancelOrder.setStyle("borderVisible", true);
						cancelOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						cancelOrder.setStyle("borderThicknessTop", 2);
						cancelOrder.setStyle("color", Constants.TITLE_COLOR);
//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
					}
					cancelOrder.txtMsg.text+=cancelOrder.txtVolume.text;
					cancelOrder.txtMsg.text+=" " + unit;
					cancelOrder.txtMsg.text+="s" +ResourceManager.getInstance().getString('marketwatch','of')+" ";
					cancelOrder.txtMsg.text+=cancelOrder.txtSymbol.text;
					cancelOrder.txtMsg.text+=' ' +ResourceManager.getInstance().getString('marketwatch','at')+" "
					cancelOrder.txtMsg.text+=cancelOrder.txtPrice.text;
					cancelOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','per')+' ' + unit + ResourceManager.getInstance().getString('marketwatch','?');
					if (cancelOrder.txtDiscVol.text.length > 0 && !isNaN(parseInt(cancelOrder.txtDiscVol.text)))
					{
						cancelOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','discVolis')+' ' + cancelOrder.txtDiscVol.text;
					}
					cancelOrder.isFirstSubmission=false;
				}
				else
				{
					orderModel_.orderBO=new OrderBO();
					for(var i:int = 0 ; i < 10 && ModelManager.getInstance().cancelbooleanFlag == false ; i++ )
					{
						setTimeout(launchAlert, 1000);
					}
					function launchAlert():void
					{
						
					}
					orderModel_.fillOrderBO(cancelOrder);
					// added on 4/1/2011
					orderModel_.orderBO.REF_NO=orderModel_.REF_NO;
					orderModel_.REF_NO="";
					// added on 12/1/2011
					orderModel_.orderBO.CLIENT_ID=orderModel_.CLIENT_ID;
					orderModel_.CLIENT_ID=-1;
					orderModel_.orderBO.PUBLIC_ORDER_STATE="Cancel";

					if (orderModel_.orderBO.IS_NEGOTIATED)
					{
						orderModel_.orderBO.USER_ID=orderModel_.USER_ID;
						orderModel_.orderBO.SENDER_USER_ID=orderModel_.USER_ID;
						orderModel_.USER_ID=-1;
						orderModel_.orderBO.TYPE="negotiated";

						orderModel_.orderBO.BROKER_ID=orderModel_.BROKER_ID;
						orderModel_.BROKER_ID=-1;
					}
					if (cancelOrder.isNgtdPanelExpanded && orderModel_.orderBO.USER_ID != userID)
					{
						if (cancelOrder.side == "sell")
						{
							orderModel_.sellOrderReject();
								//submitSellOrder(event);
						}
						else
						{
							orderModel_.buyOrderReject();
								//submitBuyOrder(event);
						}
					}
					else
					{
						orderModel_.cancelOrder();
					}
					cancelOrder.isFirstSubmission=true;
				}
			}
			else
			{
				// modified on 7/1/2011
				if (txtMessage != "")
				{
					cancelOrder.txtMsg.text=txtMessage;
					txtMessage="";
				}
				else
				{
//					cancelOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','plzCorrctInpt');
				}
				cancelOrder.isFirstSubmission=true;
			}
		}
		
		

		////////////////////////////////////////
		
		public function submitCancelOrderOkClickHandler(event:MouseEvent):void
		{
			ModelManager.getInstance().updateRemainingOrders();
			var cancelOrderWindow:Order = WindowManager.getInstance().viewManager.cancelOrder;
			if(event == null || cancelOrderWindow.txtOrderNum.text == '' )
			{
//				cancelOrderWindow.txtMsg.text = ResourceManager.getInstance().getString('marketwatch','plzfilltheReqFields')+' ';
				Alert.show(ResourceManager.getInstance().getString('marketwatch','plzfilltheReqFields'),ResourceManager.getInstance().getString('marketwatch','error'));
				return;	
			}
			var cancelOrder:Order=WindowManager.getInstance().viewManager.cancelOrder;
			WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
			WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
			WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
			ModelManager.getInstance().updateRemainingOrders();
			// modified on 5/1/2011
			if (validateOrder(cancelOrder, true))
			{
				if (cancelOrder.isFirstSubmission)
				{
					var unit:String=ResourceManager.getInstance().getString('marketwatch','share');
					var isBond:Boolean=ModelManager.getInstance().exchangeModel.isBondMarket(cancelOrder.internalExchangeID, cancelOrder.internalMarketID);
					if (isBond)
						unit=ResourceManager.getInstance().getString('marketwatch','bond');
					if (cancelOrder.isNgtdPanelExpanded)
					{
						cancelOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','reject');
					}
					else
					{
						cancelOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','cancel');
					}
					
					if (cancelOrder.side == "sell")
					{
						cancelOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','sell');
						var rect:Rect = new Rect();
						var myFill:LinearGradient=new LinearGradient();
						myFill.rotation=90;
						var myFillColor:GradientEntry=new GradientEntry(0xff8eba);
						myFillColor.ratio=0.10;
						var myFillColor1:GradientEntry=new GradientEntry(0xfe498c);
						myFillColor1.ratio=0.90;
						myFill.entries=[myFillColor, myFillColor1];
						cancelOrder.bondPanel.backgroundFill=myFill;
						
						
						
						
						
						var myFill232:SolidColor=new SolidColor();
						myFill232.color=0xbe3267;
						myFill232.alpha=1;
						cancelOrder.bcMain.backgroundFill=myFill232;
						
						WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
						
						cancelOrder.stdTopLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.topStdRt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdRgt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.stdBottom.setStyle("strokeColor", 0xbb3769);
						cancelOrder.addLeft.setStyle("strokeColor", 0xbb3769);
						cancelOrder.addRgt.setStyle("strokeColor", 0xbb3769);
						cancelOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.additionalDetailsRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.bondPanelBottomRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataTopLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataTopRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataLeftRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataRightRule.setStyle("strokeColor", 0xbb3769);
						cancelOrder.marketDataBottomRule.setStyle("strokeColor", 0xbb3769);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						cancelOrder.setStyle("borderVisible", true);
						cancelOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						cancelOrder.setStyle("borderThicknessTop", 2);
						cancelOrder.setStyle("color", Constants.TITLE_COLOR);
						cancelOrder.okButton.setStyle("skinClass", SellOkButtonOverSkin);
						cancelOrder.cancelButton.setStyle("skinClass", CancelButtonOverSkin);
						//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
						//						cancelOrder.setStyle("backgroundColor", 0xbe3267);
					}
					else if (cancelOrder.side == "buy")
					{
						cancelOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','buy');
						var myFill2:LinearGradient=new LinearGradient();
						myFill2.rotation=90;
						var myFillColor3:GradientEntry=new GradientEntry(0x94d9fa);
						myFillColor3.ratio=0.10;
						var myFillColor4:GradientEntry=new GradientEntry(0x5fc3f4);
						myFillColor4.ratio=0.90;
						myFill2.entries=[myFillColor3, myFillColor4];
						cancelOrder.bondPanel.backgroundFill=myFill2;
						
						
						
						var myFill2324:SolidColor=new SolidColor();
						myFill2324.color=0x0c70a2;
						myFill2324.alpha=1;
						cancelOrder.bcMain.backgroundFill=myFill2324;
						//						cancelOrder.grpFields.backgroundFill=myFill232;
						WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
						
						cancelOrder.stdTopLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.topStdRt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdRgt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.stdBottom.setStyle("strokeColor", 0x51bbef);
						cancelOrder.addLeft.setStyle("strokeColor", 0x51bbef);
						cancelOrder.addRgt.setStyle("strokeColor", 0x51bbef);
						cancelOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.additionalDetailsRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.bondPanelBottomRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataTopLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataTopRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataLeftRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataRightRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.marketDataBottomRule.setStyle("strokeColor", 0x51bbef);
						cancelOrder.okButton.setStyle("skinClass", BuyOkButton);
						cancelOrder.cancelButton.setStyle("skinClass", BuyCancelButton);
						//						cancelOrder.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
						cancelOrder.setStyle("borderVisible", true);
						cancelOrder.setStyle("bordercolor", Constants.BORDER_TOP);
						cancelOrder.setStyle("borderThicknessTop", 2);
						cancelOrder.setStyle("color", Constants.TITLE_COLOR);
						//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderColor", 0x909090);
						//						WindowManager.getInstance().cancelOrderWindow.setStyle("borderWeight", 1);
					}
					cancelOrder.txtMsg.text+=cancelOrder.txtVolume.text;
					cancelOrder.txtMsg.text+=" " + unit;
					cancelOrder.txtMsg.text+="s" +ResourceManager.getInstance().getString('marketwatch','of')+" ";
					cancelOrder.txtMsg.text+=cancelOrder.txtSymbol.text;
					cancelOrder.txtMsg.text+=' ' +ResourceManager.getInstance().getString('marketwatch','at')+" "
					cancelOrder.txtMsg.text+=cancelOrder.txtPrice.text;
					cancelOrder.txtMsg.text+=" "+ResourceManager.getInstance().getString('marketwatch','per')+' ' + unit + ResourceManager.getInstance().getString('marketwatch','?');
					if (cancelOrder.txtDiscVol.text.length > 0 && !isNaN(parseInt(cancelOrder.txtDiscVol.text)))
					{
						cancelOrder.txtMsg.text+=ResourceManager.getInstance().getString('marketwatch','discVolis')+' ' + cancelOrder.txtDiscVol.text;
					}
					cancelOrder.isFirstSubmission=false;
				}
				else
				{
					orderModel_.orderBO=new OrderBO();
					for(var i:int = 0 ; i < 10 && ModelManager.getInstance().cancelbooleanFlag == false ; i++ )
					{
						setTimeout(launchAlert, 1000);
					}
					function launchAlert():void
					{
						
					}
					orderModel_.fillOrderBO(cancelOrder);
					// added on 4/1/2011
					orderModel_.orderBO.REF_NO=orderModel_.REF_NO;
					orderModel_.REF_NO="";
					// added on 12/1/2011
					orderModel_.orderBO.CLIENT_ID=orderModel_.CLIENT_ID;
					orderModel_.CLIENT_ID=-1;
					orderModel_.orderBO.PUBLIC_ORDER_STATE="Cancel";
					
					if (orderModel_.orderBO.IS_NEGOTIATED)
					{
						orderModel_.orderBO.USER_ID=orderModel_.USER_ID;
						orderModel_.orderBO.SENDER_USER_ID=orderModel_.USER_ID;
						orderModel_.USER_ID=-1;
						orderModel_.orderBO.TYPE="negotiated";
						
						orderModel_.orderBO.BROKER_ID=orderModel_.BROKER_ID;
						orderModel_.BROKER_ID=-1;
					}
					if (cancelOrder.isNgtdPanelExpanded && orderModel_.orderBO.USER_ID != userID)
					{
						if (cancelOrder.side == "sell")
						{
							orderModel_.sellOrderReject();
							//submitSellOrder(event);
						}
						else
						{
							orderModel_.buyOrderReject();
							//submitBuyOrder(event);
						}
					}
					else
					{
						orderModel_.cancelOrder();
					}
					cancelOrder.isFirstSubmission=true;
				}
			}
			else
			{
				// modified on 7/1/2011
				if (txtMessage != "")
				{
					cancelOrder.txtMsg.text=txtMessage;
					txtMessage="";
				}
				else
				{
//					cancelOrder.txtMsg.text=ResourceManager.getInstance().getString('marketwatch','plzCorrctInpt');
				}
				cancelOrder.isFirstSubmission=true;
			}
		}
		///////////////////////////////////////
		public function submitCancelOrderCancelClickHandler(event:MouseEvent):void
		{
			var cancelOrderWindow:Order = WindowManager.getInstance().viewManager.cancelOrder;
			if(event != null)
			{
				cancelOrderWindow.txtOrderNum.text = '';
//				cancelOrderWindow.txtVolume.text = ''; 
//				cancelOrderWindow.txtPrice.text = '';
//				cancelOrderWindow.txtAccount.text = '';
				cancelOrderWindow.txtMsg.text = '';
			}
		}
		//////////////////////////////////////
		public function submitChangeOrderCancelClickHandler(event:MouseEvent):void
		{
			var changeOrderWindow:Order = WindowManager.getInstance().viewManager.changeOrder;
			if(event != null)
			{
				changeOrderWindow.txtOrderNum.text = '';
				//				cancelOrderWindow.txtVolume.text = ''; 
				//				cancelOrderWindow.txtPrice.text = '';
				//				cancelOrderWindow.txtAccount.text = '';
				changeOrderWindow.txtMsg.text = '';
			}
		}
		//////////////////////////////////////
		public function MarketStateChange(marketStateInfo:MarketStateInfo):void
		{
			if (marketStateInfo.exchangeID.internalID_ > -1 && marketStateInfo.marketID.internalID_ > -1)
			{
				exchangeScheduleModel_.executeMarketStateChange(marketStateInfo);
			}
		}

		////////////////////////////////////////
		public function SymbolStateChange(symbolStateInfo:SymbolStateInfo):void
		{
			if (symbolStateInfo.exchangeID.internalID_ > -1 && symbolStateInfo.marketID.internalID_ > -1)
			{
				exchangeScheduleModel_.executeSymbolStateChange(symbolStateInfo);
			}
		}

		////////////////////////////////////////
		public function SymbolOrderLimitChange(symbolOrderLimit:SymbolOrderLimitBO):void
		{
			if (symbolOrderLimit.INTERNAL_EXCHANGE_ID > -1 && symbolOrderLimit.INTERNAL_MARKET_ID > -1 && symbolOrderLimit.INTERNAL_SYMBOL_ID > -1)
			{
				symbolOrderLimitModel_.symbolOrderLimit=symbolOrderLimit;
				symbolOrderLimitModel_.execute();
			}
		}

		////////////////////////////////////////
		public function SubmitBulletin(bulletin:Bulletin):void
		{
			if (bulletin.ID > -1 || bulletin.toAllExchanges)
			{
				bulletinModel_.bulletin=bulletin;
				bulletinModel_.execute();
			}
		}

		/////////////////////setDirty///////////////////
		public function setDirty(value:Boolean):void
		{
			//for each(var objModel:IModel in models_)
			//{
			//objModel.isDirty = value;
			//}
		}

		/////////////////////update///////////////////
		public function update():void
		{
			//for each(var objModel:IModel in models_)
			//{
			//don't execute the buy/sell order
			//if (!(objModel is OrderModel))
			//{
			//	objModel.execute();
			//}
			//}
		}

		private function validateOrder(order:Order, isCancelOrder:Boolean=false):Boolean
		{
			try
			{
				ModelManager.getInstance().updateRemainingOrders();
				if(WindowManager.getInstance().viewManager.buyOrder.txtExchange.text == "BOND")
				{
					var obj:Object =(exchangeModel.getSymbolByCode(order.internalExchangeID, order.internalMarketID, order.txtSymbol.text));
					var bonsStr:String = (obj as BondBO).bondType;
				}
			}
			catch(e:Error)
			{
				trace(e.message);
			}
			var retVal:Boolean=true;
			// added on 24/3/2011 to apply exchange and market check before order submition
			if (order.internalExchangeID > -1 && order.internalMarketID > -1)
			{
				var currentState:String=exchangeScheduleModel.getCurrentMarketSchedule(order.internalExchangeID, order.internalMarketID);
				if (currentState == "" || !(States.MARKET_STATES[currentState] == States.MARKET_STATES['Open'] || States.MARKET_STATES[currentState] == States.MARKET_STATES['PreOpen']))
				{
					var strMarketCode:String=exchangeModel.getMarketCode(order.internalExchangeID, order.internalMarketID);
					txtMessage=ResourceManager.getInstance().getString('marketwatch','marketStateOf')+" " + strMarketCode + "  "+ResourceManager.getInstance().getString('marketwatch','is')+' ' + currentState;
					return false;
				}

//				var symbolObj:SymbolBO = ModelManager.getInstance().exchangeModel.getSymbol(order.internalExchangeID,order.internalMarketID,order.internalSymbolID);
//				if(symbolObj.STATE != States.SYMBOL_STATES[0])
//					{
//						txtMessage = "Symbol state of " + symbolObj.SYMBOL+ " is " + symbolObj.STATE;
//						return false;		
//					}				
			}
			if (
				//!order.ddMarket.selectedItem ||
				//!order.ddSymbol.selectedItem ||
				(order.rdogrpLmtMkt.selectedValue == "limit" && !order.txtPrice.text.length > 0) || !order.txtVolume.text.length > 0 ||
				// added on 8/12/2010 to validate price
				// commented on 9/6/2011 and asked WHY??? What were you thinking??? "man these guys dont even know that what they have to achieve and what they had already achieved so dont worry ustad g i appreciate you through out..."
				//!order.txtPrice.text.length > 0 ||
				!order.txtAccount.text.length > 0 )
			{
				retVal=false;
			}
			
			if(bonsStr=="Corporate")
			{
				retVal=false;
			}
			/*if ((order.ddType.selectedIndex == 1 || // MT or SL
				order.ddType.selectedIndex == 2) &&
				true
				)
			{
				retVal = true;
			}*/
			// Start : added on 7/1/2011
			if (retVal)
			{
				var delimRegExp:RegExp=/,/g;
				var price:Number=new Number(order.txtPrice.text.replace(delimRegExp, ""));

				var volume:Number=new Number(order.txtVolume.text.replace(delimRegExp, ""));
				if ((order.rdogrpLmtMkt.selectedValue == "limit" && price <= 0) || volume <= 0)
				{
					return false;
				}
				var symbol:String=order.txtSymbol.text.toUpperCase();
				var internalSymbolId:Number=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(order.internalExchangeID, order.internalMarketID, symbol);

				var symbolId:Number=ModelManager.getInstance().exchangeModel.getSymbolID(order.internalExchangeID, order.internalMarketID, internalSymbolId);

				var key:String=ModelManager.getInstance().exchangeModel.getExchangeID(order.internalExchangeID) + "_" + ModelManager.getInstance().exchangeModel.getMarketID(order.internalExchangeID, order.internalMarketID) + "_" + symbolId;

//				var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO = ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
//				if(bestMarketAndSymbolSummary){
//					if(bestMarketAndSymbolSummary.symbolSummary && bestMarketAndSymbolSummary.symbolSummary.browser )
//					{
//						var browser:SymbolBrowserBO = bestMarketAndSymbolSummary.symbolSummary.browser;
//						if(volume < browser.lowerVolumeLimit || volume > browser.upperVolumeLimit )
//						{
//							txtMessage = ResourceManager.getInstance().getString('marketwatch','volLimitsAre')+' '+browser.lowerVolumeLimit + " - "+browser.upperVolumeLimit;
//							return false;				
//						}
//						
//						if(!((volume / browser.lotSize) is uint) )
//						{
//							txtMessage = ResourceManager.getInstance().getString('marketwatch','volLotSize')+' '+browser.lotSize;
//							return false;
//						}
//						
//						if(price <= browser.circuitBreakerDown || price >= browser.circuitBreakerUp )
//						{
//							txtMessage = ResourceManager.getInstance().getString('marketwatch','circuitBreakLimit')+' '+browser.circuitBreakerDown + " - "+browser.circuitBreakerUp;
//							return false;				
//						}
//
//// 						commented on 12/1/2011						
////						if(!((price / browser.tickSize) is uint ))
////						{
////							txtMessage = "Price tick size is  "+browser.tickSize;
////							return false;
////						}
//						
//						if((price * volume) < browser.lowerValueLimit || (price * volume) > browser.upperValueLimit )
//						{
//							txtMessage = ResourceManager.getInstance().getString('marketwatch','valLimitsAre')+' '+browser.lowerValueLimit + " - "+browser.upperValueLimit;
//							return false;
//						}
//					}
//				}


				var symbolObj:SymbolBO=ModelManager.getInstance().exchangeModel.getSymbolDetail(ModelManager.getInstance().exchangeModel.getExchangeID(order.internalExchangeID), ModelManager.getInstance().exchangeModel.getMarketID(order.internalExchangeID, order.internalMarketID), symbolId) as SymbolBO;

				if (volume < symbolObj.LOWER_ORDER_VOLUME_LIMIT || volume > symbolObj.UPPER_ORDER_VOLUME_LIMIT)
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','volLimitsAre')+' ' + symbolObj.LOWER_ORDER_VOLUME_LIMIT + " - " + symbolObj.UPPER_ORDER_VOLUME_LIMIT;
					return false;
				}

				if (!((volume / symbolObj.BOARD_LOT) is uint))
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','volLotSize')+' ' + symbolObj.BOARD_LOT;
					return false;
				}

				if (order.rdogrpLmtMkt.selectedValue == "limit" && (price <= symbolObj.LOWER_CIRCUIT_BREAKER_LIMIT || price >= symbolObj.UPPER_CIRCUIT_BREAKER_LIMIT))
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','circuitBreakLimit')+' ' + symbolObj.LOWER_CIRCUIT_BREAKER_LIMIT + " - " + symbolObj.UPPER_CIRCUIT_BREAKER_LIMIT;
					return false;
				}

				// 						commented on 12/1/2011						
				//						if(!((price / browser.tickSize) is uint ))
				//						{
				//							txtMessage = "Price tick size is  "+browser.tickSize;
				//							return false;
				//						}

				if (order.rdogrpLmtMkt.selectedValue == "limit" && ((price * volume) < symbolObj.LOWER_ORDER_VALUE_LIMIT || (price * volume) > symbolObj.UPPER_ORDER_VALUE_LIMIT))
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','valLimitsAre')+' ' + symbolObj.LOWER_ORDER_VALUE_LIMIT + " - " + symbolObj.UPPER_ORDER_VALUE_LIMIT;
					return false;
				}

				if (order.chkNgtd && order.chkNgtd.selected && order.txtCounterPartyUserName.text.length == 0)
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','cntrUserNameMust')+' ';
					return false;
				}
				if (order.txtDiscVol.text.length > 0 && !isNaN(parseInt(order.txtDiscVol.text)) && !isCancelOrder)
				{
					var disclosed_volume:Number=new Number(order.txtDiscVol.text.replace(delimRegExp, ""));
					if (disclosed_volume > volume)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','discVolCantBeGreatThanVol')+' ';
						return false;
					}
					else if (volume % disclosed_volume != 0)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volShudBeMultipleOfDiscVol')+' ';
						return false;
					}
					else if (disclosed_volume % symbolObj.BOARD_LOT != 0)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','discVolShouldBeMultipleOfBoardLot')+' ';
						return false;
					}
				}
			}
			
			return retVal;
		}

		private function validateOrder1(order:SellOrder, isCancelOrder:Boolean=false):Boolean
		{
			try
			{
				if(WindowManager.getInstance().viewManager.sellOrder.txtExchange.text == "BOND")
				{
					var obj:Object =(exchangeModel.getSymbolByCode(order.internalExchangeID, order.internalMarketID, order.txtSymbol.text));
					var bonsStr:String = (obj as BondBO).bondType;
				}
			}
			catch(e:Error)
			{
				trace(e.message);
			}
			var retVal:Boolean=true;
			// added on 24/3/2011 to apply exchange and market check before order submition
			if (order.internalExchangeID > -1 && order.internalMarketID > -1)
			{
				var currentState:String=exchangeScheduleModel.getCurrentMarketSchedule(order.internalExchangeID, order.internalMarketID);
				if (currentState == "" || !(States.MARKET_STATES[currentState] == States.MARKET_STATES['Open'] || States.MARKET_STATES[currentState] == States.MARKET_STATES['PreOpen']))
				{
					var strMarketCode:String=exchangeModel.getMarketCode(order.internalExchangeID, order.internalMarketID);
					txtMessage=ResourceManager.getInstance().getString('marketwatch','marketStateOf')+" " + strMarketCode + "  "+ResourceManager.getInstance().getString('marketwatch','is')+' ' + currentState;
					return false;
				}

					//				var symbolObj:SymbolBO = ModelManager.getInstance().exchangeModel.getSymbol(order.internalExchangeID,order.internalMarketID,order.internalSymbolID);
					//				if(symbolObj.STATE != States.SYMBOL_STATES[0])
					//					{
					//						txtMessage = "Symbol state of " + symbolObj.SYMBOL+ " is " + symbolObj.STATE;
					//						return false;		
					//					}				
			}


			if (
				//!order.ddMarket.selectedItem ||
				//!order.ddSymbol.selectedItem ||
				(order.rdogrpLmtMkt.selectedValue == "limit" && !order.txtPrice.text.length > 0) || !order.txtVolume.text.length > 0 ||
				// added on 8/12/2010 to validate price
				// commented on 9/6/2011 and asked WHY??? What were you thinking???
				//!order.txtPrice.text.length > 0 ||
				!order.txtAccount.text.length > 0)
			{
				retVal=false;
			}
			if(bonsStr=="Corporate")
			{
				retVal=false;
			}
			/*if ((order.ddType.selectedIndex == 1 || // MT or SL
			order.ddType.selectedIndex == 2) &&
			true
			)
			{
			retVal = true;
			}*/
			// Start : added on 7/1/2011
			if (retVal)
			{
				var delimRegExp:RegExp=/,/g;
				var price:Number=new Number(order.txtPrice.text.replace(delimRegExp, ""));

				var volume:Number=new Number(order.txtVolume.text.replace(delimRegExp, ""));
				if ((order.rdogrpLmtMkt.selectedValue == "limit" && price <= 0) || volume <= 0)
				{
					return false;
				}
				var symbol:String=order.txtSymbol.text.toUpperCase();
				var internalSymbolId:Number=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(order.internalExchangeID, order.internalMarketID, symbol);

				var symbolId:Number=ModelManager.getInstance().exchangeModel.getSymbolID(order.internalExchangeID, order.internalMarketID, internalSymbolId);

				var key:String=ModelManager.getInstance().exchangeModel.getExchangeID(order.internalExchangeID) + "_" + ModelManager.getInstance().exchangeModel.getMarketID(order.internalExchangeID, order.internalMarketID) + "_" + symbolId;

				//				var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO = ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
				//				if(bestMarketAndSymbolSummary){
				//					if(bestMarketAndSymbolSummary.symbolSummary && bestMarketAndSymbolSummary.symbolSummary.browser )
				//					{
				//						var browser:SymbolBrowserBO = bestMarketAndSymbolSummary.symbolSummary.browser;
				//						if(volume < browser.lowerVolumeLimit || volume > browser.upperVolumeLimit )
				//						{
				//							txtMessage = ResourceManager.getInstance().getString('marketwatch','volLimitsAre')+' '+browser.lowerVolumeLimit + " - "+browser.upperVolumeLimit;
				//							return false;				
				//						}
				//						
				//						if(!((volume / browser.lotSize) is uint) )
				//						{
				//							txtMessage = ResourceManager.getInstance().getString('marketwatch','volLotSize')+' '+browser.lotSize;
				//							return false;
				//						}
				//						
				//						if(price <= browser.circuitBreakerDown || price >= browser.circuitBreakerUp )
				//						{
				//							txtMessage = ResourceManager.getInstance().getString('marketwatch','circuitBreakLimit')+' '+browser.circuitBreakerDown + " - "+browser.circuitBreakerUp;
				//							return false;				
				//						}
				//
				//// 						commented on 12/1/2011						
				////						if(!((price / browser.tickSize) is uint ))
				////						{
				////							txtMessage = "Price tick size is  "+browser.tickSize;
				////							return false;
				////						}
				//						
				//						if((price * volume) < browser.lowerValueLimit || (price * volume) > browser.upperValueLimit )
				//						{
				//							txtMessage = ResourceManager.getInstance().getString('marketwatch','valLimitsAre')+' '+browser.lowerValueLimit + " - "+browser.upperValueLimit;
				//							return false;
				//						}
				//					}
				//				}


				var symbolObj:SymbolBO=ModelManager.getInstance().exchangeModel.getSymbolDetail(ModelManager.getInstance().exchangeModel.getExchangeID(order.internalExchangeID), ModelManager.getInstance().exchangeModel.getMarketID(order.internalExchangeID, order.internalMarketID), symbolId) as SymbolBO;

				if (volume < symbolObj.LOWER_ORDER_VOLUME_LIMIT || volume > symbolObj.UPPER_ORDER_VOLUME_LIMIT)
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','volLimitsAre')+' ' + symbolObj.LOWER_ORDER_VOLUME_LIMIT + " - " + symbolObj.UPPER_ORDER_VOLUME_LIMIT;
					return false;
				}

				if (!((volume / symbolObj.BOARD_LOT) is uint))
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','volLotSize')+' ' + symbolObj.BOARD_LOT;
					return false;
				}

				if (order.rdogrpLmtMkt.selectedValue == "limit" && (price <= symbolObj.LOWER_CIRCUIT_BREAKER_LIMIT || price >= symbolObj.UPPER_CIRCUIT_BREAKER_LIMIT))
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','circuitBreakLimit')+' ' + symbolObj.LOWER_CIRCUIT_BREAKER_LIMIT + " - " + symbolObj.UPPER_CIRCUIT_BREAKER_LIMIT;
					return false;
				}

				// 						commented on 12/1/2011						
				//						if(!((price / browser.tickSize) is uint ))
				//						{
				//							txtMessage = "Price tick size is  "+browser.tickSize;
				//							return false;
				//						}

				if (order.rdogrpLmtMkt.selectedValue == "limit" && ((price * volume) < symbolObj.LOWER_ORDER_VALUE_LIMIT || (price * volume) > symbolObj.UPPER_ORDER_VALUE_LIMIT))
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','valLimitsAre')+' ' + symbolObj.LOWER_ORDER_VALUE_LIMIT + " - " + symbolObj.UPPER_ORDER_VALUE_LIMIT;
					return false;
				}

				if (order.chkNgtd && order.chkNgtd.selected && order.txtCounterPartyUserName.text.length == 0)
				{
					txtMessage=ResourceManager.getInstance().getString('marketwatch','cntrUserNameMust')+' ';
					return false;
				}
				if (order.txtDiscVol.text.length > 0 && !isNaN(parseInt(order.txtDiscVol.text)) && !isCancelOrder)
				{
					var disclosed_volume:Number=new Number(order.txtDiscVol.text.replace(delimRegExp, ""));
					if (disclosed_volume > volume)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','discVolCantBeGreatThanVol')+' ';
						return false;
					}
					else if (volume % disclosed_volume != 0)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','volShudBeMultipleOfDiscVol')+' ';
						return false;
					}
					else if (disclosed_volume % symbolObj.BOARD_LOT != 0)
					{
						txtMessage=ResourceManager.getInstance().getString('marketwatch','discVolShouldBeMultipleOfBoardLot')+' ';
						return false;
					}
				}
			}
		
			return retVal;
		}


	}
}
