package businessobjects
{

	public class ExchangeMarketSymbolID
	{
		private var exchangeID_:ExchangeID=new ExchangeID();

		public function get exchangeID():ExchangeID
		{
			return exchangeID_;
		}

		public function set exchangeID(value:ExchangeID):void
		{
			exchangeID_=value;
		}
		/////////////////////////////////

		private var marketID_:MarketID=new MarketID();

		public function get marketID():MarketID
		{
			return marketID_;
		}

		public function set marketID(value:MarketID):void
		{
			marketID_=value;
		}
		/////////////////////////////////

		private var symbolID_:SymbolID=new SymbolID();

		public function get symbolID():SymbolID
		{
			return symbolID_;
		}

		public function set symbolID(value:SymbolID):void
		{
			symbolID_=value;
		}

		/////////////////////////////////

		public function ExchangeMarketSymbolID()
		{
		}
	}
}
