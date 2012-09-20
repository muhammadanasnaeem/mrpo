package renderer
{
	import businessobjects.MarketWatchBO;

	import components.EZNumberFormatter;

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

	public class BuyVolumeCellRenderer extends Label
	{
		private var isUpdate:Boolean=false;
		private var mwBO:MarketWatchBO;
		private var numberFormatter:EZNumberFormatter=new EZNumberFormatter();

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
//				if (arr[listData.rowIndex].BUY_VOLUME != null)
//				{
//					this.text = numberFormatter.format(arr[listData.rowIndex].BUY_VOLUME);
//				}
//				if (DataGridListData(listData).dataField != null)
//				{
//					if (arr[listData.rowIndex].BUY_VOLUME_OLD != null)
//					{
//						paintFields(arr[listData.rowIndex].BUY_VOLUME, arr[listData.rowIndex].BUY_VOLUME_OLD);
//						arr[listData.rowIndex].BUY_VOLUME_OLD = arr[listData.rowIndex].BUY_VOLUME; 
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
				if (mwBO.BUY_VOLUME != null)
				{
					this.text=numberFormatter.format(mwBO.BUY_VOLUME);
				}
				if (DataGridListData(listData).dataField != null)
				{
					if (mwBO.BUY_VOLUME_OLD != null)
					{
						paintFields(mwBO.BUY_VOLUME, mwBO.BUY_VOLUME_OLD);
						mwBO.BUY_VOLUME_OLD=mwBO.BUY_VOLUME;
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
			if (value && value.BUY_VOLUME)
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
