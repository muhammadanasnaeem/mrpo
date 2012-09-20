package businessobjects
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class ExchangeStatsBO extends ExchangeID
	{
		public var TOTAL_VOLUME:Number=0;
		public var ADVANCED:Number=0;
		public var DECLINED:Number=0;
		public var UNCHANGED:Number=0;
		public var TRADED:Number=0;
		public var SYMBOL_COUNT:Number=0;

		public var indexesDetails:ArrayCollection=new ArrayCollection(); // IndexDetailBO
		public var sectorsDetails:ArrayCollection=new ArrayCollection(); // SectorDetailBO

		public var advancedSymbols:ArrayCollection=new ArrayCollection(); // SymbolStatBO
		public var declinedSymbols:ArrayCollection=new ArrayCollection(); // SymbolStatBO
		public var unChangedSymbols:ArrayCollection=new ArrayCollection(); // SymbolStatBO
		public var advdecStats:ArrayCollection=new ArrayCollection(); // AdvDecStatsBO
	}
}
