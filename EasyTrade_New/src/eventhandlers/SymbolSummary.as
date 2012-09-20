import components.ComboBoxItem;

import controller.ModelManager;

import flash.events.KeyboardEvent;

import mx.events.FlexEvent;

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
		txtSymbol.text=txtSymbol.text.toUpperCase();
		internalSymbolID=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);
		modelManager.symbolBrowserModel.symbols.refresh();
	}

}

public function applyFilter():void
{
	txtSymbol.text="";
	//modelManager.symbolBrowserModel.isDirty = true;
	//modelManager.symbolBrowserModel.symbols.removeAll();
	modelManager.updateSymbolSummary();
}
