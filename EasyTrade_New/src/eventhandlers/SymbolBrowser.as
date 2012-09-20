import businessobjects.MarketBO;
import businessobjects.SymbolBO;
import businessobjects.SymbolBrowserBO;
import businessobjects.SymbolSummaryBO;

import common.Messages;

import components.ComboBoxItem;

import controller.ModelManager;

import flash.events.KeyboardEvent;

import mx.controls.Alert;
import mx.events.FlexEvent;
import mx.resources.ResourceManager;
import mx.utils.StringUtil;

[Bindable]
private var modelManager:ModelManager=ModelManager.getInstance();

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
		if (StringUtil.trim(txtSymbol.text).length > 0 && internalSymbolID < 0)
		{
			Alert.show(ResourceManager.getInstance().getString('marketwatch','invalidSymbol'),ResourceManager.getInstance().getString('marketwatch','error'));
			txtSymbol.text="";
		}
		else
		{
			modelManager.symbolBrowserModel.symbols.refresh();
			applyFilter1();
		}
	}
}

public function applyFilter():void
{
	txtSymbol.text="";
	//modelManager.symbolBrowserModel.isDirty = true;
//	modified on 21/12/2010
//	modelManager.symbolBrowserModel.symbols.removeAll();
//	modelManager.updateSymbolBrowser();
	//modified on 23/12/2010
	//modelManager.symbolBrowserModel.symbols.refresh();
	
	modelManager.symbolBrowserModel.symbols.removeAll();
	var marketBO:MarketBO=ModelManager.getInstance().exchangeModel.getMarket(internalExchangeID, internalMarketID);
	if (marketBO)
	{
		for (var x:int=0; x < marketBO.symbols.length; x++)
		{
			var symBrowBO:SymbolBrowserBO=fillSymbolBrowserBO(marketBO.symbols.getItemAt(x) as SymbolBO, marketBO.INTERNAL_EXCHANGE_ID, marketBO.INTERNAL_MARKET_ID);
			modelManager.symbolBrowserModel.symbols.addItem(symBrowBO);
		}
	}
}

public function applyFilter1():void
{
	if (StringUtil.trim(txtSymbol.text).length == 0)
	{
		applyFilter();
	}
	else
	{
		modelManager.symbolBrowserModel.symbols.removeAll();
		var marketBO:MarketBO=modelManager.exchangeModel.getMarket(internalExchangeID, internalMarketID);
		
		if (marketBO)
		{
			for (var x:int=0; x < marketBO.symbols.length; x++)
			{
				var sb:SymbolBO=marketBO.symbols.getItemAt(x) as SymbolBO;
				if (txtSymbol.text == sb.SYMBOL)
				{
					var symBrowBO:SymbolBrowserBO=fillSymbolBrowserBO(marketBO.symbols.getItemAt(x) as SymbolBO, marketBO.INTERNAL_EXCHANGE_ID, marketBO.INTERNAL_MARKET_ID);
					modelManager.symbolBrowserModel.symbols.addItem(symBrowBO);
					break;
				}
			}
		}
	}
}

private function fillSymbolBrowserBO(symbolBO:SymbolBO, internalExchangeId:Number, internalMarketId:Number):SymbolBrowserBO
{
	var symbolBrowserBO:SymbolBrowserBO=new SymbolBrowserBO();
	symbolBrowserBO.SYMBOL_CODE=symbolBO.SYMBOL;
	symbolBrowserBO.STATE=symbolBO.STATE;
	//symbolBrowserBO.isSpot = symbolBO.
	//symbolBO.is = symbolBO.ISPOSTED
	symbolBrowserBO.INTERNAL_EXCHANGE_ID=this.internalExchangeID;
	symbolBrowserBO.INTERNAL_MARKET_ID=internalMarketId;
	symbolBrowserBO.INTERNAL_SYMBOL_ID=symbolBO.INTERNAL_SYMBOL_ID;
	symbolBrowserBO.symbolID=symbolBO.SYMBOL_ID;

	symbolBrowserBO.EXCHANGE_CODE=ModelManager.getInstance().exchangeModel.getExchangeCode(symbolBrowserBO.INTERNAL_EXCHANGE_ID);
	symbolBrowserBO.MARKET_CODE=ModelManager.getInstance().exchangeModel.getMarketCode(symbolBrowserBO.INTERNAL_EXCHANGE_ID, symbolBrowserBO.INTERNAL_MARKET_ID);
//	//symbolBrowserBO.SYMBOL_CODE = ModelManager.getInstance().exchangeModel.getSymbolCode(symbol.INTERNAL_EXCHANGE_ID, symbol.INTERNAL_MARKET_ID, symbol.INTERNAL_SYMBOL_ID);

	return symbolBrowserBO;
}
