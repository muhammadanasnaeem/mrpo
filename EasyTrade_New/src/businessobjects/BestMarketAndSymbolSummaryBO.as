package businessobjects
{

	public class BestMarketAndSymbolSummaryBO
	{
		private var exchangeId_:Number=-1;
		private var marketId_:Number=-1;
		private var symbolName_:String="";
		private var symbolID_:Number=-1;

		private var symbolSummary_:SymbolSummaryBO=new SymbolSummaryBO();
		private var bestMarket_:BestMarketBO=new BestMarketBO();

		public function BestMarketAndSymbolSummaryBO()
		{
		}

		public function get bestMarket():BestMarketBO
		{
			return bestMarket_;
		}

		public function set bestMarket(value:BestMarketBO):void
		{
			bestMarket_=value;
		}

		public function get symbolSummary():SymbolSummaryBO
		{
			return symbolSummary_;
		}

		public function set symbolSummary(value:SymbolSummaryBO):void
		{
			symbolSummary_=value;
		}

		public function get symbolName():String
		{
			return symbolName_;
		}

		public function set symbolName(value:String):void
		{
			symbolName_=value;
		}

		public function get marketId():Number
		{
			return marketId_;
		}

		public function set marketId(value:Number):void
		{
			marketId_=value;
		}

		public function get exchangeId():Number
		{
			return exchangeId_;
		}

		public function set exchangeId(value:Number):void
		{
			exchangeId_=value;
		}

		public function get symbolID():Number
		{
			return symbolID_;
		}

		public function set symbolID(value:Number):void
		{
			symbolID_=value;
		}


	}
}
