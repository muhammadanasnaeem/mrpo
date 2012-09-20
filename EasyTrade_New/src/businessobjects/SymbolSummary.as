package businessobjects
{

	[Bindable]
	public class SymbolSummary
	{

		/*Bond Specific fields begin*/
		public var IRR:String;
		public var AIRR:String;
		public var BASE_RATE:String;
		public var SPREAD_RATE:String;
		public var COUPON_RATE:String;
		public var DISCOUNT_RATE:String;

		public var ISSUE_DATE:String;
		public var NEXT_COUPON:String;
		public var MATURITY_DATE:String;
		/*Bond Specific fields end*/


		public var exchangeID:Number=-1;
		public var internalExchangeID:Number=-1;
		public var marketID:Number=-1;
		public var internalMarketID:Number=-1;
		public var symbolID:Number=-1;
		public var sid:String="-1";
		public var EXCHANGE:String;
		public var MARKET:String;
		public var SYMBOL:String;
		public var STATE:String;
		public var STATUS:String;
		public var FLAGS:String;
		public var BUY:String;
		public var BUY_OLD:String;
		public var BUY_VOLUME:String;
		public var BUY_VOLUME_OLD:String;
		public var SELL:String;
		public var SELL_OLD:String;
		public var SELL_VOLUME:String;
		public var SELL_VOLUME_OLD:String;
		public var LAST:String;
		public var LAST_FEED_UPDATED:Boolean=false;
		public var LAST_OLD:String;
		public var LAST_VOLUME:String;
		public var CLOSE:String;
		public var LAST_DAY_CLOSE_PRICE:String;
		public var TURN_OVER:String;
		public var TRADES:String;
		public var OPEN:String;
		public var AVERAGE:String;
		public var HIGH:String;
		public var LOW:String;
		public var CHANGE:String;
		public var PERCENT_CHANGE:String;
		public var PERCENT_BADLA:String;

		public var TOTAL_SIZE_TRADED:String;
		public var VALUE:String;
		public var PERCENTAGE_VALUE:String;

		public var PERCENTAGE_VOLUME:String;

		public var bondAskYield:String;
		public var bondBidYield:String;

		public var BOARD_LOT:String;
		public var UPPER_ORDER_VOLUME_LIMIT:String;
		public var LOWER_ORDER_VOLUME_LIMIT:String;
		public var TICK_SIZE:String;
		public var UPPER_CIRCUIT_BREAKER_LIMIT:String;
		public var LOWER_CIRCUIT_BREAKER_LIMIT:String;
		public var UPPER_ALERT_LIMIT:String;
		public var LOWER_ALERT_LIMIT:String;
		public var UPPER_ORDER_VALUE_LIMIT:String;
		public var LOWER_ORDER_VALUE_LIMIT:String;
		public var FIFTY_TWO_WEEK_HIGH:String;
		public var FIFTY_TWO_WEEK_LOW:String;
		public var EPS:String;
		public var PE_RATIO:String;
		public var SECTOR:String;

		public var ISPOSTED:Boolean;
		
		//Added By Anas
		public var TOTAL_VOLUME:String;

		public var isSummary:Boolean=false;

		public function SymbolSummary()
		{
		}

		public function init():void
		{
			/*Bond Specific fields begin*/
			IRR="";
			AIRR="";
			BASE_RATE="";
			SPREAD_RATE="";
			COUPON_RATE="";
			DISCOUNT_RATE="";

			NEXT_COUPON="";
			MATURITY_DATE="";
			/*Bond Specific fields end*/


//			 exchangeID:Number = -1;
//			 internalExchangeID:Number = -1;
//			 marketID:Number = -1;
//			 internalMarketID:Number = -1;
//			 symbolID:Number = -1;
			sid="";
			EXCHANGE="";
			MARKET="";
			SYMBOL="";
			STATE="";
			STATUS="";
			FLAGS="";
			BUY="";
			BUY_OLD="";
			BUY_VOLUME="";
			BUY_VOLUME_OLD="";
			SELL="";
			SELL_OLD="";
			SELL_VOLUME="";
			SELL_VOLUME_OLD="";
			LAST="";
			// LAST_FEED_UPDATED:Boolean = false;
			LAST_OLD="";
			LAST_VOLUME="";
			CLOSE="";
			LAST_DAY_CLOSE_PRICE="";
			TURN_OVER="";
			TRADES="";
			OPEN="";
			AVERAGE="";
			HIGH="";
			LOW="";
			CHANGE="";
			PERCENT_CHANGE="";
			PERCENT_BADLA="";

			bondAskYield="";
			bondBidYield="";

			BOARD_LOT="";
			UPPER_ORDER_VOLUME_LIMIT="";
			LOWER_ORDER_VOLUME_LIMIT="";
			TICK_SIZE="";
			UPPER_CIRCUIT_BREAKER_LIMIT="";
			LOWER_CIRCUIT_BREAKER_LIMIT="";
			UPPER_ALERT_LIMIT="";
			LOWER_ALERT_LIMIT="";
			UPPER_ORDER_VALUE_LIMIT="";
			LOWER_ORDER_VALUE_LIMIT="";
			FIFTY_TWO_WEEK_HIGH="";
			FIFTY_TWO_WEEK_LOW="";
			EPS="";
			PE_RATIO="";
			SECTOR="";
			TOTAL_SIZE_TRADED="";
			VALUE="";
			TOTAL_VOLUME="";
			PERCENTAGE_VALUE="";
		}
	}
}
