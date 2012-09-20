import components.ComboBoxItem;

import controller.ModelManager;

import flash.events.KeyboardEvent;

import mx.events.FlexEvent;

protected function group1_initializeHandler(event:FlexEvent):void
{
	for (var i:int=0; i < ModelManager.getInstance().exchangeModel.exchanges.length; ++i)
	{
		var obj:Object=ModelManager.getInstance().exchangeModel.exchanges.getItemAt(i);
		//var cbi:ComboBoxItem = new ComboBoxItem(obj.EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		exchangeList.addItem(cbi);
	}
	//txtTotalBuy.text = "";
	//txtTotalSell.text = "";
	//exchangeID = -1;
	internalExchangeID=-1;
	//marketID = -1;
	internalMarketID=-1;
	symbolID=-1;
	//ModelManager.getInstance().updateBestPrices(null);
}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 9 || event.keyCode == 13)
	{
		updateBestPrices();
			//applyFilter();
	}
}

private function updateBestPrices():void
{
//	txtSymbol.text=txtSymbol.text.toUpperCase();
	internalSymbolID=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);
	symbolID=ModelManager.getInstance().exchangeModel.getSymbolID(internalExchangeID, internalMarketID, internalSymbolID);
	if (symbolID > -1)
	{
		ModelManager.getInstance().bestPricesModel.isDirty=true;
		ModelManager.getInstance().updateBestPrices();
	}
	else
	{
		internalSymbolID=-1;
		symbolID=-1;
		txtSymbol.text="";
	}

}

protected function btnRefresh_clickHandler(event:MouseEvent):void
{
	updateBestPrices();
}


public function applyFilter():void
{
}
