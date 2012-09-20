package model
{
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	import services.QWClient;

	public class BestMarketModel implements IModel
	{
		[Bindable]
		private var bestMarket_:ArrayCollection=new ArrayCollection([{SYMBOL: "PTV", BUY_VOLUME: "10000"}, {SYMBOL: "PTV", BUY_VOLUME: "20000"}]);

		[Bindable]
		public function get bestMarket():ArrayCollection
		{
			return bestMarket_;
		}

		public function set bestMarket(value:ArrayCollection):void
		{
			bestMarket_=value;
		}


		public function BestMarketModel()
		{
		}

		public function execute():void
		{
			var qwClient:QWClient=QWClient.getInstance();
			qwClient.getBestMarket(101, 1, 1);
		}

		public function onResult(event:ResultEvent):void
		{
		}
	}
}
