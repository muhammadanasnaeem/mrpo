package controller
{
	import businessobjects.MarketWatchBO;
	import businessobjects.QuickOrdersBO;
	
	import common.Constants;
	import common.Messages;
	import common.WndInfo;
	
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	
	import flexlib.mdi.containers.MDIWindow;
	
	import model.MarketWatchColumns;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	import services.LSListener;
	
	import view.QuickOrder;

	[Bindable]
	public class ProfileManager
	{
		//////////////////// Static Properties ////////////////////

		private static const OPEN_WINDOWS:String="ProfileManager.OpenWindows";
		private static const MARKET_WATCH_SYMBOLS:String="ProfileManager.MarketWatch.Symbols";
		private static const DEFAULT_INTERNAL_EXCHANGEID:String="ProfileManager.DefaultInternalExchangeID";
		private static const DEFAULT_INTERNAL_MARKETID:String="ProfileManager.DefaultInternalMarketID";
		private static const MARKET_WATCH_COLUMNS:String="ProfileManager.MarketWatch.Columns";
		private static const QUICK_ORDERS_SYMBOLS:String="ProfileManager.QuickOrders.Symbols";
		// modified on 15/12/2010
		//private var userName_:String = "anas";
		private var userName_:String="";

		public function get userName():String
		{
			return userName_;
		}

		public function set userName(value:String):void
		{
			userName_=value;
		}

		// modified on 15/12/2010
		//private var password_:String = "infotech";
		private var password_:String="";

		public function get password():String
		{
			return password_;
		}

		public function set password(value:String):void
		{
			password_=value;
		}


		//////////////////// Properties ////////////////////
		private var sharedObject_:SharedObject

		public function get sharedObject():SharedObject
		{
			return sharedObject_;
		}

		public function set sharedObject(value:SharedObject):void
		{
			sharedObject_=value;
		}

		////////////////////////////////////////
		private var isProfileWritable_:Boolean=false;

		public function get isProfileWritable():Boolean
		{
			return isProfileWritable_;
		}

		////////////////////////////////////////
		// added on 24/12/2010
		private var defaultInternalExchangeId_:Number=-1;
		private var defaultInternalMarketId_:Number=-1;

		public function get defaultInternalMarketId():Number
		{
			return defaultInternalMarketId_;
		}

		public function set defaultInternalMarketId(value:Number):void
		{
			defaultInternalMarketId_=value;
		}

		public function get defaultInternalExchangeId():Number
		{
			return defaultInternalExchangeId_;
		}

		public function set defaultInternalExchangeId(value:Number):void
		{
			defaultInternalExchangeId_=value;
		}

		////////////////////////////////////////
		public var openWindowsList_:Array=new Array();

		////////////////////////////////////////
		private static var instance:ProfileManager=new ProfileManager();

		///////////////////////////////////////////////////////////////
		public function ProfileManager()
		{
			if (instance)
			{
				throw new Error("ProfileManager can only be accessed through ModelManager.getInstance()");
			}
		}

		///////////////////////////////////////////////////////////////

		public static function getInstance():ProfileManager
		{
			return instance;
		}

		/////////////////////////////////////////////////////////
		public function init():void
		{
			//registerClassAlias("flexlib.mdi.containers.MDIWindow", MDIWindow); // modified on 30/11/2010 for prfile change
			registerClassAlias("common.WndInfo", WndInfo);
			registerClassAlias("businessobjects.MarketWatchBO", MarketWatchBO);
			registerClassAlias("model.MarketWatchColumns", MarketWatchColumns)
			//Modified on 15/12/2010
			//sharedObject = SharedObject.getLocal( ModelManager.getInstance().userID.toString() );
			sharedObject=null;
			sharedObject=SharedObject.getLocal(ProfileManager.getInstance().userName);
			sharedObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}

		/////////////////////////////////////////////////////////
		public function saveProfile():void
		{
			saveMarketWatchSymbols();
//			saveQuickOrdersWindowSymbols();

			openWindowsList_=WindowManager.getInstance().canvas.windowManager.windowList;
			for (var i:int=openWindowsList_.length - 1; i >= 0; --i)
			{
				var window:MDIWindow=openWindowsList_[i] as MDIWindow;
				//setInfo(ProfileManager.OPEN_WINDOWS + "_WndInfo_" + window.id, window);
				setInfo(ProfileManager.OPEN_WINDOWS + "_WndInfo_" + window.id, setWindowAttributes(window)); // changed on 30/11/2010 for profile
					//window.close();
			}
			// added on 18/1/2011 to save default exchange and market IDs
			setInfo(DEFAULT_INTERNAL_EXCHANGEID, defaultInternalExchangeId);
			setInfo(DEFAULT_INTERNAL_MARKETID, defaultInternalMarketId);
			// added on 3/3/2011 
			setInfo(MARKET_WATCH_COLUMNS, ModelManager.getInstance().marketWatchModel.marketWatchCols);
			WindowManager.getInstance().canvas.windowManager.removeAll();
			save();
			sharedObject=null; // added on 2/12/2010
		}

		/////////////////////////////////////////////////////////

		private function setWindowAttributes(window:MDIWindow):WndInfo
		{
			var wndInfo:WndInfo=new WndInfo();
			wndInfo.x=window.x;
			wndInfo.y=window.y;
			wndInfo.height = window.height;
			wndInfo.width = window.width;
			wndInfo.hasFocus=window.hasFocus;
			return wndInfo;
		}

		/////////////////////////////////////////////////////////
		public function loadProfile():void
		{
			try
			{
//				Alert.show(''+sharedObject_.data.toString());
				var windowManager:WindowManager=WindowManager.getInstance();
				//if no profile data, show market watch window
				if (sharedObject_.size == 0)
				{
					//windowManager.initMarketWatchWindow();
					//windowManager.canvas.windowManager.add(windowManager.marketWatchWindow);
					ModelManager.getInstance().remainingOrdersModel.isInit=true;
				}
				else
				{
//				for (var s:String in sharedObject_.data )
//				{
//					var wndInfo:WndInfo = new WndInfo();
//					if (s.indexOf(ProfileManager.OPEN_WINDOWS + "_WndInfo_") == 0)
//					{
//						var window:MDIWindow = sharedObject_.data[s] as MDIWindow;
//						if ( window &&
//							windowManager.canvas.windowManager.container
//						)
//						{
//							//This case should never happen, but just in case
//							if (windowManager.canvas.windowManager.container.contains(window))
//							{
//								windowManager.canvas.windowManager.bringToFront(window);
//							}
//							else
//							{
//								windowManager.canvas.windowManager.add(window);
//							}
//						}
//					}
//					else if (s.indexOf(ProfileManager.MARKET_WATCH_SYMBOLS) == 0)
//					{
//						loadMarketWatchSymbolData(sharedObject_.data[s]);
//					}
//				}

					var window:MDIWindow;
					var focusedWindow:MDIWindow;
					for (var s:String in sharedObject_.data)
					{

						var wndInfo:WndInfo=new WndInfo();
						if (s.indexOf(ProfileManager.OPEN_WINDOWS + "_WndInfo_") == 0)
						{
							switch (s)
							{
								case ProfileManager.OPEN_WINDOWS + "_WndInfo_" + Constants.MARKET_WATCH_WINDOW_ID:
									window=windowManager.initMarketWatchWindow() as MDIWindow;
									break;

								case ProfileManager.OPEN_WINDOWS + "_WndInfo_" + Constants.BUY_ORDER_WINDOW_ID:
//								window = windowManager.initBuyOrderWindow()as MDIWindow;
									break;
								case ProfileManager.OPEN_WINDOWS + "_WndInfo_" + Constants.SELL_ORDER_WINDOW_ID:
//								window = windowManager.initSellOrderWindow()as MDIWindow;
									break;

								//Added by anas 10/1/2012
								case ProfileManager.OPEN_WINDOWS + "_WndInfo_" + Constants.LIVE_MESSAGES_WINDOW_WINDOW_ID:
									window=windowManager.initLiveMessagesWindow() as MDIWindow;
									break;
								case ProfileManager.OPEN_WINDOWS + "_WndInfo_" + Constants.HIST_SYMBOL_CHART_WINDOW_ID:
									window=windowManager.initLiveSymbolChartWindow() as MDIWindow;
									break;
								case ProfileManager.OPEN_WINDOWS + "_WndInfo_" + Constants.QUICK_ORDERS_WINDOW_ID:
									window=windowManager.initQuickOrderWindow() as MDIWindow;
									break;
							}

							//var window:MDIWindow = sharedObject_.data[s] as MDIWindow;
							var savedWndInfo:WndInfo=sharedObject_.data[s] as WndInfo;
							if (savedWndInfo != null && window != null)
							{
								window.x=savedWndInfo.x;
								window.y=savedWndInfo.y;
							window.height = savedWndInfo.height;
							window.width = savedWndInfo.width;
							}

							if (window && windowManager.canvas.windowManager.container)
							{
								//This case should never happen, but just in case
								if (windowManager.canvas.windowManager.container.contains(window))
								{
									windowManager.canvas.windowManager.bringToFront(window);
								}
								else
								{
									windowManager.canvas.windowManager.add(window);
									windowManager.canvas.windowManager.absPos(window, savedWndInfo.x, savedWndInfo.y);
									if (savedWndInfo.hasFocus)
									{
										focusedWindow=window;
									}
								}
							}
						}
						else if (s.indexOf(ProfileManager.MARKET_WATCH_SYMBOLS) == 0)
						{
							loadMarketWatchSymbolData(sharedObject_.data[s]);
						}
						// added on 18/1/2011
						else if (s.indexOf(ProfileManager.DEFAULT_INTERNAL_EXCHANGEID) == 0)
						{
							ProfileManager.getInstance().defaultInternalExchangeId=sharedObject_.data[s];
						}
						else if (s.indexOf(ProfileManager.DEFAULT_INTERNAL_MARKETID) == 0)
						{
							ProfileManager.getInstance().defaultInternalMarketId=sharedObject_.data[s];
						}
						// added on 3/3/2011
						else if ((s.indexOf(ProfileManager.MARKET_WATCH_COLUMNS) == 0))
						{
							ModelManager.getInstance().marketWatchModel.marketWatchCols=sharedObject_.data[s] as MarketWatchColumns;
						}
						else if (s.indexOf(ProfileManager.QUICK_ORDERS_SYMBOLS) == 0)
						{
//							loadQuickOrdersSymbols(sharedObject_.data[s]);
						}
					}

					if (focusedWindow != null)
					{
						windowManager.canvas.windowManager.bringToFront(focusedWindow);
					}
				}
			}
			catch (e:Error)
			{
				trace('' + e.toString());
			}
			/* modified on 19/3/2011 by Anas. this is done so that every time user logs off the system his/her 
			current prefrences and settings are saved to the shared object by clearing the shared object 
			we are just clearing its data property but the refrence to the shared object itself is still available 
			also the all the data from the data property of the shared object is deleted upon calling this method.
			*/
			ProfileManager.getInstance().sharedObject.clear();
		}

		///////////////////////////// Private Methods ////////////////////////////

		private function netStatusHandler(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case "SharedObject.Flush.Failed":
					Alert.show(ResourceManager.getInstance().getString('marketwatch','noWritePermissions'));
					break;
			}
		}

		/////////////////////////////////////////////////////////
		private function save():void
		{
			sharedObject.flush();
		}

		/////////////////////////////////////////////////////////
		private function getInfo(key:String):Object
		{
			return sharedObject.data[key];
		}

		/////////////////////////////////////////////////////////
		private function setInfo(key:String, value:Object):void
		{
			sharedObject.data[key]=value;
		}

		/////////////////////////////////////////////////////////
		private function saveQuickOrdersWindowSymbols():void
		{
			var qkOWin:QuickOrder = WindowManager.getInstance().viewManager.quickOrders;
			var modelManager:ModelManager=ModelManager.getInstance();
			for (var i:int=0; i < 1; ++i)
			{
				for (var j:int=0; j < 4; ++j)
				{  
						
						if(modelManager.quickOrdersModel.quickOrders[i][j].SYMBOL != null)
						{
							var quickOrdersBO:QuickOrdersBO=new QuickOrdersBO();
							quickOrdersBO.SYMBOL=modelManager.quickOrdersModel.quickOrders[i][j].SYMBOL;
							quickOrdersBO.symbolID=modelManager.quickOrdersModel.quickOrders[i][j].symbolID;
	
							quickOrdersBO.EXCHANGE=modelManager.quickOrdersModel.quickOrders[i][j].EXCHANGE;
							quickOrdersBO.exchangeID=modelManager.quickOrdersModel.quickOrders[i][j].exchangeID;
							quickOrdersBO.internalExchangeID=modelManager.quickOrdersModel.quickOrders[i][j].internalExchangeID;
	
							quickOrdersBO.MARKET=modelManager.quickOrdersModel.quickOrders[i][j].MARKET;
							quickOrdersBO.marketID=modelManager.quickOrdersModel.quickOrders[i][j].marketID;
							quickOrdersBO.internalMarketID=modelManager.quickOrdersModel.quickOrders[i][j].internalMarketID;
	
							quickOrdersBO.segmentNumber=i;
							quickOrdersBO.dropDownLimit=j;
							
							if((qkOWin.firstSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL == modelManager.quickOrdersModel.quickOrders[i][j].SYMBOL)
							{
//								qkOWin.firstSymbolDropDown.dataProvider = quickOrdersBO;
//								qkOWin.firstSymbolDropDown.labelField = "SYMBOL";
//									Alert.show(''+(qkOWin.firstSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL.toString());
							}
							
							
							if((qkOWin.secondSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL == modelManager.quickOrdersModel.quickOrders[i][j].SYMBOL)
							{
//								qkOWin.secondSymbolDropDown.dataProvider = quickOrdersBO;
//								qkOWin.secondSymbolDropDown.labelField = "SYMBOL";
//								Alert.show(''+(qkOWin.secondSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL.toString());
							}
							
							if((qkOWin.thirdSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL == modelManager.quickOrdersModel.quickOrders[i][j].SYMBOL)
							{
//								qkOWin.thirdSymbolDropDown.dataProvider = quickOrdersBO;
//								qkOWin.thirdSymbolDropDown.labelField = "SYMBOL";
//								Alert.show(''+(qkOWin.thirdSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL.toString());
							}
							
							if((qkOWin.fourthSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL == modelManager.quickOrdersModel.quickOrders[i][j].SYMBOL)
							{
//								qkOWin.fourthSymbolDropDown.dataProvider = quickOrdersBO;
//								qkOWin.fourthSymbolDropDown.labelField = "SYMBOL";
//								Alert.show(''+(qkOWin.fourthSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL.toString());
							}
	
							setInfo(ProfileManager.QUICK_ORDERS_SYMBOLS + "_" + i + "_" + "_" + j + "_", quickOrdersBO);
						}
				}
			}
			return;
		}

		/////////////////////////////////////////////////////////
		private function saveMarketWatchSymbols():void
		{
			var modelManager:ModelManager=ModelManager.getInstance();
			for (var i:int=0; i < Constants.PAGE_COUNT_MARKET_WATCH; ++i)
			{
				var marketWatchView:ArrayCollection=new ArrayCollection();
				for (var j:int=0; j < Constants.ROW_COUNT_MARKET_WATCH; ++j)
				{
					if (modelManager.marketWatchModel.marketWatch[i][j].internalExchangeID < 0 || modelManager.marketWatchModel.marketWatch[i][j].internalMarketID < 0 || modelManager.marketWatchModel.marketWatch[i][j].SYMBOL.length <= 0)
					{

					}
					else
					{
						var marketWatchBO:MarketWatchBO=new MarketWatchBO();

						marketWatchBO.SYMBOL=modelManager.marketWatchModel.marketWatch[i][j].SYMBOL;
						marketWatchBO.symbolID=modelManager.marketWatchModel.marketWatch[i][j].symbolID;

						marketWatchBO.EXCHANGE=modelManager.marketWatchModel.marketWatch[i][j].EXCHANGE;
						marketWatchBO.exchangeID=modelManager.marketWatchModel.marketWatch[i][j].exchangeID;
						marketWatchBO.internalExchangeID=modelManager.marketWatchModel.marketWatch[i][j].internalExchangeID;

						marketWatchBO.MARKET=modelManager.marketWatchModel.marketWatch[i][j].MARKET;
						marketWatchBO.marketID=modelManager.marketWatchModel.marketWatch[i][j].marketID;
						marketWatchBO.internalMarketID=modelManager.marketWatchModel.marketWatch[i][j].internalMarketID;

						//modelManager.marketWatchModel.marketWatch[i][j];
						marketWatchBO.pageNumber=i;
						marketWatchBO.rowNumber=j;

						// added for Bond specific fields

						marketWatchBO.IRR=modelManager.marketWatchModel.marketWatch[i][j].IRR;
						marketWatchBO.AIRR=modelManager.marketWatchModel.marketWatch[i][j].AIRR;
						marketWatchBO.BASE_RATE=modelManager.marketWatchModel.marketWatch[i][j].BASE_RATE;
						marketWatchBO.SPREAD_RATE=modelManager.marketWatchModel.marketWatch[i][j].SPREAD_RATE;
						marketWatchBO.COUPON_RATE=modelManager.marketWatchModel.marketWatch[i][j].COUPON_RATE;
						marketWatchBO.DISCOUNT_RATE=modelManager.marketWatchModel.marketWatch[i][j].DISCOUNT_RATE;
						marketWatchBO.NEXT_COUPON=modelManager.marketWatchModel.marketWatch[i][j].NEXT_COUPON;
						marketWatchBO.MATURITY_DATE=modelManager.marketWatchModel.marketWatch[i][j].MATURITY_DATE;

						setInfo(ProfileManager.MARKET_WATCH_SYMBOLS + "_" + i + "_" + "_" + j + "_", marketWatchBO);
					}
				}
					//marketWatch_.push(marketWatchView);
			}
		}

		/////////////////////////////////////////////////////////
		private function loadMarketWatchSymbolData(o:Object):void
		{
			var modelManager:ModelManager=ModelManager.getInstance();
//			modelManager.marketWatchModel.marketWatch[o.pageNumber][o.rowNumber] =
//				ObjectTranslator.objectToInstance( o, MarketWatchBO ) as MarketWatchBO; // commented on 1/12/2010 for profile change

			// added on 2/2/2011
			var mwBO:MarketWatchBO=o as MarketWatchBO;
			if (mwBO)
			{

				var obj:Object=modelManager.exchangeModel.getSymbolByCode(o.internalExchangeID, o.internalMarketID, o.SYMBOL);
				if (obj)
				{
					//modelManager.marketWatchModel.marketWatch[o.pageNumber][o.rowNumber] = o as MarketWatchBO;
					fillMarketWatchByObjInProfile(o as MarketWatchBO);

					modelManager.symbolTickerFeedModel.addFeedItem(o.SYMBOL, o.CHANGE, o.LAST, o.LAST_VOLUME);

					//modelManager.getBestMarketAndSymbolSummaryByName( o.exchangeID, o.marketID, o.SYMBOL, false);
					modelManager.getBestMarketAndSymbolSummary(o.exchangeID, o.marketID, o.symbolID, o.SYMBOL, false);

					//var key:String = modelManager.exchangeModel.getExchangeID(internalExchangeID) + "_" + modelManager.exchangeModel.getMarketID(internalExchangeID, internalMarketID) + "_" + modelManager.marketWatchModel.marketWatch[selectedIndex][index].symbolID;
					var key:String=o.exchangeID + "_" + o.marketID + "_" + o.symbolID;
					var itemName:String="BMEMS_" + key;
					// End : modified on 4/4/2011 after discussion with usman
					LSListener.getInstance().subscribeItem(
						itemName,
						LSListener.fieldSchemaBestMarket,
						LSListener.getInstance().lsClientBestMarket,
						WindowManager.getInstance().viewManager.marketWatch.updateBestMarketOrderFields
					);
					
					// End Modified on 28/1/2011 to fix market watch update issue on relogin
					//Start :  modified on 03/01/2011
					//itemName = "Symbol_" + symbolID.toString();
					itemName = "STEMS_" + key;
					//End :  modified on 03/01/2011
					LSListener.getInstance().subscribeItem(
						itemName,
						LSListener.fieldSchemaSymbolStat,
						LSListener.getInstance().lsClientSymbolStats,
						WindowManager.getInstance().viewManager.marketWatch.updateSymbolStatsOrderFields
					);
				}
			}
		}

		private function loadQuickOrdersSymbols(o:Object):void
		{
			var modelManager:ModelManager=ModelManager.getInstance();

			var qoBO:QuickOrdersBO=o as QuickOrdersBO;
			if (o)
			{
				var obj:Object=modelManager.exchangeModel.getSymbolByCode(o.internalExchangeID, o.internalMarketID, o.SYMBOL);
				if (obj)
				{
//					fillQuickOrdersByObjInProfile(o);
					modelManager.getBestMarketAndSymbolSummary(o.exchangeID, o.marketID, o.symbolID, o.SYMBOL, false);
					var key:String=o.exchangeID + "_" + o.marketID + "_" + o.symbolID;
					var itemName:String="BMEMS_" + key;
					if (!ModelManager.getInstance().subscribedItems.hasKey(itemName))
					{
//						ModelManager.getInstance().subscribedItems.put(itemName, itemName);
//						ExternalInterface.call("subscribeItem", Constants.BEST_MARKET_DATA_ADAPTER, "tblBestMarket" + itemName, itemName, "fieldSchemaBestMarket", "updateBestMarketOrderFields", ProfileManager.getInstance().userName, ProfileManager.getInstance().password);
//						itemName = "STEMS_" + key;
//						ExternalInterface.call("subscribeItem", Constants.SYMBOL_STAT_DATA_ADAPTER, "tblSymbolStat" + itemName, itemName, "fieldSchemaSymbolStat", "updateSymbolStatsOrderFields", ProfileManager.getInstance().userName, ProfileManager.getInstance().password);
					}
				}
			}
		}

		private function fillMarketWatchByObjInProfile(profileObj:MarketWatchBO):void
		{
			var modelManager:ModelManager=ModelManager.getInstance();
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].SYMBOL=profileObj.SYMBOL;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].symbolID=profileObj.symbolID;

			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].EXCHANGE=profileObj.EXCHANGE;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].exchangeID=profileObj.exchangeID;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].internalExchangeID=profileObj.internalExchangeID;

			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].MARKET=profileObj.MARKET;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].marketID=profileObj.marketID;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].internalMarketID=profileObj.internalMarketID;

			//profileObj;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].pageNumber=profileObj.pageNumber;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].rowNumber=profileObj.rowNumber;

			// added for Bond specific fields  

			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].IRR=profileObj.IRR;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].AIRR=profileObj.AIRR;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].BASE_RATE=profileObj.BASE_RATE;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].SPREAD_RATE=profileObj.SPREAD_RATE;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].COUPON_RATE=profileObj.COUPON_RATE;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].DISCOUNT_RATE=profileObj.DISCOUNT_RATE;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].NEXT_COUPON=profileObj.NEXT_COUPON;
			modelManager.marketWatchModel.marketWatch[profileObj.pageNumber][profileObj.rowNumber].MATURITY_DATE=profileObj.MATURITY_DATE;

		}

		private function fillQuickOrdersByObjInProfile(profileObj:Object):void
		{
			try
			{
			var modelManager:ModelManager=ModelManager.getInstance();
			var qkOWin:QuickOrder = WindowManager.getInstance().viewManager.quickOrders;
			
			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].SYMBOL=profileObj.SYMBOL;
			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].symbolID=profileObj.symbolID;

			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].EXCHANGE=profileObj.EXCHANGE;
			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].exchangeID=profileObj.exchangeID;
			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].internalExchangeID=profileObj.internalExchangeID;

			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].MARKET=profileObj.MARKET;
			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].marketID=profileObj.marketID;
			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].internalMarketID=profileObj.internalMarketID;
			
			if(qkOWin.firstSymbolDropDown)
			{
				if((qkOWin.firstSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL == modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].SYMBOL)
				{
					var qoBO:QuickOrdersBO = new QuickOrdersBO();
					qoBO.SYMBOL = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].SYMBOL;
					qoBO.symbolID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].symbolID=profileObj.symbolID;
					
					qoBO.EXCHANGE = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].EXCHANGE=profileObj.EXCHANGE;
					qoBO.exchangeID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].exchangeID=profileObj.exchangeID;
					
					qoBO.MARKET = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].MARKET=profileObj.MARKET;
					qoBO.marketID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].marketID=profileObj.marketID;
					
					
					trace('abc');
//				qkOWin.firstSymbolDropDown.dataProvider = qoBO;
				qkOWin.firstSymbolDropDown.labelField = "SYMBOL";
				}
				else
				{
//					Alert.show("No Symbol was saved",Messages.TITLE_ERROR);
				}
			}
			
			if(qkOWin.secondSymbolDropDown)
			{
				if((qkOWin.secondSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL == modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].SYMBOL)
				{
					var qoBO1:QuickOrdersBO = new QuickOrdersBO();
					qoBO1.SYMBOL = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].SYMBOL;
					qoBO1.symbolID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].symbolID=profileObj.symbolID;
					
					qoBO1.EXCHANGE = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].EXCHANGE=profileObj.EXCHANGE;
					qoBO1.exchangeID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].exchangeID=profileObj.exchangeID;
					
					qoBO1.MARKET = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].MARKET=profileObj.MARKET;
					qoBO1.marketID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].marketID=profileObj.marketID;
					
					
					trace('abc');
//					qkOWin.secondSymbolDropDown.dataProvider = qoBO1;
					qkOWin.secondSymbolDropDown.labelField = "SYMBOL";
				}
				else
				{
//					Alert.show("No Symbol was saved",Messages.TITLE_ERROR);
				}
			}
			
			if(qkOWin.thirdSymbolDropDown)
			{
				if((qkOWin.thirdSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL == modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].SYMBOL)
				{
					var qoBO2:QuickOrdersBO = new QuickOrdersBO();
					qoBO2.SYMBOL = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].SYMBOL;
					qoBO2.symbolID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].symbolID=profileObj.symbolID;
					
					qoBO2.EXCHANGE = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].EXCHANGE=profileObj.EXCHANGE;
					qoBO2.exchangeID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].exchangeID=profileObj.exchangeID;
					
					qoBO2.MARKET = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].MARKET=profileObj.MARKET;
					qoBO2.marketID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].marketID=profileObj.marketID;
					
					
					trace('abc');
//					qkOWin.thirdSymbolDropDown.dataProvider = qoBO2;
					qkOWin.thirdSymbolDropDown.labelField = "SYMBOL";
				}
				else
				{
//					Alert.show("No Symbol was saved",Messages.TITLE_ERROR);
				}
			}
			
			if(qkOWin.fourthSymbolDropDown)
			{
				if((qkOWin.fourthSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL == modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].SYMBOL)
				{
					var qoBO3:QuickOrdersBO = new QuickOrdersBO();
					qoBO3.SYMBOL = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].SYMBOL;
					qoBO3.symbolID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].symbolID=profileObj.symbolID;
					
					qoBO3.EXCHANGE = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].EXCHANGE=profileObj.EXCHANGE;
					qoBO3.exchangeID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].exchangeID=profileObj.exchangeID;
					
					qoBO3.MARKET = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].MARKET=profileObj.MARKET;
					qoBO3.marketID = modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].marketID=profileObj.marketID;
					
					
					trace('abc');
//					qkOWin.fourthSymbolDropDown.dataProvider = qoBO3;
					qkOWin.fourthSymbolDropDown.labelField = "SYMBOL";
				}
				else
				{
//					Alert.show("No Symbol was saved",Messages.TITLE_ERROR);
				}
			}
			else
			{
				trace('UI loading not completed yet');
			}


			//profileObj;
			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].segmentNumber=profileObj.segmentNumber;
			modelManager.quickOrdersModel.quickOrders[profileObj.segmentNumber][profileObj.dropDownLimit].dropDownLimit=profileObj.dropDownLimit;
			}catch(e:Error)
			{
				trace(e.message.toString());
			}
		}
	}
}
