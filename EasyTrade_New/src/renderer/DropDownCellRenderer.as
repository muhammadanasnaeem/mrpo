package renderer
{
	import businessobjects.MarketWatchBO;

	import controller.ModelManager;
	import controller.WindowManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.*;
	import mx.core.BitmapAsset;
	import mx.styles.StyleManager;

	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

	public class DropDownCellRenderer extends Label
	{

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var oldTriangle:DisplayObject=getChildByName("ddArrow");
			if (oldTriangle != null)
			{
				removeChild(oldTriangle);
			}
			var triangleHeight:uint=6;
			var triangle:Shape=new Shape();
			triangle.name="ddArrow";
			var triangleStartXPosition:uint=this.width + triangleHeight / 2 - 12;
			var triangleStartYPosition:uint=this.height - 12;
			triangle.graphics.beginFill(0x555555);
			triangle.graphics.moveTo(triangleStartXPosition, triangleStartYPosition);
			triangle.graphics.lineTo(triangleStartXPosition + triangleHeight, triangleStartYPosition);
			triangle.graphics.lineTo(triangleStartXPosition + triangleHeight / 2, triangleStartYPosition + triangleHeight);
			triangle.graphics.lineTo(triangleStartXPosition, triangleStartYPosition);
			triangle.graphics.endFill();
			this.addChild(triangle);
		}
	}
}
