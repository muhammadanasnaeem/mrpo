package model
{
	import businessobjects.SymbolStatBO;
	import businessobjects.SymbolSummaryBO;
	
	import common.Messages;
	
	import components.ComboBoxItem;
	
	import controller.ModelManager;
	import controller.WindowManager;
	
	import filters.Filters;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.QWClient;

	public class SymbolSummaryModel implements IModel
	{
		/////////////////////////////////////////////////////////
		private var isDirty_:Boolean=true;

		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}
		/////////////////////////////////////////////////////////

		private var symbols_:ArrayCollection=new ArrayCollection(); // of SymbolSummaryBOs
		[Bindable]
		public function get symbols():ArrayCollection
		{
			return symbols_;
		}

		public function set symbols(value:ArrayCollection):void
		{
			symbols_=value;
		}
		/////////////////////////////////////////////////////////

		public var isSymbolSummaryUpdate:Boolean=true;
		public var exchangeID:Number;
		public var marketID:Number;
		public var symbol:String;

		/////////////////////////////////////////////////////////
		public function SymbolSummaryModel()
		{
			symbols_.filterFunction=Filters.symbolSummaryFilter;
		}

		/////////////////////////////////////////////////////////

		public function execute():void
		{
			CursorManager.setBusyCursor();
			QWClient.getInstance().getSymbolSummary(WindowManager.getInstance().viewManager.symbolSummary.internalExchangeID, WindowManager.getInstance().viewManager.symbolSummary.internalMarketID, WindowManager.getInstance().viewManager.symbolSummary.internalSymbolID);
		}

		/////////////////////////////////////////////////////////

		public function onResult(event:ResultEvent):void
		{
//			WindowManager.getInstance().viewManager.symbolSumm.lastDayField.text = event.result.symbolSummary_.stats.lastDayClosePrice_;;
			/*symbols_.removeAll();
			if (event.result.length)
			{
				for each (var obj:Object in event.result)
				{
					symbols.addItem( fillSymbolBrowserBO( obj, new SymbolBrowserBO() ) );
				}
			}
			else
			{
				symbols.addItem( fillSymbolBrowserBO( event.result, new SymbolBrowserBO() ) );
			}*/
			CursorManager.removeBusyCursor();
		}

		/////////////////////////////////////////////////////////

		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}

		/////////////////////////////////////////////////////////

		/*private function fillSymbolBrowserBO(obj:Object, symbol:SymbolBrowserBO):SymbolBrowserBO
		{
			symbol.symbolID = obj.actualID_;
			symbol.INTERNAL_SYMBOL_ID = obj.internalID_;

			symbol.INTERNAL_EXCHANGE_ID = WindowManager.getInstance().viewManager.symbolBrowser.internalExchangeID;
			symbol.INTERNAL_MARKET_ID = WindowManager.getInstance().viewManager.symbolBrowser.internalMarketID;

			symbol.EXCHANGE_CODE = ModelManager.getInstance().exchangeModel.getExchangeCode(symbol.INTERNAL_EXCHANGE_ID);
			symbol.MARKET_CODE = ModelManager.getInstance().exchangeModel.getMarketCode(symbol.INTERNAL_EXCHANGE_ID, symbol.INTERNAL_MARKET_ID);
			symbol.SYMBOL_CODE = ModelManager.getInstance().exchangeModel.getSymbolCode(symbol.INTERNAL_EXCHANGE_ID, symbol.INTERNAL_MARKET_ID, symbol.INTERNAL_SYMBOL_ID);

			symbol.company = obj.symbolCompanyDetails_.company_;
			symbol.sector = obj.symbolCompanyDetails_.sector_;
			symbol.clearingType = obj.symbolCompanyDetails_.clearingType_;

			symbol.tickSize = obj.tickSize_;
			symbol.fiftyTwoWeekHigh = obj.fiftyTwoWeekHigh_;
			symbol.fiftyTwoWeekLow = obj.fiftyTwoWeekLow_;
			symbol.earningPerShare = obj.earningPerShare_;
			symbol.priceEarningRatio = obj.priceEarningRatio_;
			symbol.lotSize = obj.lotSize_;
			symbol.upperVolumeLimit = obj.upperVolumeLimit_;
			symbol.lowerVolumeLimit = obj.lowerVolumeLimit_;
			symbol.upperValueLimit = obj.upperValueLimit_;
			symbol.lowerValueLimit = obj.lowerValueLimit_;

			symbol.orderWindowUp = obj.orderWindow_.up_;
			symbol.orderWindowDown = obj.orderWindow_.down_;
			symbol.circuitBreakerUp = obj.circuitBreaker_.up_;
			symbol.circuitBreakerDown = obj.circuitBreaker_.down_;
			symbol.spotPriceUp = obj.spotPrice_.up_;
			symbol.spotPriceDown = obj.spotPrice_.down_;

			symbol.spotScheduleStart = obj.spotSchedule_.start_;
			symbol.spotScheduleEnd = obj.spotSchedule_.end_;

			return symbol;
		}*/

		public function fillSymbolStatBO(obj:Object, symbolStat:SymbolStatBO):SymbolStatBO
		{
			symbolStat.internalMarketID=obj.marketID.internalID_;
			symbolStat.INTERNAL_MARKET_ID=obj.marketID.internalID_;
			symbolStat.internalSymbolID=obj.symbolID.internalID_;

			symbolStat.totalSizeTraded=obj.totalSizeTraded_;
			symbolStat.totalNoOfTrades=obj.totalNoOfTrades_;
			symbolStat.lastTradeSize=obj.lastTradeSize_;
			symbolStat.fiftyTwoWeekHigh=obj.fiftyTwoWeekHigh_;
			symbolStat.fiftyTwoWeekLow=obj.fiftyTwoWeekLow_;
			symbolStat.turnover=obj.turnover_;
			symbolStat.lastTradePrice=obj.lastTradePrice_;
			symbolStat.averagePrice=obj.averagePrice_;
			symbolStat.netChange=obj.netChange_;
			symbolStat.lastDayClosePrice=obj.lastDayClosePrice_;

			symbolStat.open=obj.ohlc_.open_;
			symbolStat.high=obj.ohlc_.high_;
			symbolStat.low=obj.ohlc_.low_;
			symbolStat.close=obj.ohlc_.close_;

			return symbolStat;
		}
	}
}
