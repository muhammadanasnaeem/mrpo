package businessobjects
{
	import mx.collections.ArrayList;

	public class MarketBO
	{
		private var INTERNAL_EXCHANGE_ID_:Number;
		private var EXCHANGE_ID_:Number;
		private var MARKET_ID_:Number;
		private var INTERNAL_MARKET_ID_:Number;
		private var USER_ID_:Number;
		private var ISVALID_:Boolean;
		private var MARKET_CODE_:String;
		private var MARKET_DESC_:String;
		private var ENTRY_DATETIME_:Date;
		private var STATE_:Number;
		private var symbols_:ArrayList=new ArrayList(); // SymbolBO

		//TODO: Temporary. Find a better place to put this list in.
		private var bonds_:ArrayList=new ArrayList(); // BondBO only for bonds screens

		public function get bonds():ArrayList
		{
			return bonds_;
		}

		public function set bonds(value:ArrayList):void
		{
			bonds_=value;
		}


		public function MarketBO()
		{
		}

		public function get EXCHANGE_ID():Number
		{
			return EXCHANGE_ID_;
		}

		public function set EXCHANGE_ID(value:Number):void
		{
			EXCHANGE_ID_=value;
		}

		public function get symbols():ArrayList
		{
			return symbols_;
		}

		public function set symbols(value:ArrayList):void
		{
			symbols_=value;
		}

		public function get INTERNAL_EXCHANGE_ID():Number
		{
			return INTERNAL_EXCHANGE_ID_;
		}

		public function set INTERNAL_EXCHANGE_ID(value:Number):void
		{
			INTERNAL_EXCHANGE_ID_=value;
		}

		public function get STATE():Number
		{
			return STATE_;
		}

		public function set STATE(value:Number):void
		{
			STATE_=value;
		}

		public function get ENTRY_DATETIME():Date
		{
			return ENTRY_DATETIME_;
		}

		public function set ENTRY_DATETIME(value:Date):void
		{
			ENTRY_DATETIME_=value;
		}

		public function get MARKET_DESC():String
		{
			return MARKET_DESC_;
		}

		public function set MARKET_DESC(value:String):void
		{
			MARKET_DESC_=value;
		}

		public function get MARKET_CODE():String
		{
			return MARKET_CODE_;
		}

		public function set MARKET_CODE(value:String):void
		{
			MARKET_CODE_=value;
		}

		public function get ISVALID():Boolean
		{
			return ISVALID_;
		}

		public function set ISVALID(value:Boolean):void
		{
			ISVALID_=value;
		}

		public function get USER_ID():Number
		{
			return USER_ID_;
		}

		public function set USER_ID(value:Number):void
		{
			USER_ID_=value;
		}

		public function get INTERNAL_MARKET_ID():Number
		{
			return INTERNAL_MARKET_ID_;
		}

		public function set INTERNAL_MARKET_ID(value:Number):void
		{
			INTERNAL_MARKET_ID_=value;
		}

		public function get MARKET_ID():Number
		{
			return MARKET_ID_;
		}

		public function set MARKET_ID(value:Number):void
		{
			MARKET_ID_=value;
		}

	}
}
