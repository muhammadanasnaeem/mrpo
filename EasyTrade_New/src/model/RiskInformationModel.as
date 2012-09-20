package model
{
	import common.Messages;
	
	import controller.ModelManager;
	import controller.WindowManager;
	
	import filters.Filters;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
//	import org.hamcrest.filter.FilterFunction;
	
	import services.QWClient;
	
	public class RiskInformationModel implements IModel
	{
		private var isDirty_:Boolean=true;		
		private var holdings_:ArrayCollection=new ArrayCollection();
		
		[Bindable]
		public function get holdings():ArrayCollection
		{
			return holdings_;
		}
		
		public function set holdings(value:ArrayCollection):void
		{
			holdings_=value;
		}
		
		public function RiskInformationModel()
		{
			holdings.filterFunction = Filters.riskInformationFilter;
		}
		
		public function execute():void
		{
			var modelMgr:ModelManager = ModelManager.getInstance();
			var brokerId:Number = modelMgr.userProfileModel.userProfile.brokerId;
			var clnCode:String = WindowManager.getInstance().viewManager.riskInfo.txtClientCode.text;
			var requesterUserId:Number  = ModelManager.getInstance().userID;
			QWClient.getInstance().getClientRiskInfo(requesterUserId,brokerId,clnCode);
		}
		
		public function onResult(event:ResultEvent):void
		{
			var obj:Object = event.result;
			if(obj.clientCode == "")
			{
				isDirty=true;
				WindowManager.getInstance().viewManager.riskInfo.txtActive.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtShortSell.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtBuyingPower.text ='';
				WindowManager.getInstance().viewManager.riskInfo.txtByPassRisk.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtCash.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtClientCode.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtMargin.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtOpenPosition.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtShareValue.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtProfitLoss.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtRemainigBuyingPower.text = '';
				WindowManager.getInstance().viewManager.riskInfo.txtUseOpenPosition.text = '';
				ModelManager.getInstance().riskInformationModel.holdings = null;
				Alert.show('Client not found.', ResourceManager.getInstance().getString('marketwatch','error'));
				CursorManager.removeBusyCursor();
			}
			else
			{
				WindowManager.getInstance().viewManager.riskInfo.txtActive.text = obj.active;
				WindowManager.getInstance().viewManager.riskInfo.txtShortSell.text = obj.allowShortSell;
				WindowManager.getInstance().viewManager.riskInfo.txtBuyingPower.text = obj.buyingPower;
				WindowManager.getInstance().viewManager.riskInfo.txtByPassRisk.text = obj.bypassRisk;
				WindowManager.getInstance().viewManager.riskInfo.txtCash.text = obj.cash;
				WindowManager.getInstance().viewManager.riskInfo.txtClientCode.text = obj.clientCode;
				WindowManager.getInstance().viewManager.riskInfo.txtMargin.text = obj.margin;
				WindowManager.getInstance().viewManager.riskInfo.txtOpenPosition.text = obj.openPosition;
				WindowManager.getInstance().viewManager.riskInfo.txtShareValue.text = obj.shareValue;
				WindowManager.getInstance().viewManager.riskInfo.txtProfitLoss.text = obj.profitLoss;
				WindowManager.getInstance().viewManager.riskInfo.txtRemainigBuyingPower.text = obj.remainingBuyingPower;
				WindowManager.getInstance().viewManager.riskInfo.txtUseOpenPosition.text = obj.useOpenPosition;
				ModelManager.getInstance().riskInformationModel.holdings = obj.holdings;
				CursorManager.removeBusyCursor();
			}
		}
		
		public function onFault(event:FaultEvent):void
		{
			
		}
		
		public function get isDirty():Boolean
		{
			return isDirty_;
		}
		
		public function set isDirty(value:Boolean):void
		{
			isDirty_ = value;
		}
	}
}