package model
{
	import businessobjects.SymbolOrderLimitBO;
	
	import common.Messages;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.AnnouncerClient;

	public class SymbolOrderLimitModel implements IModel
	{
		private var isDirty_:Boolean=true;

		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}

		private var symbolOrderLimit_:SymbolOrderLimitBO=new SymbolOrderLimitBO();

		public function get symbolOrderLimit():SymbolOrderLimitBO
		{
			return symbolOrderLimit_;
		}

		public function set symbolOrderLimit(value:SymbolOrderLimitBO):void
		{
			symbolOrderLimit_=value;
		}


		public function SymbolOrderLimitModel()
		{
		}

		public function execute():void
		{
			AnnouncerClient.getInstance().SymbolOrderLimitChange(symbolOrderLimit);
		}

		public function onResult(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
		}

		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}
	}
}
