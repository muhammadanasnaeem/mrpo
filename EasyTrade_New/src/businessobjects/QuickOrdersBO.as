package businessobjects

{ //added 31/1/2012 by anas
	[Bindable]
	public class QuickOrdersBO
	{
		private var exchangeID_:Number=-1;
		private var internalExchangeID_:Number=-1;
		private var marketID_:Number=-1;
		private var internalMarketID_:Number=-1;
		private var symbolID_:Number=-1;
		public var sid:String="-1";
		private var SYMBOL_:String;
		private var EXCHANGE_:String;
		private var MARKET_:String;
		private var BUY_VOLUME_:String;
		private var BUY_:String;
		private var SELL_:String;
		private var SELL_VOLUME_:String;
		private var HIGH_:String;
		private var LOW_:String;
		private var CHANGE_:String;
		private var ACCOUNT_NUMBER_:String;
		private var segmentNumber_:int;
		private var dropDownLimit_:int;

		public function QuickOrdersBO()
		{
		}

		public function init():void
		{
			BUY_VOLUME_=null;
			BUY_=null;
			SELL_=null;
			SELL_VOLUME_=null;
			HIGH_=null;
			LOW_=null;
			CHANGE_=null;
		}

		public function get symbolID():Number
		{
			return symbolID_;
		}

		public function set symbolID(value:Number):void
		{
			symbolID_=value;
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

		public function get ACCOUNT_NUMBER():String
		{
			return ACCOUNT_NUMBER_;
		}

		public function set ACCOUNT_NUMBER(value:String):void
		{
			ACCOUNT_NUMBER_=value;
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

		public function get MARKET():String
		{
			return MARKET_;
		}

		public function set MARKET(value:String):void
		{
			MARKET_=value;
		}

		public function get segmentNumber():int
		{
			return segmentNumber_;
		}

		public function set segmentNumber(value:int):void
		{
			segmentNumber_=value;
		}

		public function get dropDownLimit():int
		{
			return dropDownLimit_;
		}

		public function set dropDownLimit(value:int):void
		{
			dropDownLimit_=value;
		}
	}
}
