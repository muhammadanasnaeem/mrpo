package controller
{
	import businessobjects.ExchangeBO;
	import common.Constants;
	import common.HashMap;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import flexlib.mdi.containers.MDICanvas;
	import flexlib.mdi.containers.MDIWindow;
	import flexlib.mdi.events.MDIWindowEvent;
	
	import model.MarketWatchModel;
	import model.UserProfileModel;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.events.ItemClickEvent;
	
	import services.LSListener;
	import services.OrdererClient;
	import services.QWClient;
	
	import spark.components.Group;
	
	import windows.LoginWindow;
	
	public class EasyTradeApp 
	{
		//Members
		private var easyTrade_:EasyTrade;

		public function get easyTrade():EasyTrade
		{
			return easyTrade_;
		}

		///////////////////////////////////////////////////////////////
		private static var instance:EasyTradeApp=new EasyTradeApp();

		public function EasyTradeApp()
		{
			if (instance)
			{
				throw new Error("EasyTradeApp can only be accessed through EasyTradeApp.getInstance()");
			}
		}

		///////////////////////////////////////////////////////////////
		public static function getInstance():EasyTradeApp
		{
			return instance;
		}

		///////////////////////////////////////////////////////////////
		public function init(easyTrade:EasyTrade):void
		{
			easyTrade_=easyTrade;

			ConfigurationManager.getInstance().screenConf.width=(easyTrade_.canvas.parent as Group).screen.width;
			ConfigurationManager.getInstance().screenConf.height=(easyTrade_.canvas.parent as Group).screen.height - easyTrade_.menubarMain.height - easyTrade_.newsTapeTicker.height - easyTrade_.symbolTapeTicker.height;

			toggleMenuBarVisibility(false);
//			ViewManager.getInstance().init();
			WindowManager.getInstance().init(easyTrade_.canvas)
			ModelManager.getInstance().easyTradeApp=this;
		}

		///////////////////////////////////////////////////////////////
		public function userLoggedin():void
		{
			ModelManager.getInstance().init();
			//Start : added on 15/12/2010
			ProfileManager.getInstance().userName=WindowManager.getInstance().loginWindow.txtUserID.text;
			ProfileManager.getInstance().password=WindowManager.getInstance().loginWindow.txtPassword.text;
			//End : added on 15/12/2010
			ProfileManager.getInstance().init();
			//modified on 13/12/2010 to resolve empty exchange list on relogin  
//			ProfileManager.getInstance().loadProfile();

			LSListener.getInstance().init();
			toggleMenuBarVisibility();
			//update market watch window
			var itemNameUser:String="USER_" + ModelManager.getInstance().userID + "_" + ModelManager.getInstance().userID;
				LSListener.getInstance().subscribeItem(
				itemNameUser,
				LSListener.fieldSchemaOrderConfirmation,
				LSListener.getInstance().lsClientOrderConfirmation,
				WindowManager.getInstance().viewManager.marketWatch.handleOrderConfirmation);
			if (!ModelManager.getInstance().subscribedItems.hasKey(itemNameUser))
			{
				ModelManager.getInstance().subscribedItems.put(itemNameUser, itemNameUser);
				ExternalInterface.call("subscribeItem", Constants.ORDER_CONFIRMATION_DATA_ADAPTER, "tblOrderConfirmation", itemNameUser, "fieldSchemaOrderConfirmation", "handleOrderConfirmation", ProfileManager.getInstance().userName, ProfileManager.getInstance().password);
			}

			subscribeOrderConfirmations();
		}

		private function subscribeOrderConfirmations():void
		{

			var itemNamesMap:HashMap=new HashMap();
			for (var i:int=0; i < ModelManager.getInstance().userProfileModel.userProfile.grants.length; ++i)
			{
				var grant:Object=ModelManager.getInstance().userProfileModel.userProfile.grants.getItemAt(i);
				for (var j:int=0; j < grant.privileges.length; j++)
				{
					if ('SubmitOrder' == grant.privileges.getItemAt(j) || 'ChangeOrder' == grant.privileges.getItemAt(j) || 'CancelOrder' == grant.privileges.getItemAt(j))
					{
						var itemNameUser:String="USER_" + ModelManager.getInstance().userID + "_" + grant.userId;
						if (!itemNamesMap.hasKey(itemNameUser))
						{
							itemNamesMap.put(itemNameUser, itemNameUser);
								LSListener.getInstance().subscribeItem(
									itemNameUser,
									LSListener.fieldSchemaOrderConfirmation,
									LSListener.getInstance().lsClientOrderConfirmation,
									WindowManager.getInstance().viewManager.marketWatch.handleOrderConfirmation);	
							if (!ModelManager.getInstance().subscribedItems.hasKey(itemNameUser))
							{
								ModelManager.getInstance().subscribedItems.put(itemNameUser, itemNameUser);
								ExternalInterface.call("subscribeItem", Constants.ORDER_CONFIRMATION_DATA_ADAPTER, "tblOrderConfirmations_" + i.toString() + "_" + j.toString(), itemNameUser, "fieldSchemaOrderConfirmation", "handleOrderConfirmation", ProfileManager.getInstance().userName, ProfileManager.getInstance().password);
							}
						}
					}
				}
			}

			for (var k:int=0; k < ModelManager.getInstance().userProfileModel.userProfile.grantedUsers.length; ++k)
			{
				var userId:Number=ModelManager.getInstance().userProfileModel.userProfile.grantedUsers.getItemAt(k) as Number;

				var itemName:String="USER_" + userId + "_" + ModelManager.getInstance().userID;
				LSListener.getInstance().subscribeItem(
					itemName,
					LSListener.fieldSchemaOrderConfirmation,
					LSListener.getInstance().lsClientOrderConfirmation,
					WindowManager.getInstance().viewManager.marketWatch.handleOrderConfirmation);
				if (!ModelManager.getInstance().subscribedItems.hasKey(itemName))
				{
					ModelManager.getInstance().subscribedItems.put(itemName, itemName);
					ExternalInterface.call("subscribeItem", Constants.ORDER_CONFIRMATION_DATA_ADAPTER, "tblOrderConfirmation__" + k.toString(), itemName, "fieldSchemaOrderConfirmation", "handleOrderConfirmation", ProfileManager.getInstance().userName, ProfileManager.getInstance().password);
				}
			}

			itemNamesMap.clear();
			itemNamesMap=null;
		}

		///////////////////////////////////////////////////////////////
		public function isUserLoggedin():Boolean
		{
			return ModelManager.getInstance().userID > 0;
		}

		///////////////////////////////////////////////////////////////
		public function toggleMenuBarVisibility(toShow:Boolean=true):void
		{
			easyTrade_.canvasHeader.visible=toShow;
		}

		///////////////////////////////////////////////////////////////
		public function logOffUser():void
		{
			ProfileManager.getInstance().saveProfile();
			toggleMenuBarVisibility(false);
			ModelManager.getInstance().userID=-1;
			ModelManager.getInstance().symbolTickerFeedModel.feed=new Array();
			// added on 13/12/2010 to clear hashmap
			ModelManager.getInstance().bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap=new HashMap();

			//Start : added on 15/12/2010
			ProfileManager.getInstance().userName="";
			ProfileManager.getInstance().password="";
			WindowManager.getInstance().viewManager.liveMessages.vgroup1=null;
			WindowManager.getInstance().viewManager.liveMessages.vgroup=null;
			//End : added on 15/12/2010

			//Start : Modified on 20/12/2010
			var ref:URLRequest=new URLRequest("javascript:location.reload(true)");
			navigateToURL(ref, "_self");

			//WindowManager.getInstance().initLoginWindow();		
			//End : Modified on 20/12/2010
		}

		///////////////////////////////////////////////////////////////
		public function updateUserMenu():void
		{
			var i:int=0;
			var rolesLength:int=ModelManager.getInstance().userProfileModel.userProfile.roles.length;
			for (i; i < rolesLength; i++)
			{
				if (ModelManager.getInstance().userProfileModel.userProfile.roles[i] == Constants.ADMIN_ROLE)
				{
					//this.easyTrade.menubarMain.getMenuAt(4).enabled = true;
					this.easyTrade.menubarMain.menuBarItems[4].enabled=true;
					ModelManager.getInstance().userProfileModel.isAdminUser=true;
					break;
				}
				else
					ModelManager.getInstance().userProfileModel.isAdminUser=false;
			}

		}
	}
}
