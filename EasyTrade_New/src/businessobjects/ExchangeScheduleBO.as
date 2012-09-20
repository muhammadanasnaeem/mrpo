package businessobjects
{
	import mx.collections.ArrayCollection;

	public class ExchangeScheduleBO
	{
		private var INTERNAL_EXCHANGE_ID_:Number;

		public function get INTERNAL_EXCHANGE_ID():Number
		{
			return INTERNAL_EXCHANGE_ID_;
		}

		public function set INTERNAL_EXCHANGE_ID(value:Number):void
		{
			INTERNAL_EXCHANGE_ID_=value;
		}

		private var EXCHANGE_ID_:Number;

		public function get EXCHANGE_ID():Number
		{
			return EXCHANGE_ID_;
		}

		public function set EXCHANGE_ID(value:Number):void
		{
			EXCHANGE_ID_=value;
		}

		private var CODE_:String="";

		[Bindable]
		public function get CODE():String
		{
			return CODE_;
		}

		public function set CODE(value:String):void
		{
			CODE_=value;
		}

		private var SCHEDULE_:ArrayCollection=new ArrayCollection(); // of MarketScheduleBO

		[Bindable]
		public function get SCHEDULE():ArrayCollection
		{
			return SCHEDULE_;
		}

		public function set SCHEDULE(value:ArrayCollection):void
		{
			SCHEDULE_=value;
		}

		public function ExchangeScheduleBO()
		{
		}

	/*public function getMarketSchedule(internalMarketID:Number):MarketScheduleBO
	{
		var marketScheduleBO:MarketScheduleBO;
		var i:int = 0;
		for (i; i < SCHEDULE.length; ++i)
		{
			if ((SCHEDULE.getItemAt(i) as MarketScheduleBO).INTERNAL_MARKET_ID == internalMarketID)
			{
				marketScheduleBO = SCHEDULE.getItemAt(i) as MarketScheduleBO;
				break;
			}
		}
		return marketScheduleBO;
	}

	public function setMarketSchedule(internalMarketID:Number, marketScheduleBO:MarketScheduleBO):void
	{
		var i:int = 0;
		for (i; i < SCHEDULE.length; ++i)
		{
			if ((SCHEDULE.getItemAt(i) as MarketScheduleBO).INTERNAL_MARKET_ID == internalMarketID)
			{
				SCHEDULE.setItemAt(marketScheduleBO, i);
				break;
			}
		}
	}*/
	}
}
