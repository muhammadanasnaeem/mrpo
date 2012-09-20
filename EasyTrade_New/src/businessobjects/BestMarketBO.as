package businessobjects
{

	public class BestMarketBO
	{
		private var symbolBO_:SymbolBO=new SymbolBO();
		private var buyOrderBO_:OrderBO=new OrderBO();
		private var sellOrderBO_:OrderBO=new OrderBO();

		public function BestMarketBO()
		{
		}

		public function get sellOrderBO():OrderBO
		{
			return sellOrderBO_;
		}

		public function set sellOrderBO(value:OrderBO):void
		{
			sellOrderBO_=value;
		}

		public function get buyOrderBO():OrderBO
		{
			return buyOrderBO_;
		}

		public function set buyOrderBO(value:OrderBO):void
		{
			buyOrderBO_=value;
		}

		public function get symbolBO():SymbolBO
		{
			return symbolBO_;
		}

		public function set symbolBO(value:SymbolBO):void
		{
			symbolBO_=value;
		}
	}
}
