package components.ticker
{
	import common.Constants;
	import mx.controls.Image;

	[Bindable]
	public class TickerItemData
	{
		[Embed(source='../../../images/u.png')]
		public static var IMG_UP:Class;
		[Embed(source='../../../images/d.png')]
		public static var IMG_DOWN:Class;
		[Embed(source='../../../images/nc.png')]
		public static var IMG_NO_CHANGE:Class;

		public var imgDirection:Image=new Image();
		public var textColor:uint=Constants.TICKER_COLOR_NO_CHANGE_INT;
		public var CODE:String="";
		public var isChanged:Boolean=false;
		public var value:Number=0;
		public var lastPrice:Number=0;
		public var lastVolume:Number=0;
		public var info:String="";
		public var guid:String="";
	}
}
