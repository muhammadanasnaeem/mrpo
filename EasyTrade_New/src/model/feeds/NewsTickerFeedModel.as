package model.feeds
{
	import common.Constants;

	import components.ticker.TickerItemData;

	public class NewsTickerFeedModel
	{
		private var feed_:Array=new Array();

		public function NewsTickerFeedModel()
		{
//			addFeedItem("CAL-ALLOCATION OF SHARES TO KURA AFRICA FUND-ADDITIONAL INFORMATION  .", "0");
//			addFeedItem("SG-SSB-UN-AUDITED RESULTS FOR THE THIRD QUARTER ENDING-SEPTEMBER 2010.", "1");
//			addFeedItem("BOPP-RESIGNATION OF A DIRECTOR                                       .", "2");
//			addFeedItem("UNIL-UPDATE ON PROPOSED TRANSACTION-WILMAR AFRICA LIMITED            .", "3");
//			addFeedItem("HFC-UN-AUDITED RESULTS FOR THE THIRD QUARTER ENDED-SEPTEMBER 2010    .", "4");
//			addFeedItem("SMS, E-MAIL NOTIFICATION AND ONLINE SERVICES                         .", "5");
		}

		public function get feed():Array
		{
			return feed_;
		}

		public function set feed(value:Array):void
		{
			feed_=value;
		}

		public function addFeedItem(info:String, guid:String):void
		{
			var hasItem:Boolean=false;
			var tickerItemData:TickerItemData=new TickerItemData();

			tickerItemData.info=info;
			tickerItemData.guid=guid;

			for each (var tid:TickerItemData in feed)
			{
				if (tid.guid == tickerItemData.guid)
				{
					hasItem=true;
					break;
				}
			}

			if (!hasItem)
			{
				feed.push(tickerItemData);
			}
		}
	}
}
