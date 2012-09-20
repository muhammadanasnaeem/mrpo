package components
{

	import businessobjects.OrderBO;

	import common.Constants;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;

	import mx.collections.ListCollectionView;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.FlexShape;

	public class EZDataGrid extends DataGrid
	{
		public var collectioView:ListCollectionView;
		private var index:int;

		public function EZDataGrid()
		{
			super();
		}

		override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void
		{
			index=dataIndex;
			var contentHolder:ListBaseContentHolder=ListBaseContentHolder(s.parent);
			var background:Shape;
			if (rowIndex < s.numChildren)
			{
				background=Shape(s.getChildAt(rowIndex));
			}
			else
			{
				background=new FlexShape();
				background.name="background";
				s.addChild(background);
			}
			background.y=y;

			var height:Number=Math.min(height, contentHolder.height - y);

			var g:Graphics=background.graphics;
			g.clear();

			var color2:uint;
			if (dataIndex < this.dataProvider.length)
			{
				data;
				if (this.dataProvider.getItemAt(dataIndex).SIDE == "buy")
				{
//					color2 = Constants.BUY_COLOR_INT;
//					this.setStyle("color" , color2);
				}
				else if (this.dataProvider.getItemAt(dataIndex).SIDE == "sell")
				{
//					color2 = Constants.SELL_COLOR_INT;
//					this.dataProvider.setStyle("color" ,color2);
				}
			}
			g.beginFill(color, getStyle("color"));
			g.drawRect(0, 0, contentHolder.width, height);
			g.endFill();
		}

		public function drawArrows():void
		{
			placeSortArrow();
		}

	/**
	 * override the setting of the dataprovider so we can get a
	 * local listcollection set up
	 **/
//		override public function get dataProvider():Object
//		{
//			return super.dataProvider;
//		}
//		override public function set dataProvider(value:Object):void
//		{
//			super.dataProvider = value;
//			collectioView = ListCollectionView(value);
//			
//		}

	}
}
