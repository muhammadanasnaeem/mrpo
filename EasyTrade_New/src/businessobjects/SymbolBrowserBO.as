package businessobjects
{

	public class SymbolBrowserBO
	{
		public var symbolID:Number=-1;
		public var INTERNAL_SYMBOL_ID:Number=-1;

		public var company:String="";
		public var sector:String="";
		public var clearingType:String="";

		public var tickSize:Number=0;
		public var fiftyTwoWeekHigh:Number=0;
		public var fiftyTwoWeekLow:Number=0;
		public var earningPerShare:Number=0;
		public var priceEarningRatio:Number=0;
		public var lotSize:Number=0;
		public var upperVolumeLimit:Number=0;
		public var lowerVolumeLimit:Number=0;
		public var upperValueLimit:Number=0;
		public var lowerValueLimit:Number=0;

		public var orderWindowUp:Number=0;
		public var orderWindowDown:Number=0;
		public var circuitBreakerUp:Number=0;
		public var circuitBreakerDown:Number=0;
		public var spotPriceUp:Number=0;
		public var spotPriceDown:Number=0;

		public var spotScheduleStart:Date;
		public var spotScheduleEnd:Date;

		/*Required for client only*/
		public var INTERNAL_EXCHANGE_ID:Number=-1;
		public var INTERNAL_MARKET_ID:Number=-1;

		public var EXCHANGE_CODE:String="";
		public var MARKET_CODE:String="";
		public var SYMBOL_CODE:String="";
		/*Required for client only*/

		public var STATE:String;
		public var isSpot:String;

		public function SymbolBrowserBO()
		{
		}
	}
}
