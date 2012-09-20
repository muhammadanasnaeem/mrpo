package businessobjects
{
	import components.ComboBoxContent;
	
	import controller.ModelManager;

	[Bindable]
	public class MarketWatchBO
	{
		private var exchangeID_:Number=-1;
		private var internalExchangeID_:Number=-1;
		private var marketID_:Number=-1;
		private var internalMarketID_:Number=-1;
		private var symbolID_:Number=-1;
		public var sid:String="-1";
		private var EXCHANGE_:String;
		private var MARKET_:String;
		private var SYMBOL_:String;
		private var STATE_:String;
		private var FLAGS_:String;
		private var BUY_:String;
		private var BUY_OLD_:String;
		private var BUY_VOLUME_:String;
		private var BUY_VOLUME_OLD_:String;
		private var SELL_:String;
		private var SELL_OLD_:String;
		private var SELL_VOLUME_:String;
		private var SELL_VOLUME_OLD_:String;
		private var LAST_:String;
		private var LAST_FEED_UPDATED_:Boolean=false;
		private var LAST_OLD_:String;
		private var LAST_VOLUME_:String;
		private var TURN_OVER_:String;
		private var TRADES_:String;
		private var OPEN_:String;
		private var AVERAGE_:String;
		private var HIGH_:String;
		private var LOW_:String;
		private var CHANGE_:String;
		private var PERCENT_CHANGE_:String;
		private var PERCENT_BADLA_:String;
		public var SECTOR:String;
		public var CLOSE:String;
		public var LAST_DAY_CLOSE_PRICE_:String;
		public var DAYS_TO_MATURITY_:String;
		/*Bond Specific fields begin*/
		public var IRR:String;
		public var AIRR:String;
		public var BASE_RATE:String;
		public var SPREAD_RATE:String;
		public var COUPON_RATE:String;
		public var DISCOUNT_RATE:String;

		public var NEXT_COUPON:String;
		public var MATURITY_DATE:String;
		/*Bond Specific fields end*/

		//used for profile load/save methods
		private var pageNumber_:Number;
		private var rowNumber_:Number;

		//
		
		public function get LAST_FEED_UPDATED():Boolean
		{
			return LAST_FEED_UPDATED_;
		}

		public function set LAST_FEED_UPDATED(value:Boolean):void
		{
			LAST_FEED_UPDATED_=value;
		}

		public function get BUY_OLD():String
		{
			return BUY_OLD_;
		}

		public function set BUY_OLD(value:String):void
		{
			BUY_OLD_=value;
		}

		public function get BUY_VOLUME_OLD():String
		{
			return BUY_VOLUME_OLD_;
		}

		public function set BUY_VOLUME_OLD(value:String):void
		{
			BUY_VOLUME_OLD_=value;
		}

		public function get SELL_OLD():String
		{
			return SELL_OLD_;
		}

		public function set SELL_OLD(value:String):void
		{
			SELL_OLD_=value;
		}

		public function get SELL_VOLUME_OLD():String
		{
			return SELL_VOLUME_OLD_;
		}

		public function set SELL_VOLUME_OLD(value:String):void
		{
			SELL_VOLUME_OLD_=value;
		}

		public function get LAST_OLD():String
		{
			return LAST_OLD_;
		}

		public function set LAST_OLD(value:String):void
		{
			LAST_OLD_=value;
		}

		public function get EXCHANGE():String
		{
			return EXCHANGE_;
		}

		public function set EXCHANGE(value:String):void
		{
			EXCHANGE_=value;
		}

		public function get exchangeID():Number
		{
			return exchangeID_;
		}

		public function set exchangeID(value:Number):void
		{
			exchangeID_=value;
		}

		public function get internalExchangeID():Number
		{
			return internalExchangeID_;
		}

		public function set internalExchangeID(value:Number):void
		{
			internalExchangeID_=value;
		}

		public function init():void
		{
			STATE_=null;
			FLAGS_=null;
			BUY_VOLUME_=null;
			BUY_=null;
			SELL_=null;
			SELL_VOLUME_=null;
			LAST_=null;
			LAST_VOLUME_=null;
			TURN_OVER_=null;
			TRADES_=null;
			OPEN_=null;
			AVERAGE_=null;
			HIGH_=null;
			LOW_=null;
			CHANGE_=null;
			PERCENT_CHANGE_=null;
			PERCENT_BADLA_=null;
			CLOSE=null;
			LAST_DAY_CLOSE_PRICE=null;
			DAYS_TO_MATURITY=null;
			// added on 27/1/2011
			IRR=null;
			AIRR=null;
			BASE_RATE=null;
			SPREAD_RATE=null;
			COUPON_RATE=null;
			DISCOUNT_RATE=null;
			NEXT_COUPON=null;
			MATURITY_DATE=null;
			SECTOR=null;
		}

		public function MarketWatchBO()
		{
		}

		public function get symbolID():Number
		{
			return symbolID_;
		}

		public function set symbolID(value:Number):void
		{
			symbolID_=value;
		}

		public function get marketID():Number
		{
			return marketID_;
		}

		public function set marketID(value:Number):void
		{
			marketID_=value;
		}

		public function get internalMarketID():Number
		{
			return internalMarketID_;
		}

		public function set internalMarketID(value:Number):void
		{
			internalMarketID_=value;
		}

		public function get pageNumber():Number
		{
			return pageNumber_;
		}

		public function set pageNumber(value:Number):void
		{
			pageNumber_=value;
		}

		public function get PERCENT_BADLA():String
		{
			return PERCENT_BADLA_;
		}

		public function set PERCENT_BADLA(value:String):void
		{
			PERCENT_BADLA_=value;
		}

		public function get PERCENT_CHANGE():String
		{
			return PERCENT_CHANGE_;
		}

		public function set PERCENT_CHANGE(value:String):void
		{
			PERCENT_CHANGE_=value;
		}

		public function get CHANGE():String
		{
			return CHANGE_;
		}

		public function set CHANGE(value:String):void
		{
			CHANGE_=value;
		}

		public function get LOW():String
		{
			return LOW_;
		}

		public function set LOW(value:String):void
		{
			LOW_=value;
		}

		public function get HIGH():String
		{
			return HIGH_;
		}

		public function set HIGH(value:String):void
		{
			HIGH_=value;
		}

		public function get AVERAGE():String
		{
			return AVERAGE_;
		}

		public function set AVERAGE(value:String):void
		{
			AVERAGE_=value;
		}

		public function get OPEN():String
		{
			return OPEN_;
		}

		public function set OPEN(value:String):void
		{
			OPEN_=value;
		}

		public function get TRADES():String
		{
			return TRADES_;
		}

		public function set TRADES(value:String):void
		{
			TRADES_=value;
		}

		public function get TURN_OVER():String
		{
			return TURN_OVER_;
		}

		public function set TURN_OVER(value:String):void
		{
			TURN_OVER_=value;
		}

		public function get LAST_VOLUME():String
		{
			return LAST_VOLUME_;
		}

		public function set LAST_VOLUME(value:String):void
		{
			LAST_VOLUME_=value;
		}

		public function get LAST():String
		{
			return LAST_;
		}

		public function set LAST(value:String):void
		{
			LAST_=value;
		}

		public function get SELL_VOLUME():String
		{
			return SELL_VOLUME_;
		}

		public function set SELL_VOLUME(value:String):void
		{
			SELL_VOLUME_=value;
		}

		public function get SELL():String
		{
			return SELL_;
		}

		public function set SELL(value:String):void
		{
			SELL_=value;
		}

		public function get BUY():String
		{
			return BUY_;
		}

		public function set BUY(value:String):void
		{
			BUY_=value;
		}

		public function get FLAGS():String
		{
			return FLAGS_;
		}

		public function set FLAGS(value:String):void
		{
			FLAGS_=value;
		}

		public function get STATE():String
		{
			return STATE_;
		}

		public function set STATE(value:String):void
		{
			STATE_=value;
		}

		public function get MARKET():String
		{
			return MARKET_;
		}

		public function set MARKET(value:String):void
		{
			MARKET_=value;
		}

		public function get BUY_VOLUME():String
		{
			return BUY_VOLUME_;
		}

		public function set BUY_VOLUME(value:String):void
		{
			BUY_VOLUME_=value;
		}

		public function get SYMBOL():String
		{
			return SYMBOL_;
		}

		public function set SYMBOL(value:String):void
		{
			SYMBOL_=value;
		}

		public function get rowNumber():Number
		{
			return rowNumber_;
		}

		public function set rowNumber(value:Number):void
		{
			rowNumber_=value;
		}
		
		public function set LAST_DAY_CLOSE_PRICE(value:String):void
		{
			LAST_DAY_CLOSE_PRICE_ = value;
		}
		
		public function get LAST_DAY_CLOSE_PRICE():String
		{
			return LAST_DAY_CLOSE_PRICE_;
		}
		
		public function get DAYS_TO_MATURITY():String
		{
			return DAYS_TO_MATURITY_;
		}
		
		public function set DAYS_TO_MATURITY(value:String):void
		{
			DAYS_TO_MATURITY_=value;
		}
	}
}
