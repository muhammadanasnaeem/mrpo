package controller
{
	import businessobjects.OrderBO;
	
	import common.Constants;
	
	import controller.ModelManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.ui.ContextMenu;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import flexlib.mdi.containers.MDICanvas;
	import flexlib.mdi.containers.MDIWindow;
	import flexlib.mdi.events.MDIWindowEvent;
	import flexlib.scheduling.scheduleClasses.schedule_internal;
	
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.ItemClickEvent;
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	import mx.graphics.SolidColor;
	import mx.managers.PopUpManager;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	import view.LiveMessages;
	import view.MarketWatch;
	import view.Order;
	import view.QuickOrder;
	import view.RemainingOrders;
	import view.UserTradeHistory;
	
	import windows.LoginWindow;

	public class WindowManager
	{
		private var modelManager_:ModelManager=ModelManager.getInstance();
		private var viewManager_:ViewManager; // = ViewManager.getInstance();

		public function get viewManager():ViewManager
		{
			return viewManager_;
		}

		public function set viewManager(value:ViewManager):void
		{
			viewManager_=value;
		}

		////////////////////Canvas////////////////////
		private var canvas_:MDICanvas;

		public function get canvas():MDICanvas
		{
			return canvas_;
		}

		public function set canvas(value:MDICanvas):void
		{
			canvas_=value;
		}

		////////////////////Login Window////////////////////
		private var loginWindow_:LoginWindow;

		public function get loginWindow():LoginWindow
		{
			return loginWindow_;
		}

		public function set loginWindow(value:LoginWindow):void
		{
			loginWindow_=value;
		}
//		var mdiwin:MDIWindow;
//		mdiwin.
		////////////////////Market Watch Window////////////////////
		private var marketWatchWindow_:MDIWindow;

		public function get marketWatchWindow():MDIWindow
		{
			return marketWatchWindow_;
		}

		public function set marketWatchWindow(value:MDIWindow):void
		{
			marketWatchWindow_=value;
		}
		////////////////////Quick Orders Window///////////////////////
		private var quickOrdersWindow_:MDIWindow;

		public function get quickOrdersWindow():MDIWindow
		{
			return quickOrdersWindow_;
		}

		public function set quickOrdersWindow(value:MDIWindow):void
		{
			quickOrdersWindow_=value;
		}

		////////////////////Quick Orders Window///////////////////////
		private var liveMessages_:MDIWindow;

		public function get liveMessages():MDIWindow
		{
			return liveMessages_;
		}

		public function set liveMessages(value:MDIWindow):void
		{
			liveMessages_=value;
		}

		////////////////////Exchange Stats Window////////////////////
		private var exchangeStatsWindow_:MDIWindow;

		public function get exchangeStatsWindow():MDIWindow
		{
			return exchangeStatsWindow_;
		}

		public function set exchangeStatsWindow(value:MDIWindow):void
		{
			exchangeStatsWindow_=value;
		}

		////////////////////Remaining Orders Window////////////////////
		private var remainingOrdersWindow_:MDIWindow;

		public function get remainingOrdersWindow():MDIWindow
		{
			return remainingOrdersWindow_;
		}

		public function set remainingOrdersWindow(value:MDIWindow):void
		{
			remainingOrdersWindow_=value;
		}

		////////////////////Last Day Remaining Orders Window////////////////////
		private var lastDayRemainingOrdersWindow_:MDIWindow;

		public function get lastDayRemainingOrdersWindow():MDIWindow
		{
			return lastDayRemainingOrdersWindow_;
		}

		public function set lastDayRemainingOrdersWindow(value:MDIWindow):void
		{
			lastDayRemainingOrdersWindow_=value;
		}

		////////////////////User Trade Hisotry Window////////////////////
		private var userTradeHistoryWindow_:MDIWindow;

		public function get userTradeHistoryWindow():MDIWindow
		{
			return userTradeHistoryWindow_;
		}

		public function set userTradeHistoryWindow(value:MDIWindow):void
		{
			userTradeHistoryWindow_=value;
		}

		////////////////////Event Log Window////////////////////
		private var eventLogWindow_:MDIWindow;

		public function get eventLogWindow():MDIWindow
		{
			return eventLogWindow_;
		}

		public function set eventLogWindow(value:MDIWindow):void
		{
			eventLogWindow_=value;
		}

		////////////////////Symbol Browser Window////////////////////
		private var symbolBrowserWindow_:MDIWindow;

		public function get symbolBrowserWindow():MDIWindow
		{
			return symbolBrowserWindow_;
		}

		public function set symbolBrowserWindow(value:MDIWindow):void
		{
			symbolBrowserWindow_=value;
		}

		////////////////////Symbol Summary Window////////////////////
		private var symbolSummWindow_:MDIWindow;

		public function get symbolSummWindow():MDIWindow
		{
			return symbolSummWindow_;
		}

		public function set symbolSummWindow(value:MDIWindow):void
		{
			symbolSummWindow_=value;
		}

		////////////////////Market Summary Window////////////////////
		private var marketSummaryWindow_:MDIWindow;

		public function get marketSummaryWindow():MDIWindow
		{
			return marketSummaryWindow_;
		}

		public function set marketSummaryWindow(value:MDIWindow):void
		{
			marketSummaryWindow_=value;
		}

		////////////////////Best Market Window////////////////////
		private var bestMarketWindow_:MDIWindow;

		public function get bestMarketWindow():MDIWindow
		{
			return bestMarketWindow_;
		}

		public function set bestMarketWindow(value:MDIWindow):void
		{
			bestMarketWindow_=value;
		}

		////////////////////Best Orders Window////////////////////
		private var bestOrdersWindow_:MDIWindow;

		public function get bestOrdersWindow():MDIWindow
		{
			return bestOrdersWindow_;
		}

		public function set bestOrdersWindow(value:MDIWindow):void
		{
			bestOrdersWindow_=value;
		}

		////////////////////Best Prices Window////////////////////
		private var bestPricesWindow_:MDIWindow;

		public function get bestPricesWindow():MDIWindow
		{
			return bestPricesWindow_;
		}

		public function set bestPricesWindow(value:MDIWindow):void
		{
			bestPricesWindow_=value;
		}

		////////////////////Buy Order Window////////////////////
		private var buyOrderWindow_:MDIWindow;

		public function get buyOrderWindow():MDIWindow
		{
			return buyOrderWindow_;
		}

		public function set buyOrderWindow(value:MDIWindow):void
		{
			buyOrderWindow_=value;
		}

		///////////////////Messages Window////////////////////////
		private var messagesWindow_:MDIWindow;

		public function get messagesWindow():MDIWindow
		{
			return messagesWindow_;
		}

		public function set messagesWindow(value:MDIWindow):void
		{
			messagesWindow_=value;
		}

		////////////////////Sell Orders Window////////////////////
		private var sellOrderWindow_:MDIWindow;

		public function get sellOrderWindow():MDIWindow
		{
			return sellOrderWindow_;
		}

		public function set sellOrderWindow(value:MDIWindow):void
		{
			sellOrderWindow_=value;
		}

		////////////////////Change Order Window////////////////////
		private var changeOrderWindow_:MDIWindow;

		public function get changeOrderWindow():MDIWindow
		{
			return changeOrderWindow_;
		}

		public function set changeOrderWindow(value:MDIWindow):void
		{
			changeOrderWindow_=value;
		}

		////////////////////Cancel Order Window////////////////////
		private var cancelOrderWindow_:MDIWindow;

		public function get cancelOrderWindow():MDIWindow
		{
			return cancelOrderWindow_;
		}

		public function set cancelOrderWindow(value:MDIWindow):void
		{
			cancelOrderWindow_=value;
		}

		////////////////////Cancel All Orders Window////////////////////
		private var cancelAllOrdersWindow_:MDIWindow;

		public function get cancelAllOrdersWindow():MDIWindow
		{
			return cancelAllOrdersWindow_;
		}

		public function set cancelAllOrdersWindow(value:MDIWindow):void
		{
			cancelAllOrdersWindow_=value;
		}

		////////////////////Yield Calculator Window////////////////////
		private var yieldCalculatorWindow_:MDIWindow;

		public function get yieldCalculatorWindow():MDIWindow
		{
			return yieldCalculatorWindow_;
		}

		public function set yieldCalculatorWindow(value:MDIWindow):void
		{
			yieldCalculatorWindow_=value;
		}

		////////////////////Change Password Window////////////////////
		private var changePasswordWindow_:MDIWindow;

		public function get changePasswordWindow():MDIWindow
		{
			return changePasswordWindow_;
		}

		public function set changePasswordWindow(value:MDIWindow):void
		{
			changePasswordWindow_=value;
		}

		////////////////////Market Schedule Window////////////////////
		private var marketScheduleWindow_:MDIWindow;

		public function get marketScheduleWindow():MDIWindow
		{
			return marketScheduleWindow_;
		}

		public function set marketScheduleWindow(value:MDIWindow):void
		{
			marketScheduleWindow_=value;
		}

		////////////////////Market Schedule Control Window////////////////////
		private var marketScheduleControlWindow_:MDIWindow;

		public function get marketScheduleControlWindow():MDIWindow
		{
			return marketScheduleControlWindow_;
		}

		public function set marketScheduleControlWindow(value:MDIWindow):void
		{
			marketScheduleControlWindow_=value;
		}

		////////////////////Symbol State Control Window////////////////////
		private var symbolStateControlWindow_:MDIWindow;

		public function get symbolStateControlWindow():MDIWindow
		{
			return symbolStateControlWindow_;
		}

		public function set symbolStateControlWindow(value:MDIWindow):void
		{
			symbolStateControlWindow_=value;
		}

		////////////////////Bulletin Control Window////////////////////
		private var bulletinControlWindow_:MDIWindow;

		public function get bulletinControlWindow():MDIWindow
		{
			return bulletinControlWindow_;
		}

		public function set bulletinControlWindow(value:MDIWindow):void
		{
			bulletinControlWindow_=value;
		}

		////////////////////Order Limit Control Window////////////////////
		private var orderLimitControlWindow_:MDIWindow;

		public function get orderLimitControlWindow():MDIWindow
		{
			return orderLimitControlWindow_;
		}

		public function set orderLimitControlWindow(value:MDIWindow):void
		{
			orderLimitControlWindow_=value;
		}

		private var profileSettingsWindow_:MDIWindow;

		public function get profileSettingsWindow():MDIWindow
		{
			return profileSettingsWindow_;
		}

		public function set profileSettingsWindow(value:MDIWindow):void
		{
			profileSettingsWindow_=value;
		}

		/////////////////////Risk Information Window/////////////////////

		private var riskInformationWindow_:MDIWindow;

		public function get riskInformationWindow():MDIWindow
		{
			return riskInformationWindow_;
		}

		public function set riskInformationWindow(value:MDIWindow):void
		{
			riskInformationWindow_=value;
		}

		/**
		 *
		 * Chart Windows
		 *
		 **/

		////////////////////Live Symbol Chart Window////////////////////
		private var liveSymbolChartWindow_:MDIWindow;

		public function get liveSymbolChartWindow():MDIWindow
		{
			return liveSymbolChartWindow_;
		}

		public function set liveSymbolChartWindow(value:MDIWindow):void
		{
			liveSymbolChartWindow_=value;
		}

		///////////////////////////////////////////////////////////////
		private static var instance:WindowManager=new WindowManager();

		public function WindowManager()
		{
			if (instance)
			{
				throw new Error("WindowManager can only be accessed through QWClient.getInstance()");
			}
		}

		///////////////////////////////////////////////////////////////
		public static function getInstance():WindowManager
		{
			return instance;
		}

		///////////////////////////////////////////////////////////////
		public function init(c:MDICanvas):void
		{
			canvas=c;
			viewManager=ViewManager.getInstance();
//			initMarketWatchWindow();
//			initHistoricalSymbolChartWindow();
//			initQuickOrderWindow();
			initLoginWindow();
		}

		///////////////////////////////////////////////////////////////
		public function initLoginWindow():void
		{
			if (loginWindow && canvas.windowManager.container.contains(loginWindow))
			{
				canvas.windowManager.bringToFront(loginWindow);
				return;
			}
			else if (!loginWindow)
			{
				loginWindow=new LoginWindow();
			}
			loginWindow.left=(ConfigurationManager.getInstance().screenConf.width - loginWindow.width) / 2;
			loginWindow.top=(ConfigurationManager.getInstance().screenConf.height - loginWindow.height) / 2;
			canvas.windowManager.add(loginWindow);
		}

		///////////////////////////////////////////////////////////////
		public function initRiskInformationWindow():void
		{
//			riskInformationWindow=initWindow(riskInformationWindow, viewManager_.riskInfo, ResourceManager.getInstance().getString('marketwatch', 'riskInformation'), Constants.RISK_INFORMATION_WINDOW_ID, 1135, 607);
			riskInformationWindow.resizable=true;
			riskInformationWindow.minWidth=1110;
			riskInformationWindow.minHeight=607;
			riskInformationWindow.verticalScrollPolicy="off";
			riskInformationWindow.horizontalScrollPolicy="off";
			// added on 18/1/2011
//			bulletinControlWindow.addEventListener(MDIWindowEvent.FOCUS_START, bulletinControl_FocusStartHandler);
		}

		///////////////////////////////////////////////////////////////
		public function initBuyOrderWindow():Object
		{
			if (viewManager_.buyOrder.imgExpanderBond != null && viewManager_.buyOrder.imgExpanderBond.rotation == 0)
			{
				buyOrderWindow=initWindow(buyOrderWindow, viewManager_.buyOrder, ResourceManager.getInstance().getString('marketwatch', 'buy'), Constants.BUY_ORDER_WINDOW_ID, 635, 510, false);
//				buyOrderWindow.contextMenu.hideBuiltInItems();
				buyOrderWindow.titleBarOverlay.layoutDirection="rtl";
				buyOrderWindow.resizable=false;
				buyOrderWindow.horizontalScrollPolicy="off";
				buyOrderWindow.verticalScrollPolicy="off";
				viewManager_.buyOrder.window=buyOrderWindow;
				viewManager.buyOrder.opaqueBackground=Constants.BUY_COLOR_INT;
				//			buyOrderWindow.setStyle("backgroundColor", Constants.BUY_COLOR);
				// added on 16/3/2011
				viewManager_.buyOrder.initTraders("SubmitOrder");
//				viewManager_.buyOrder.okButton.removeEventListener(MouseEvent.CLICK,viewManager_.buyOrder.txtOrderNum_keyDownHandler1);
//				viewManager_.buyOrder.okButton.addEventListener(MouseEvent.CLICK,modelManager_.submitBuyOrderOnClick);

				viewManager_.buyOrder.cancelButton.addEventListener(MouseEvent.CLICK, modelManager_.buycancelButton_clickHandler);
				buyOrderWindow.addEventListener(KeyboardEvent.KEY_DOWN, modelManager_.submitBuyOrder);
				// added on 11/1/2011
				buyOrderWindow.addEventListener(MDIWindowEvent.FOCUS_START, initBuyOrderWindowFocus);
				viewManager_.buyOrder.setTabIndices(100);
			}
			else
			{
				buyOrderWindow=initWindow(buyOrderWindow, viewManager_.buyOrder, ResourceManager.getInstance().getString('marketwatch', 'buy'), Constants.BUY_ORDER_WINDOW_ID, 635, 440, false);
				//viewManager_.buyOrder.imgExpander_clickHandler(null);
				buyOrderWindow.resizable=false;
				buyOrderWindow.horizontalScrollPolicy="off";
				buyOrderWindow.verticalScrollPolicy="off";
				viewManager_.buyOrder.window=buyOrderWindow;
				viewManager.buyOrder.opaqueBackground=Constants.BUY_COLOR_INT;
				//			buyOrderWindow.setStyle("backgroundColor", Constants.BUY_COLOR);
				// added on 16/3/2011
				viewManager_.buyOrder.initTraders("SubmitOrder");
//				viewManager_.buyOrder.okButton.removeEventListener(MouseEvent.CLICK,viewManager_.buyOrder.txtOrderNum_keyDownHandler1);
//				viewManager_.buyOrder.okButton.addEventListener(MouseEvent.CLICK,modelManager_.submitBuyOrderOnClick);

				viewManager_.buyOrder.cancelButton.addEventListener(MouseEvent.CLICK, modelManager_.buycancelButton_clickHandler);
				buyOrderWindow.addEventListener(KeyboardEvent.KEY_DOWN, modelManager_.submitBuyOrder);
				// added on 11/1/2011
				buyOrderWindow.addEventListener(MDIWindowEvent.FOCUS_START, initBuyOrderWindowFocus);
				viewManager_.buyOrder.setTabIndices(100);
			}
			return buyOrderWindow;
		}

		// added on 11/1/2011
		private function initBuyOrderWindowFocus(event:MDIWindowEvent):void
		{
//			viewManager_.buyOrder.focusManager.setFocus(viewManager_.buyOrder.txtExchange);
		}

		///////////////////////////////////////////////////////////////
		public function initSellOrderWindow():Object
		{
			if (viewManager_.sellOrder.imgExpanderBond != null && viewManager_.sellOrder.imgExpanderBond.rotation == 0)
			{
				sellOrderWindow=initWindow(sellOrderWindow, viewManager_.sellOrder, ResourceManager.getInstance().getString('marketwatch', 'sell'), Constants.SELL_ORDER_WINDOW_ID, 635, 510, false);
				sellOrderWindow.resizable=false;
				viewManager_.sellOrder.window=sellOrderWindow;
				viewManager.sellOrder.opaqueBackground=Constants.SELL_COLOR_INT;
				//			sellOrderWindow.setStyle("backgroundColor", Constants.SELL_COLOR);
				// added on 16/3/2011
				viewManager_.sellOrder.initTraders("SubmitOrder");
				sellOrderWindow.addEventListener(KeyboardEvent.KEY_DOWN, modelManager_.submitSellOrder);
				sellOrderWindow.horizontalScrollPolicy="false";
				sellOrderWindow.verticalScrollPolicy="false";
					// added on 11/1/2011
					//			sellOrderWindow.addEventListener(MDIWindowEvent.FOCUS_START,initSellOrderWindowFocus)
					//			viewManager_.sellOrder.setTabIndices(200);
			}
			else
			{
				sellOrderWindow=initWindow(sellOrderWindow, viewManager_.sellOrder, ResourceManager.getInstance().getString('marketwatch', 'sell'), Constants.SELL_ORDER_WINDOW_ID, 635, 440, false);
				//viewManager_.sellOrder.imgExpander_clickHandler(null);
				sellOrderWindow.resizable=false;
				viewManager_.sellOrder.window=sellOrderWindow;
				viewManager.sellOrder.opaqueBackground=Constants.SELL_COLOR_INT;
				//			sellOrderWindow.setStyle("backgroundColor", Constants.SELL_COLOR);
				// added on 16/3/2011
				viewManager_.sellOrder.initTraders("SubmitOrder");
				sellOrderWindow.addEventListener(KeyboardEvent.KEY_DOWN, modelManager_.submitSellOrder);
				sellOrderWindow.horizontalScrollPolicy="false";
				sellOrderWindow.verticalScrollPolicy="false";
					// added on 11/1/2011
					//			sellOrderWindow.addEventListener(MDIWindowEvent.FOCUS_START,initSellOrderWindowFocus)
					//			viewManager_.sellOrder.setTabIndices(200);
			}
			return sellOrderWindow;
		}

		// added on 11/1/2011
		private function initSellOrderWindowFocus(event:MDIWindowEvent):void
		{
//			viewManager_.sellOrder.focusManager.setFocus(viewManager_.sellOrder.txtExchange);
		}

		///////////////////////////////////////////////////////////////
		public function initChangeOrderWindow():MDIWindow
		{
			modelManager_.changebooleanFlag=false;
			ModelManager.getInstance().updateRemainingOrders();
			for (var i:int=0; i < 10 && ModelManager.getInstance().changebooleanFlag == false; i++)
			{
				setTimeout(launchAlert1, 3000);
			}
			function launchAlert1():void
			{
//				Alert.show('aaa');
			}
			changeOrderWindow=initWindow(changeOrderWindow, viewManager_.changeOrder, ResourceManager.getInstance().getString('marketwatch', 'change'), Constants.CHANGE_ORDER_WINDOW_ID, 635, 440, false);
			changeOrderWindow.maximizeRestoreBtn.visible=false;
			changeOrderWindow.minimizeBtn.visible=false;
			changeOrderWindow.verticalScrollPolicy="off";
			changeOrderWindow.horizontalScrollPolicy="off";
			//viewManager_.changeOrder.imgExpander_clickHandler(null);
			changeOrderWindow.resizable=false;
			viewManager.changeOrder.window=changeOrderWindow;
			viewManager.changeOrder.opaqueBackground=Constants.CHANGE_COLOR_INT;

			var myFill2:LinearGradient=new LinearGradient();
			myFill2.rotation=90;
			var myFillColor3:GradientEntry=new GradientEntry(0xF5B63D);
			myFillColor3.ratio=0.10;
			var myFillColor4:GradientEntry=new GradientEntry(0xebb91c);
			myFillColor4.ratio=0.90;
			myFill2.entries=[myFillColor3, myFillColor4];
			viewManager.changeOrder.bondPanel.backgroundFill=myFill2;

			var myFill2323:SolidColor=new SolidColor();
			myFill2323.color=0xF5B63D;
			myFill2323.alpha=1.00;
			viewManager.changeOrder.bcMain.backgroundFill=myFill2323;

			viewManager.changeOrder.stdTopLeft.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.topStdRt.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.stdRgt.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.stdLeft.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.stdBottom.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.addLeft.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.addRgt.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.additionalDetailsRightRule.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.bondPanelBottomRule.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.marketDataTopLeftRule.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.marketDataTopRightRule.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.marketDataLeftRule.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.marketDataRightRule.setStyle("strokeColor", 0xebb91c);
			viewManager.changeOrder.marketDataBottomRule.setStyle("strokeColor", 0xebb91c);
//			changeOrderWindow.setStyle("backgroundColor", Constants.CHANGE_COLOR);
			// added on 16/3/2011
			viewManager_.changeOrder.txtMsg.text='';
			viewManager_.changeOrder.initTraders("ChangeOrder");
			viewManager_.changeOrder.disableFields(false);
			viewManager_.changeOrder.okButton.addEventListener(MouseEvent.CLICK, modelManager_.submitChangeOrderOkClcikHandler);
//			viewManager_.changeOrder.okButton.addEventListener(MouseEvent.CLICK,viewManager_.changeOrder.txtOrderNum_keyDownHandler1);
			viewManager_.changeOrder.cancelButton.addEventListener(MouseEvent.CLICK, modelManager_.submitChangeOrderCancelClickHandler);

			changeOrderWindow.addEventListener(KeyboardEvent.KEY_DOWN, modelManager_.submitChangeOrder);
			viewManager_.changeOrder.setTabIndices(300);
			return changeOrderWindow;
		}

		///////////////////////////////////////////////////////////////
		public function updateChangeOrderWindow(orderBO:OrderBO):void
		{
			updateOrderView(viewManager_.changeOrder, orderBO);
		}

		///////////////////////////////////////////////////////////////
		public function initCancelOrderWindow():MDIWindow
		{
			modelManager_.cancelbooleanFlag=false;
			ModelManager.getInstance().updateRemainingOrders();
			cancelOrderWindow=initWindow(cancelOrderWindow, viewManager_.cancelOrder, ResourceManager.getInstance().getString('marketwatch', 'cancel'), Constants.CANCEL_ORDER_WINDOW_ID, 635, 440, false);
//			viewManager_.cancelOrder.imgExpander_clickHandler(null);
			cancelOrderWindow.resizable=false;
			cancelOrderWindow.maximizeRestoreBtn.visible=false;
			cancelOrderWindow.minimizeBtn.visible=false;
			cancelOrderWindow.verticalScrollPolicy="off";
			cancelOrderWindow.horizontalScrollPolicy="off";
			viewManager_.cancelOrder.window=cancelOrderWindow;
			viewManager.cancelOrder.opaqueBackground=Constants.CANCEL_COLOR_INT;

			var myFill2:LinearGradient=new LinearGradient();
			myFill2.rotation=90;
			var myFillColor3:GradientEntry=new GradientEntry(0x7E22D4);
			myFillColor3.ratio=0.10;
			var myFillColor4:GradientEntry=new GradientEntry(0x3f1e53);
			myFillColor4.ratio=0.90;
			myFill2.entries=[myFillColor3, myFillColor4];
			viewManager.cancelOrder.bondPanel.backgroundFill=myFill2;

			var myFill2323:SolidColor=new SolidColor();
			myFill2323.color=0x7E22D4;
			myFill2323.alpha=1.00;
			viewManager.cancelOrder.bcMain.backgroundFill=myFill2323;

			viewManager.cancelOrder.stdTopLeft.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.topStdRt.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.stdRgt.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.stdLeft.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.stdBottom.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.addLeft.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.addRgt.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.additionalOrdersLeftRule.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.additionalDetailsRightRule.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.bondPanelBottomRule.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.marketDataTopLeftRule.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.marketDataTopRightRule.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.marketDataLeftRule.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.marketDataRightRule.setStyle("strokeColor", 0x3f1e53);
			viewManager.cancelOrder.marketDataBottomRule.setStyle("strokeColor", 0x3f1e53);


//			cancelOrderWindow.setStyle("backgroundColor", Constants.CANCEL_COLOR);
			// added on 16/3/2011

//			viewManager_.cancelOrder.disableFields(false);
			viewManager_.cancelOrder.initTraders("CancelOrder");
			viewManager_.cancelOrder.disableFields(true);
			viewManager_.cancelOrder.okButton.addEventListener(MouseEvent.CLICK, modelManager_.submitCancelOrderOkClickHandler);
//			viewManager_.cancelOrder.okButton.addEventListener(MouseEvent.CLICK,viewManager_.cancelOrder.txtOrderNum_keyDownHandler1);
			viewManager_.cancelOrder.cancelButton.addEventListener(MouseEvent.CLICK, modelManager_.submitCancelOrderCancelClickHandler);

			cancelOrderWindow.addEventListener(KeyboardEvent.KEY_DOWN, modelManager_.submitCancelOrder);
			viewManager_.cancelOrder.setTabIndices(400);
			return cancelOrderWindow;
		}

		///////////////////////////////////////////////////////////////
		public function initCancelAllOrdersWindow():void
		{
			cancelAllOrdersWindow=initWindow(cancelAllOrdersWindow, viewManager_.cancelAllOrders, ResourceManager.getInstance().getString('marketwatch', 'cancelAllOrders'), Constants.CANCEL_ALL_ORDERS_WINDOW_ID, 275, 200, false);
			cancelAllOrdersWindow.resizable=false;
		}

		///////////////////////////////////////////////////////////////

		public function initYieldCalculatorWindow():void
		{
			yieldCalculatorWindow=initWindow(yieldCalculatorWindow, viewManager_.yieldCalculator, ResourceManager.getInstance().getString('marketwatch', 'yieldCalculator'), Constants.YIELD_CALCULATOR_WINDOW_ID, 330, 230, false);
			yieldCalculatorWindow.resizable=false;
		}

		///////////////////////////////////////////////////////////////

		public function initChangePasswordWindow():void
		{
			changePasswordWindow=initWindow(changePasswordWindow, viewManager_.changePassword, ResourceManager.getInstance().getString('marketwatch', 'changePassword'), Constants.CHANGE_PASSWORD_WINDOW_ID, 324, 178, false);
			changePasswordWindow.resizable=false;
		}

		///////////////////////////////////////////////////////////////

		public function initMarketScheduleWindow():void
		{
			marketScheduleWindow=initWindow(marketScheduleWindow, viewManager_.marketSchedule, ResourceManager.getInstance().getString('marketwatch', 'marketSchedule'), Constants.MARKET_SCHEDULE_WINDOW_ID, 500, 200);
		}

		///////////////////////////////////////////////////////////////
		public function initMarketScheduleControlWindow():void
		{
			marketScheduleControlWindow=initWindow(marketScheduleControlWindow, viewManager_.marketScheduleControl, ResourceManager.getInstance().getString('marketwatch', 'marketSchedule'), Constants.MARKET_SCHEDULE_CONTROL_WINDOW_ID, 440, 255);
			marketScheduleControlWindow.resizable=false;
			// added on 18/1/2011
			marketScheduleControlWindow.addEventListener(MDIWindowEvent.FOCUS_START, marketScheduleControl_FocusStartHandler);
		}

		private function marketScheduleControl_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.marketScheduleControl.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initSymbolStateControlWindow():void
		{
			symbolStateControlWindow=initWindow(symbolStateControlWindow, viewManager_.symbolStateControl, ResourceManager.getInstance().getString('marketwatch', 'symbolState'), Constants.SYMBOL_STATE_CONTROL_WINDOW_ID, 250, 220,false);
			symbolStateControlWindow.resizable=false;
			symbolStateControlWindow.maximizeRestoreBtn.visible=false;
			symbolStateControlWindow.minimizeBtn.visible=false;
//			symbolStateControlWindow.maximizeRestore(null);
			// added on 18/1/2011
			symbolStateControlWindow.addEventListener(MDIWindowEvent.FOCUS_START, symbolStateControl_FocusStartHandler);
		}

		private function symbolStateControl_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.symbolStateControl.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initBulletinControlWindow():void
		{
			bulletinControlWindow=initWindow(bulletinControlWindow, viewManager_.bulletinControl, ResourceManager.getInstance().getString('marketwatch', 'bulletin'), Constants.BULLETIN_CONTROL_WINDOW_ID, 400, 300);
			bulletinControlWindow.resizable=true;
			bulletinControlWindow.minWidth=400;
			bulletinControlWindow.minHeight=300;
			// added on 18/1/2011
			bulletinControlWindow.addEventListener(MDIWindowEvent.FOCUS_START, bulletinControl_FocusStartHandler);
		}

		private function bulletinControl_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.bulletinControl.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initOrderLimitControlWindow():void
		{
			orderLimitControlWindow=initWindow(orderLimitControlWindow, viewManager_.orderLimitControl, ResourceManager.getInstance().getString('marketwatch', 'changeOrderLimit'), Constants.ORDER_LIMIT_CONTROL_WINDOW_ID, 400, 200);
			orderLimitControlWindow.resizable=true;
			orderLimitControlWindow.minWidth=400;
			orderLimitControlWindow.minHeight=200;
			// added on 18/1/2011
			orderLimitControlWindow.addEventListener(MDIWindowEvent.FOCUS_START, orderLimitControl_FocusStartHandler);
		}

		private function orderLimitControl_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.orderLimitControl.setDefaultExchangeAndMarket();
		}

		/**
		 *
		 * Chart Windows
		 *
		 **/

		public function initLiveSymbolChartWindow():MDIWindow
		{
			var resourceManager:IResourceManager=ResourceManager.getInstance();
			liveSymbolChartWindow=initWindow(liveSymbolChartWindow, viewManager_.liveSymbolChart, Constants.HIST_SYMBOL_CHART_WINDOW_TITLE, Constants.HIST_SYMBOL_CHART_WINDOW_ID,

				403, 289);
			liveSymbolChartWindow.left=0;
			liveSymbolChartWindow.bottom=217;
			liveSymbolChartWindow.minWidth=402;
//			liveSymbolChartWindow.addEventListener(MDIWindowEvent.RESIZE,resizeCharts);
//			historicalSymbolChartWindow.minHeight = 300;  

			// added on 18/1/2011
			liveSymbolChartWindow.addEventListener(MDIWindowEvent.FOCUS_START, liveSymbolChart_FocusStartHandler);
			return liveSymbolChartWindow;
		}

		private function resizeCharts(event:MDIWindowEvent):void
		{
			if (liveSymbolChartWindow.minWidth <= 408)
			{
				viewManager_.liveSymbolChart.areaChart.percentWidth=96;
				viewManager_.liveSymbolChart.timeVolumeChart.percentWidth=96;
//				viewManager_.liveSymbolChart.chartVbox.percentWidth=96;
			}
//			if(viewManager_.liveSymbolChart.chartVbox <= 408)
//			{
//				viewManager_.liveSymbolChart.areaChart.percentWidth = 96;
//				viewManager_.liveSymbolChart.timeVolumeChart.percentWidth = 96;
//			}
		}

		private function liveSymbolChart_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.liveSymbolChart.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function setWindowColor(window:MDIWindow, orderView:Order, newColor:uint):void
		{
			window.setStyle("backgroundColor", newColor);
			orderView.opaqueBackground=newColor;
		}

		///////////////////////////////////////////////////////////////
		public function updateCancelOrderWindow(orderBO:OrderBO):void
		{
			updateOrderView(viewManager_.cancelOrder, orderBO);
		}

		///////////////////////////////////////////////////////////////
		public function initMarketWatchWindow():Object
		{
			viewManager_.marketWatch=new MarketWatch();
			marketWatchWindow=initWindow(marketWatchWindow, viewManager_.marketWatch, Constants.MARKET_WATCH_WINDOW_TITLE, Constants.MARKET_WATCH_WINDOW_ID, 810, 584);
			var resourceManager:IResourceManager=ResourceManager.getInstance();
			if (resourceManager.localeChain[0] == ['ar_SA'])
			{
//				marketWatchWindow.layoutDirection = 'rtl';
			}
			else
			{
				marketWatchWindow.layoutDirection='ltr';
			}
			marketWatchWindow.top=0;
			marketWatchWindow.right=0;
//			marketWatchWindow.maxHeight = canvas.height;
//			marketWatchWindow.maxWidth = canvas.width;
//			marketWatchWindow.minWidth = 800;
			marketWatchWindow.minHeight=400;
			// added on 17/1/2011
			marketWatchWindow.addEventListener(MDIWindowEvent.FOCUS_START, marketWatch_FocusStartHandler);
			marketWatchWindow.addEventListener(MDIWindowEvent.FOCUS_END, marketWatch_FocusEndHandler);
			return marketWatchWindow; // added on 30/11/2010
		}

		private function marketWatch_FocusStartHandler(event:MDIWindowEvent):void
		{
			try
			{
				viewManager.marketWatch.adgMarketWatch.editable=true;
			}
			catch (e:Error)
			{
				trace('Catched');
			}
		}

		private function marketWatch_FocusEndHandler(event:MDIWindowEvent):void
		{
			viewManager.marketWatch.adgMarketWatch.editable=false;
		}

		///////////////////////////////////////////////////////////
		public function initQuickOrderWindow():MDIWindow
		{
			var resourceManager:IResourceManager=ResourceManager.getInstance();
			viewManager_.quickOrders=new QuickOrder();
			quickOrdersWindow=initWindow(quickOrdersWindow, viewManager_.quickOrders, Constants.QUICK_ORDERS_WINDOW_TITLE, Constants.QUICK_ORDERS_WINDOW_ID, 402, 296, false);
			quickOrdersWindow.maxHeight=298;
			quickOrdersWindow.maxHeight=265;
			quickOrdersWindow.left=0;
			quickOrdersWindow.top=0;
			quickOrdersWindow.visible=true;
			quickOrdersWindow.resizable=false;
			quickOrdersWindow.minimizeBtn.visible=false;
			quickOrdersWindow.maximizeRestoreBtn.visible=false;
			quickOrdersWindow.horizontalScrollPolicy="off";
			quickOrdersWindow.verticalScrollPolicy="off";
//			quickOrdersWindow.addEventListener(MouseEvent.CLICK,
			return quickOrdersWindow;
		}

		///////////////////////////////////////////////////////////////
		public function initLiveMessagesWindow():MDIWindow
		{
			var resourceManager:IResourceManager=ResourceManager.getInstance();
			viewManager_.liveMessages=new LiveMessages();
			liveMessages=initWindow(liveMessages, viewManager_.liveMessages, Constants.LIVE_MESSAGES_WINDOW_TITLE, Constants.LIVE_MESSAGES_WINDOW_WINDOW_ID, 1260, 215, false);
			liveMessages.maxHeight=215;
			liveMessages.maxWidth=1260;
			liveMessages.left=0;
			liveMessages.bottom=0;
			liveMessages.visible=true;
			liveMessages.resizable=false;
			liveMessages.maximizeRestoreBtn.visible=true;
			liveMessages.maximizeRestoreBtn.enabled=true;
			liveMessages.minimizeBtn.visible=true;
			liveMessages.minimizeBtn.enabled=true;
			liveMessages.verticalScrollPolicy="off";
			liveMessages.horizontalScrollPolicy="off";
			liveMessages.setStyle("color", Constants.TITLE_COLOR);
//			liveMessages.closeBtn.enabled
			return liveMessages;
		}

		///////////////////////////////////////////////////////////////
		public function windowMaximized(event:MouseEvent):void
		{
			if (liveMessages.maximized == true)
			{
//				viewManager.liveMessages.txaMessages.height = viewManager.liveMessages.height;
			}
			else
			{
//				liveMessages.restore();
			}
		}

		///////////////////////////////////////////////////////////////
		public function initExchangeStatsWindow():void
		{
			exchangeStatsWindow=initWindow(exchangeStatsWindow, viewManager_.exchangeStats, ResourceManager.getInstance().getString('marketwatch', 'exchangeStats'), Constants.EXCHANGE_STATS_WINDOW_ID, 550, 500);
			exchangeStatsWindow.minWidth=exchangeStatsWindow.width;
			exchangeStatsWindow.maxHeight=exchangeStatsWindow.height;
			// added on 18/1/2011
			exchangeStatsWindow.addEventListener(MDIWindowEvent.FOCUS_START, exchangeStats_FocusStartHandler);
		}

		private function exchangeStats_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.exchangeStats.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initSymbolBrowserWindow():void
		{
			symbolBrowserWindow=initWindow(symbolBrowserWindow, viewManager_.symbolBrowser, ResourceManager.getInstance().getString('marketwatch', 'symbolBrowser'), Constants.SYMBOL_BROWSER_WINDOW_ID, 650, 400);
			symbolBrowserWindow.minWidth=600;
			symbolBrowserWindow.minHeight=350;
			// added on 18/1/2011
			symbolBrowserWindow.addEventListener(MDIWindowEvent.FOCUS_START, symbolBrowser_FocusStartHandler);
		}

		private function symbolBrowser_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.symbolBrowser.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initSymbolSummWindow():void
		{
			symbolSummWindow=initWindow(symbolSummWindow, viewManager_.symbolSumm, ResourceManager.getInstance().getString('marketwatch', 'symbolSummary'), Constants.SYMBOL_SUMMARY_WINDOW_ID, 760, 330, false);
			symbolSummWindow.resizable=false;
//			symbolSummWindow.minWidth = 760;
//			symbolSummWindow.minHeight = 510;
			// added on 18/1/2011
			symbolSummWindow.addEventListener(MDIWindowEvent.FOCUS_START, symbolSumm_FocusStartHandler);
		}

		private function symbolSumm_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.symbolSumm.setDefaultExchangeAndMarket();
			viewManager.symbolSumm.adjustBondPanel();
		}

		///////////////////////////////////////////////////////////////
		public function initMarketSummaryWindow():void
		{
			marketSummaryWindow=initWindow(marketSummaryWindow, viewManager_.marketSummary, ResourceManager.getInstance().getString('marketwatch', 'marketSummary'), Constants.MARKET_SUMMARY_WINDOW_ID, 760, 330, false);
			marketSummaryWindow.resizable=true;
			//			symbolSummWindow.minWidth = 760;
			//			symbolSummWindow.minHeight = 510;
			// added on 18/1/2011
			marketSummaryWindow.addEventListener(MDIWindowEvent.FOCUS_START, marketSummary_FocusStartHandler)
		}

		private function marketSummary_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.marketSummary.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initRemainingOrdersWindow():MDIWindow
		{
			remainingOrdersWindow=initWindow(remainingOrdersWindow, viewManager_.remainingOrders, ResourceManager.getInstance().getString('marketwatch', 'workingOrders'), Constants.WORKING_ORDERS_WINDOW_ID, 750, 400);
			remainingOrdersWindow.minWidth=750;
			remainingOrdersWindow.minHeight=300;
			// added on 18/1/2011
			remainingOrdersWindow.addEventListener(MDIWindowEvent.FOCUS_START, remainingOrders_FocusStartHandler);
			return remainingOrdersWindow;
		}

		private function remainingOrders_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.remainingOrders.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initLastDayRemainingOrdersWindow():void
		{

			lastDayRemainingOrdersWindow=initWindow(lastDayRemainingOrdersWindow, viewManager_.lastDayRemainingOrders, ResourceManager.getInstance().getString('marketwatch', 'lastDayRemainingOrders'), Constants.LAST_DAY_REMAINING_ORDERS_WINDOW_ID, 650, 400);

			lastDayRemainingOrdersWindow.minWidth=550;
			lastDayRemainingOrdersWindow.minHeight=300;
		}

		///////////////////////////////////////////////////////////////
		public function initUserTradeHistoryWindow():void
		{
			userTradeHistoryWindow=initWindow(userTradeHistoryWindow, viewManager_.userTradeHistory, ResourceManager.getInstance().getString('marketwatch', 'executedOrders'), Constants.EXECUTED_ORDERS_WINDOW_ID, 750, 400);
			userTradeHistoryWindow.minWidth=750;
			userTradeHistoryWindow.minHeight=300;
			// added on 18/1/2011
			userTradeHistoryWindow.addEventListener(MDIWindowEvent.FOCUS_START, userTradeHistory_FocusStartHandler);
		}

		private function userTradeHistory_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.userTradeHistory.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initEventLogWindow():void
		{
			eventLogWindow=initWindow(eventLogWindow, viewManager_.eventLog, ResourceManager.getInstance().getString('marketwatch', 'eventLog'), Constants.EVENT_LOG_WINDOW_ID, 750, 400);
			eventLogWindow.minWidth=750;
			eventLogWindow.minHeight=300;
			// added on 18/1/2011
			eventLogWindow.addEventListener(MDIWindowEvent.FOCUS_START, eventLog_FocusStartHandler);
		}

		private function eventLog_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.eventLog.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initBestMarketWindow():void
		{
			bestMarketWindow=initWindow(bestMarketWindow, viewManager_.bestMarket, Constants.BEST_MARKET_WINDOW_TITLE, Constants.BEST_MARKET_WINDOW_ID, 600, 200);
		}

		///////////////////////////////////////////////////////////////
		public function initBestOrdersWindow():void
		{
			bestOrdersWindow=initWindow(bestOrdersWindow, viewManager_.bestOrders, ResourceManager.getInstance().getString('marketwatch', 'bestOrders'), Constants.BEST_ORDERS_WINDOW_ID, 580, 350);
			bestOrdersWindow.minWidth=580;
			bestOrdersWindow.minHeight=350;
			// added on 18/1/2011
			bestOrdersWindow.addEventListener(MDIWindowEvent.FOCUS_START, bestOrders_FocusStartHandler);
		}

		private function bestOrders_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.bestOrders.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initBestPricesWindow():void
		{
			bestPricesWindow=initWindow(bestPricesWindow, viewManager_.bestPrices, ResourceManager.getInstance().getString('marketwatch', 'bestPriceLevels'), Constants.BEST_PRICES_WINDOW_ID, 580, 350);
			bestPricesWindow.minWidth=580;
			bestPricesWindow.minHeight=350;
			// added on 18/1/2011
			bestPricesWindow.addEventListener(MDIWindowEvent.FOCUS_START, bestPrices_FocusStartHandler);
		}

		private function bestPrices_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.bestPrices.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		public function initProfileSettingsWindow():void
		{
			profileSettingsWindow=initWindow(profileSettingsWindow, viewManager.profileSetting, ResourceManager.getInstance().getString('marketwatch', 'profileSettings'), Constants.PROFILE_WINDOW_ID, 420, 305, false);
			profileSettingsWindow.addEventListener(MDIWindowEvent.FOCUS_START, profileSettings_FocusStartHandler);
		}

		private function profileSettings_FocusStartHandler(event:MDIWindowEvent):void
		{
			viewManager.profileSetting.setDefaultExchangeAndMarket();
		}

		///////////////////////////////////////////////////////////////
		private function initWindow(window:MDIWindow, displayObject:DisplayObject, title:String, id:String, width:Number, height:Number, maximizable:Boolean=true):MDIWindow
		{
			try
			{
				window=new MDIWindow();

				window.removeAllChildren();
				window.addChild(displayObject);
				window.title=title;
				window.id=id;
				window.width=width;
				window.height=height;
				window.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
				window.setStyle("borderVisible", true);
				window.setStyle("bordercolor", Constants.BORDER_TOP);
				window.setStyle("borderThicknessTop", 2);
				window.setStyle("color", Constants.TITLE_COLOR);

				if (!maximizable)
				{
					window.maximizeRestoreBtn.enabled=false;
					window.maximizeRestoreBtn.visible=false;
					window.minimizeBtn.enabled=false;
					window.minimizeBtn.visible=false;
					//window.addEventListener(MouseEvent.DOUBLE_CLICK, windowTitleBar_doubleClickHandler);
					window.addEventListener(MDIWindowEvent.MAXIMIZE, windowTitleBar_maximizeButtonClickHandler);
				}
				window.addEventListener(MDIWindowEvent.CLOSE, window_closeHandler);


			}
			catch (e:Error)
			{

			}
			return window;
		}

		///////////////////////////////////////////////////////////////
		private function windowTitleBar_doubleClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			(event.currentTarget as MDIWindow).restore();
		}

		///////////////////////////////////////////////////////////////
		private function windowTitleBar_maximizeButtonClickHandler(event:MDIWindowEvent):void
		{
			event.stopImmediatePropagation();
		}

		///////////////////////////////////////////////////////////////
		private function window_closeHandler(event:MDIWindowEvent):void
		{
			var window:MDIWindow=(event.target as MDIWindow);
			canvas.windowManager.remove(window);
			//window.removeAllElements();
		}

		///////////////////////////////////////////////////////////////
		private function updateOrderView(order:Order, orderBO:OrderBO):void
		{
			try
			{
				if (orderBO.ORDER_NO < 0)
				{
					order.clearForm();
					return;
				}
				order.internalExchangeID=orderBO.INTERNAL_EXCHANGE_ID;
				order.internalMarketID=orderBO.INTERNAL_MARKET_ID;
				order.internalSymbolID=orderBO.INTERNAL_SYMBOL_ID;
				order.symbolID=orderBO.SYMBOL_ID;
				order.side=orderBO.SIDE;
				if (orderBO.PUBLIC_ORDER_STATE == 'change')
				{
					WindowManager.getInstance().changeOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
				}
//			WindowManager.getInstance().cancelOrderWindow.setStyle("backgroundColor",Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
				order.txtOrderNum.text=orderBO.ORDER_NO.toString();
				// modified on 24/12/2010
				//order.txtAccount.text = orderBO.REF_NO.toString();
				order.txtAccount.text=orderBO.CLIENT_CODE.toString();
				order.txtExchange.text=modelManager_.exchangeModel.getExchangeCode(orderBO.INTERNAL_EXCHANGE_ID);
				order.txtMarket.text=modelManager_.exchangeModel.getMarketCode(orderBO.INTERNAL_EXCHANGE_ID, orderBO.INTERNAL_MARKET_ID);

				if (orderBO.DISCLOSED_VOLUME > 0)
					order.txtDiscVol.text=orderBO.DISCLOSED_VOLUME.toString();

				if (orderBO.PRICE > 0)
					order.txtPrice.text=orderBO.PRICE.toString();

				if (orderBO.TRIGGER_PRICE > 0)
					order.txtTriggerPrice.text=orderBO.TRIGGER_PRICE.toString();

				order.txtSymbol.text=orderBO.SYMBOL;

				order.rdogrpLmtMkt.selectedValue=orderBO.PRICE_TYPE;

				if (orderBO.TIF)
				{
					order.dateTIF.selectedDate=orderBO.TIF;
				}

				order.txtVolume.text=orderBO.VOLUME.toString();

				// added on 29/3/2011
				order.setSelectedTrader(orderBO.USER_ID);

				// added on 4/4/2011
				order.updateBestMarketAndSymbolStats();

				order.chkNgtd.selected=orderBO.IS_NEGOTIATED;
				//order.chkNgtd_changeHandler(null);

				if (orderBO.IS_NEGOTIATED)
				{
					order.chkNgtd.enabled=false;
					order.txtCounterPartyUserName.text=orderBO.COUNTER_USER_NAME;
					order.txtCounterPartyClientCode.text=orderBO.COUNTER_CLIENT_CODE;
				}

			}
			catch (e:Error)
			{
				trace(e.message);
			}
		}
	}
}

//Added by Anas on 10/1/2012
///////////////////////////////////////////////////////////////
//		public function initMessagesWindow():Object
//		{
//			messagesWindow = initWindow(messagesWindow,
//				viewManager_.messagesWindow,
//				Constants.MESSAGES_WINDOW_TITLE,
//				Constants.MESSAGES_WINDOW_WINDOW_ID,
//				750,
//				750,
//				false);
//			messagesWindow.resizable = true;
//			sellOrderWindow.setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
////			viewManager_.sellOrder.initTraders("SubmitOrder");
////			sellOrderWindow.addEventListener(MDIWindowEvent.FOCUS_START,initSellOrderWindowFocus)
//			return sellOrderWindow;
//		}
