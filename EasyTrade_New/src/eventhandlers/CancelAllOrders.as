import mx.controls.Alert;
import mx.resources.ResourceManager;

public function applyFilter():void
{
}

///////////////////////////////////////////////////////////

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 9 || event.keyCode == 13)
	{
		event.stopImmediatePropagation();
		txtSymbol_focusOutHandler(null);
	}
}

///////////////////////////////////////////////////////////

public function txtSymbol_focusOutHandler(event:FocusEvent):void
{
	if (txtSymbol.text.length == 0)
	{
		return;
	}

	txtSymbol.text=txtSymbol.text.toUpperCase();
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
///////////////////////////////////////////////////////////
