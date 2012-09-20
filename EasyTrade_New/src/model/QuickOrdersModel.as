package model
{
	import businessobjects.MarketWatchBO;
	import businessobjects.QuickOrdersBO;
	
	import common.Constants;
	import common.Messages;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class QuickOrdersModel implements IModel
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

		[Bindable]
		private var quickOrders_:Array=new Array();

		[Bindable]
		public function get quickOrders():Array
		{
			return quickOrders_;
		}

		public function set quickOrders(value:Array):void
		{
			quickOrders_=value;
		}

		public function QuickOrdersModel()
		{
			for (var i:int=0; i < Constants.QUICK_ORDERS_MAX_SEGMENTS; ++i)
			{
				var quickOrdersView:ArrayCollection=new ArrayCollection();
				for (var j:int=0; j < Constants.QUICK_ORDERS_DROP_DOWN_LIMIT; ++j)
				{
					quickOrdersView.addItem(new QuickOrdersBO());
				}
				quickOrders_.push(quickOrdersView);
			}
		}

		public function execute():void
		{
		}

		public function onResult(event:ResultEvent):void
		{
		}

		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
		}

		public function isSymbolSubscribed(internalExchangeID:Number, internalMarketID:Number, symbolCode:String):Boolean
		{
			var retVal:Boolean=false;
			for (var i:int=0; i < Constants.QUICK_ORDERS_MAX_SEGMENTS; ++i)
			{
				var quickOrdersView:ArrayCollection=quickOrders[i] as ArrayCollection;
				for (var j:int=0; j < Constants.QUICK_ORDERS_DROP_DOWN_LIMIT; ++j)
				{
					var qobo:QuickOrdersBO=quickOrdersView.getItemAt(j) as QuickOrdersBO;
					if (qobo && qobo.SYMBOL == symbolCode && qobo.internalExchangeID == internalExchangeID && qobo.internalMarketID == internalMarketID)
					{
						retVal=true;
						break;
					}
				}
			}
			return retVal;
		}


		public function getQuickOrdersBO(internalExchangeID:Number, internalMarketID:Number, symbolCode:String):QuickOrdersBO
		{
			for (var i:int=0; i < Constants.QUICK_ORDERS_MAX_SEGMENTS; ++i)
			{
				var quickOrdersView:ArrayCollection=quickOrders[i] as ArrayCollection;
				for (var j:int=0; j < Constants.QUICK_ORDERS_DROP_DOWN_LIMIT; ++j)
				{
					var qobo:QuickOrdersBO=quickOrdersView.getItemAt(j) as QuickOrdersBO;
					if (qobo && qobo.SYMBOL == symbolCode && qobo.internalExchangeID == internalExchangeID && qobo.internalMarketID == internalMarketID)
					{
						return qobo;
					}
				}
			}
			return null;
		}

	}
}
