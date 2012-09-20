package model
{
	import businessobjects.SymbolBrowserBO;
	
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

	public class SymbolBrowserModel implements IModel
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

		private var symbols_:ArrayCollection=new ArrayCollection(); // of SymbolBroswerBOs
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

		public function SymbolBrowserModel()
		{
			//Commentted on 22/12/2010
			//symbols_.filterFunction = Filters.symbolBrowserFilter;
		}

		/////////////////////////////////////////////////////////

		public function execute():void
		{
//			Commentted on 22/12/2010
//			CursorManager.setBusyCursor();
//			QWClient.getInstance().getSymbolsBrowser(
//				WindowManager.getInstance().viewManager.symbolBrowser.internalExchangeID,
//				WindowManager.getInstance().viewManager.symbolBrowser.internalMarketID
//			);
		}

		/////////////////////////////////////////////////////////

		public function onResult(event:ResultEvent):void
		{
			symbols_.removeAll();
			if (event.result.length)
			{
				for each (var obj:Object in event.result)
				{
					symbols.addItem(fillSymbolBrowserBO(obj, new SymbolBrowserBO()));
				}
			}
			else
			{
				symbols.addItem(fillSymbolBrowserBO(event.result, new SymbolBrowserBO()));
			}
			// added on 21/12/2010
			symbols.refresh();
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

		private function fillSymbolBrowserBO(obj:Object, symbol:SymbolBrowserBO):SymbolBrowserBO
		{
			symbol.symbolID=obj.actualID_;
			symbol.INTERNAL_SYMBOL_ID=obj.internalID_;

//			modified on 21/12/2010
//			symbol.INTERNAL_EXCHANGE_ID = WindowManager.getInstance().viewManager.symbolBrowser.internalExchangeID;
//			symbol.INTERNAL_MARKET_ID = WindowManager.getInstance().viewManager.symbolBrowser.internalMarketID;

//			symbol.INTERNAL_EXCHANGE_ID = obj.emID_.exchangeID.internalID_;
//			symbol.INTERNAL_MARKET_ID = obj.emID_.marketID.internalID_;

			symbol.EXCHANGE_CODE=ModelManager.getInstance().exchangeModel.getExchangeCode(symbol.INTERNAL_EXCHANGE_ID);
			symbol.MARKET_CODE=ModelManager.getInstance().exchangeModel.getMarketCode(symbol.INTERNAL_EXCHANGE_ID, symbol.INTERNAL_MARKET_ID);
			symbol.SYMBOL_CODE=ModelManager.getInstance().exchangeModel.getSymbolCode(symbol.INTERNAL_EXCHANGE_ID, symbol.INTERNAL_MARKET_ID, symbol.INTERNAL_SYMBOL_ID);

			symbol.company=obj.symbolCompanyDetails_.company_;
			symbol.sector=obj.symbolCompanyDetails_.sector_;
			symbol.clearingType=obj.symbolCompanyDetails_.clearingType_;

			symbol.tickSize=obj.tickSize_;
			symbol.fiftyTwoWeekHigh=obj.fiftyTwoWeekHigh_;
			symbol.fiftyTwoWeekLow=obj.fiftyTwoWeekLow_;
			symbol.earningPerShare=obj.earningPerShare_;
			symbol.priceEarningRatio=obj.priceEarningRatio_;
			symbol.lotSize=obj.lotSize_;
			symbol.upperVolumeLimit=obj.upperVolumeLimit_;
			symbol.lowerVolumeLimit=obj.lowerVolumeLimit_;
			symbol.upperValueLimit=obj.upperValueLimit_;
			symbol.lowerValueLimit=obj.lowerValueLimit_;

			symbol.orderWindowUp=obj.orderWindow_.up_;
			symbol.orderWindowDown=obj.orderWindow_.down_;
			symbol.circuitBreakerUp=obj.circuitBreaker_.up_;
			symbol.circuitBreakerDown=obj.circuitBreaker_.down_;
			symbol.spotPriceUp=obj.spotPrice_.up_;
			symbol.spotPriceDown=obj.spotPrice_.down_;

			symbol.spotScheduleStart=obj.spotSchedule_.start_;
			symbol.spotScheduleEnd=obj.spotSchedule_.end_;

			return symbol;
		}

	}
}
