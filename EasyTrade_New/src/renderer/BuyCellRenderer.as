package renderer
{
	import businessobjects.MarketWatchBO;

	import components.EZCurrencyFormatter;

	import controller.ModelManager;
	import controller.WindowManager;

	import flash.display.Graphics;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.*;
	import mx.styles.StyleManager;

	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

	public class BuyCellRenderer extends Label
	{
		private var isUpdate:Boolean=false;
		private var mwBO:MarketWatchBO;
		private var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();

//		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
//		{
//			super.updateDisplayList(unscaledWidth, unscaledHeight);
//
//			var g:Graphics = graphics;
//			g.clear();
//			var modelManager:ModelManager = ModelManager.getInstance();
//			var arr:ArrayCollection = modelManager.marketWatchModel.marketWatch[WindowManager.getInstance().viewManager.marketWatch.selectedIndex];
//			if (isUpdate)
//			{
//				if (arr[listData.rowIndex].BUY != null)
//				{
//					this.text = moneyFormatter.format(arr[listData.rowIndex].BUY);
//				}
//				if (DataGridListData(listData).dataField != null)
//				{
//					if (arr[listData.rowIndex].BUY_OLD != null)
//					{
//						paintFields(arr[listData.rowIndex].BUY, arr[listData.rowIndex].BUY_OLD);
//						arr[listData.rowIndex].BUY_OLD = arr[listData.rowIndex].BUY; 
//					}
//				}
//			}
//		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var g:Graphics=graphics;
			g.clear();
			var modelManager:ModelManager=ModelManager.getInstance();
			var arr:ArrayCollection=modelManager.marketWatchModel.marketWatch[WindowManager.getInstance().viewManager.marketWatch.selectedIndex];
			if (isUpdate)
			{
				if (mwBO.BUY != null)
				{
					this.text=moneyFormatter.format(mwBO.BUY);
				}
				if (DataGridListData(listData).dataField != null)
				{
					if (mwBO.BUY_OLD != null)
					{
						paintFields(mwBO.BUY, mwBO.BUY_OLD);
						mwBO.BUY_OLD=mwBO.BUY;
					}
				}
			}
		}


		private function paintFields(newValue:String, oldValue:String):void
		{
			var g:Graphics=graphics;
			var timer:Timer=new Timer(3000, 1);
			if (newValue > oldValue)
			{
				g.beginFill(0x94DE96);
				timer.addEventListener(TimerEvent.TIMER, clearFields);
				timer.start();
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
				g.endFill();
			}
			else if (newValue < oldValue)
			{
				g.beginFill(0xF1F586);
				timer.addEventListener(TimerEvent.TIMER, clearFields);
				timer.start();
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
				g.endFill();
			}
		}

		private function clearFields(evt:TimerEvent):void
		{
			var g:Graphics=graphics;
			g.clear();
		}

		override public function set data(value:Object):void
		{
			if (value && value.BUY)
			{
				super.data=value;
				mwBO=value as MarketWatchBO;
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
