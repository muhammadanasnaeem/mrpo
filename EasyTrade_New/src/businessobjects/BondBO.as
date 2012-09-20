package businessobjects
{

	[Bindable]
	public class BondBO extends SymbolBO
	{
		public var IRR:Number;
		public var AIRR:Number;
		public var baseRate:Number;
		public var spreadRate:Number;
		public var couponRate:Number;
		public var discountRate:Number;

		public var nextCouponDate:Date;
		public var issueDate:Date;
		public var maturityDate:Date;
		//days to maturity field added by Anas 15/03/2012 .
		public var daysToMaturity:int;
		public var bondType:String="";
	}
}
