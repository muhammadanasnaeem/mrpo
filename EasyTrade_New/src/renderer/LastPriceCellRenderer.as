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

	public class LastPriceCellRenderer extends Label
	{
		private var isUpdate:Boolean=false;
		private var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
		private var mwBO:MarketWatchBO;

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
//				if (arr[listData.rowIndex].LAST != null)
//				{
//					this.text = moneyFormatter.format(arr[listData.rowIndex].LAST);
//				}
//				if (DataGridListData(listData).dataField != null && arr[listData.rowIndex].LAST_FEED_UPDATED)
//				{
//					paintFields(arr[listData.rowIndex].LAST, arr[listData.rowIndex].LAST_OLD);
//					arr[listData.rowIndex].LAST_OLD = arr[listData.rowIndex].LAST;
//					arr[listData.rowIndex].LAST_FEED_UPDATED = false;
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
				if (mwBO.LAST != null)
				{
					this.text=moneyFormatter.format(mwBO.LAST);
				}
				if (DataGridListData(listData).dataField != null && mwBO.LAST_FEED_UPDATED)
				{
					paintFields(mwBO.LAST, mwBO.LAST_OLD);
					mwBO.LAST_OLD=mwBO.LAST;
					mwBO.LAST_FEED_UPDATED=false;
				}
			}
		}


		private function paintFields(newValue:String, oldValue:String):void
		{
			var g:Graphics=graphics;
			var timer:Timer=new Timer(3000, 1);
			if (oldValue != null && newValue != null)
			{
				if (oldValue == newValue)
				{
					g.beginFill(0xFF3F3F);
					timer.addEventListener(TimerEvent.TIMER, clearFields);
					timer.start();
					g.drawRect(0, 0, unscaledWidth, unscaledHeight);
					g.endFill();
				}
				else if (newValue > oldValue)
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
		}

		private function clearFields(evt:TimerEvent):void
		{
			var g:Graphics=graphics;
			g.clear();
		}

		override public function set data(value:Object):void
		{
			if (value && value.LAST)
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
