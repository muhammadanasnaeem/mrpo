package model
{
	import businessobjects.OrderBO;
	import businessobjects.SymbolBO;
	
	import common.HashMap;
	import common.Messages;
	
	import components.ComboBoxItem;
	
	import controller.ModelManager;
	import controller.ProfileManager;
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
	
	import view.Order;
	import view.SellOrder;

	public class RemainingOrdersModel implements IModel
	{
		public var isInit:Boolean=false;
		public var isFromOrderView:Boolean=false;
		public var orderView:Order=null;
		public var sellOrderView:SellOrder=null;
		private var isDirty_:Boolean=true;

		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}

		private var remainingOrders_:ArrayCollection=new ArrayCollection();

		[Bindable]
		public function get remainingOrders():ArrayCollection
		{
			return remainingOrders_;
		}

		public function set remainingOrders(value:ArrayCollection):void
		{
			remainingOrders_=value;
		}

		public function RemainingOrdersModel()
		{
			remainingOrders_.filterFunction=Filters.remainingOrdersFilter;
		}

		public function execute():void
		{
			var userId:Number=ModelManager.getInstance().userID;
			var selectedItem:ComboBoxItem=WindowManager.getInstance().viewManager.remainingOrders.traders.selectedItem as ComboBoxItem;
			if (selectedItem && selectedItem.value != "")
			{
				userId=new Number(selectedItem.value);
			}
			QWClient.getInstance().getRemainingOrders(ModelManager.getInstance().userID, userId);
		}

		public function onResult(event:ResultEvent):void
		{
			var strMsg:String="";
			var containedNegotiatedTrades:HashMap=new HashMap();
			var adgro:DataGrid=WindowManager.getInstance().viewManager.remainingOrders.adgRemainingOrders;
			remainingOrders_.removeAll();
			remainingOrders_.list.removeAll();
			var remainingOrdersMap:ArrayCollection=event.result.map;
			for (var p:String in remainingOrdersMap)
			{
				var orderList:ArrayCollection=remainingOrdersMap[p].value.list;
				var i:int=0;
				for (i; i < orderList.length; ++i)
				{
					var orderBO:OrderBO=new OrderBO();
					orderBO.ORDER_NO=orderList[i].ORDER_NO;
					orderBO.INTERNAL_EXCHANGE_ID=orderList[i].INTERNAL_EXCHANGE_ID;
					orderBO.INTERNAL_MARKET_ID=orderList[i].INTERNAL_MARKET_ID;
					orderBO.CLIENT_ID=orderList[i].CLIENT_ID;
					orderBO.BROKER_ID=orderList[i].BROKER_ID;
					// added on 8/12/2010 to display Client Code instead of ClientId
					orderBO.CLIENT_CODE=orderList[i].CLIENT_CODE;
					orderBO.REF_NO=orderList[i].REF_NO;
					//orderBO.SYMBOL = orderList[i].SYMBOL;
					orderBO.SYMBOL_ID=orderList[i].SYMBOL_ID;
					orderBO.INTERNAL_SYMBOL_ID=orderList[i].INTERNAL_SYMBOL_ID;
					orderBO.DISCLOSED_VOLUME=orderList[i].DISCLOSED_VOLUME;
					orderBO.PRICE=orderList[i].PRICE;
					orderBO.SIDE=orderList[i].SIDE;
					orderBO.ENTRY_DATETIME=orderList[i].ENTRY_DATETIME;
					orderBO.TRIGGER_PRICE=orderList[i].TRIGGER_PRICE;
					orderBO.VOLUME=orderList[i].VOLUME;
					orderBO.PUBLIC_ORDER_STATE=orderList[i].PUBLIC_ORDER_STATE;
					// added on 29/3/2011
					orderBO.USER_ID=orderList[i].USER_ID;
					orderBO.TYPE=orderList[i].TYPE;
					orderBO.PRICE_TYPE=orderList[i].PRICE_TYPE;
					orderBO.ORDER_CONDITION=orderList[i].ORDER_CONDITION;

					// Modified on 20/1/2011 to fix scenario when valid Internal Symbol Id is not returned from server 
//					orderBO.SYMBOL = ModelManager.getInstance().exchangeModel.getSymbolCode(
//						orderBO.INTERNAL_EXCHANGE_ID,
//						orderBO.INTERNAL_MARKET_ID,
//						orderBO.INTERNAL_SYMBOL_ID
//					);

					var symbolBO:SymbolBO=ModelManager.getInstance().exchangeModel.getSymbolDetail(orderList[i].EXCHANGE_ID, orderList[i].MARKET_ID, orderList[i].SYMBOL_ID) as SymbolBO;

					if (symbolBO)
					{
						orderBO.SYMBOL=symbolBO.SYMBOL;
					}

					//Negotiated Trade
					if (orderList[i].TYPE == "negotiated")
					{
						orderBO.COUNTER_CLIENT_CODE=orderList[i].COUNTER_CLIENT_CODE;
						orderBO.COUNTER_USER_NAME=orderList[i].COUNTER_USER_NAME;
						orderBO.COUNTER_BROKER_ID=orderList[i].COUNTER_BROKER_ID;
						orderBO.COUNTER_USER_ID=orderList[i].COUNTER_USER_ID;
						orderBO.COUNTER_CLIENT_ID=orderList[i].COUNTER_CLIENT_ID;
						orderBO.NEGOTIATED_ORDER_STATE=orderList[i].NEGOTIATED_ORDER_STATE;
						orderBO.COUNTER_ORDER_NO=orderList[i].COUNTER_ORDER_NO;
						orderBO.IS_NEGOTIATED=true;

						remainingOrders_.addItem(orderBO);
						var tmp:Number=-1;
						if (orderBO.USER_ID == orderBO.COUNTER_USER_ID)
						{
							var j:int=0;
							var OrderInList:Boolean=false;

							for (j; j < i; ++j)
							{
								if (orderList[i].ORDER_NO == orderBO.ORDER_NO)
								{
									OrderInList=true;
									break;
								}
							}
							if (OrderInList)
							{
								strMsg="<font style='color:red'>";
								strMsg+="You have received an offer for a trade. Please check \"Working Orders\" for details.";
								strMsg+="</font>";
								//WindowManager.getInstance().viewManager.marketWatch.txaMessages.htmlText += strMsg;
								if (orderBO.SIDE == "buy")
								{
									orderBO.SIDE="sell";
								}
								else if (orderBO.SIDE == "sell")
								{
									orderBO.SIDE="buy";
								}
								tmp=orderBO.CLIENT_ID;
								orderBO.CLIENT_ID=orderBO.COUNTER_CLIENT_ID;
								orderBO.COUNTER_CLIENT_ID=tmp;

								tmp=orderBO.ORDER_NO;
								orderBO.ORDER_NO=orderBO.COUNTER_ORDER_NO;
								orderBO.COUNTER_ORDER_NO=tmp;
								orderBO.IS_ORDER_NO_SWAPPED=true;
							}
						}
						else if (orderBO.COUNTER_USER_ID == ModelManager.getInstance().userID)
						{
							strMsg="<font style='color:red'>";
							strMsg+="You have received an offer for a trade. Please check \"Working Orders\" for details.";
							strMsg+="</font>";
							//WindowManager.getInstance().viewManager.marketWatch.txaMessages.htmlText += strMsg;
							if (orderBO.SIDE == "buy")
							{
								orderBO.SIDE="sell";
							}
							else if (orderBO.SIDE == "sell")
							{
								orderBO.SIDE="buy";
							}
							tmp=orderBO.CLIENT_ID;
							orderBO.CLIENT_ID=orderBO.COUNTER_CLIENT_ID;
							orderBO.COUNTER_CLIENT_ID=tmp;

							tmp=orderBO.ORDER_NO;
							orderBO.ORDER_NO=orderBO.COUNTER_ORDER_NO;
							orderBO.COUNTER_ORDER_NO=tmp;
						}
					}
					else
					{
						remainingOrders_.addItem(orderBO);
					}
				}
			}
			isDirty=false;
			CursorManager.removeBusyCursor();

			if (isInit)
			{
				isInit=false;
				var windowManager:WindowManager=WindowManager.getInstance()
				var profiler:ProfileManager=ProfileManager.getInstance(); 
				if(profiler.sharedObject.size==0)
				{
					windowManager.initMarketWatchWindow();
					windowManager.initQuickOrderWindow();
					windowManager.initLiveMessagesWindow();
					windowManager.initLiveSymbolChartWindow();
					windowManager.canvas.windowManager.add(windowManager.marketWatchWindow);
					windowManager.canvas.windowManager.add(windowManager.quickOrdersWindow);
					windowManager.canvas.windowManager.add(windowManager.liveMessages);
					windowManager.canvas.windowManager.add(windowManager.liveSymbolChartWindow);
					//				windowManager.marketWatchWindow.maximize();
				}
			}

			// added on 5/1/2011
			if (isFromOrderView)
			{
				isFromOrderView=false;
				orderView.updateOrderViewAfterRefetch();
				orderView=null;
			}

			try
			{
				WindowManager.getInstance().viewManager.remainingOrders.applyFilterEx();
			}
			catch (err:Error)
			{
				trace(err.errorID, err.message);
			}
		}

		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}

		public function getOrderBOByOrderNumber(orderNum:Number):OrderBO
		{
			var i:int=0;
			for (; i < remainingOrders.length; ++i)
			{
				var orderBO:OrderBO=remainingOrders[i] as OrderBO;
				if (orderBO.ORDER_NO == orderNum)
				{
					return orderBO;
				}
			}
			return null;
		}
	}
}
