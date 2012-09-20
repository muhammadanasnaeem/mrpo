package businessobjects
{

	public class UserTradeBO
	{
		public var USER_ID:Number;
		public var USER:String;
		public var CLIENT_ID:Number;
		public var CLIENT_CODE:String;
		public var ORDER_ID:Number;

		public var PRICE:Number;
		public var VOLUME:Number;

		public var ENTRY_DATETIME:Date;

		public var TICKET_ID:Number;

		public var EXCHANGE_ID:Number=-1;
		public var MARKET_ID:Number=-1;
		public var SYMBOL_ID:Number=-1;

		public var INTERNAL_EXCHANGE_ID:Number=-1;
		public var INTERNAL_MARKET_ID:Number=-1;
		public var INTERNAL_SYMBOL_ID:Number=-1;

		public var EXCHANGE_CODE:String="";
		public var MARKET_CODE:String="";
		public var SYMBOL_CODE:String="";

		public var SIDE:String="";

		public var summary:Boolean=false;
		public var mainSummary:Boolean=false;
		public var buyPriceTotal:Number;
		public var buyValueTotal:Number;
		public var sellPriceTotal:Number;
		public var sellValueTotal:Number;
		public var buyPriceGrandTotal:Number;
		public var buyValueGrandTotal:Number;
		public var sellPriceGrandTotal:Number;
		public var sellValueGrandTotal:Number;
		public var totalTxt:String;

		public var subTotalNum:int=0;
		public var grandTotalNum:int=0;

		public var trade_type_:String="normal";

		public var IS_NEGOTIATED:Boolean;

		public function UserTradeBO()
		{
		}
	}
}
