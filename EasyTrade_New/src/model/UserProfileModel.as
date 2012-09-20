package model
{
	import businessobjects.Bulletin;
	import businessobjects.GrantBO;
	import businessobjects.UserProfile;
	
	import common.Constants;
	import common.Messages;
	
	import components.ComboBoxItem;
	
	import controller.ModelManager;
	import controller.ProfileManager;
	import controller.WindowManager;
	
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.core.INavigatorContent;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.AnnouncerClient;
	import services.LoginManagerClient;

	[Bindable]
	public class UserProfileModel implements IModel
	{
		public var isAdminUser:Boolean=false;
		private var userName_:String="";

		public function get userName():String
		{
			return userName_;
		}

		public function set userName(value:String):void
		{
			userName_=value;
		}

		///////////////////////////////////////////////////////////////
		private var password_:String="";

		public function get password():String
		{
			return password_;
		}

		public function set password(value:String):void
		{
			password_=value;
		}

		///////////////////////////////////////////////////////////////
		private var isDirty_:Boolean=true;

		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}

		///////////////////////////////////////////////////////////////
		private var userProfile_:UserProfile=new UserProfile();

		public function get userProfile():UserProfile
		{
			return userProfile_;
		}

		public function set userProfile(value:UserProfile):void
		{
			userProfile_=value;
		}

		///////////////////////////////////////////////////////////////
		public function UserProfileModel()
		{
		}

		///////////////////////////////////////////////////////////////
		public function execute():void
		{
			LoginManagerClient.getInstance().Login(userName, password);
		}

		///////////////////////////////////////////////////////////////

		public function onChangePasswordResult(event:ResultEvent):void
		{
			if (event.result && event.result == true)
			{
				Alert.show("Password successfully changed.", "Change Password");
			}
			else
			{
				Alert.show("There was a problem changing your password.\n Please try later", "Change Password");
			}
			var windowManager:WindowManager=WindowManager.getInstance();
			if (windowManager.changePasswordWindow && windowManager.canvas.windowManager.container.contains(windowManager.changePasswordWindow))
			{
				var profileManager:controller.ProfileManager=controller.ProfileManager.getInstance();
				profileManager.password=windowManager.viewManager.changePassword.txtNewPassword.text;

				windowManager.viewManager.changePassword.txtCurrentPassword.text="";
				windowManager.viewManager.changePassword.txtNewPassword.text="";
				windowManager.viewManager.changePassword.txtRepeatNewPassword.text="";
				windowManager.changePasswordWindow.close(null);
			}
			CursorManager.removeBusyCursor();
		}

		///////////////////////////////////////////////////////////////

		public function onChangePasswordFault(event:FaultEvent):void
		{
			Alert.show("There was a problem changing your password.\n Please try later", "Change Password");
			CursorManager.removeBusyCursor();
		}

		///////////////////////////////////////////////////////////////

		public function onResult(event:ResultEvent):void
		{
//			var sobj:SharedObject = ProfileManager.getInstance().sharedObject;
//			ProfileManager.getInstance().loadMarketWatchSymbolData(sobj);
			// added on 11/1/2011
			var modelManager:ModelManager=ModelManager.getInstance();
			if (event.result && event.result.userId && event.result.userId > -1)
			{
				// modified on 11/1/2011
				//var modelManager:ModelManager = ModelManager.getInstance();
				modelManager.userID=event.result.userId;
				modelManager.brokerID=event.result.brokerId;
				this.userProfile.roles=event.result.roles; // added on 29/11/2010
				// added on 16/3/2011
				this.userProfile.grants=event.result.grants;
				this.userProfile.brokerId = event.result.brokerId;// added on 06/10/2012 (nonsense people making code sloppy by placing a single attribute at more than single place and then playing blame game)
				for each (var grant:Object in this.userProfile.grants)
				{
					modelManager.distinctModel.brokers.put(grant.brokerCode, grant.brokerId.toString());
				}
				this.userProfile.grantedUsers=event.result.grantedUsers;

				//this.userProfile.roles = new ArrayCollection(["Pak","Admin","App"]);
				modelManager.easyTradeApp.userLoggedin();
				WindowManager.getInstance().loginWindow.close();
				modelManager.easyTradeApp.updateUserMenu(); // added on 29/11/2010

				//Start : added on 8/12//2010 for remember me functionality
				var userProfileRemSO:SharedObject=SharedObject.getLocal(Constants.USER_LOGIN_PREFERENCES);
				if (WindowManager.getInstance().loginWindow.chckRememberMe.selected)
				{
					userProfileRemSO.data.userName=WindowManager.getInstance().loginWindow.txtUserID.text;
//					userProfileRemSO.data.password=WindowManager.getInstance().loginWindow.txtPassword.text;
					//userProfileRemSO.addEventListener(NetStatusEvent.NET_STATUS, ProfileManager.getInstance().netStatusHandler);
					userProfileRemSO.flush();
				}
				else
				{
					userProfileRemSO.clear();
					WindowManager.getInstance().loginWindow.txtPassword.text="";
					WindowManager.getInstance().loginWindow.txtUserID.text="";
				}

					//End : added on 8/12//2010 for remember me functionality
			}
			else
			{
				modelManager.userID=-1;
				modelManager.brokerID=-1;
				Alert.show(ResourceManager.getInstance().getString('marketwatch','sysCouldNotLogin'), ResourceManager.getInstance().getString('marketwatch','error'));
			}
			CursorManager.removeBusyCursor();
		}

		///////////////////////////////////////////////////////////////
		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}

		///////////////////////////////////////////////////////////////

		public function getTraders(privilegeType:String):ArrayCollection
		{
			var traders:ArrayCollection=new ArrayCollection();
			for (var i:int=0; i < userProfile.grants.length; ++i)
			{
				var grant:Object=userProfile.grants.getItemAt(i);
				for (var j:int=0; j < grant.privileges.length; j++)
				{
					if (privilegeType == grant.privileges.getItemAt(j))
					{
						var comboItem:ComboBoxItem=new ComboBoxItem(grant.userId, grant.userName);
						traders.addItem(comboItem);
						break;
					}
				}
			}
			if (traders.length > 0)
				traders.addItemAt(new ComboBoxItem("", ""), 0);
			return traders;
		}
	}
}
