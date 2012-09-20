package businessobjects
{
	import mx.collections.ArrayCollection;

	public class RiskInformationBO
	{
		public var clientCode:String;
		public var bypassRisk:Boolean;
		public var active:Boolean;
		public var allowShortSell:Boolean;
		public var useOpenPosition:Boolean;
		public var cash:Number;
		public var buyingPower:Number;
		public var remainingBuyingPower:Number;
		public var margin:Number;
		public var shareValue:Number;
		public var openPosition:Number;
		public var profitLoss:Number;
		public var holdings:ArrayCollection;
		public function RiskInformationBO()
		{
		}
	}
}