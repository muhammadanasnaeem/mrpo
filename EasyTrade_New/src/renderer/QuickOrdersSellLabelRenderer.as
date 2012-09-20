package renderer
{
	import businessobjects.QuickOrdersBO;

	import components.EZCurrencyFormatter;

	import controller.ModelManager;
	import controller.WindowManager;

	import mx.collections.ArrayCollection;
	import mx.controls.Label;



	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

	public class QuickOrdersSellLabelRenderer extends Label
	{
		private var isUpdate:Boolean=false;
		private var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
		private var qoBO:QuickOrdersBO;

		public function QuickOrdersSellLabelRenderer()
		{
			super();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var modelManager:ModelManager=ModelManager.getInstance();
			var arr:ArrayCollection=modelManager.quickOrdersModel.quickOrders[WindowManager.getInstance().viewManager.quickOrders.selectedIndex];
			if (isUpdate)
			{
				if (qoBO.SELL != null)
				{
					this.text=moneyFormatter.format(qoBO.SELL);
				}
			}
		}

		override public function set data(value:Object):void
		{
			if (value && value.SELL)
			{
				super.data=value;
				qoBO=value as QuickOrdersBO;
				isUpdate=true;
			}
			else
			{
				isUpdate=false;
				this.text="";
			}
		}
	}
}
