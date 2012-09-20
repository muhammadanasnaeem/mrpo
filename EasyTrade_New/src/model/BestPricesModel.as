package model
{
	import common.Constants;
	import common.Messages;
	
	import controller.ModelManager;
	import controller.WindowManager;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.QWClient;

	public class BestPricesModel implements IModel
	{
		private var totalBuy_:Number=0;

		[Bindable]
		public function get totalBuy():Number
		{
			return totalBuy_;
		}

		private function set totalBuy(value:Number):void
		{
			totalBuy_=value;
		}

		private var totalSell_:Number=0;

		[Bindable]
		public function get totalSell():Number
		{
			return totalSell_;
		}

		private function set totalSell(value:Number):void
		{
			totalSell_=value;
		}


		private var isDirty_:Boolean=true;

		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}

		private var bestPrices_:ArrayList=new ArrayList();

		[Bindable]
		public function get bestPrices():ArrayList
		{
			return bestPrices_;
		}

		private function set bestPrices(value:ArrayList):void
		{
			bestPrices_=bestPrices;
		}

		public function BestPricesModel()
		{
		}

		public function execute():void
		{
			CursorManager.setBusyCursor();
			// modified on 31/3/2011 after discussion with usman
			var internalExchangeId:Number=WindowManager.getInstance().viewManager.bestPrices.internalExchangeID;
			var exchangeId:Number=ModelManager.getInstance().exchangeModel.getExchangeID(internalExchangeId);
			var marketId:Number=ModelManager.getInstance().exchangeModel.getMarketID(internalExchangeId, WindowManager.getInstance().viewManager.bestPrices.internalMarketID);
			QWClient.getInstance().getBestPrices(exchangeId, marketId, WindowManager.getInstance().viewManager.bestPrices.symbolID);
		}

		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}

		public function onResult(event:ResultEvent):void
		{
			bestPrices_.removeAll();
			totalBuy_=0;
			totalSell_=0;
			for (var i:int=0; i < Constants.ROW_COUNT_BEST_PRICES; ++i)
			{
				var obj:Object=new Object();
				bestPrices_.addItem(obj);
			}
			FillPriceLevels(event.result.buyPriceLevels_, true);
			FillPriceLevels(event.result.sellPriceLevels_, false);
			//isDirty = false;
			//CursorManager.removeBusyCursor();
			CursorManager.removeAllCursors();
		}

		private function FillPriceLevels(priceLevels:ArrayCollection, isBuyOrders:Boolean):void
		{
			for (var i:int=0; i < Constants.ROW_COUNT_BEST_PRICES && i < priceLevels.length; ++i)
			{
				if (isBuyOrders)
				{
					bestPrices_.getItemAt(i).BUY_COUNT=priceLevels.getItemAt(i).count_;
					bestPrices_.getItemAt(i).BUY_VOLUME=priceLevels.getItemAt(i).VOLUME;
					bestPrices_.getItemAt(i).BUY_PRICE=priceLevels.getItemAt(i).PRICE;
				}
				else
				{
					bestPrices_.getItemAt(i).SELL_COUNT=priceLevels.getItemAt(i).count_;
					bestPrices_.getItemAt(i).SELL_VOLUME=priceLevels.getItemAt(i).VOLUME;
					bestPrices_.getItemAt(i).SELL_PRICE=priceLevels.getItemAt(i).PRICE;
				}
			}
		}
	}
}
