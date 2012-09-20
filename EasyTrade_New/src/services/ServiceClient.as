package services
{
	import mx.rpc.soap.WebService;

	public class ServiceClient
	{
		public function ServiceClient()
		{
		}

		protected function createService(serviceEndpoint:String):WebService
		{
			var webService:WebService=new WebService();
			webService.wsdl=serviceEndpoint;
			webService.useProxy=false;
			webService.loadWSDL();
			return webService;
		}
	}
}
