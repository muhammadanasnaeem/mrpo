package controller
{
	import flexlib.mdi.containers.MDICanvas;
	import flexlib.mdi.containers.MDIWindow;
	
	import view.BestMarket;
	import view.BestOrders;
	import view.BestPrices;
	import view.BulletinControl;
	import view.CancelAllOrders;
	import view.ChangePassword;
	import view.EventLog;
	import view.ExchangeStats;
	import view.HistoricalSymbolChart;
	import view.LastDayRemainingOrders;
	import view.LiveMessages;
	import view.LiveSymbolChart;
	import view.MarketSchedule;
	import view.MarketScheduleControl;
	import view.MarketSummary;
	import view.MarketWatch;
	import view.Order;
	import view.OrderLimitControl;
	import view.ProfileSettings;
	import view.QuickOrder;
	import view.RemainingOrders;
	import view.RiskInformation;
	import view.SelectionMenu;
	import view.SellOrder;
	import view.SymbolBrowser;
	import view.SymbolStateControl;
	import view.SymbolSumm;
	import view.SymbolSummary;
	import view.UserTradeHistory;
	import view.YieldCalculator;

	public class ViewManager
	{
		////////////////////Exchange Stats View////////////////////
		private var exchangeStats_:ExchangeStats=new ExchangeStats();

		public function get exchangeStats():ExchangeStats
		{
			return exchangeStats_;
		}

		public function set exchangeStats(value:ExchangeStats):void
		{
			exchangeStats_=value;
		}

		////////////////////Market Watch View////////////////////
		private var marketWatch_:MarketWatch=new MarketWatch();

		public function get marketWatch():MarketWatch
		{
			return marketWatch_;
		}

		public function set marketWatch(value:MarketWatch):void
		{
			marketWatch_=value;
		}
		
		/////////////////////Quick Orders View//////////////////////
		private var quickOrders_:QuickOrder=new QuickOrder();

		public function get quickOrders():QuickOrder
		{
			return quickOrders_;
		}

		public function set quickOrders(value:QuickOrder):void
		{
			quickOrders_=value;
		}

		/////////////////////Messages View//////////////////////
		private var liveMessages_:LiveMessages=new LiveMessages();

		public function get liveMessages():LiveMessages
		{
			return liveMessages_;
		}

		public function set liveMessages(value:LiveMessages):void
		{
			liveMessages_=value;
		}
		////////////////////Symbol Browser View////////////////////
		private var symbolBrowser_:SymbolBrowser=new SymbolBrowser();

		public function get symbolBrowser():SymbolBrowser
		{
			return symbolBrowser_;
		}

		public function set symbolBrowser(value:SymbolBrowser):void
		{
			symbolBrowser_=value;
		}

		////////////////////Symbol Summary View////////////////////
		private var symbolSumm_:SymbolSumm=new SymbolSumm();

		public function get symbolSumm():SymbolSumm
		{
			return symbolSumm_;
		}

		public function set symbolSumm(value:SymbolSumm):void
		{
			symbolSumm_=value;
		}
		
		//////////////////Risk Information/////////////////////////
		private var riskInfo_:RiskInformation = new RiskInformation();
		
		public function get riskInfo():RiskInformation
		{
			return riskInfo_;
		}
		
		public function set riskInfo(value:RiskInformation):void
		{
			riskInfo_=value;
		}
		////////////////////Symbol Summary View////////////////////
		private var symbolSummary_:SymbolSummary=new SymbolSummary();

		public function get symbolSummary():SymbolSummary
		{
			return symbolSummary_;
		}

		public function set symbolSummary(value:SymbolSummary):void
		{
			symbolSummary_=value;
		}

		////////////////////Market Summary View////////////////////
		private var marketSummary_:MarketSummary=new MarketSummary();

		public function get marketSummary():MarketSummary
		{
			return marketSummary_;
		}

		public function set marketSummary(value:MarketSummary):void
		{
			marketSummary_=value;
		}

		////////////////////Remaining Orders View////////////////////
		private var remainingOrders_:RemainingOrders=new RemainingOrders();

		public function get remainingOrders():RemainingOrders
		{
			return remainingOrders_;
		}

		public function set remainingOrders(value:RemainingOrders):void
		{
			remainingOrders_=value;
		}

		////////////////////Last Day Remaining Orders View////////////////////
		private var lastDayRemainingOrders_:LastDayRemainingOrders=new LastDayRemainingOrders();

		public function get lastDayRemainingOrders():LastDayRemainingOrders
		{
			return lastDayRemainingOrders_;
		}

		public function set lastDayRemainingOrders(value:LastDayRemainingOrders):void
		{
			lastDayRemainingOrders_=value;
		}

		////////////////////User Trade History View////////////////////
		private var userTradeHistory_:UserTradeHistory=new UserTradeHistory();

		public function get userTradeHistory():UserTradeHistory
		{
			return userTradeHistory_;
		}

		public function set userTradeHistory(value:UserTradeHistory):void
		{
			userTradeHistory_=value;
		}

		////////////////////Event Log View////////////////////
		private var eventLog_:EventLog=new EventLog();

		public function get eventLog():EventLog
		{
			return eventLog_;
		}

		public function set eventLog(value:EventLog):void
		{
			eventLog_=value;
		}

		////////////////////Best Market View////////////////////
		private var bestMarket_:BestMarket=new BestMarket();

		public function get bestMarket():BestMarket
		{
			return bestMarket_;
		}

		public function set bestMarket(value:BestMarket):void
		{
			bestMarket_=value;
		}

		////////////////////Best Order View////////////////////
		private var bestOrders_:BestOrders=new BestOrders();

		public function get bestOrders():BestOrders
		{
			return bestOrders_;
		}

		public function set bestOrders(value:BestOrders):void
		{
			bestOrders_=value;
		}

		////////////////////Best Prices View////////////////////
		private var bestPrices_:BestPrices=new BestPrices();

		public function get bestPrices():BestPrices
		{
			return bestPrices_;
		}

		public function set bestPrices(value:BestPrices):void
		{
			bestPrices_=value;
		}

		////////////////////Buy Order View////////////////////
		private var buyOrder_:Order=new Order();

		public function get buyOrder():Order
		{
			return buyOrder_;
		}

		public function set buyOrder(value:Order):void
		{
			buyOrder_=value;
		}


		////////////////////Sell Order View////////////////////
		private var sellOrder_:SellOrder=new SellOrder();

		public function get sellOrder():SellOrder
		{
			return sellOrder_;
		}

		public function set sellOrder(value:SellOrder):void
		{
			sellOrder_=value;
		}


		////////////////////Change Order View////////////////////
		private var changeOrder_:Order=new Order();

		public function get changeOrder():Order
		{
			return changeOrder_;
		}

		public function set changeOrder(value:Order):void
		{
			changeOrder_=value;
		}


		////////////////////Cancel Order View////////////////////
		private var cancelOrder_:Order=new Order();

		public function get cancelOrder():Order
		{
			return cancelOrder_;
		}

		public function set cancelOrder(value:Order):void
		{
			cancelOrder_=value;
		}

		////////////////////Cancel All Orders View////////////////////
		private var cancelAllOrders_:CancelAllOrders=new CancelAllOrders();

		public function get cancelAllOrders():CancelAllOrders
		{
			return cancelAllOrders_;
		}

		public function set cancelAllOrders(value:CancelAllOrders):void
		{
			cancelAllOrders_=value;
		}

		////////////////////Yield Calculator View////////////////////
		private var yieldCalculator_:YieldCalculator=new YieldCalculator();

		public function get yieldCalculator():YieldCalculator
		{
			return yieldCalculator_;
		}

		public function set yieldCalculator(value:YieldCalculator):void
		{
			yieldCalculator_=value;
		}

		////////////////////Change Password View////////////////////
		private var changePassword_:ChangePassword=new ChangePassword();

		public function get changePassword():ChangePassword
		{
			return changePassword_;
		}

		public function set changePassword(value:ChangePassword):void
		{
			changePassword_=value;
		}

		////////////////////Market Schedule View////////////////////
		private var marketSchedule_:MarketSchedule=new MarketSchedule();

		public function get marketSchedule():MarketSchedule
		{
			return marketSchedule_;
		}

		public function set marketSchedule(value:MarketSchedule):void
		{
			marketSchedule_=value;
		}

		////////////////////Market Selection Menu////////////////////
		private var marketSelectionMenu_:SelectionMenu=new SelectionMenu();

		public function get marketSelectionMenu():SelectionMenu
		{
			return marketSelectionMenu_;
		}

		public function set marketSelectionMenu(value:SelectionMenu):void
		{
			marketSelectionMenu_=value;
		}
		/********** Control views **********/
		////////////////////Market Schedule Control View////////////////////
		private var marketScheduleControl_:MarketScheduleControl=new MarketScheduleControl();

		public function get marketScheduleControl():MarketScheduleControl
		{
			return marketScheduleControl_;
		}

		public function set marketScheduleControl(value:MarketScheduleControl):void
		{
			marketScheduleControl_=value;
		}

		////////////////////Symbol State Control View////////////////////
		private var symbolStateControl_:SymbolStateControl=new SymbolStateControl();

		public function get symbolStateControl():SymbolStateControl
		{
			return symbolStateControl_;
		}

		public function set symbolStateControl(value:SymbolStateControl):void
		{
			symbolStateControl_=value;
		}

		////////////////////Bulletin Control View////////////////////
		private var bulletinControl_:BulletinControl=new BulletinControl();

		public function get bulletinControl():BulletinControl
		{
			return bulletinControl_;
		}

		public function set bulletinControl(value:BulletinControl):void
		{
			bulletinControl_=value;
		}

		////////////////////Order Limit Control View////////////////////
		private var orderLimitControl_:OrderLimitControl=new OrderLimitControl();

		public function get orderLimitControl():OrderLimitControl
		{
			return orderLimitControl_;
		}

		public function set orderLimitControl(value:OrderLimitControl):void
		{
			orderLimitControl_=value;
		}

		////////////////////Profile Settings View////////////////////
		private var profileSetting_:ProfileSettings=new ProfileSettings();

		public function get profileSetting():ProfileSettings
		{
			return profileSetting_;
		}

		public function set profileSetting(value:ProfileSettings):void
		{
			profileSetting_=value;
		}

		/**
		 *
		 * Chart Views
		 *
		 **/

		////////////////////Live Symbol Chart View////////////////////
		private var liveSymbolChart_:HistoricalSymbolChart=new HistoricalSymbolChart();

		public function get liveSymbolChart():HistoricalSymbolChart
		{
			return liveSymbolChart_;
		}

		public function set liveSymbolChart(value:HistoricalSymbolChart):void
		{
			liveSymbolChart_=value;
		}

		///////////////////////////////////////////////////////////////
		private static var instance:ViewManager=new ViewManager();

		public function ViewManager()
		{
			if (instance)
			{
				throw new Error("ViewManager can only be accessed through ViewManager.getInstance()");
			}
		}

		///////////////////////////////////////////////////////////////
		public static function getInstance():ViewManager
		{
			return instance;
		}

		/*
		 * Messages Views
		 *
		 */
//		private var messagesWindow_:MessagesView = new MessagesView();
//		public function set messagesWindow(value:MessagesView):void
//		{
//			messagesWindow_ = value;
//		}
//		
//		public function get messagesWindow():MessagesView
//		{
//			return messagesWindow_;
//		}

		///////////////////////////////////////////////////////////////
		public function init():void
		{
		/*marketWatch_ = new MarketWatch();
		remainingOrders_ = new RemainingOrders();
		userTradeHistory_ = new UserTradeHistory();
		bestMarket_ = new BestMarket();
		buyOrder_ = new Order();
		sellOrder_ = new Order();*/
		}
	}
}
