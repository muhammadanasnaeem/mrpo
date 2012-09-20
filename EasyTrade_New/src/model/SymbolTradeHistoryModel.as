package model
{
	import businessobjects.SymbolTradeBO;
	
	import common.Constants;
	import common.Messages;
	
	import controller.ModelManager;
	import controller.ProfileManager;
	import controller.WindowManager;
	
	import flash.external.ExternalInterface;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.LSListener;
	import services.QWClient;

	public class SymbolTradeHistoryModel implements IModel
	{
		private var symbolTrades_:ArrayCollection=new ArrayCollection();
		private var exchangeID:Number=-1;
		private var marketID:Number=-1;
		private var symbolID:Number=-1;

		[Bindable]
		public function get symbolTrades():ArrayCollection
		{
			return symbolTrades_;
		}

		public function set symbolTrades(value:ArrayCollection):void
		{
			symbolTrades_=value;
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

		public function SymbolTradeHistoryModel()
		{
		}

		public function execute():void
		{
			CursorManager.setBusyCursor();
			exchangeID=ModelManager.getInstance().exchangeModel.getExchangeID(WindowManager.getInstance().viewManager.liveSymbolChart.internalExchangeID);
			marketID=ModelManager.getInstance().exchangeModel.getMarketID(WindowManager.getInstance().viewManager.liveSymbolChart.internalExchangeID, WindowManager.getInstance().viewManager.liveSymbolChart.internalMarketID);
			symbolID=ModelManager.getInstance().exchangeModel.getSymbolID(WindowManager.getInstance().viewManager.liveSymbolChart.internalExchangeID, WindowManager.getInstance().viewManager.liveSymbolChart.internalMarketID, WindowManager.getInstance().viewManager.liveSymbolChart.internalSymbolID);
			QWClient.getInstance().getSymbolTradeHistory(exchangeID, marketID, symbolID);
		}

		public function onResult(event:ResultEvent):void
		{
			symbolTrades.removeAll();
			symbolTrades.list.removeAll();
			// changed on 14/12/2010
			//for each (var o:Object in event.result.map[0].value.list)			
			for each (var val:Object in event.result.map)
			{
				for each (var o:Object in val.value.list)
				{
					var stb:SymbolTradeBO=new SymbolTradeBO;
					stb.price=o.price_;
					stb.size=o.size_;
					stb.ticket=o.ticket_;
					stb.time=o.time_;
					symbolTrades.addItem(stb);
				}
			}
			CursorManager.removeBusyCursor();

			//here subscribe to lightstreamer's symbol trade feed...
			if (exchangeID == -1 || marketID == -1 || symbolID == -1)
			{
				return;
			}

			try
			{
				//var key:String = event.result.exchangeId.toString() + "_" + event.result.marketId.toString() + "_" + event.result.symbolId;
				var key:String=exchangeID.toString() + "_" + marketID.toString() + "_" + symbolID.toString();
				var itemName:String="STEMS_" + key;
				LSListener.getInstance().subscribeItem(
					itemName,
					LSListener.fieldSchemaSymbolStat,
					LSListener.getInstance().lsClientSymbolStats,
					WindowManager.getInstance().viewManager.liveSymbolChart.updateSymbolTradeHistory
				);
				if (!ModelManager.getInstance().subscribedItems.hasKey(itemName))
				{
					ModelManager.getInstance().subscribedItems.put(itemName, itemName);
					ExternalInterface.call("subscribeItem", Constants.SYMBOL_STAT_DATA_ADAPTER, "tblSymbolStat_" + itemName, itemName, "fieldSchemaSymbolStat", "updateSymbolTradeHistory", ProfileManager.getInstance().userName, ProfileManager.getInstance().password);
				}
			}
			catch (err:Error)
			{
				trace("Error number: " + err.errorID.toString() + "occured. Message was" + err.message);
			}

		}

		public function onFault(event:FaultEvent):void
		{
			ModelManager.getInstance().orderModel.isDirty=false;
			CursorManager.removeBusyCursor();
			Alert.show(event.fault.message, ResourceManager.getInstance().getString('marketwatch','error'));
		}
	}
}
