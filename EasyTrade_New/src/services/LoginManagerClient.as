package services
{
	import common.Constants;

	import controller.ModelManager;

	import mx.managers.CursorManager;
	import mx.rpc.soap.WebService;

	public class LoginManagerClient extends ServiceClient
	{
		private static var instance:LoginManagerClient=new LoginManagerClient();

		public function LoginManagerClient()
		{
			if (instance)
			{
				throw new Error("LoginManagerClient can only be accessed through LoginManagerClient.getInstance()");
			}
		}

		///////////////////////////////////////////////////////////////
		public static function getInstance():LoginManagerClient
		{
			return instance;
		}

		public function Login(userName:String, password:String):void
		{
			var webService:WebService=createService(Constants.LOGIN_MANAGER_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().userProfileModel.onResult);
			webService.addEventListener("fault", ModelManager.getInstance().userProfileModel.onFault);
			webService.Login(userName, password);
			CursorManager.setBusyCursor();
		}

		public function ChangePassword(username:String, oldPassword:String, newPassword:String):void
		{
			var webService:WebService=createService(Constants.LOGIN_MANAGER_WSDL_END_POINT);
			webService.addEventListener("result", ModelManager.getInstance().userProfileModel.onChangePasswordResult);
			webService.addEventListener("fault", ModelManager.getInstance().userProfileModel.onChangePasswordFault);
			webService.ChangePassword(username, oldPassword, newPassword);
			CursorManager.setBusyCursor();
		}
	}
}
