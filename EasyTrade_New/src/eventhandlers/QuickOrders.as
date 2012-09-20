// ActionScript file

import businessobjects.BestMarketAndSymbolSummaryBO;
import businessobjects.MarketWatchBO;
import businessobjects.OrderBO;
import businessobjects.QuickOrdersBO;
import businessobjects.SymbolBO;

import common.Constants;
import common.Messages;

import components.ComboBoxItem;
import components.DedupeComboBox;
import components.EZCurrencyFormatter;
import components.EZNumberFormatter;

import controller.ModelManager;
import controller.WindowManager;

import flash.events.MouseEvent;

import model.OrderModel;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.effects.easing.*;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.messaging.events.MessageAckEvent;

import services.LSListener;
import services.OrdererClient;

import spark.components.DropDownList;

import view.QuickOrder.*;

[Bindable]
public var selectedIndex:Number=0;

[Bindable]
public var sellText:String;

[Bindable]
public var internalExchangeID:Number=-1;
//public var marketID:Number = -1;
[Bindable]
public var internalMarketID:Number=-1;

private var modelManager:ModelManager=ModelManager.getInstance();
private var flag:Boolean=false;
private var flag2:Boolean=false;
private var flag3:Boolean=false;
private var flag4:Boolean=false;
private var isFirstSubmission:Boolean=true;
private var side:String="";
private var previousNumber:Number=0;
private var globalQuickOrdersBO:QuickOrdersBO;
private var globalQuickOrdersBO2:QuickOrdersBO;
private var globalQuickOrdersBO3:QuickOrdersBO;
private var globalQuickOrdersBO4:QuickOrdersBO;
private var isUpdate:Boolean=false;
private var isUpdate2:Boolean=false;
private var isUpdate3:Boolean=false;
private var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();


//			[Bindable] var splittedSellPrice2:Array;
//			[Bindable] var splittedBuyPrice2:Array;

[Bindable]
[Embed(source="images/alertIcon.png")]
public var alertImg:Class;

protected function creationCompleteHandler(event:FlexEvent):void
{
	mainBorder.setStyle("backgroundColor", 0x000000);
}

private var orderModel_:OrderModel=new OrderModel();

[Bindable]
public function get orderModel():OrderModel
{
	return orderModel_;
}

public function set orderModel(value:OrderModel):void
{
	orderModel_=value;
}

protected function sellButtonClickHandler(event:MouseEvent):void
{
	Alert.show("Do you want to sell this order", "Order Information");
}

protected function symbolDropDownchangeHandler(event:ListEvent):void
{
	if (event.currentTarget.id == "firstSymbolDropDown" && event.currentTarget.dataProvider != null)
	{
		var quickOrdersObject:QuickOrdersBO=event.currentTarget.selectedItem as QuickOrdersBO;
		globalQuickOrdersBO=event.currentTarget.selectedItem as QuickOrdersBO;
		var symbolSubscribed:Boolean=modelManager.quickOrdersModel.isSymbolSubscribed(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.SYMBOL);
		if (symbolSubscribed)
		{
			quickOrdersObject=modelManager.quickOrdersModel.getQuickOrdersBO(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.SYMBOL);
			if (quickOrdersObject)
			{
				//								updateBestMarketOrderFieldsByQOBO(quickOrdersObject);
				modelManager.getBestMarketAndSymbolSummary(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.symbolID, quickOrdersObject.SYMBOL);
			}
			else
			{
				
			}
			//							var arr:Array = WindowManager.getInstance().viewManager.marketWatch.adgMarketWatch.columns;
			//							firstSegmentLowLabel.text
		}
	}
	else
	{
		Alert.show(Messages.NO_SYMBOL_ADDED_TO_DROPDOWN, Messages.TITLE_ERROR);
	}
}


protected function secondsymbolDropDownchangeHandler(event:ListEvent):void
{
	if (event.currentTarget.id == "secondSymbolDropDown" && event.currentTarget.dataProvider != null)
	{
		var quickOrdersObject:QuickOrdersBO=event.currentTarget.selectedItem as QuickOrdersBO;
		globalQuickOrdersBO2=event.currentTarget.selectedItem as QuickOrdersBO;
		var symbolSubscribed:Boolean=modelManager.quickOrdersModel.isSymbolSubscribed(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.SYMBOL);
		if (symbolSubscribed)
		{
			quickOrdersObject=modelManager.quickOrdersModel.getQuickOrdersBO(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.SYMBOL);
			if (quickOrdersObject)
			{
				//								updateBestMarketOrderFieldsByQOBO(quickOrdersObject);
				modelManager.getBestMarketAndSymbolSummary(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.symbolID, quickOrdersObject.SYMBOL);
			}
			else
			{
			}
			//							var arr:Array = WindowManager.getInstance().viewManager.marketWatch.adgMarketWatch.columns;
			//							firstSegmentLowLabel.text
		}
	}
	else
	{
		Alert.show(Messages.NO_SYMBOL_ADDED_TO_DROPDOWN, Messages.TITLE_ERROR);
	}
}

protected function thirdsymbolDropDownchangeHandler(event:ListEvent):void
{
	if (event.currentTarget.id == "thirdSymbolDropDown" && event.currentTarget.dataProvider != null)
	{
		var quickOrdersObject:QuickOrdersBO=event.currentTarget.selectedItem as QuickOrdersBO;
		globalQuickOrdersBO3=event.currentTarget.selectedItem as QuickOrdersBO;
		var symbolSubscribed:Boolean=modelManager.quickOrdersModel.isSymbolSubscribed(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.SYMBOL);
		if (symbolSubscribed)
		{
			quickOrdersObject=modelManager.quickOrdersModel.getQuickOrdersBO(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.SYMBOL);
			if (quickOrdersObject)
			{
				//								updateBestMarketOrderFieldsByQOBO(quickOrdersObject);
				modelManager.getBestMarketAndSymbolSummary(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.symbolID, quickOrdersObject.SYMBOL);
			}
			else
			{
			}
			//							var arr:Array = WindowManager.getInstance().viewManager.marketWatch.adgMarketWatch.columns;
			//							firstSegmentLowLabel.text
		}
	}
	else
	{
		Alert.show(Messages.NO_SYMBOL_ADDED_TO_DROPDOWN, Messages.TITLE_ERROR);
	}
}

protected function fourthsymbolDropDownchangeHandler(event:ListEvent):void
{
	if (event.currentTarget.id == "fourthSymbolDropDown" && event.currentTarget.dataProvider != null)
	{
		var quickOrdersObject:QuickOrdersBO=event.currentTarget.selectedItem as QuickOrdersBO;
		globalQuickOrdersBO4=event.currentTarget.selectedItem as QuickOrdersBO;
		var symbolSubscribed:Boolean=modelManager.quickOrdersModel.isSymbolSubscribed(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.SYMBOL);
		if (symbolSubscribed)
		{
			quickOrdersObject=modelManager.quickOrdersModel.getQuickOrdersBO(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.SYMBOL);
			if (quickOrdersObject)
			{
				//								updateBestMarketOrderFieldsByQOBO(quickOrdersObject);
				modelManager.getBestMarketAndSymbolSummary(quickOrdersObject.internalExchangeID, quickOrdersObject.internalMarketID, quickOrdersObject.symbolID, quickOrdersObject.SYMBOL);
			}
			else
			{
			}
			//							var arr:Array = WindowManager.getInstance().viewManager.marketWatch.adgMarketWatch.columns;
			//							firstSegmentLowLabel.text
		}
	}
	else
	{
		Alert.show(Messages.NO_SYMBOL_ADDED_TO_DROPDOWN, Messages.TITLE_ERROR);
	}
}

protected function firstorderButtonClickHandler(event:MouseEvent):void
{
	firstclientCode.text=firstclientCode.text;
	firstNumericStepper.value=firstNumericStepper.value;
	if (modelManager != null)
		if (firstclientCode.text != "" && firstNumericStepper.value.toString() != "" && firstSymbolDropDown.selectedItem != null)
		{
			var localQuickOrdersBO:QuickOrdersBO=firstSymbolDropDown.selectedItem as QuickOrdersBO;
			var exchangeId:Number=modelManager.exchangeModel.getExchangeID(localQuickOrdersBO.internalExchangeID);
			var marketId:Number=modelManager.exchangeModel.getMarketID(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
			var symbolId:Number=(modelManager.exchangeModel.getSymbolByCode(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID, localQuickOrdersBO.SYMBOL) as SymbolBO).SYMBOL_ID;
			
			var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
			var delimRegExp:RegExp=/,/g;
			var volume:Number=new Number(firstNumericStepper.value.toString().replace(delimRegExp, ""));
			
			if (volume.toString() == "" && firstclientCode.text == "")
			{
				Alert.show(Messages.INVALID_INPUT, Messages.TITLE_ERROR);
			}
			if (exchangeId > -1 && marketId > -1 && symbolId > -1)
			{
				var key:String=exchangeId + "_" + marketId + "_" + symbolId;
				var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO=modelManager.bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
				var symbol:SymbolBO=modelManager.exchangeModel.getSymbolDetail(exchangeId, marketId, symbolId) as SymbolBO;
				if (volume < symbol.LOWER_ORDER_VOLUME_LIMIT || volume > symbol.UPPER_ORDER_VOLUME_LIMIT)
				{
					Alert.show("Volume limits are " + symbol.LOWER_ORDER_VOLUME_LIMIT + " - " + symbol.UPPER_ORDER_VOLUME_LIMIT, Messages.TITLE_ERROR);
					firstNumericStepper.setFocus();
					return;
				}
				
				if (!((volume / symbol.BOARD_LOT) is uint))
				{
					Alert.show("Volume lot size is  " + symbol.BOARD_LOT, Messages.TITLE_ERROR);
					firstNumericStepper.setFocus();
					return;
				}
				
				var marketState:Number=modelManager.exchangeModel.getMarketState(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
				var unit:String='share';
				var isBond:Boolean=modelManager.exchangeModel.isBondMarket(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
				var buyPrice:Number = parseFloat(firstBuyBeforeDecimal.text+firstBuyAfterDecimal.text);
				var sellPrice:Number = parseFloat(firstSellBeforeDecimal.text+firstSellAfterDecimal.text);
				if (isBond)
					unit="bond";
				if (modelManager.bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.hasKey(key))
				{
					orderModel_.orderBO.SIDE="";
					if (bestMarketAndSymbolSummary)
					{
						if (event.currentTarget.id == "buyButton" && bestMarketAndSymbolSummary.bestMarket.buyOrderBO != null && firstBuyBeforeDecimal.text != "" && firstBuyAfterDecimal.text != "" && firstSellBeforeDecimal.text != "" && firstSellAfterDecimal.text != "")
						{
							orderModel_.orderBO.SIDE="buy";
							orderModel_.orderBO.PRICE=sellPrice;
							orderModel_.orderBO.VOLUME=volume;
							orderModel_.orderBO.TRAILING_STOPLOSS_DIP=sellPrice;
							if (orderModel_.orderBO.SIDE == "buy")
							{
								Alert.show("BUY " + firstNumericStepper.value.toString() + unit + "s  of " + localQuickOrdersBO.SYMBOL + " at " + orderModel_.orderBO.PRICE + " per " +unit+"?", Messages.INFORMATION,Alert.OK|Alert.CANCEL,this,subMissionFunction,alertImg,Alert.OK);
							}
						}
						else if (event.currentTarget.id == "sellButton" && bestMarketAndSymbolSummary.bestMarket.sellOrderBO != null && firstSellBeforeDecimal.text != "" && firstSellAfterDecimal.text != "" && firstBuyBeforeDecimal.text != "" && firstBuyAfterDecimal.text != "")
						{
							orderModel_.orderBO.SIDE="sell";
							orderModel_.orderBO.PRICE=buyPrice;
							orderModel_.orderBO.TRAILING_STOPLOSS_DIP=buyPrice;
							orderModel_.orderBO.VOLUME=volume;
							if (orderModel_.orderBO.SIDE == "sell" )
							{
								Alert.show("SELL " + firstNumericStepper.value.toString() + unit + "s  of " + localQuickOrdersBO.SYMBOL + " at " + orderModel_.orderBO.PRICE + " per " + unit+"?", Messages.INFORMATION,Alert.OK|Alert.CANCEL,this,subMissionFunction,alertImg,Alert.OK);
							}
						}
						else
						{
							Alert.show("No Order could be placed with empty value for symbol "+ localQuickOrdersBO.SYMBOL,Messages.TITLE_ERROR);
						}
					}
				}
			}
			function subMissionFunction(eventObj:CloseEvent):void
			{
				if(eventObj.detail==Alert.OK)
					
				{
					var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
					orderModel_.orderBO.ENTRY_DATETIME=new Date();
					orderModel_.orderBO.IS_SHORT=false;
					orderModel_.orderBO.EXCHANGE_ID=modelManager.exchangeModel.getExchangeID(localQuickOrdersBO.internalExchangeID);
					orderModel_.orderBO.MARKET_ID=ModelManager.getInstance().exchangeModel.getMarketID(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
					orderModel_.orderBO.SYMBOL=localQuickOrdersBO.SYMBOL;
					orderModel_.orderBO.INTERNAL_EXCHANGE_ID=localQuickOrdersBO.internalExchangeID;
					orderModel_.orderBO.INTERNAL_MARKET_ID=localQuickOrdersBO.internalMarketID;
					orderModel_.orderBO.INTERNAL_SYMBOL_ID=modelManager.exchangeModel.getInternalSymbolIDByCode(orderModel_.orderBO.INTERNAL_EXCHANGE_ID, orderModel_.orderBO.INTERNAL_MARKET_ID, orderModel_.orderBO.SYMBOL);
					orderModel_.orderBO.SYMBOL_ID=modelManager.exchangeModel.getSymbolID(orderModel_.orderBO.INTERNAL_EXCHANGE_ID, orderModel_.orderBO.INTERNAL_MARKET_ID, orderModel_.orderBO.INTERNAL_SYMBOL_ID);
					
					orderModel_.orderBO.CLIENT_CODE=firstclientCode.text;
					orderModel_.orderBO.BROKER_ID=modelManager.brokerID;
					orderModel_.orderBO.SENDER_USER_ID=modelManager.userID;
					orderModel_.orderBO.USER_ID=modelManager.userID;
					orderModel_.orderBO.PUBLIC_ORDER_STATE="Submit";
					orderModel_.orderBO.PRIVATE_ORDER_STATE="UnExecuted";
					orderModel_.orderBO.PRICE_TYPE="limit";
					
					flag=true;
					OrdererClient.getInstance().submitQuickOrder(orderModel_.orderBO);
				}
				else if(eventObj.detail==Alert.CANCEL)
					
				{
					
				}
			}
		}
		else
		{
			Alert.show("Please correct the input.", Messages.INFORMATION);
			firstclientCode.setFocus();
		}
}

protected function secondorderButtonClickHandler(event:MouseEvent):void
{
	secondclientCode.text=secondclientCode.text;
	secondNumericStepper.value=secondNumericStepper.value;
	if (modelManager != null)
		if (secondclientCode.text != "" && secondNumericStepper.value.toString() != "" && secondSymbolDropDown.selectedItem != null)
		{
			var localQuickOrdersBO:QuickOrdersBO=secondSymbolDropDown.selectedItem as QuickOrdersBO;
			var exchangeId:Number=modelManager.exchangeModel.getExchangeID(localQuickOrdersBO.internalExchangeID);
			var marketId:Number=modelManager.exchangeModel.getMarketID(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
			var symbolId:Number=(modelManager.exchangeModel.getSymbolByCode(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID, localQuickOrdersBO.SYMBOL) as SymbolBO).SYMBOL_ID;
			
			var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
			var delimRegExp:RegExp=/,/g;
			var volume:Number=new Number(secondNumericStepper.value.toString().replace(delimRegExp, ""));
			
			if (volume.toString() == "" && secondclientCode.text == "")
			{
				Alert.show(Messages.INVALID_INPUT, Messages.TITLE_ERROR);
			}
			if (exchangeId > -1 && marketId > -1 && symbolId > -1)
			{
				var key:String=exchangeId + "_" + marketId + "_" + symbolId;
				
				var symbol:SymbolBO=modelManager.exchangeModel.getSymbolDetail(exchangeId, marketId, symbolId) as SymbolBO;
				if (volume < symbol.LOWER_ORDER_VOLUME_LIMIT || volume > symbol.UPPER_ORDER_VOLUME_LIMIT)
				{
					Alert.show("Volume limits are " + symbol.LOWER_ORDER_VOLUME_LIMIT + " - " + symbol.UPPER_ORDER_VOLUME_LIMIT, Messages.TITLE_ERROR);
					secondNumericStepper.setFocus();
					return;
				}
				
				if (!((volume / symbol.BOARD_LOT) is uint))
				{
					Alert.show("Volume lot size is  " + symbol.BOARD_LOT, Messages.TITLE_ERROR);
					secondNumericStepper.setFocus();
					return;
				}
				
				var marketState:Number=modelManager.exchangeModel.getMarketState(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
				var unit:String='share';
				var isBond:Boolean=modelManager.exchangeModel.isBondMarket(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
				var buyPrice:Number = parseFloat(secondBuyBeforeDecimal.text+secondBuyAfterDecimal.text);
				var sellPrice:Number = parseFloat(secondSellBeforeDecimal.text+secondSellAfterDecimal.text);
				if (isBond)
					unit="bond";
				if (modelManager.bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.hasKey(key))
				{
					orderModel_.orderBO.SIDE="";
					var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO=modelManager.bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
					if (bestMarketAndSymbolSummary)
					{
						if (event.currentTarget.id == "secondBuyButton" && bestMarketAndSymbolSummary.bestMarket.buyOrderBO != null && secondBuyBeforeDecimal.text != "" && secondBuyAfterDecimal.text != "" && secondSellBeforeDecimal.text != "" && secondSellAfterDecimal.text != "")
						{
							orderModel_.orderBO.SIDE="buy";
							orderModel_.orderBO.PRICE=sellPrice
							orderModel_.orderBO.VOLUME=volume;
							orderModel_.orderBO.TRAILING_STOPLOSS_DIP=sellPrice;
							if (orderModel_.orderBO.SIDE == "buy")
							{
								Alert.show("BUY " + secondNumericStepper.value.toString() + unit + "s  of " + localQuickOrdersBO.SYMBOL + " at " + orderModel_.orderBO.PRICE + " per " + unit+"?", Messages.INFORMATION,Alert.OK|Alert.CANCEL,this,subMissionFunction,alertImg,Alert.OK);
							}
						}
						else if (event.currentTarget.id == "secondSellButton" && bestMarketAndSymbolSummary.bestMarket.sellOrderBO != null && secondSellBeforeDecimal.text != "" && secondSellAfterDecimal.text != "" && secondBuyBeforeDecimal.text != "" && secondBuyAfterDecimal.text != "")
						{
							orderModel_.orderBO.SIDE="sell";
							orderModel_.orderBO.PRICE=buyPrice;
							orderModel_.orderBO.TRAILING_STOPLOSS_DIP=buyPrice;
							orderModel_.orderBO.VOLUME=volume;
							if (orderModel_.orderBO.SIDE == "sell")
							{
								Alert.show("SELL " + secondNumericStepper.value.toString() + unit + "s  of " + localQuickOrdersBO.SYMBOL + " at " + orderModel_.orderBO.PRICE + " per " +  unit+"?", Messages.INFORMATION,Alert.OK|Alert.CANCEL,this,subMissionFunction,alertImg,Alert.OK);
							}
						}
						else
						{
							Alert.show("No Order could be placed with empty value for symbol "+ localQuickOrdersBO.SYMBOL,Messages.TITLE_ERROR);
						}
					}
				}
			}
			function subMissionFunction(eventObj:CloseEvent):void
			{
				if(eventObj.detail==Alert.OK)
					
				{
					var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
					orderModel_.orderBO.ENTRY_DATETIME=new Date();
					orderModel_.orderBO.IS_SHORT=false;
					orderModel_.orderBO.EXCHANGE_ID=modelManager.exchangeModel.getExchangeID(localQuickOrdersBO.internalExchangeID);
					orderModel_.orderBO.MARKET_ID=ModelManager.getInstance().exchangeModel.getMarketID(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
					orderModel_.orderBO.SYMBOL=localQuickOrdersBO.SYMBOL;
					orderModel_.orderBO.INTERNAL_EXCHANGE_ID=localQuickOrdersBO.internalExchangeID;
					orderModel_.orderBO.INTERNAL_MARKET_ID=localQuickOrdersBO.internalMarketID;
					orderModel_.orderBO.INTERNAL_SYMBOL_ID=modelManager.exchangeModel.getInternalSymbolIDByCode(orderModel_.orderBO.INTERNAL_EXCHANGE_ID, orderModel_.orderBO.INTERNAL_MARKET_ID, orderModel_.orderBO.SYMBOL);
					
					orderModel_.orderBO.SYMBOL_ID=modelManager.exchangeModel.getSymbolID(orderModel_.orderBO.INTERNAL_EXCHANGE_ID, orderModel_.orderBO.INTERNAL_MARKET_ID, orderModel_.orderBO.INTERNAL_SYMBOL_ID);
					
					
					orderModel_.orderBO.CLIENT_CODE=secondclientCode.text;
					orderModel_.orderBO.BROKER_ID=modelManager.brokerID;
					orderModel_.orderBO.SENDER_USER_ID=modelManager.userID;
					orderModel_.orderBO.USER_ID=modelManager.userID;
					orderModel_.orderBO.PUBLIC_ORDER_STATE="Submit";
					orderModel_.orderBO.PRIVATE_ORDER_STATE="UnExecuted";
					orderModel_.orderBO.PRICE_TYPE="limit";
					
					flag=true;
					OrdererClient.getInstance().submitQuickOrder(orderModel_.orderBO);
				}
				else
				{
					
				}
				
			}
			
		}
		else
		{
			Alert.show("Please correct the input.", Messages.INFORMATION);
			secondclientCode.setFocus();
		}
}

public function quikcOrdersLiveValues(itemName:String, itemPos:Number, updatedFields:Array, index:Number):void
{
	//				var ezCurrencyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
	//				splittedSellPrice2=ezCurrencyFormatter.format(LSListener.extractFieldData(updatedFields, 5, index)).toString().split(".");
	//				splittedBuyPrice2=ezCurrencyFormatter.format(LSListener.extractFieldData(updatedFields, 1, index)).toString().split(".");
}

protected function thirdorderButtonClickHandler(event:MouseEvent):void
{
	thirdclientCode.text=thirdclientCode.text;
	thirdNumericStepper.value=thirdNumericStepper.value;
	if (modelManager != null)
		if (thirdclientCode.text != "" && thirdNumericStepper.value.toString() != "" && thirdSymbolDropDown.selectedItem != null)
		{
			var localQuickOrdersBO:QuickOrdersBO=thirdSymbolDropDown.selectedItem as QuickOrdersBO;
			var exchangeId:Number=modelManager.exchangeModel.getExchangeID(localQuickOrdersBO.internalExchangeID);
			var marketId:Number=modelManager.exchangeModel.getMarketID(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
			var symbolId:Number=(modelManager.exchangeModel.getSymbolByCode(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID, localQuickOrdersBO.SYMBOL) as SymbolBO).SYMBOL_ID;
			
			var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
			var delimRegExp:RegExp=/,/g;
			var volume:Number=new Number(thirdNumericStepper.value.toString().replace(delimRegExp, ""));
			
			if (volume.toString() == "" && secondclientCode.text == "")
			{
				Alert.show(Messages.INVALID_INPUT, Messages.TITLE_ERROR);
			}
			if (exchangeId > -1 && marketId > -1 && symbolId > -1)
			{
				var key:String=exchangeId + "_" + marketId + "_" + symbolId;
				
				var symbol:SymbolBO=modelManager.exchangeModel.getSymbolDetail(exchangeId, marketId, symbolId) as SymbolBO;
				if (volume < symbol.LOWER_ORDER_VOLUME_LIMIT || volume > symbol.UPPER_ORDER_VOLUME_LIMIT)
				{
					Alert.show("Volume limits are " + symbol.LOWER_ORDER_VOLUME_LIMIT + " - " + symbol.UPPER_ORDER_VOLUME_LIMIT, Messages.TITLE_ERROR);
					thirdNumericStepper.setFocus();
					return;
				}
				
				if (!((volume / symbol.BOARD_LOT) is uint))
				{
					Alert.show("Volume lot size is  " + symbol.BOARD_LOT, Messages.TITLE_ERROR);
					thirdNumericStepper.setFocus();
					return;
				}
				
				var marketState:Number=modelManager.exchangeModel.getMarketState(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
				var unit:String='share';
				var isBond:Boolean=modelManager.exchangeModel.isBondMarket(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
				var buyPrice:Number = parseFloat(thirdBuyBeforeDecimal.text+thirdBuyAfterDecimal.text);
				var sellPrice:Number = parseFloat(thirdSellBeforeDecimal.text+thirdSellAfterDecimal.text);
				if (isBond)
					unit="bond";
				if (modelManager.bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.hasKey(key))
				{
					orderModel_.orderBO.SIDE="";
					var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO=modelManager.bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
					if (bestMarketAndSymbolSummary)
					{
						if (event.currentTarget.id == "thirdBuyButton" && bestMarketAndSymbolSummary.bestMarket.buyOrderBO != null  && thirdBuyBeforeDecimal.text != "" && thirdBuyAfterDecimal.text != ""  && thirdSellBeforeDecimal.text != "" && thirdSellAfterDecimal.text != "")
						{
							orderModel_.orderBO.SIDE="buy";
							orderModel_.orderBO.PRICE=sellPrice;
							orderModel_.orderBO.VOLUME=volume;
							orderModel_.orderBO.TRAILING_STOPLOSS_DIP=sellPrice;
							if (orderModel_.orderBO.SIDE == "buy")
							{
								Alert.show("BUY " + thirdNumericStepper.value.toString() + unit + "s  of " + localQuickOrdersBO.SYMBOL + " at " + orderModel_.orderBO.PRICE + " per " + unit+"?", Messages.INFORMATION,Alert.OK|Alert.CANCEL,this,subMissionFunction,alertImg,Alert.OK);
							}
						}
						else if (event.currentTarget.id == "thirdSellButton" && bestMarketAndSymbolSummary.bestMarket.sellOrderBO != null  && thirdSellBeforeDecimal.text != "" && thirdSellAfterDecimal.text != "" && thirdBuyBeforeDecimal.text != "" && thirdBuyAfterDecimal.text != "")
						{
							orderModel_.orderBO.SIDE="sell";
							orderModel_.orderBO.PRICE=buyPrice;
							orderModel_.orderBO.TRAILING_STOPLOSS_DIP=buyPrice;
							orderModel_.orderBO.VOLUME=volume;
							if (orderModel_.orderBO.SIDE == "sell")
							{
								Alert.show("SELL " + thirdNumericStepper.value.toString() + unit + "s  of " + localQuickOrdersBO.SYMBOL + " at " + orderModel_.orderBO.PRICE + " per " + unit+"?", Messages.INFORMATION,Alert.OK|Alert.CANCEL,this,subMissionFunction,alertImg,Alert.OK);
							}
						}
						else
						{
							Alert.show("No Order could be placed with empty value for symbol "+ localQuickOrdersBO.SYMBOL,Messages.TITLE_ERROR);
						}
					}
				}
			}
			function subMissionFunction(eventObj:CloseEvent):void
			{
				if(eventObj.detail==Alert.OK)
					
				{
					var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
					orderModel_.orderBO.ENTRY_DATETIME=new Date();
					orderModel_.orderBO.IS_SHORT=false;
					orderModel_.orderBO.EXCHANGE_ID=modelManager.exchangeModel.getExchangeID(localQuickOrdersBO.internalExchangeID);
					orderModel_.orderBO.MARKET_ID=ModelManager.getInstance().exchangeModel.getMarketID(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
					orderModel_.orderBO.SYMBOL=localQuickOrdersBO.SYMBOL;
					orderModel_.orderBO.INTERNAL_EXCHANGE_ID=localQuickOrdersBO.internalExchangeID;
					orderModel_.orderBO.INTERNAL_MARKET_ID=localQuickOrdersBO.internalMarketID;
					orderModel_.orderBO.INTERNAL_SYMBOL_ID=modelManager.exchangeModel.getInternalSymbolIDByCode(orderModel_.orderBO.INTERNAL_EXCHANGE_ID, orderModel_.orderBO.INTERNAL_MARKET_ID, orderModel_.orderBO.SYMBOL);
					orderModel_.orderBO.SYMBOL_ID=modelManager.exchangeModel.getSymbolID(orderModel_.orderBO.INTERNAL_EXCHANGE_ID, orderModel_.orderBO.INTERNAL_MARKET_ID, orderModel_.orderBO.INTERNAL_SYMBOL_ID);
					orderModel_.orderBO.CLIENT_CODE=thirdclientCode.text;
					orderModel_.orderBO.BROKER_ID=modelManager.brokerID;
					orderModel_.orderBO.SENDER_USER_ID=modelManager.userID;
					orderModel_.orderBO.USER_ID=modelManager.userID;
					orderModel_.orderBO.PUBLIC_ORDER_STATE="Submit";
					orderModel_.orderBO.PRIVATE_ORDER_STATE="UnExecuted";
					orderModel_.orderBO.PRICE_TYPE="limit";
					
					flag=true;
					OrdererClient.getInstance().submitQuickOrder(orderModel_.orderBO);
				}
			}
		}
		else
		{
			Alert.show("Please correct the input.", Messages.INFORMATION);
			thirdclientCode.setFocus();
		}
}

protected function fourthorderButtonClickHandler(event:MouseEvent):void
{
	fourthclientCode.text=fourthclientCode.text;
	fourthNumericStepper.value=fourthNumericStepper.value;
	if (modelManager != null)
		if (fourthclientCode.text != "" && fourthNumericStepper.value.toString() != "" && fourthSymbolDropDown.selectedItem != null)
		{
			var localQuickOrdersBO:QuickOrdersBO=fourthSymbolDropDown.selectedItem as QuickOrdersBO;
			var exchangeId:Number=modelManager.exchangeModel.getExchangeID(localQuickOrdersBO.internalExchangeID);
			var marketId:Number=modelManager.exchangeModel.getMarketID(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
			var symbolId:Number=(modelManager.exchangeModel.getSymbolByCode(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID, localQuickOrdersBO.SYMBOL) as SymbolBO).SYMBOL_ID;
			
			var moneyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
			var delimRegExp:RegExp=/,/g;
			var volume:Number=new Number(fourthNumericStepper.value.toString().replace(delimRegExp, ""));
			
			if (volume.toString() == "" && fourthclientCode.text == "")
			{
				Alert.show(Messages.INVALID_INPUT, Messages.TITLE_ERROR);
			}
			if (exchangeId > -1 && marketId > -1 && symbolId > -1)
			{
				var key:String=exchangeId + "_" + marketId + "_" + symbolId;
				
				var symbol:SymbolBO=modelManager.exchangeModel.getSymbolDetail(exchangeId, marketId, symbolId) as SymbolBO;
				if (volume < symbol.LOWER_ORDER_VOLUME_LIMIT || volume > symbol.UPPER_ORDER_VOLUME_LIMIT)
				{
					Alert.show("Volume limits are " + symbol.LOWER_ORDER_VOLUME_LIMIT + " - " + symbol.UPPER_ORDER_VOLUME_LIMIT, Messages.TITLE_ERROR);
					fourthNumericStepper.setFocus();
					return;
				}
				
				if (!((volume / symbol.BOARD_LOT) is uint))
				{
					Alert.show("Volume lot size is  " + symbol.BOARD_LOT, Messages.TITLE_ERROR);
					fourthNumericStepper.setFocus();
					return;
				}
				
				var marketState:Number=modelManager.exchangeModel.getMarketState(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
				var unit:String='share';
				var isBond:Boolean=modelManager.exchangeModel.isBondMarket(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
				var buyPrice:Number = parseFloat(fourthBuyBeforeDecimal.text+fourthBuyAfterDecimal.text);
				var sellPrice:Number = parseFloat(fourthSellBeforeDecimal.text+fourthSellAfterDecimal.text);
				if (isBond)
					unit="bond";
				if (modelManager.bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.hasKey(key))
				{
					orderModel_.orderBO.SIDE="";
					var bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO=modelManager.bestMarketAndSymbolSummaryModel.bestMarketAndSymbolSummaryMap.getItem(key) as BestMarketAndSymbolSummaryBO;
					if (bestMarketAndSymbolSummary)
					{ 
						if (event.currentTarget.id == "fourthBuyButton" && bestMarketAndSymbolSummary.bestMarket.buyOrderBO != null  && fourthBuyBeforeDecimal.text != "" && fourthBuyAfterDecimal.text != "" && fourthSellBeforeDecimal.text != "" && fourthSellAfterDecimal.text != "")
						{
							orderModel_.orderBO.SIDE="buy";
							orderModel_.orderBO.PRICE=sellPrice;
							orderModel_.orderBO.VOLUME=volume;
							orderModel_.orderBO.TRAILING_STOPLOSS_DIP=sellPrice;
							if (orderModel_.orderBO.SIDE == "buy")
							{
								Alert.show("BUY " + fourthNumericStepper.value.toString() + unit + "s  of " + localQuickOrdersBO.SYMBOL + " at " + orderModel_.orderBO.PRICE + " per " + unit+"?", Messages.INFORMATION,Alert.OK|Alert.CANCEL,this,subMissionFunction,alertImg,Alert.OK);
							}
						}
						else if (event.currentTarget.id == "fourthSellButton" && bestMarketAndSymbolSummary.bestMarket.sellOrderBO != null && fourthSellBeforeDecimal.text != "" && fourthSellAfterDecimal.text != "" && fourthBuyBeforeDecimal.text != "" && fourthBuyAfterDecimal.text != "")
						{
							orderModel_.orderBO.SIDE="sell";
							orderModel_.orderBO.PRICE=buyPrice;
							orderModel_.orderBO.TRAILING_STOPLOSS_DIP=buyPrice;
							orderModel_.orderBO.VOLUME=volume;
							if (orderModel_.orderBO.SIDE == "sell")
							{
								Alert.show("SELL " + fourthNumericStepper.value.toString() + unit + "s  of " + localQuickOrdersBO.SYMBOL + " at " + orderModel_.orderBO.PRICE + " per " +  unit +"?", Messages.INFORMATION,Alert.OK|Alert.CANCEL,this,subMissionFunction,alertImg,Alert.OK);
							}
						}
						else
						{
							Alert.show("No Order could be placed with empty value for symbol "+ localQuickOrdersBO.SYMBOL,Messages.TITLE_ERROR);
						}
					}
				}
			}
			
			function subMissionFunction(eventObj:CloseEvent):void
			{
				if(eventObj.detail==Alert.OK)
					
				{
					var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
					orderModel_.orderBO.ENTRY_DATETIME=new Date();
					orderModel_.orderBO.IS_SHORT=false;
					orderModel_.orderBO.EXCHANGE_ID=modelManager.exchangeModel.getExchangeID(localQuickOrdersBO.internalExchangeID);
					orderModel_.orderBO.MARKET_ID=ModelManager.getInstance().exchangeModel.getMarketID(localQuickOrdersBO.internalExchangeID, localQuickOrdersBO.internalMarketID);
					orderModel_.orderBO.SYMBOL=localQuickOrdersBO.SYMBOL;
					orderModel_.orderBO.INTERNAL_EXCHANGE_ID=localQuickOrdersBO.internalExchangeID;
					orderModel_.orderBO.INTERNAL_MARKET_ID=localQuickOrdersBO.internalMarketID;
					orderModel_.orderBO.INTERNAL_SYMBOL_ID=modelManager.exchangeModel.getInternalSymbolIDByCode(orderModel_.orderBO.INTERNAL_EXCHANGE_ID, orderModel_.orderBO.INTERNAL_MARKET_ID, orderModel_.orderBO.SYMBOL);
					orderModel_.orderBO.SYMBOL_ID=modelManager.exchangeModel.getSymbolID(orderModel_.orderBO.INTERNAL_EXCHANGE_ID, orderModel_.orderBO.INTERNAL_MARKET_ID, orderModel_.orderBO.INTERNAL_SYMBOL_ID);
					orderModel_.orderBO.CLIENT_CODE=fourthclientCode.text;
					orderModel_.orderBO.BROKER_ID=modelManager.brokerID;
					orderModel_.orderBO.SENDER_USER_ID=modelManager.userID;
					orderModel_.orderBO.USER_ID=modelManager.userID;
					orderModel_.orderBO.PUBLIC_ORDER_STATE="Submit";
					orderModel_.orderBO.PRIVATE_ORDER_STATE="UnExecuted";
					orderModel_.orderBO.PRICE_TYPE="limit";
					
					flag=true;
					OrdererClient.getInstance().submitQuickOrder(orderModel_.orderBO);
				}
			}
		}
		else
		{
			Alert.show("Please correct the input.", Messages.INFORMATION);
			fourthclientCode.setFocus();
		}
}

public function updateBestMarketOrderFieldsByQOBO(qoBO:QuickOrdersBO):void
{
	if (firstSegmentLowLabel)
	{
		firstSegmentLowLabel.text=qoBO.LOW;
	}
}

public function updateQuickOrderView(bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO, bestBuyPrice:Number, bestSellPrice:Number):void
{
	try
	{
		if (flag == true && firstSymbolDropDown.selectedIndex != -1 &&
			(firstSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName 
			&&
			(firstSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName 
			&&
			(firstSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName
		)
		{
			var splittedBuyPrice:Array=bestBuyPrice.toString().split(".");
			var splittedSellPrice:Array=bestSellPrice.toString().split(".");
			var localQuickOrdersBO:QuickOrdersBO=firstSymbolDropDown.selectedItem as QuickOrdersBO;
			if (bestMarketAndSymbolSummary.symbolName == localQuickOrdersBO.SYMBOL)
			{
				if (bestMarketAndSymbolSummary.symbolSummary)
				{
					if (splittedSellPrice || splittedBuyPrice)
					{
						firstBuyBeforeDecimal.text=(splittedBuyPrice[0] != null && !isNaN(splittedBuyPrice[0]) ? splittedBuyPrice[0] : splittedBuyPrice[0]="");
						firstBuyAfterDecimal.text="." + (splittedBuyPrice[1] != null && !isNaN(splittedBuyPrice[1]) ? splittedBuyPrice[1] : "");
						firstSellBeforeDecimal.text=(splittedSellPrice[0] != null && !isNaN(splittedSellPrice[0]) ? splittedSellPrice[0] : splittedSellPrice[0]="");
						firstSellAfterDecimal.text="." + (splittedSellPrice[1] != null && !isNaN(splittedSellPrice[1]) ? splittedSellPrice[1] : "");
						firstSegmentLowLabel.text=(bestMarketAndSymbolSummary.symbolSummary.stats.low.toString() != null ? bestMarketAndSymbolSummary.symbolSummary.stats.low.toString().slice(0, 4) : "");
						firstHighValue.text=(bestMarketAndSymbolSummary.symbolSummary.stats.high.toString() != null ? bestMarketAndSymbolSummary.symbolSummary.stats.high.toString().slice(0, 4) : "");
						if (bestMarketAndSymbolSummary.symbolSummary.stats && bestMarketAndSymbolSummary.symbolSummary.stats.netChange < 0)
						{
							firstChangeValue.setStyle("backgroundColor", 0xdf241d);
							firstChangeValue.text="-" + bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						if (bestMarketAndSymbolSummary.symbolSummary.stats && bestMarketAndSymbolSummary.symbolSummary.stats.netChange > 0)
						{
							firstChangeValue.setStyle("backgroundColor", 0x01e92a);
							firstChangeValue.text="+" + bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						if (bestMarketAndSymbolSummary.symbolSummary.stats && bestMarketAndSymbolSummary.symbolSummary.stats.netChange == previousNumber)
						{
							firstChangeValue.setStyle("backgroundColor", 0xffffff);
							firstChangeValue.text=bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						previousNumber=bestMarketAndSymbolSummary.symbolSummary.stats.netChange;
					}
					else
					{
					}
				}
				else
				{
					firstBuyBeforeDecimal.text="";
					firstBuyAfterDecimal.text="";
					firstSellBeforeDecimal.text="";
					firstSellAfterDecimal.text="";
					firstSegmentLowLabel.text="";
					firstHighValue.text="";
				}
			}
		}
		else
		{
			flag=true;
		}
	}
	catch (e:Error)
	{
		trace(e.message.toString());
	}
}

public function secondupdateQuickOrderView(bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO, bestBuyPrice:Number, bestSellPrice:Number):void
{
	try
	{
		if (flag2 == true  && secondSymbolDropDown.selectedIndex != -1 &&
			(secondSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName 
			&&
			(secondSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName 
			&&
			(secondSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName)
		{
			var splittedBuyPrice:Array=bestBuyPrice.toString().split(".");
			var splittedSellPrice:Array=bestSellPrice.toString().split(".");
			var localQuickOrdersBO:QuickOrdersBO=secondSymbolDropDown.selectedItem as QuickOrdersBO;
			if (bestMarketAndSymbolSummary.symbolName == localQuickOrdersBO.SYMBOL)
			{
				if (bestMarketAndSymbolSummary.symbolSummary)
				{
					if (splittedSellPrice || splittedBuyPrice)
					{
						secondBuyBeforeDecimal.text=(splittedBuyPrice[0] != null && !isNaN(splittedBuyPrice[0]) ? splittedBuyPrice[0] : splittedBuyPrice[0]="");
						secondBuyAfterDecimal.text="." + (splittedBuyPrice[1] != null && !isNaN(splittedBuyPrice[1]) ? splittedBuyPrice[1] : "");
						secondSellBeforeDecimal.text=(splittedSellPrice[0] != null && !isNaN(splittedSellPrice[0]) ? splittedSellPrice[0] : splittedSellPrice[0]="");
						secondSellAfterDecimal.text="." + (splittedSellPrice[1] != null && !isNaN(splittedSellPrice[1]) ? splittedSellPrice[1] : "");
						secondSegmentLowLabel.text=(bestMarketAndSymbolSummary.symbolSummary.stats.low.toString() != null ? bestMarketAndSymbolSummary.symbolSummary.stats.low.toString().slice(0, 4) : "");
						secondHighValue.text=(bestMarketAndSymbolSummary.symbolSummary.stats.high.toString() != null ? bestMarketAndSymbolSummary.symbolSummary.stats.high.toString().slice(0, 4) : "");
						if (bestMarketAndSymbolSummary.symbolSummary.stats && bestMarketAndSymbolSummary.symbolSummary.stats.netChange < 0)
						{
							secondChangeValue.setStyle("backgroundColor", 0xdf241d);
							secondChangeValue.text="-" + bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						if (bestMarketAndSymbolSummary.symbolSummary.stats && bestMarketAndSymbolSummary.symbolSummary.stats.netChange > 0)
						{
							secondChangeValue.setStyle("backgroundColor", 0x01e92a);
							secondChangeValue.text="+" + bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						if (bestMarketAndSymbolSummary.symbolSummary.stats && bestMarketAndSymbolSummary.symbolSummary.stats.netChange == previousNumber)
						{
							secondChangeValue.setStyle("backgroundColor", 0xffffff);
							secondChangeValue.text=bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						previousNumber=bestMarketAndSymbolSummary.symbolSummary.stats.netChange;
					}
					else
					{
					}
				}
				else
				{
					secondBuyBeforeDecimal.text="";
					secondBuyAfterDecimal.text="";
					secondSellBeforeDecimal.text="";
					secondSellAfterDecimal.text="";
					secondSegmentLowLabel.text="";
					secondHighValue.text="";
				}
			}
		}
		else
		{
			flag2=true;
		}
	}
	catch (e:Error)
	{
		trace(e.message.toString());
	}
}

public function thirdupdateQuickOrderView(bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO, bestBuyPrice:Number, bestSellPrice:Number):void
{
	try
	{
		if (flag3 == true && thirdSymbolDropDown.selectedIndex != -1 &&
			(thirdSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName 
			&&
			(thirdSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName 
			&&
			(thirdSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName)
		{
			var splittedBuyPrice:Array=bestBuyPrice.toString().split(".");
			var splittedSellPrice:Array=bestSellPrice.toString().split(".");
			var localQuickOrdersBO:QuickOrdersBO=thirdSymbolDropDown.selectedItem as QuickOrdersBO;
			if (bestMarketAndSymbolSummary.symbolName == localQuickOrdersBO.SYMBOL)
			{
				if (bestMarketAndSymbolSummary.symbolSummary)
				{
					if (splittedSellPrice || splittedBuyPrice)
					{
						thirdBuyBeforeDecimal.text=(splittedBuyPrice[0] != null && !isNaN(splittedBuyPrice[0]) ? splittedBuyPrice[0] : splittedBuyPrice[0]="");
						thirdBuyAfterDecimal.text="." + (splittedBuyPrice[1] != null && !isNaN(splittedBuyPrice[1]) ? splittedBuyPrice[1] : "");
						thirdSellBeforeDecimal.text=(splittedSellPrice[0] != null && !isNaN(splittedSellPrice[0]) ? splittedSellPrice[0] : splittedSellPrice[0]="");
						thirdSellAfterDecimal.text="." + (splittedSellPrice[1] != null && !isNaN(splittedSellPrice[1]) ? splittedSellPrice[1] : "");
						thirdSegmentLowLabel.text=(bestMarketAndSymbolSummary.symbolSummary.stats.low.toString() != null ? bestMarketAndSymbolSummary.symbolSummary.stats.low.toString().slice(0, 4) : "--");
						thirdHighValue.text=(bestMarketAndSymbolSummary.symbolSummary.stats.high.toString() != null ? bestMarketAndSymbolSummary.symbolSummary.stats.high.toString().slice(0, 4) : "--");
						if (bestMarketAndSymbolSummary.symbolSummary.stats && bestMarketAndSymbolSummary.symbolSummary.stats.netChange < 0)
						{
							thirdChangeValue.setStyle("backgroundColor", 0xdf241d);
							thirdChangeValue.text="-" + bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						if (bestMarketAndSymbolSummary.symbolSummary.stats && bestMarketAndSymbolSummary.symbolSummary.stats.netChange > 0)
						{
							thirdChangeValue.setStyle("backgroundColor", 0x01e92a);
							thirdChangeValue.text="+" + bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						if (bestMarketAndSymbolSummary.symbolSummary.stats && bestMarketAndSymbolSummary.symbolSummary.stats.netChange == previousNumber)
						{
							thirdChangeValue.setStyle("backgroundColor", 0xffffff);
							thirdChangeValue.text=bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						previousNumber=bestMarketAndSymbolSummary.symbolSummary.stats.netChange;
					}
					else
					{
					}
				}
				else
				{
					thirdBuyBeforeDecimal.text="";
					thirdBuyAfterDecimal.text="";
					thirdSellBeforeDecimal.text="";
					thirdSellAfterDecimal.text="";
					thirdSegmentLowLabel.text="";
					thirdHighValue.text="";
				}
			}
		}
		else
		{
			flag3=true;
		}
	}
	catch (e:Error)
	{
		trace(e.message.toString());
	}
}

public function fourthupdateQuickOrderView(bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO, bestBuyPrice:Number, bestSellPrice:Number):void
{
	try
	{ 
		if (flag4 == true &&  fourthSymbolDropDown.selectedIndex != -1 &&
			(fourthSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName
			&&
			(fourthSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName 
			&&
			(fourthSymbolDropDown.selectedItem as QuickOrdersBO).SYMBOL 
			== bestMarketAndSymbolSummary.symbolName)
		{
			var splittedBuyPrice:Array=bestBuyPrice.toString().split(".");
			var splittedSellPrice:Array=bestSellPrice.toString().split(".");
			var localQuickOrdersBO:QuickOrdersBO=fourthSymbolDropDown.selectedItem as QuickOrdersBO;
			if (bestMarketAndSymbolSummary.symbolName == localQuickOrdersBO.SYMBOL)
			{
				if (bestMarketAndSymbolSummary.symbolSummary)
				{
					if (splittedSellPrice || splittedBuyPrice)
					{
						fourthBuyBeforeDecimal.text=(splittedBuyPrice[0] != null && !isNaN(splittedBuyPrice[0]) ? splittedBuyPrice[0] : splittedBuyPrice[0]="");
						fourthBuyAfterDecimal.text="." + (splittedBuyPrice[1] != null && !isNaN(splittedBuyPrice[1]) ? splittedBuyPrice[1] : "");
						fourthSellBeforeDecimal.text=(splittedSellPrice[0] != null && !isNaN(splittedSellPrice[0]) ? splittedSellPrice[0] : splittedSellPrice[0]="");
						fourthSellAfterDecimal.text="." + (splittedSellPrice[1] != null && !isNaN(splittedSellPrice[1]) ? splittedSellPrice[1] : "");
						fourthSegmentLowLabel.text=(bestMarketAndSymbolSummary.symbolSummary.stats.low.toString() != null ? bestMarketAndSymbolSummary.symbolSummary.stats.low.toString().slice(0, 4) : "--");
						fourthHighValue.text=(bestMarketAndSymbolSummary.symbolSummary.stats.high.toString() != null ? bestMarketAndSymbolSummary.symbolSummary.stats.high.toString().slice(0, 4) : "--");
						if (bestMarketAndSymbolSummary.symbolSummary.stats.netChange && bestMarketAndSymbolSummary.symbolSummary.stats.netChange < 0)
						{
							fourthChangeValue.setStyle("backgroundColor", 0xdf241d);
							fourthChangeValue.text="-" + bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						if (bestMarketAndSymbolSummary.symbolSummary.stats.netChange && bestMarketAndSymbolSummary.symbolSummary.stats.netChange > 0)
						{
							fourthChangeValue.setStyle("backgroundColor", 0x01e92a);
							fourthChangeValue.text="+" + bestMarketAndSymbolSummary.symbolSummary.stats.netChange;
						}
						if (bestMarketAndSymbolSummary.symbolSummary.stats.netChange && bestMarketAndSymbolSummary.symbolSummary.stats.netChange == previousNumber)
						{
							fourthChangeValue.setStyle("backgroundColor", 0xffffff);
							fourthChangeValue.text=bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
						}
						previousNumber=bestMarketAndSymbolSummary.symbolSummary.stats.netChange;
					}
					else
					{
					}
				}
				else
				{
					fourthBuyBeforeDecimal.text="";
					fourthBuyAfterDecimal.text="";
					fourthSellBeforeDecimal.text="";
					fourthSellAfterDecimal.text="";
					fourthSegmentLowLabel.text="";
					fourthHighValue.text="";
				}
			}
		}
		else
		{
			flag4=true;
		}
	}
	catch (e:Error)
	{
		trace(e.message.toString());
	}
}

protected function fourthSymbolDropDownCreationCompleteHandler(event:FlexEvent):void
{
	try
	{
		
		//					firstSymbolDropDown.selectedIndex=-1;
		var quickOrders:ArrayCollection=modelManager.quickOrdersModel.quickOrders[selectedIndex];
		for(var i:int = 0 ; i <= quickOrders.source.length ; i++)
		{
			if(quickOrders.source[i].SYMBOL != null)
			{
				quickOrders.refresh();
				(event.target as DedupeComboBox).dataProvider=quickOrders;
				(event.target as DedupeComboBox).labelField="SYMBOL";
			}
			else
			{
				(event.target as DedupeComboBox).dataProvider=null;
			}
		}
		//					(event.target as ComboBox).dataProvider=null;
	}
	catch (e:Error)
	{
		trace(e.message);
	}
}

protected function secondSymbolDropDownCreationCompleteHandler(event:FlexEvent):void
{
	try
	{
		
		//					firstSymbolDropDown.selectedIndex=-1;
		var quickOrders:ArrayCollection=modelManager.quickOrdersModel.quickOrders[selectedIndex];
		for(var i:int = 0 ; i <= quickOrders.source.length ; i++)
		{
			if(quickOrders.source[i].SYMBOL != null)
			{
				quickOrders.refresh();
				(event.target as DedupeComboBox).dataProvider=quickOrders;
				(event.target as DedupeComboBox).labelField="SYMBOL";
			}
			else
			{
				(event.target as DedupeComboBox).dataProvider=null;
			}
		}
		//					(event.target as ComboBox).dataProvider=null;
	}
	catch (e:Error)
	{
		trace(e.message);
	}
}

protected function thirdSymbolDropDownCreationCompleteHandler(event:FlexEvent):void
{
	try
	{
		
		//					firstSymbolDropDown.selectedIndex=-1;
		var quickOrders:ArrayCollection=modelManager.quickOrdersModel.quickOrders[selectedIndex];
		for(var i:int = 0 ; i <= quickOrders.source.length ; i++)
		{
			if(quickOrders.source[i].SYMBOL != null)
			{
				quickOrders.refresh();
				(event.target as DedupeComboBox).dataProvider=quickOrders;
				(event.target as DedupeComboBox).labelField="SYMBOL";
			}
			else
			{
				(event.target as DedupeComboBox).dataProvider=null;
			}
		}
		//					(event.target as ComboBox).dataProvider=null;
	}
	catch (e:Error)
	{
		trace(e.message);
	}
}

protected function firstSymbolDropDownCreationCompleteHandler(event:FlexEvent):void
{
	try
	{
		
		//					firstSymbolDropDown.selectedIndex=-1;
		var quickOrders:ArrayCollection=modelManager.quickOrdersModel.quickOrders[selectedIndex];
		for(var i:int = 0 ; i <= quickOrders.source.length ; i++)
		{
			if(quickOrders.source[i].SYMBOL != null)
			{
				quickOrders.refresh();
				(event.target as DedupeComboBox).dataProvider=quickOrders;
				(event.target as DedupeComboBox).labelField="SYMBOL";
			}
			else
			{
				(event.target as DedupeComboBox).dataProvider=null;
			}
		}
		//					(event.target as ComboBox).dataProvider=null;
	}
	catch (e:Error)
	{
		trace(e.message);
	}
}