package services
{
	import businessobjects.Bulletin;
	import businessobjects.MarketStateInfo;
	import businessobjects.SymbolOrderLimitBO;
	import businessobjects.SymbolStateInfo;

	import common.Constants;

	import controller.ModelManager;

	import mx.managers.CursorManager;
	import mx.rpc.soap.WebService;

	public class AnnouncerClient extends ServiceClient
	{
		private static var instance:AnnouncerClient=new AnnouncerClient();

		public function AnnouncerClient()
		{
			if (instance)
			{
				throw new Error("AnnouncerClient can only be accessed through AnnouncerClient.getInstance()");
			}
		}

		///////////////////////////////////////////////////////////////
		public static function getInstance():AnnouncerClient
		{
			return instance;
		}

		public function MarketStateChange(marketStateInfo:MarketStateInfo):void
		{
			var webService:WebService=createService(Constants.ANNOUNCER_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().exchangeScheduleModel.onMarketStateChangeResult);
			webService.addEventListener("fault", ModelManager.getInstance().exchangeScheduleModel.onFault);
			webService.MarketStateChange(marketStateInfo);
			CursorManager.setBusyCursor();
		}

		public function SymbolStateChange(symbolStateInfo:SymbolStateInfo):void
		{
			var webService:WebService=createService(Constants.ANNOUNCER_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().exchangeScheduleModel.onSymbolStateChangeResult);
			webService.addEventListener("fault", ModelManager.getInstance().exchangeScheduleModel.onFault);
			webService.SymbolStateChange(symbolStateInfo);
			CursorManager.setBusyCursor();
		}

		public function SymbolOrderLimitChange(orderlimit:SymbolOrderLimitBO):void
		{
			var webService:WebService=createService(Constants.ANNOUNCER_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().symbolOrderLimitModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().symbolOrderLimitModel.onFault);
			webService.SymbolOrderLimitChange(orderlimit);
			CursorManager.setBusyCursor();
		}

		public function SubmitBulletin(bulletin:Bulletin):void
		{
			var webService:WebService=createService(Constants.ANNOUNCER_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().bulletinModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().bulletinModel.onFault);
			webService.SubmitBulletin(bulletin);
			CursorManager.setBusyCursor();
		}
	}
}
