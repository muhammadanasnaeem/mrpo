package businessobjects
{

	public class PriceLevelBO extends OrderBO
	{
		private var count:Number=0;

		public function get count_():Number
		{
			return count;
		}

		public function set count_(value:Number):void
		{
			count=value;
		}


		public function PriceLevelBO()
		{
			super();
		}
	}
}
