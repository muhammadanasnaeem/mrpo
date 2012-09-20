package components
{

	import businessobjects.ExchangeScheduleBO;
	import businessobjects.MarketStateInfo;

	import common.Constants;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;

	import flashx.textLayout.factory.TruncationOptions;

	import mx.collections.HierarchicalCollectionView;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.listClasses.AdvancedListBaseContentHolder;
	import mx.core.FlexShape;

	public class EZAdvancedDataGrid extends AdvancedDataGrid
	{
		public function EZAdvancedDataGrid()
		{
			super();
		}

		override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void
		{
			var marketStateInfo:MarketStateInfo=rowNumberToData(dataIndex) as MarketStateInfo;
			if (marketStateInfo)
			{
				if (marketStateInfo.isCurrentState)
				{
					color=0xABCCBA;
				}
			}

			super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
		}
	}
}
