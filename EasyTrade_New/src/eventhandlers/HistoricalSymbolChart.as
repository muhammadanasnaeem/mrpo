import businessobjects.SymbolTradeBO;

import com.lightstreamer.as_client.events.NonVisualItemUpdateEvent;

import common.Messages;

import components.ComboBoxItem;

import controller.ModelManager;
import controller.WindowManager;

import flash.events.KeyboardEvent;

import mx.charts.HitData;
import mx.controls.Alert;
import mx.events.FlexEvent;
import mx.resources.ResourceManager;

import services.LSListener;

[Bindable]
public var modelManager:ModelManager=ModelManager.getInstance();
private var exchangeID:Number=-1;
private var marketID:Number=-1;

//private var symbolID:Number = -1;

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
}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 9 || event.keyCode == 13)
	{
//		txtSymbol.text=txtSymbol.text.toUpperCase();
		internalSymbolID=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);
		if (internalSymbolID < 0)
		{
			Alert.show(ResourceManager.getInstance().getString('marketwatch','invalidSymbol'),ResourceManager.getInstance().getString('marketwatch','error'));
			txtSymbol.text="";
		}
		else
		{
			exchangeID=ModelManager.getInstance().exchangeModel.getExchangeID(internalExchangeID);
			marketID=ModelManager.getInstance().exchangeModel.getMarketID(internalExchangeID, internalMarketID);
			symbolID=ModelManager.getInstance().exchangeModel.getSymbolID(internalExchangeID, internalMarketID, internalSymbolID);
			applyFilter();
		}
	}
}

public function applyFilter():void
{
	modelManager.updateSymbolTradeHistory();
}

public function priceDataTipFunction(hitData:HitData):String
{
	var retVal:String="";
	if (hitData.item is SymbolTradeBO)
	{
		var stb:SymbolTradeBO=(hitData.item as SymbolTradeBO);
		retVal="Price at " + stb.time.toLocaleTimeString() + " was " + stb.price;
	}
	return retVal;
}

public function volumeDataTipFunction(hitData:HitData):String
{
	var retVal:String="";
	if (hitData.item is SymbolTradeBO)
	{
		var stb:SymbolTradeBO=(hitData.item as SymbolTradeBO);
		retVal="Volume at " + stb.time.toLocaleTimeString() + " was " + stb.size;
	}
	return retVal;
}

//public function updateSymbolTradeHistory(event:NonVisualItemUpdateEvent):void
public function updateSymbolTradeHistory(event:NonVisualItemUpdateEvent):void
{
	var stb:SymbolTradeBO = new SymbolTradeBO;
	var itemID:Array = event.currentTarget.groupString.split("_");
	var windowManager:WindowManager = WindowManager.getInstance();
	
	
	if ( exchangeID == itemID[1] && marketID == itemID[2] && symbolID == itemID[3] )
	{
		stb.price = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[1]));
		stb.size = new Number(LSListener.extractFieldData(event, LSListener.fieldSchemaSymbolStat[0]));
		stb.ticket = new Number();
		stb.time = new Date();
		modelManager.symbolTradeHistoryModel.symbolTrades.addItem(stb);
	}
}
