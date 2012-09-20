package model
{
	import components.ComboBoxItem;

	import mx.collections.ArrayList;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class OrderTypesModel implements IModel
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

		private var orderTypes_:ArrayList=new ArrayList();

		[Bindable]
		public function get orderTypes():ArrayList
		{
			return orderTypes_;
		}

		public function set orderTypes(value:ArrayList):void
		{
			orderTypes_=value;
		}

		public function OrderTypesModel()
		{
			orderTypes_.addItem(new ComboBoxItem("", ""));
			orderTypes_.addItem(new ComboBoxItem("mt", "MT"));
			orderTypes_.addItem(new ComboBoxItem("sl", "SL"));
		}

		public function execute():void
		{
		}

		public function onResult(event:ResultEvent):void
		{
		}

		public function onFault(event:FaultEvent):void
		{
		}

	}
}
