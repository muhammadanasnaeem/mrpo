import businessobjects.BestMarketAndSymbolSummaryBO;
import businessobjects.MarketWatchBO;
import businessobjects.SymbolBO;
import businessobjects.SymbolSummary;
import businessobjects.SymbolSummaryBO;

import com.lightstreamer.as_client.events.NonVisualItemUpdateEvent;

import common.Constants;
import common.Messages;

import components.ComboBoxItem;
import components.EZNumberFormatter;

import controller.ModelManager;
import controller.WindowManager;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.events.FlexEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.resources.ResourceManager;

import services.LSListener;

import view.SelectionMenu;

[Bindable]
private var modelManager:ModelManager=ModelManager.getInstance();

[Bindable]
private var symbol:businessobjects.SymbolSummary=new businessobjects.SymbolSummary();

public var dateFormatter:DateFormatter=new DateFormatter();

[Bindable]
public var displayBondPanel:Boolean=false;


protected function group1_initializeHandler(event:FlexEvent):void
{
	for (var i:int=0; i < ModelManager.getInstance().exchangeModel.exchanges.length; ++i)
	{
		var obj:Object=ModelManager.getInstance().exchangeModel.exchanges.getItemAt(i);
		var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		exchangeList.addItem(cbi);
	}
	internalExchangeID=-1;
	internalMarketID=-1;
	internalSymbolID=-1;
	symbolID=-1;

	symbol.init();
}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 9 || event.keyCode == 13)
	{
//		txtSymbol.text=txtSymbol.text.toUpperCase();

		var obj:Object=modelManager.exchangeModel.getSymbolByCode(internalExchangeID, internalMarketID, txtSymbol.text);

		if (!obj)
		{
			txtSymbol.text="";
			symbol.init();
			return;
		}

		loadSymbolData();
	}

}

public function loadSymbolData():void
{
	var mwbo:MarketWatchBO=modelManager.marketWatchModel.getMarketWatchBO(internalExchangeID, internalMarketID, txtSymbol.text);
	 
	if (mwbo)
	{
		fillSymbolSummaryByMWBO(mwbo);
	}
	else
	{
		var obj:Object=modelManager.exchangeModel.getSymbolByCode(internalExchangeID, internalMarketID, txtSymbol.text);

		//modelManager.symbolSummaryModel.exchangeID = obj.exchangeID;
		modelManager.symbolSummaryModel.marketID=obj.MARKET_ID;
		modelManager.symbolSummaryModel.symbol=obj.SYMBOL;
		modelManager.symbolSummaryModel.isSymbolSummaryUpdate=false;


		var exID:Number=modelManager.exchangeModel.getExchangeID(internalExchangeID);
		modelManager.symbolSummaryModel.exchangeID=exID;

		modelManager.bestMarketAndSymbolSummaryModel.exchangeID=exID;
		modelManager.bestMarketAndSymbolSummaryModel.marketID=obj.MARKET_ID;
		modelManager.bestMarketAndSymbolSummaryModel.symbolName=obj.SYMBOL;
		modelManager.bestMarketAndSymbolSummaryModel.symbolID=obj.SYMBOL_ID;
		modelManager.bestMarketAndSymbolSummaryModel.execute();

	}

}

public function fillSymbolSummaryByMWBO(mwBO:MarketWatchBO):void
{
	var numberFormatter:EZNumberFormatter = new EZNumberFormatter();
	dateFormatter.formatString="DD/MM/YYYY";

//	symbol.AIRR =  mwBO.AIRR;
//	symbol.IRR = mwBO.IRR;	
//	symbol.DISCOUNT_RATE = mwBO.DISCOUNT_RATE;
//	symbol.NEXT_COUPON = dateFormatter.format(mwBO.NEXT_COUPON);
//	symbol.MATURITY_DATE = dateFormatter.format(mwBO.MATURITY_DATE);
//	symbol.BASE_RATE = mwBO.BASE_RATE;
//	symbol.SPREAD_RATE = mwBO.SPREAD_RATE;
//	symbol.COUPON_RATE = mwBO.COUPON_RATE;
//	var event:NonVisualItemUpdateEvent
	
//	var high:Number = numberFormatter.format(LSListener.extractFieldData(, LSListener.fieldSchemaSymbolStat[6])).toString().slice(0, 5);
	symbol.LAST_DAY_CLOSE_PRICE = "";	
	symbol.SYMBOL=mwBO.SYMBOL;
	symbol.symbolID=mwBO.symbolID;
	symbol.HIGH=mwBO.HIGH;
	symbol.TRADES=mwBO.TRADES;
	symbol.LOW=mwBO.LOW;
	symbol.STATE=mwBO.STATE;
	symbol.OPEN=mwBO.OPEN;
	symbol.LAST=mwBO.LAST;
	symbol.CHANGE=mwBO.CHANGE;
	symbol.BUY=mwBO.BUY;
	symbol.BUY_VOLUME=mwBO.BUY_VOLUME;
	symbol.SELL=mwBO.SELL;
	symbol.SELL_VOLUME=mwBO.SELL_VOLUME;
	symbol.SECTOR=mwBO.SECTOR;
	symbol.LAST_VOLUME=mwBO.LAST_VOLUME;
	symbol.CLOSE=mwBO.CLOSE;
	symbol.LAST_DAY_CLOSE_PRICE = modelManager.bestMarketAndSymbolSummaryModel.symbolSummary1.stats.lastDayClosePrice.toString();
	//symbol.SELL = mwBO.SELL;

	var obj:Object=modelManager.exchangeModel.getSymbolByCode(internalExchangeID, internalMarketID, txtSymbol.text);

	if (obj)
	{
		symbol.UPPER_ORDER_VALUE_LIMIT=obj.UPPER_ORDER_VALUE_LIMIT;
		symbol.LOWER_ORDER_VALUE_LIMIT=obj.LOWER_ORDER_VALUE_LIMIT;

		symbol.UPPER_CIRCUIT_BREAKER_LIMIT=obj.UPPER_CIRCUIT_BREAKER_LIMIT;
		symbol.LOWER_CIRCUIT_BREAKER_LIMIT=obj.LOWER_CIRCUIT_BREAKER_LIMIT;


		symbol.BOARD_LOT=obj.BOARD_LOT;
		symbol.STATE=obj.STATE;
		symbol.STATUS=obj.STATUS;
		symbol.UPPER_ORDER_VOLUME_LIMIT=obj.UPPER_ORDER_VOLUME_LIMIT;
		symbol.LOWER_ORDER_VOLUME_LIMIT=obj.LOWER_ORDER_VOLUME_LIMIT;
		symbol.SYMBOL=obj.SYMBOL;

		if (obj.hasOwnProperty("SYMBOL_TYPE") && obj.SYMBOL_TYPE == "Bond")
		{
			symbol.AIRR=obj.AIRR;
			symbol.IRR=obj.IRR;

			symbol.NEXT_COUPON=dateFormatter.format(obj.nextCouponDate);
			symbol.MATURITY_DATE=dateFormatter.format(obj.maturityDate);
			symbol.ISSUE_DATE=dateFormatter.format(obj.issueDate);
			symbol.BASE_RATE=obj.baseRate;
			symbol.SPREAD_RATE=obj.spreadRate;
			symbol.COUPON_RATE=obj.couponRate;
			symbol.DISCOUNT_RATE=obj.discountRate;


			if (symbol.SELL && symbol.COUPON_RATE && (symbol.SELL.length > 0 && symbol.SELL != "0") && (symbol.COUPON_RATE.length > 0))
			{
				symbol.bondAskYield=calculateCurrentYield(new Number(symbol.SELL), new Number(symbol.COUPON_RATE)).toString();
			}

			if (symbol.BUY && symbol.COUPON_RATE && (symbol.BUY.length > 0 && symbol.BUY != "0") && (symbol.COUPON_RATE.length > 0))
			{
				symbol.bondBidYield=calculateCurrentYield(new Number(symbol.BUY), new Number(symbol.COUPON_RATE)).toString();
			}

		}


	}

}

public function updateSymbolSummView(bestMarketAndSymbolSummary:BestMarketAndSymbolSummaryBO):void
{
	if (txtSymbol && bestMarketAndSymbolSummary.symbolName == txtSymbol.text && bestMarketAndSymbolSummary.exchangeId == ModelManager.getInstance().exchangeModel.getExchangeID(internalExchangeID) && bestMarketAndSymbolSummary.marketId == ModelManager.getInstance().exchangeModel.getMarketID(internalExchangeID, internalMarketID))
	{
		if (bestMarketAndSymbolSummary.symbolSummary && bestMarketAndSymbolSummary.symbolSummary.stats)
		{
			symbol.LAST=bestMarketAndSymbolSummary.symbolSummary.stats.lastTradePrice.toString();
			symbol.CHANGE=bestMarketAndSymbolSummary.symbolSummary.stats.netChange.toString();
			symbol.TURN_OVER=bestMarketAndSymbolSummary.symbolSummary.stats.turnover.toString();
		}
		else
		{
			symbol.LAST="";
			symbol.CHANGE="";
			symbol.TURN_OVER="";

		}

		if (bestMarketAndSymbolSummary.bestMarket)
		{
			if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO)
			{
				if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE > -1)
				{
					symbol.BUY=bestMarketAndSymbolSummary.bestMarket.buyOrderBO.PRICE.toString();
				}
				else
				{
					symbol.BUY="";

				}
				if (bestMarketAndSymbolSummary.bestMarket.buyOrderBO.VOLUME > -1)
				{
					symbol.BUY_VOLUME=bestMarketAndSymbolSummary.bestMarket.buyOrderBO.VOLUME.toString();
				}
				else
				{
					symbol.BUY_VOLUME="";
				}
			}
			else
			{
				symbol.BUY="";
				symbol.BUY_VOLUME="";
			}
			if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO)
			{
				if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE > -1)
				{
					symbol.SELL=bestMarketAndSymbolSummary.bestMarket.sellOrderBO.PRICE.toString();
				}
				else
				{
					symbol.SELL="";
				}
				if (bestMarketAndSymbolSummary.bestMarket.sellOrderBO.VOLUME > -1)
				{
					symbol.SELL_VOLUME=bestMarketAndSymbolSummary.bestMarket.sellOrderBO.VOLUME.toString();
				}
				else
				{
					symbol.SELL_VOLUME="";
				}
			}
			else
			{
				symbol.SELL="";
				symbol.SELL_VOLUME="";
			}
		}
	}
}

public function updateBestMarketSymbolSummFields(event:NonVisualItemUpdateEvent):void

{
var itemID:Array = event.currentTarget.groupString.split("_");
	
	if (symbol.symbolID == itemID[3] && itemID[2] == modelManager.exchangeModel.getMarketID(internalExchangeID,internalMarketID) && itemID[1] == modelManager.exchangeModel.getExchangeID(internalExchangeID))
	{
		symbol.BUY = moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[1]));
	
		symbol.BUY_VOLUME = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[3]));
	
		symbol.SELL = moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[5]));
	
		symbol.SELL_VOLUME = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaBestMarket[7]));
	}	
}

/**
 * Reset Order View
 */
public function updateSymbolStatsSymbolSummFields(event:NonVisualItemUpdateEvent):void
{
var itemID:Array = event.currentTarget.groupString.split("_");
	var symbolDetail:SymbolBO = modelManager.exchangeModel.getSymbolDetail(itemID[1],itemID[2],itemID[3]) as SymbolBO;
	if(symbolDetail)
	{
		if (symbol.SYMBOL == symbolDetail.SYMBOL && itemID[2] == modelManager.exchangeModel.getMarketID(internalExchangeID,internalMarketID))
		{
			symbol.LAST = moneyFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[1]));
			
			symbol.CHANGE = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[8]));
			
			symbol.TURN_OVER = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[2]));
			symbol.CLOSE = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[9]));
			symbol.TRADES = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[3]));
			symbol.LAST_VOLUME = numberFormatter.format(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[0]));
		}
	}
}


private function calculateCurrentYield(currentPrice:Number, couponRate:Number):Number
{
	return (couponRate / currentPrice) * 100;
}

protected function txtMarket_clickHandlerForSymbol(event:MouseEvent):void
{
	if (internalExchangeID < 0)
	{
		Alert.show(ResourceManager.getInstance().getString('marketwatch','invalidExchange'),ResourceManager.getInstance().getString('marketwatch','error'));
		return;
	}
	var menu:SelectionMenu=PopUpManager.createPopUp(this, SelectionMenu) as SelectionMenu;
	marketList=ModelManager.getInstance().exchangeModel.getexchangeMarkets(internalExchangeID);
	menu.lstList.dataProvider=marketList;
	positionMenu(event, menu);
	menu.addEventListener(Constants.EVENT_MENU_CLOSE, marketSelectionMenuClosedForSymbol);
}

protected function marketSelectionMenuClosedForSymbol(event:Event):void
{
	if (!event.currentTarget.lstList.selectedItem)
	{
		return;
	}
	txtMarket.text=event.currentTarget.lstList.selectedItem.label;
	internalMarketID=event.currentTarget.lstList.selectedItem.value;

	adjustBondPanel();
	applyFilter();

}

public function adjustBondPanel():void
{
	if (modelManager.exchangeModel.isBondMarket(internalExchangeID, internalMarketID))
	{
		displayBondPanel=true;
		WindowManager.getInstance().symbolSummWindow.height=510;
	}
	else
	{
		displayBondPanel=false;
		WindowManager.getInstance().symbolSummWindow.height=330;
	}
}

public function applyFilter():void
{
	txtSymbol.text="";
	internalSymbolID=-1;
	symbolID=-1;
	symbol.init();
}
