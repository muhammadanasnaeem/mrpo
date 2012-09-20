package businessobjects
{

	public class EventLogBO
	{
		//Common properties for OrderBO and UserTradeBO

		public var EXCHANGE_ID:Number=-1;
		public var MARKET_ID:Number=-1;
		public var SYMBOL_ID:Number=-1;

		public var INTERNAL_EXCHANGE_ID:Number=-1;
		public var INTERNAL_MARKET_ID:Number=-1;
		public var INTERNAL_SYMBOL_ID:Number=-1;

		public var EXCHANGE_CODE:String="";
		public var MARKET_CODE:String="";
		public var SYMBOL:String="";

		public var USER_ID:Number=-1;
		public var CLIENT_ID:Number=-1;
		public var CLIENT_CODE:String="";
		public var ORDER_NO:Number=-1;

		public var PRICE:Number=0;
		public var VOLUME:String="";
		public var ENTRY_DATETIME:Date;
		public var IS_NEGOTIATED:Boolean;
		//Properties for UserTradeBO

		public var TICKET_ID:String="";

		//Properties for OrderBO

		public var DISCLOSED_VOLUME:String="";
		public var SIDE:String="";
		public var TIF:Date;
		public var TRIGGER_PRICE:Number=-1;
		public var REMAINING:String="";
		public var PUBLIC_ORDER_STATE:String="";
		public var REMAINING_VOL:String="";
		
		public var FILLED_VOL:Number=0;
		public var ORDER_TYPE:String;
		public function EventLogBO()
		{
		}
	}
}
