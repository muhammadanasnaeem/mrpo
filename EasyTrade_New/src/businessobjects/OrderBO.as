package businessobjects
{

	[Bindable]
	public class OrderBO
	{
		public var TIF:Date;
		public var IS_SHORT:Boolean;
		public var SIDE:String="";
		public var REF_NO:String="";
		public var TRIGGER_PRICE:Number=-1;
		public var TRAILING_STOPLOSS_DIP:Number=-1;
		public var BUY_ORDER_COLOR:uint=0x0c70a2;
		public var SELL_ORDER_COLOR:uint=0xbe3267;

		public var TYPE:String="normal";
		public var PRICE_TYPE:String="";

		public var ENTRY_DATETIME:Date;
		public var PRICE:Number=-1;
		public var PREVIOUS_PRICE:Number=-1;
		public var VOLUME:Number=-1;
		public var PREVIOUS_VOLUME:Number=-1;

		public var DISCLOSED_VOLUME:Number=0;

		public var USER_ID:Number=-1;

		public var SENDER_USER_ID:Number=-1;
		public var CLIENT_ID:Number=-1;
		public var ORDER_NO:Number=0;

		//from business_objects.Order
		public var EXCHANGE_ID:Number=-1;
		public var MARKET_ID:Number=-1;
		public var SYMBOL_ID:Number=-1;

		public var INTERNAL_EXCHANGE_ID:Number=-1;
		public var INTERNAL_MARKET_ID:Number=-1;
		public var INTERNAL_SYMBOL_ID:Number=-1;

		public var EXCHANGE_CODE:String="";
		public var MARKET_CODE:String="";
		//only used for oder submission from client end where symbol id is unknown
		public var SYMBOL:String="";

		public var PUBLIC_ORDER_STATE:String="";
		public var PRIVATE_ORDER_STATE:String="";

		public var CLIENT_CODE:String="";
		public var BROKER_ID:Number=-1;

		//Targetted trade:
		public var COUNTER_CLIENT_CODE:String="";
		public var COUNTER_BROKER_ID:Number=-1;
		public var COUNTER_USER_ID:Number=-1;
		public var COUNTER_CLIENT_ID:Number=-1;
		public var NEGOTIATED_ORDER_STATE:String="";
		public var COUNTER_USER_NAME:String="";
		public var COUNTER_ORDER_NO:Number=-1;
		public var IS_NEGOTIATED:Boolean;
		public var ORDER_CONDITION:String="NONE";

		//only used at view
		public var REMAINING:Number=0;

		public var SELECTED:Boolean=false;
		public var IS_ORDER_NO_SWAPPED:Boolean=false;

		public function OrderBO()
		{
		}
	}
}
