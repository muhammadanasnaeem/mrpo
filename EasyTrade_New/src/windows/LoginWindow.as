package windows
{
	import common.Constants;
	import common.Messages;
	
	import controller.EasyTradeApp;
	import controller.ModelManager;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.system.System;
	
	import flexlib.controls.PromptingTextInput;
	import flexlib.mdi.containers.MDIWindow;
	import flexlib.mdi.events.MDIWindowEvent;
	
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.core.FlexGlobals;
	import mx.managers.FocusManager;
	import mx.states.SetEventHandler;
	import mx.utils.StringUtil;
	import mx.validators.StringValidator;
	
	import spark.components.BorderContainer;
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.effects.Rotate3D;
	import spark.events.TextOperationEvent;

	public class LoginWindow extends MDIWindow
	{
		private var easyTradeApp_:EasyTradeApp=EasyTradeApp.getInstance();
		private var modelManager_:ModelManager=ModelManager.getInstance();

		private var bc:BorderContainer=new BorderContainer();
		private var lblUserID:Label=new Label();
		private var _txtUserID:PromptingTextInput=new PromptingTextInput();
		private var lblPassword:Label=new Label();
		private var _txtPassword:PromptingTextInput=new PromptingTextInput();
		private var btnLogin:Button=new Button();
		private var _chckRememberMe:CheckBox=new CheckBox();
//		private var stringValidator1:StringValidator=new StringValidator();
//		private var stringValidator2:StringValidator=new StringValidator();
		
		//Some extra 3-D effects to please kids ;)
		
		private var rotate3DY:Rotate3D;
		

		public function LoginWindow()
		{
			super();
//			stringValidator1.source=txtUserID;
//			stringValidator1.trigger = btnLogin;
//			stringValidator1.triggerEvent = "click";
//			stringValidator1.property="text";

//			stringValidator2.source=txtPassword;
//			stringValidator2.trigger = btnLogin;
//			stringValidator2.triggerEvent = "click";
//			stringValidator2.property="text";

			setStyle("backgroundColor", Constants.MARKET_WATCH_TITLE_BACKGROUND_INT);
			setStyle("borderVisible", true);
			setStyle("bordercolor", Constants.MARKET_WATCH_TITLE_BORDER_INT);
			setStyle("bordercolor", Constants.BORDER_TOP);
			addEventListener(MDIWindowEvent.CLOSE, onLoginWindowClose);
			if (FlexGlobals.topLevelApplication.parameters.LOCALE == "ar_SA")
			{
				resourceManager.localeChain=['ar_SA'];
				txtUserID.layoutDirection="rtl";
				txtPassword.layoutDirection="rtl";
				bc.layoutDirection="rtl";
			}
			else
			{
				resourceManager.localeChain=['en_US'];   
			}
			id="Login";
			title=resourceManager.getString('marketwatch', 'login').toString();

			resizable=false;
			minimizeBtn.visible=false;
			maximizeRestoreBtn.visible=false;
			this.closeBtn.visible=false;
			closeBtn.enabled=false;
			var pglobal:Point=new Point(200, 200);
			var plocal:Point=globalToLocal(pglobal);
			x=plocal.x;
			y=plocal.y;
			width=245;
			height=170;

			bc.x=0;
			bc.y=0;
			bc.width=238;
			bc.height=137;

			lblUserID.text=resourceManager.getString('marketwatch', 'username').toString();
			lblUserID.x=10;
			lblUserID.y=22;
			bc.addElement(lblUserID);

			txtUserID.id="txtUserID";
			txtUserID.x=100;
			txtUserID.y=10;
			txtUserID.width=125;
			txtUserID.prompt=resourceManager.getString('marketwatch', 'username').toString();
			bc.addElement(txtUserID);

			lblPassword.text=resourceManager.getString('marketwatch', 'password').toString();
			lblPassword.x=10;
			lblPassword.y=62;
			bc.addElement(lblPassword);

			txtPassword.id="txtPassword";
			txtPassword.x=100;
			txtPassword.y=50;
			txtPassword.width=125;
			txtPassword.prompt=resourceManager.getString('marketwatch', 'password').toString();
			txtPassword.displayAsPassword=true;
			bc.addElement(txtPassword);

			chckRememberMe.layoutDirection="ltr";
			chckRememberMe.x=10;
			chckRememberMe.y=80;
			chckRememberMe.label=resourceManager.getString('marketwatch', 'rememberme').toString();
			chckRememberMe.id="chckRememberMe";
			bc.addElement(chckRememberMe);

			btnLogin.layoutDirection="rtl";
			btnLogin.buttonMode=true;
			btnLogin.useHandCursor=true;
			btnLogin.x=85;
			btnLogin.y=100;
			btnLogin.label=resourceManager.getString('marketwatch', 'logmein').toString();
			btnLogin.id="btnLogin";
			btnLogin.addEventListener(MouseEvent.CLICK, btnLogin_clickHandler);
			bc.addElement(btnLogin);

			addElement(bc);

			this.defaultButton=btnLogin;
			// Start : added on 8/12//2010 for remember me functionality
			var userProfileRemSO:SharedObject=SharedObject.getLocal(Constants.USER_LOGIN_PREFERENCES);
			if (userProfileRemSO.size > 0)
			{
				txtUserID.text=userProfileRemSO.data.userName;
//				txtPassword.text=userProfileRemSO.data.password;
				chckRememberMe.selected=true;
			}

			// End : added on 8/12//2010 for remember me functionality
			
			
		}

		private function btnLogin_clickHandler(event:MouseEvent):void
		{
			if (StringUtil.trim(txtUserID.text).length <= 0 || StringUtil.trim(txtPassword.text).length <= 0)
			{
//				Alert.show(Messages.INVALID_USER_PWD, Messages.TITLE_ERROR);
				return;
			}
			else
			{
				modelManager_.Login(txtUserID.text, txtPassword.text);
			}
		}

		public function onLoginWindowClose(event:MDIWindowEvent):void
		{
			if (!easyTradeApp_.isUserLoggedin())
			{
				//NativeApplication.nativeApplication.exit();
			}
		}

		public function get chckRememberMe():CheckBox
		{
			return _chckRememberMe;
		}

		public function set chckRememberMe(value:CheckBox):void
		{
			_chckRememberMe=value;
		}

		public function get txtPassword():PromptingTextInput
		{
			return _txtPassword;
		}

		public function set txtPassword(value:PromptingTextInput):void
		{
			_txtPassword=value;
		}

		public function get txtUserID():PromptingTextInput
		{
			return _txtUserID;
		}

		public function set txtUserID(value:PromptingTextInput):void
		{
			_txtUserID=value;
		}


	}
}
