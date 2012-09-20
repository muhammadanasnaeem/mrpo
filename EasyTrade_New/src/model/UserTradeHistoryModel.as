package model
{
	import businessobjects.UserTradeBO;
	
	import common.Messages;
	
	import components.ComboBoxItem;
	
	import controller.ModelManager;
	import controller.ProfileManager;
	import controller.ViewManager;
	import controller.WindowManager;
	
	import filters.Filters;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.QWClient;

	public class UserTradeHistoryModel implements IModel
	{
		private var isDirty_:Boolean=true;

		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}

		private var userTradeHistoryGroups_:ArrayCollection=new ArrayCollection();

		[Bindable]
		public function get userTradeHistoryGroups():ArrayCollection
		{
			return userTradeHistoryGroups_;
		}

		public function set userTradeHistoryGroups(value:ArrayCollection):void
		{
			userTradeHistoryGroups_=value;
		}

		private var userTradeHistory_:ArrayCollection=new ArrayCollection();

		[Bindable]
		public function get userTradeHistory():ArrayCollection
		{
			return userTradeHistory_;
		}

		public function set userTradeHistory(value:ArrayCollection):void
		{
			userTradeHistory_=value;
		}

		public function UserTradeHistoryModel()
		{
			userTradeHistory_.filterFunction=Filters.userTradeHistoryFilter;
		}

		public var decending:Boolean=false;
		public var sortColumnName:String="SYMBOL_CODE";

		public function execute():void
		{
			CursorManager.setBusyCursor();
			var userId:Number=ModelManager.getInstance().userID;
			var selectedItem:ComboBoxItem=WindowManager.getInstance().viewManager.userTradeHistory.traders.selectedItem as ComboBoxItem;
			if (selectedItem && selectedItem.value != "")
			{
				userId=new Number(selectedItem.value);
			}
			QWClient.getInstance().getUserTradeHistory(ModelManager.getInstance().userID, userId);
		}

		public function onResult(event:ResultEvent):void
		{
			var selectedItem:ComboBoxItem=WindowManager.getInstance().viewManager.userTradeHistory.traders.selectedItem as ComboBoxItem;
			var userName:String;
			if (selectedItem && selectedItem.value != "")
				userName=selectedItem.label;
			else
				userName=ProfileManager.getInstance().userName;

			var exchangeModel:ExchangeModel=ModelManager.getInstance().exchangeModel;
			userTradeHistory_.removeAll();
			userTradeHistory_.list.removeAll();
			var userTradeHistoryMap:ArrayCollection=event.result.map;
			for (var p:String in userTradeHistoryMap)
			{
				var userTradeList:ArrayCollection=userTradeHistoryMap[p].value.list;
				var i:int=0;
				for (i; i < userTradeList.length; ++i)
				{
					var userTradeBO:UserTradeBO=new UserTradeBO();
					userTradeBO.ORDER_ID=userTradeList[i].orderID_;
					userTradeBO.CLIENT_ID=userTradeList[i].clientID_;
					// added on 14/1/2011 to display Client Code instead of ClientId
					userTradeBO.CLIENT_CODE=userTradeList[i].client_code_;
					// added on 6/1/2011
					//userTradeBO.USER_ID = userTradeList[i].userID_;
					// modified on 28/3/2011
					//userTradeBO.USER = ProfileManager.getInstance().userName;					
					userTradeBO.USER=userName;
					userTradeBO.PRICE=userTradeList[i].price_;
					userTradeBO.VOLUME=userTradeList[i].volume_;
					userTradeBO.TICKET_ID=userTradeList[i].ticketID_;
					userTradeBO.ENTRY_DATETIME=userTradeList[i].datetimeStamp_;
					userTradeBO.SIDE=userTradeList[i].SIDE;

					userTradeBO.INTERNAL_EXCHANGE_ID=userTradeList[i].exchangeID.internalID_;
					userTradeBO.INTERNAL_MARKET_ID=userTradeList[i].marketID.internalID_;
					userTradeBO.INTERNAL_SYMBOL_ID=userTradeList[i].symbolID.internalID_;

					userTradeBO.EXCHANGE_CODE=exchangeModel.getExchangeCode(userTradeBO.INTERNAL_EXCHANGE_ID);
					userTradeBO.MARKET_CODE=exchangeModel.getMarketCode(userTradeBO.INTERNAL_EXCHANGE_ID, userTradeBO.INTERNAL_MARKET_ID);
					userTradeBO.SYMBOL_CODE=exchangeModel.getSymbolCode(userTradeBO.INTERNAL_EXCHANGE_ID, userTradeBO.INTERNAL_MARKET_ID, userTradeBO.INTERNAL_SYMBOL_ID);
					userTradeBO.IS_NEGOTIATED=userTradeList[i].tradeType_ == "negotiated" ? true : false;

					userTradeBO.USER_ID=userTradeList[i].USER_ID
					// **** //
					var tmp:Number=-1;
					if (userTradeBO.USER_ID == userTradeList[i].COUNTER_USER_ID)
					{
						var j:int=0;
						var OrderInList:Boolean=false;

						for (j; j < i; ++j)
						{
							if (userTradeList[i].ORDER_NO == userTradeBO.ORDER_ID)
							{
								OrderInList=true;
								break;
							}
						}
						if (OrderInList)
						{
							if (userTradeBO.SIDE == "buy")
							{
								userTradeBO.SIDE="sell";
							}
							else if (userTradeBO.SIDE == "sell")
							{
								userTradeBO.SIDE="buy";
							}
							tmp=userTradeBO.CLIENT_ID;
							userTradeBO.CLIENT_ID=userTradeList[i].COUNTER_CLIENT_ID;
							userTradeList[i].COUNTER_CLIENT_ID=tmp;

							tmp=userTradeBO.ORDER_ID;
							userTradeBO.ORDER_ID=userTradeList[i].COUNTER_ORDER_NO;
							userTradeList[i].COUNTER_ORDER_NO=tmp;
						}
					}
					else if (userTradeList[i].COUNTER_USER_ID == ModelManager.getInstance().userID)
					{
						if (userTradeBO.SIDE == "buy")
						{
							userTradeBO.SIDE="sell";
						}
						else if (userTradeBO.SIDE == "sell")
						{
							userTradeBO.SIDE="buy";
						}
						tmp=userTradeBO.CLIENT_ID;
						userTradeBO.CLIENT_ID=userTradeList[i].COUNTER_CLIENT_ID;
						userTradeList[i].COUNTER_CLIENT_ID=tmp;

						tmp=userTradeBO.ORDER_ID;
						userTradeBO.ORDER_ID=userTradeList[i].COUNTER_ORDER_NO;
						userTradeList[i].COUNTER_ORDER_NO=tmp;
					}
					// **** //


					userTradeHistory_.addItem(userTradeBO);
				}
			}
			isDirty=false;
			// Start : Added  for summary rows

			if (sortColumnName == "SYMBOL_CODE")
				makeUserTradeHistorySymbolGroups(sortColumnName, decending);
			else if (sortColumnName == "CLIENT_CODE")
				makeUserTradeHistoryAccountGroups(sortColumnName, decending);
			// End : Added  for summary rows
			CursorManager.removeBusyCursor();
		}

		public function makeUserTradeHistorySymbolGroups(dataFeild:String, decending:Boolean):void
		{
			var sort:Sort=new Sort();
			sort.fields=[new SortField(dataFeild, true, decending)];

			userTradeHistory.sort=sort;
			// Apply the sort to the collection.
			userTradeHistory.refresh();


			var oldSymbolValue:String="";
			var buyPriceTotal:Number=0;
			var buyValueTotal:Number=0;
			var sellPriceTotal:Number=0;
			var sellValueTotal:Number=0;
			userTradeHistoryGroups.removeAll();

			for (var i:int=0; i < userTradeHistory.length; ++i)
			{
				var userTradeBO:UserTradeBO=userTradeHistory.getItemAt(i) as UserTradeBO;

				if ((oldSymbolValue != "" && userTradeHistory.getItemAt(i).SYMBOL_CODE == oldSymbolValue) || oldSymbolValue == "")
				{
					if (userTradeBO.SIDE == "buy")
					{
						//buyPriceTotal = buyPriceTotal + userTradeBO.PRICE;
						buyPriceTotal=buyPriceTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//buyValueTotal = buyValueTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						buyValueTotal=buyValueTotal + userTradeBO.VOLUME;
					}
					else
					{
						//sellPriceTotal = sellPriceTotal + userTradeBO.PRICE;
						sellPriceTotal=sellPriceTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//sellValueTotal = sellValueTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						sellValueTotal=sellValueTotal + userTradeBO.VOLUME;
					}
					userTradeHistoryGroups.addItem(userTradeHistory.getItemAt(i));
				}
				else if ((oldSymbolValue != "" && userTradeHistory.getItemAt(i).SYMBOL_CODE != oldSymbolValue))
				{
					var obj:UserTradeBO=new UserTradeBO();
					obj.totalTxt="G. Total";
					obj.summary=true;

					obj.buyPriceTotal=buyPriceTotal;
					obj.buyValueTotal=buyValueTotal;
					obj.sellPriceTotal=sellPriceTotal;
					obj.sellValueTotal=sellValueTotal;

					buyPriceTotal=0;
					buyValueTotal=0;
					sellPriceTotal=0;
					sellValueTotal=0;

					userTradeHistoryGroups.addItem(obj);

					if (userTradeBO.SIDE == "buy")
					{
						//buyPriceTotal = buyPriceTotal + userTradeBO.PRICE;
						buyPriceTotal=buyPriceTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//buyValueTotal = buyValueTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						buyValueTotal=buyValueTotal + userTradeBO.VOLUME;
					}
					else
					{
						//sellPriceTotal = sellPriceTotal + userTradeBO.PRICE;
						sellPriceTotal=sellPriceTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//sellValueTotal = sellValueTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						sellValueTotal=sellValueTotal + userTradeBO.PRICE;
					}
					userTradeHistoryGroups.addItem(userTradeHistory.getItemAt(i));

				}
				if (userTradeHistory.length - 1 == i)
				{
					var obj1:UserTradeBO=new UserTradeBO();
					obj1.summary=true;
					obj1.totalTxt="G. Total";
					obj1.buyPriceTotal=buyPriceTotal;
					obj1.buyValueTotal=buyValueTotal;
					obj1.sellPriceTotal=sellPriceTotal;
					obj1.sellValueTotal=sellValueTotal;

					buyPriceTotal=0;
					buyValueTotal=0;
					sellPriceTotal=0;
					sellValueTotal=0;

					userTradeHistoryGroups.addItem(obj1);

				}
				oldSymbolValue=userTradeHistory.getItemAt(i).SYMBOL_CODE;
			}

			//userTradeHistoryGroups.refresh();
		}

		public function makeUserTradeHistoryAccountGroups(dataFeild:String, decending:Boolean):void
		{
			var sort:Sort=new Sort();
			sort.fields=[new SortField(dataFeild, true, decending), new SortField("SYMBOL_CODE", true, decending)];

			userTradeHistory.sort=sort;
			// Apply the sort to the collection.
			userTradeHistory.refresh();

			var oldSymbolValue:String="";
			var buyPriceSubTotal:Number=0;
			var buyValueSubTotal:Number=0;
			var sellPriceSubTotal:Number=0;
			var sellValueSubTotal:Number=0;

			var oldAccountValue:String="";
			var buyPriceGrandTotal:Number=0;
			var buyValueGrandTotal:Number=0;
			var sellPriceGrandTotal:Number=0;
			var sellValueGrandTotal:Number=0;
			var isAccountChanged:Boolean=false;

			userTradeHistoryGroups.removeAll();

			// Start : added for test
//			var userTradeHistoryGroupsort:Sort = new Sort();
//			userTradeHistoryGroupsort.fields = [new SortField(dataFeild,true, decending)];
//			
//			userTradeHistoryGroups.sort = userTradeHistoryGroupsort;			
//			userTradeHistoryGroups.refresh();
//			
//			
//			
//			userTradeHistoryGroups.sort = new Sort
			//userTradeHistoryGroups.refresh();

			// End : added for test

			for (var i:int=0; i < userTradeHistory.length; ++i)
			{
				var userTradeBO:UserTradeBO=userTradeHistory.getItemAt(i) as UserTradeBO;

				if ((oldAccountValue != "" && userTradeHistory.getItemAt(i).CLIENT_CODE != oldAccountValue))
				{
					oldSymbolValue="";
					isAccountChanged=true;
				}
				if (!isAccountChanged && ((oldSymbolValue != "" && userTradeHistory.getItemAt(i).SYMBOL_CODE == oldSymbolValue) || oldSymbolValue == ""))
				{
					if (userTradeBO.SIDE == "buy")
					{
						//buyPriceSubTotal = buyPriceSubTotal + userTradeBO.PRICE;
						buyPriceSubTotal=buyPriceSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//buyValueSubTotal = buyValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						buyValueSubTotal=buyValueSubTotal + userTradeBO.VOLUME;
					}
					else
					{
						//sellPriceSubTotal = sellPriceSubTotal + userTradeBO.PRICE;
						sellPriceSubTotal=sellPriceSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//sellValueSubTotal = sellValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						sellValueSubTotal=sellValueSubTotal + userTradeBO.VOLUME;
					}
					userTradeHistoryGroups.addItem(userTradeHistory.getItemAt(i));
				}
				else if (!isAccountChanged && ((oldSymbolValue != "" && userTradeHistory.getItemAt(i).SYMBOL_CODE != oldSymbolValue)))
				{
					var obj:UserTradeBO=new UserTradeBO();
					obj.totalTxt="Sub Total";
					obj.summary=true;

					fillSortAtt(obj, userTradeBO, i);

					obj.buyPriceTotal=buyPriceSubTotal;
					obj.buyValueTotal=buyValueSubTotal;
					obj.sellPriceTotal=sellPriceSubTotal;
					obj.sellValueTotal=sellValueSubTotal;

					buyPriceGrandTotal=buyPriceGrandTotal + buyPriceSubTotal;
					buyValueGrandTotal=buyValueGrandTotal + buyValueSubTotal;
					sellPriceGrandTotal=sellPriceGrandTotal + sellPriceSubTotal
					sellValueGrandTotal=sellValueGrandTotal + sellValueSubTotal;

					buyPriceSubTotal=0;
					buyValueSubTotal=0;
					sellPriceSubTotal=0;
					sellValueSubTotal=0;

					userTradeHistoryGroups.addItem(obj);

					if (userTradeBO.SIDE == "buy")
					{
						//buyPriceSubTotal = buyPriceSubTotal + userTradeBO.PRICE;
						buyPriceSubTotal=buyPriceSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//buyValueSubTotal = buyValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						buyValueSubTotal=buyValueSubTotal + userTradeBO.VOLUME;
					}
					else
					{
						//sellPriceSubTotal = sellPriceSubTotal + userTradeBO.PRICE;
						sellPriceSubTotal=sellPriceSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//sellValueSubTotal = sellValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						sellValueSubTotal=sellValueSubTotal + userTradeBO.VOLUME;
					}
					userTradeHistoryGroups.addItem(userTradeHistory.getItemAt(i));

				}

				if (userTradeHistory.length - 1 == i)
				{
					if (isAccountChanged)
					{
						var summaryObj1:UserTradeBO=new UserTradeBO();
						summaryObj1.summary=true;
						summaryObj1.totalTxt="Sub Total";
						fillSortAtt(summaryObj1, userTradeBO, i);
						summaryObj1.buyPriceTotal=buyPriceSubTotal;
						summaryObj1.buyValueTotal=buyValueSubTotal;
						summaryObj1.sellPriceTotal=sellPriceSubTotal;
						summaryObj1.sellValueTotal=sellValueSubTotal;

						buyPriceGrandTotal=buyPriceGrandTotal + buyPriceSubTotal;
						buyValueGrandTotal=buyValueGrandTotal + buyValueSubTotal;
						sellPriceGrandTotal=sellPriceGrandTotal + sellPriceSubTotal
						sellValueGrandTotal=sellValueGrandTotal + sellValueSubTotal;

						buyPriceSubTotal=0;
						buyValueSubTotal=0;
						sellPriceSubTotal=0;
						sellValueSubTotal=0;

						userTradeHistoryGroups.addItem(summaryObj1);


						var grandSummaryObj1:UserTradeBO=new UserTradeBO();
						grandSummaryObj1.totalTxt="G. Total";
						grandSummaryObj1.mainSummary=true;
						grandSummaryObj1.summary=true;
						fillSortAtt(grandSummaryObj1, userTradeBO, i);

						grandSummaryObj1.buyPriceGrandTotal=buyPriceGrandTotal;
						grandSummaryObj1.buyValueGrandTotal=buyValueGrandTotal;
						grandSummaryObj1.sellPriceGrandTotal=sellPriceGrandTotal;
						grandSummaryObj1.sellValueGrandTotal=sellValueGrandTotal;

						buyPriceGrandTotal=0;
						buyValueGrandTotal=0;
						sellPriceGrandTotal=0;
						sellValueGrandTotal=0;

						userTradeHistoryGroups.addItem(grandSummaryObj1);



						if (userTradeBO.SIDE == "buy")
						{
							//buyPriceSubTotal = buyPriceSubTotal + userTradeBO.PRICE;
							buyPriceSubTotal=buyPriceSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
							//buyValueSubTotal = buyValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
							buyValueSubTotal=buyValueSubTotal + userTradeBO.VOLUME;
						}
						else
						{
							//sellPriceSubTotal = sellPriceSubTotal + userTradeBO.PRICE;
							sellPriceSubTotal=sellPriceSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
							//sellValueSubTotal = sellValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
							sellValueSubTotal=sellValueSubTotal + userTradeBO.VOLUME;
						}
						userTradeHistoryGroups.addItem(userTradeHistory.getItemAt(i));
					}

					var obj1:UserTradeBO=new UserTradeBO();
					obj1.summary=true;
					obj1.totalTxt="Sub Total";
					fillSortAtt(obj1, userTradeBO, i);

					obj1.buyPriceTotal=buyPriceSubTotal;
					obj1.buyValueTotal=buyValueSubTotal;
					obj1.sellPriceTotal=sellPriceSubTotal;
					obj1.sellValueTotal=sellValueSubTotal;

					buyPriceGrandTotal=buyPriceGrandTotal + buyPriceSubTotal;
					buyValueGrandTotal=buyValueGrandTotal + buyValueSubTotal;
					sellPriceGrandTotal=sellPriceGrandTotal + sellPriceSubTotal
					sellValueGrandTotal=sellValueGrandTotal + sellValueSubTotal;

					buyPriceSubTotal=0;
					buyValueSubTotal=0;
					sellPriceSubTotal=0;
					sellValueSubTotal=0;

					userTradeHistoryGroups.addItem(obj1);


				}

//				if(!isAccountChanged)
				oldSymbolValue=userTradeHistory.getItemAt(i).SYMBOL_CODE;


//				if((oldAccountValue != "" && userTradeHistory.getItemAt(i).CLIENT_CODE == oldAccountValue) || oldAccountValue == "" )
//				{
////					if(userTradeBO.SIDE == "buy")
////					{
////						buyPriceSubTotal = buyPriceSubTotal + userTradeBO.PRICE;
////						buyValueSubTotal = buyValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
////					}
////					else
////					{
////						sellPriceSubTotal = sellPriceSubTotal + userTradeBO.PRICE;
////						sellValueSubTotal = sellValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
////					}
////					userTradeHistoryGroups.addItem(userTradeHistory.getItemAt(i));					
//				}
				if ((oldAccountValue != "" && userTradeHistory.length - 1 != i && userTradeHistory.getItemAt(i).CLIENT_CODE != oldAccountValue))
				{

					var summaryMiddleObj:UserTradeBO=new UserTradeBO();
					summaryMiddleObj.summary=true;
					summaryMiddleObj.totalTxt="Sub Total";
					fillSortAtt(summaryMiddleObj, userTradeBO, i);

					summaryMiddleObj.buyPriceTotal=buyPriceSubTotal;
					summaryMiddleObj.buyValueTotal=buyValueSubTotal;
					summaryMiddleObj.sellPriceTotal=sellPriceSubTotal;
					summaryMiddleObj.sellValueTotal=sellValueSubTotal;

					buyPriceGrandTotal=buyPriceGrandTotal + buyPriceSubTotal;
					buyValueGrandTotal=buyValueGrandTotal + buyValueSubTotal;
					sellPriceGrandTotal=sellPriceGrandTotal + sellPriceSubTotal
					sellValueGrandTotal=sellValueGrandTotal + sellValueSubTotal;

					buyPriceSubTotal=0;
					buyValueSubTotal=0;
					sellPriceSubTotal=0;
					sellValueSubTotal=0;

					userTradeHistoryGroups.addItem(summaryMiddleObj);


					var grandSummaryObj:UserTradeBO=new UserTradeBO();
					grandSummaryObj.totalTxt="G. Total";
					grandSummaryObj.mainSummary=true;
					grandSummaryObj.summary=true;
					fillSortAtt(grandSummaryObj, userTradeBO, i);

					grandSummaryObj.buyPriceGrandTotal=buyPriceGrandTotal;
					grandSummaryObj.buyValueGrandTotal=buyValueGrandTotal;
					grandSummaryObj.sellPriceGrandTotal=sellPriceGrandTotal;
					grandSummaryObj.sellValueGrandTotal=sellValueGrandTotal;

					buyPriceGrandTotal=0;
					buyValueGrandTotal=0;
					sellPriceGrandTotal=0;
					sellValueGrandTotal=0;

					userTradeHistoryGroups.addItem(grandSummaryObj);
					oldSymbolValue="";
					if (userTradeBO.SIDE == "buy")
					{
						//buyPriceSubTotal = buyPriceSubTotal + userTradeBO.PRICE;
						buyPriceSubTotal=buyPriceSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//buyValueSubTotal = buyValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						buyValueSubTotal=buyValueSubTotal + userTradeBO.VOLUME;
					}
					else
					{
						//sellPriceSubTotal = sellPriceSubTotal + userTradeBO.PRICE;
						sellPriceSubTotal=sellPriceSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						//sellValueSubTotal = sellValueSubTotal + (userTradeBO.PRICE * userTradeBO.VOLUME);
						sellValueSubTotal=sellValueSubTotal + userTradeBO.VOLUME;
					}
					userTradeHistoryGroups.addItem(userTradeHistory.getItemAt(i));
					oldSymbolValue=userTradeHistory.getItemAt(i).SYMBOL_CODE;

				}
				if (userTradeHistory.length - 1 == i)
				{
					var grandSummaryObj2:UserTradeBO=new UserTradeBO();
					grandSummaryObj2.mainSummary=true;
					grandSummaryObj2.summary=true;
					grandSummaryObj2.totalTxt="G. Total";
					fillSortAtt(grandSummaryObj2, userTradeBO, i);

					grandSummaryObj2.buyPriceGrandTotal=buyPriceGrandTotal;
					grandSummaryObj2.buyValueGrandTotal=buyValueGrandTotal;
					grandSummaryObj2.sellPriceGrandTotal=sellPriceGrandTotal;
					grandSummaryObj2.sellValueGrandTotal=sellValueGrandTotal;

					buyPriceGrandTotal=0;
					buyValueGrandTotal=0;
					sellPriceGrandTotal=0;
					sellValueGrandTotal=0;

					userTradeHistoryGroups.addItem(grandSummaryObj2);

				}

				oldAccountValue=userTradeHistory.getItemAt(i).CLIENT_CODE;
				isAccountChanged=false;
			}

//			var userTradeHistoryGroupsort:Sort = new Sort();
//			userTradeHistoryGroupsort.fields = [new SortField(dataFeild,true, decending), new SortField("SYMBOL_CODE",true, decending)];
//			
//			userTradeHistoryGroups.sort = userTradeHistoryGroupsort;
//			
//			//ViewManager.getInstance().userTradeHistory.adgUserTradeHistory.invalidateDisplayList();
//			userTradeHistoryGroups.refresh();
		}

		private function fillSortAtt(summaryObj:Object, userTradeBO:Object, i:int):void
		{
//			summaryObj.SYMBOL_CODE = userTradeBO.SYMBOL_CODE;
//			summaryObj.CLIENT_CODE = userTradeBO.CLIENT_CODE;
//			summaryObj.subTotalNum = i;
//			summaryObj.grandTotalNum = i;
		}

		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}
	}
}
