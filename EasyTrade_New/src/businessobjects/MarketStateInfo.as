package businessobjects
{

	[Bindable]
	public class MarketStateInfo extends ExchangeMarketID
	{
		public var startDateTime_:Date=new Date();
		public var state_:String="";
		public var name_:String="";
		public var description_:String="";
		public var isNullTime_:Boolean=false;

		//for display purposes only
		public var isCurrentState:Boolean=false;

		public function MarketStateInfo()
		{
			super();
		}
	}
}
