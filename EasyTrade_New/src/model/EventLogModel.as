package model
{
	import businessobjects.EventLogBO;
	import businessobjects.OrderBO;
	
	import common.Messages;
	
	import components.ComboBoxItem;
	
	import controller.ModelManager;
	import controller.WindowManager;
	
	import filters.Filters;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.QWClient;

	public class EventLogModel implements IModel
	{
		private var isDirty_:Boolean=true;
		private static var savedVolume:Number;
		try
		{
//		private var windowManager:WindowManager = WindowManager.getInstance();
		}
		catch(e:Error)
		{
			trace(e.message);
		}
		
		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}

		private var eventLog_:ArrayCollection=new ArrayCollection(); // EventLogBO

		[Bindable]
		public function get eventLog():ArrayCollection
		{
			return eventLog_;
		}

		public function set eventLog(value:ArrayCollection):void
		{
			eventLog_=value;
		}

		public function EventLogModel()
		{
			eventLog_.filterFunction=Filters.eventLogFilter;
		}

		public function execute():void
		{
			var userId:Number=ModelManager.getInstance().userID;
			var selectedItem:ComboBoxItem=WindowManager.getInstance().viewManager.eventLog.traders.selectedItem as ComboBoxItem;
			if (selectedItem && selectedItem.value != "")
			{
				userId=new Number(selectedItem.value);
			}
			QWClient.getInstance().getEventLog(ModelManager.getInstance().userID, userId);
		}

		public function onResult(event:ResultEvent):void
		{
			var remainingOrdersMap:ArrayCollection=event.result.remainingOrders_.map;
			var userTradeHistoryMap:ArrayCollection=event.result.tradeHistory_.map;
			var exchangeModel:ExchangeModel=ModelManager.getInstance().exchangeModel;
			
			eventLog_.removeAll();

			for (var p:String in remainingOrdersMap)
			{
				var orderList:ArrayCollection=remainingOrdersMap[p].value.list;
				var i:int=0;
				for (i; i < orderList.length; ++i)
				{
					var eventLogBO:EventLogBO=new EventLogBO();
					eventLogBO.ORDER_NO=orderList[i].ORDER_NO;
					eventLogBO.INTERNAL_EXCHANGE_ID=orderList[i].INTERNAL_EXCHANGE_ID;
					eventLogBO.INTERNAL_MARKET_ID=orderList[i].INTERNAL_MARKET_ID;
					eventLogBO.CLIENT_ID=orderList[i].CLIENT_ID;
					// added on 8/12/2010 to display Client Code instead of ClientId
					eventLogBO.CLIENT_CODE=orderList[i].CLIENT_CODE;
					eventLogBO.SYMBOL_ID=orderList[i].SYMBOL_ID;
					eventLogBO.INTERNAL_SYMBOL_ID=orderList[i].INTERNAL_SYMBOL_ID;
					eventLogBO.PRICE=orderList[i].PRICE;
					eventLogBO.VOLUME=orderList[i].VOLUME;
					savedVolume=orderList[i].VOLUME;
//					eventLogBO.REMAINING_VOL = windowManager.viewManager.marketWatch.remainedVol;
					eventLogBO.SYMBOL=exchangeModel.getSymbolCode(eventLogBO.INTERNAL_EXCHANGE_ID, eventLogBO.INTERNAL_MARKET_ID, eventLogBO.INTERNAL_SYMBOL_ID);
					eventLogBO.ENTRY_DATETIME=orderList[i].ENTRY_DATETIME;

					eventLogBO.DISCLOSED_VOLUME=orderList[i].DISCLOSED_VOLUME;
					eventLogBO.SIDE=orderList[i].SIDE;
					eventLogBO.TIF=orderList[i].TIF;
					eventLogBO.TRIGGER_PRICE=orderList[i].TRIGGER_PRICE;
					eventLogBO.PUBLIC_ORDER_STATE=orderList[i].PUBLIC_ORDER_STATE;
					//eventLogBO.IS_NEGOTIATED = orderList[i].IS_NEGOTIATED;
					eventLogBO.ORDER_TYPE = orderList[i].TYPE;
					eventLogBO.IS_NEGOTIATED=orderList[i].TYPE == "negotiated" ? true : false;
					eventLogBO.USER_ID=orderList[i].USER_ID
					// **** //
					var tmp:Number=-1;
					if (eventLogBO.USER_ID == orderList[i].COUNTER_USER_ID)
					{
						var j:int=0;
						var OrderInList:Boolean=false;

						for (j; j < i; ++j)
						{
							if (orderList[i].ORDER_NO == eventLogBO.ORDER_NO)
							{
								OrderInList=true;
								break;
							}
						}
						if (OrderInList)
						{
							if (eventLogBO.SIDE == "buy")
							{
								eventLogBO.SIDE="sell";
							}
							else if (eventLogBO.SIDE == "sell")
							{
								eventLogBO.SIDE="buy";
							}
							tmp=eventLogBO.CLIENT_ID;
							eventLogBO.CLIENT_ID=orderList[i].COUNTER_CLIENT_ID;
							orderList[i].COUNTER_CLIENT_ID=tmp;

							tmp=eventLogBO.ORDER_NO;
							eventLogBO.ORDER_NO=orderList[i].COUNTER_ORDER_NO;
							orderList[i].COUNTER_ORDER_NO=tmp;
						}
					}
					else if (orderList[i].COUNTER_USER_ID == ModelManager.getInstance().userID)
					{
						if (eventLogBO.SIDE == "buy")
						{
							eventLogBO.SIDE="sell";
						}
						else if (eventLogBO.SIDE == "sell")
						{
							eventLogBO.SIDE="buy";
						}
						tmp=eventLogBO.CLIENT_ID;
						eventLogBO.CLIENT_ID=orderList[i].COUNTER_CLIENT_ID;
						orderList[i].COUNTER_CLIENT_ID=tmp;

						tmp=eventLogBO.ORDER_NO;
						eventLogBO.ORDER_NO=orderList[i].COUNTER_ORDER_NO;
						orderList[i].COUNTER_ORDER_NO=tmp;
					}
					// **** //

					eventLog_.addItem(eventLogBO);
				}
			}

			p="";
			eventLogBO=null;

			for (p in userTradeHistoryMap)
			{
				var userTradeList:ArrayCollection=userTradeHistoryMap[p].value.list;
				i=0;
				for (i; i < userTradeList.length; ++i)
				{
					eventLogBO=new EventLogBO();

					ENTRY_DATETIME: Date;

					eventLogBO.ORDER_NO=userTradeList[i].orderID_;
					eventLogBO.CLIENT_ID=userTradeList[i].clientID_;
					eventLogBO.CLIENT_CODE=userTradeList[i].client_code_;
					eventLogBO.USER_ID=userTradeList[i].userID_;
					eventLogBO.PRICE=userTradeList[i].price_;
					eventLogBO.FILLED_VOL=userTradeList[i].volume_;
//					eventLogBO.REMAINING_VOL=(userTradeList[i].volume_)?(savedVolume-eventLogBO.FILLED_VOL).toString():'';   
					eventLogBO.ENTRY_DATETIME=userTradeList[i].datetimeStamp_;
					eventLogBO.INTERNAL_EXCHANGE_ID=userTradeList[i].exchangeID.internalID_;
					eventLogBO.INTERNAL_MARKET_ID=userTradeList[i].marketID.internalID_;
					eventLogBO.INTERNAL_SYMBOL_ID=userTradeList[i].symbolID.internalID_;

					eventLogBO.EXCHANGE_CODE=exchangeModel.getExchangeCode(eventLogBO.INTERNAL_EXCHANGE_ID);
					eventLogBO.MARKET_CODE=exchangeModel.getMarketCode(eventLogBO.INTERNAL_EXCHANGE_ID, eventLogBO.INTERNAL_MARKET_ID);
					eventLogBO.SYMBOL=exchangeModel.getSymbolCode(eventLogBO.INTERNAL_EXCHANGE_ID, eventLogBO.INTERNAL_MARKET_ID, eventLogBO.INTERNAL_SYMBOL_ID);
					eventLogBO..SIDE=userTradeList[i].SIDE;
					eventLogBO.PUBLIC_ORDER_STATE="Filled";
					eventLogBO.TICKET_ID=userTradeList[i].ticketID_;
					eventLogBO.IS_NEGOTIATED=userTradeList[i].trade_type_ == "negotiated" ? true : false;
					eventLogBO.ORDER_TYPE = userTradeList[i].trade_type_;
					eventLogBO.USER_ID=userTradeList[i].USER_ID
					// **** //
					tmp=-1;
					if (eventLogBO.USER_ID == userTradeList[i].COUNTER_USER_ID)
					{
						j=0;
						OrderInList=false;

						for (j; j < i; ++j)
						{
							if (userTradeList[i].ORDER_NO == eventLogBO.ORDER_NO)
							{
								OrderInList=true;
								break;
							}
						}
						if (OrderInList)
						{
							if (eventLogBO.SIDE == "buy")
							{
								eventLogBO.SIDE="sell";
							}
							else if (eventLogBO.SIDE == "sell")
							{
								eventLogBO.SIDE="buy";
							}
							tmp=eventLogBO.CLIENT_ID;
							eventLogBO.CLIENT_ID=userTradeList[i].COUNTER_CLIENT_ID;
							userTradeList[i].COUNTER_CLIENT_ID=tmp;

							tmp=eventLogBO.ORDER_NO;
							eventLogBO.ORDER_NO=userTradeList[i].COUNTER_ORDER_NO;
							userTradeList[i].COUNTER_ORDER_NO=tmp;
						}
					}
					else if (userTradeList[i].COUNTER_USER_ID == ModelManager.getInstance().userID)
					{
						if (eventLogBO.SIDE == "buy")
						{
							eventLogBO.SIDE="sell";
						}
						else if (eventLogBO.SIDE == "sell")
						{
							eventLogBO.SIDE="buy";
						}
						tmp=eventLogBO.CLIENT_ID;
						eventLogBO.CLIENT_ID=userTradeList[i].COUNTER_CLIENT_ID;
						userTradeList[i].COUNTER_CLIENT_ID=tmp;

						tmp=eventLogBO.ORDER_NO;
						eventLogBO.ORDER_NO=userTradeList[i].COUNTER_ORDER_NO;
						userTradeList[i].COUNTER_ORDER_NO=tmp;
					}
					// **** //

					eventLog_.addItem(eventLogBO);
				}
			}
					
			isDirty=false;
			CursorManager.removeBusyCursor();
		}

		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}
	}
}
