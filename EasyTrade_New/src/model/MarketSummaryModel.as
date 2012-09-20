package model
{
	import businessobjects.SymbolStatBO;
	import businessobjects.SymbolSummary;
	import businessobjects.SymbolSummaryBO;
	
	import common.Messages;
	
	import components.ComboBoxItem;
	import components.EZCurrencyFormatter;
	
	import controller.ModelManager;
	import controller.WindowManager;
	
	import filters.Filters;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.QWClient;

	public class MarketSummaryModel implements IModel
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

		public var exchangeID:Number;
		public var marketID:Number;

		public var totalNumberOfSymbols:Number=0;
		public var totalVolume:Number=0;
		public var totalValue:Number=0;
		public var totalTrades:Number=0;

		public var decending:Boolean=false;
		public var sortColumnName:String="SYMBOL";
		
		//Currency Formatter 
		private var ezCurrencyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();

		/////////////////////////////////////////////////////////
		public function MarketSummaryModel()
		{

		}

		/////////////////////////////////////////////////////////

		public function execute():void
		{
			CursorManager.setBusyCursor();
			var exchangeID:Number=ModelManager.getInstance().exchangeModel.getExchangeID(WindowManager.getInstance().viewManager.marketSummary.internalExchangeID);
			var marketID:Number=ModelManager.getInstance().exchangeModel.getMarketID(WindowManager.getInstance().viewManager.marketSummary.internalExchangeID, WindowManager.getInstance().viewManager.marketSummary.internalMarketID);
			QWClient.getInstance().getMarketSummary(exchangeID, marketID);
		}

		/////////////////////////////////////////////////////////

		public function onResult(event:ResultEvent):void
		{
			symbols_.removeAll();
			var addSummary:Boolean=false;
			totalNumberOfSymbols=0;
			totalVolume=0;
			totalValue=0;
			totalTrades=0;
			decending=false;
			sortColumnName="SYMBOL";

			if (event.result)
			{
				for each (var obj:Object in event.result)
				{
					var internalExchangeID:Number=obj.browser.exchangeID.internalID_;
					var internalMarketID:Number=obj.browser.marketID.internalID_;
					if (obj.stats)
					{
						symbols.addItem(fillSymbolSummary(obj.stats, new SymbolSummary(), internalExchangeID, internalMarketID));
						addSummary=true;
					}
					if (obj.stats.turnover_ == 0)
					{
						addSummary=false;
					}
//						else
//						{
//							symbols.addItem( fillSymbolSummary( event.result.stats, new SymbolSummary() ) );
//						}

						//			var sort:Sort = new Sort();
						//			sort.fields = [new SortField(dataFeild,true, decending), new SortField("SYMBOL_CODE",true, decending)];
						//			
						//			symbols.sort = sort;
						//			// Apply the sort to the collection.
						//			symbols.refresh();
				}



				if (addSummary)
				{
					var summaryObj:SymbolSummary=new SymbolSummary();
					summaryObj.isSummary=true;
					summaryObj.SYMBOL="Total = " + totalNumberOfSymbols;
					if(totalTrades == 0 )
					{
						summaryObj.TOTAL_SIZE_TRADED='';
						summaryObj.VALUE='';
						summaryObj.TRADES='';
					}
					else
					{
						summaryObj.SYMBOL="";
						summaryObj.TOTAL_SIZE_TRADED=totalVolume.toString();
						summaryObj.VALUE=totalValue.toString();
						summaryObj.TRADES=totalTrades.toString();
					}
					symbols.addItem(summaryObj);
				}

				sortMarketSummary();

			}

			CursorManager.removeBusyCursor();
		}

		/////////////////////////////////////////////////////////

		public function sortMarketSummary():void
		{
			var sort:Sort=new Sort();
			sort.fields=[new SortField('isSummary', true, false), new SortField(sortColumnName, true, decending)];

			symbols.sort=sort;
			// Apply the sort to the collection.
			symbols.refresh();
		}

		////////////////////////////////////////////////////////
		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}

		/////////////////////////////////////////////////////////


		public function fillSymbolSummary(obj:Object, symbol:SymbolSummary, exchangeID:Number, marketID:Number):SymbolSummary
		{
			var symbolDetail:Object=ModelManager.getInstance().exchangeModel.getSymbolDetail(exchangeID, marketID, obj.symbolID.actualID_);

			if (symbolDetail)
			{
				symbol.SYMBOL=symbolDetail.SYMBOL;
			}
			symbol.symbolID=obj.symbolID;
			if( symbolDetail == null)
			{
				symbol.HIGH='';
				symbol.LOW='';
				//symbol.STATE = obj.STATE;
				symbol.OPEN='';
				//symbol.LAST = obj.LAST;
				symbol.CHANGE='';
				
				//symbol.SECTOR = obj.SECTOR;
				//symbol.LAST_VOLUME = obj.LAST_VOLUME;
				symbol.CLOSE='';
				symbol.LAST_DAY_CLOSE_PRICE='';
				symbol.AVERAGE='';
			}
			else
			{
				
			symbol.HIGH=obj.ohlc_.high_;
			symbol.LOW=obj.ohlc_.low_;
			//symbol.STATE = obj.STATE;
			symbol.OPEN=obj.ohlc_.open_;
			//symbol.LAST = obj.LAST;
			symbol.CHANGE=obj.netChange_;
			
			//symbol.SECTOR = obj.SECTOR;
			//symbol.LAST_VOLUME = obj.LAST_VOLUME;
			symbol.CLOSE=obj.ohlc_.close_;
			symbol.LAST_DAY_CLOSE_PRICE=obj.lastDayClosePrice_;
			symbol.AVERAGE=obj.averagePrice_;
			//symbol.SELL = obj.SELL;
			}
			if(obj.totalNoOfTrades_ == '0')
			{
				symbol.TRADES='';
			}
			else
			{
				symbol.TRADES=obj.totalNoOfTrades_;
			}
			
			if(obj.totalSizeTraded_ == '0')
			{
				symbol.TOTAL_SIZE_TRADED = '';
				symbol.VALUE='';
				symbol.PERCENTAGE_VALUE'';
			}
			else
			{
				symbol.TOTAL_SIZE_TRADED=obj.totalSizeTraded_;
				symbol.VALUE=(obj.totalSizeTraded_ * obj.ohlc_.high_).toString();
				symbol.PERCENTAGE_VALUE = ((obj.totalSizeTraded_ * obj.ohlc_.high_) / 100 * 100).toString();
			}
			
			if(obj.totalSizeTraded_ == '0')  
			{
				symbol.PERCENTAGE_VOLUME=''; 
			}
			else
			{
				symbol.PERCENTAGE_VOLUME=((obj.totalSizeTraded_ / 100) * 100).toString();
			}
				totalNumberOfSymbols++;
				totalTrades=totalTrades + new Number(obj.totalNoOfTrades_);
				totalVolume=totalVolume + new Number(obj.totalSizeTraded_);
				totalValue=totalValue + new Number(symbol.VALUE);

			return symbol;
		}
	}
}
