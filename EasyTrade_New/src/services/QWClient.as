package services
{
	import businessobjects.CancelAllOrdersBO;
	import businessobjects.YieldBO;
	
	import common.Constants;
	import common.Messages;
	
	import controller.EasyTradeApp;
	import controller.ModelManager;
	
	import flash.profiler.showRedrawRegions;
	
	import model.ExchangeModel;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Grouping;
	import mx.collections.GroupingCollection2;
	import mx.collections.HierarchicalData;
	import mx.controls.Alert;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.managers.CursorManager;
	import mx.utils.ObjectProxy;

	public class QWClient extends ServiceClient
	{
		import mx.rpc.soap.WebService;
		import mx.rpc.events.ResultEvent;
		import mx.rpc.events.FaultEvent;

		private static var instance:QWClient=new QWClient();

		public function QWClient()
		{
			if (instance)
			{
				throw new Error("QWClient can only be accessed through QWClient.getInstance()");
			}
		}

		///////////////////////////////////////////////////////////////
		public static function getInstance():QWClient
		{
			return instance;
		}

		public function getExchanges():void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().exchangeModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().exchangeModel.onFault);
			webService.getExchanges();
			CursorManager.setBusyCursor();
		}

		public function getBrokers():void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().brokerModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().brokerModel.onFault);
			webService.getBrokers();
			CursorManager.setBusyCursor();
		}

		public function getExchangeStats(actualExchangeID:Number, internalExchangeID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().exchangeStatsModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().exchangeStatsModel.onFault);
			webService.getExchangeStat(actualExchangeID, internalExchangeID);
			CursorManager.setBusyCursor();
		}

		public function getBestOrders(exchangeID:Number, marketID:Number, symbolID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().bestOrdersModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().bestOrdersModel.onFault);

			webService.getBestOrders(exchangeID, marketID, symbolID);
			CursorManager.setBusyCursor();
		}

		public function getBestPrices(exchangeID:Number, marketID:Number, symbolID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().bestPricesModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().bestPricesModel.onFault);
			webService.getBestPrices(exchangeID, marketID, symbolID);
			CursorManager.setBusyCursor();
		}

		public function getBestMarketAndSymbolSummary(exchangeID:Number, marketID:Number, symbolId:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().bestMarketAndSymbolSummaryModel.onResult);
			webService.addEventListener("result", ModelManager.getInstance().bestMarketAndSymbolSummaryModel.onResult2);
			webService.addEventListener("fault", ModelManager.getInstance().bestMarketAndSymbolSummaryModel.onFault);
			webService.getBestMarketAndSymbolSummary(exchangeID, marketID, symbolId);
		}

		public function getSymbolsBrowser(exchangeID:Number, marketID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().symbolBrowserModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().symbolBrowserModel.onFault);

			//modified on 20/12/2010
			webService.getSymbolsBrowser(exchangeID, marketID);
			//webService.getSymbolsBrowser();
		}

		public function getSymbolSummary(exchangeID:Number, marketID:Number, symbolID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().symbolSummaryModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().symbolSummaryModel.onFault);

			webService.getSymbolSummary(exchangeID, marketID, symbolID);
		}

		public function getMarketSummary(exchangeID:Number, marketID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().marketSummaryModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().marketSummaryModel.onFault);

			webService.getMarketSymbolsSummary(exchangeID, marketID);
		}

		public function getSymbolTradeHistory(exchangeID:Number, marketID:Number, symbolID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().symbolTradeHistoryModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().symbolTradeHistoryModel.onFault);

			webService.getSymbolTradeHistory(exchangeID, marketID, symbolID);
		}

		public function getRemainingOrders(requesterUserId:Number, userID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().remainingOrdersModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().remainingOrdersModel.onFault);

			webService.getRemainingOrders(requesterUserId, userID);
		}

		public function getLastDayRemainingOrders(userID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().lastDayRemainingOrdersModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().lastDayRemainingOrdersModel.onFault);

			// this will be changed for last day remaining orders
			//webService.getRemainingOrders(userID);
			webService.getLastDayRemainingOrders();
		}


		public function getUserTradeHistory(requesterUserId:Number, userID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().userTradeHistoryModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().userTradeHistoryModel.onFault);

			webService.getUserTradeHistory(requesterUserId, userID);
		}

		public function getEventLog(requesterUserId:Number, userID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().eventLogModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().eventLogModel.onFault);

			webService.getEventLog(requesterUserId, userID);
			CursorManager.setBusyCursor();
		}
		
		public function getClientRiskInfo(requesterUserId:Number,brokerId:Number,clientCode:String):void
		{
			var webService:WebService=createService(Constants.RS_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().riskInformationModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().riskInformationModel.onFault);
			
			webService.getClientRiskInfoEx(requesterUserId,brokerId,clientCode);
			CursorManager.setBusyCursor();
		}

		public function getExchangesMarketsSchedules(exchangeID:Number):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().exchangeScheduleModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().exchangeScheduleModel.onFault);

			webService.getExchangesMarketsSchedules(exchangeID);
		}

		public function calculateYield(yield:YieldBO):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().yieldModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().yieldModel.onFault);

			webService.calculateYield(yield);
		}
		
		// Changes By Anas 21/03/2012
		//These methods were created and written so that the yield must be calulated in the same order
		//as its being caluclated using the yield calculator window. but they were changed with other implimentation as when i took a day off.
		//The prevoius one were working though correctly but i was told that there was a scenario made for which they got flopped
		public function calculateYieldFromSellOrderWindow(yield:YieldBO):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().yieldModel.onResult2);
			webService.addEventListener("fault", ModelManager.getInstance().yieldModel.onFault);
			
			webService.calculateYield(yield);
		}
		
		public function calculateYieldFromBuyOrderWindow(yield:YieldBO):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().yieldModel.onResult1);
			webService.addEventListener("fault", ModelManager.getInstance().yieldModel.onFault);
			
			webService.calculateYield(yield);
		}
		// Anas changes completed 
		//Anas changes 26/03/2012
		// the following two methods were written so that "on request" proper yield is shown that is synchronized 
		// with yield calucated using the above 2 methods
		public function calculateYieldFromBuyOrderWindowUsingBestMarket(yield:YieldBO):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().yieldModel.onResult3);
			webService.addEventListener("result", ModelManager.getInstance().yieldModel.onResult4);
			webService.addEventListener("fault", ModelManager.getInstance().yieldModel.onFault);
			webService.calculateYield(yield);
		}
		
		public function calculateYieldFromBuyOrderWindowUsingBestMarketSell(yield:YieldBO):void
		{
			var webService:WebService=createService(Constants.QW_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().yieldModel.onResult5);
			webService.addEventListener("result", ModelManager.getInstance().yieldModel.onResult6);
			webService.addEventListener("fault", ModelManager.getInstance().yieldModel.onFault);
			webService.calculateYield(yield);
		}
		// Chnages by Anas completed.26/03/2012.
	}
}
