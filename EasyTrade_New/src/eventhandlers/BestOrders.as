import common.Constants;
import common.Messages;

import components.ComboBoxItem;

import controller.ModelManager;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;
import mx.resources.ResourceManager;

import view.SelectionMenu;

protected function group1_initializeHandler(event:FlexEvent):void
{
	for (var i:int=0; i < ModelManager.getInstance().exchangeModel.exchanges.length; ++i)
	{
		var obj:Object=ModelManager.getInstance().exchangeModel.exchanges.getItemAt(i);
		//var cbi:ComboBoxItem = new ComboBoxItem(obj.EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		exchangeList.addItem(cbi);
	}
	txtTotalBuy.text="";
	txtTotalSell.text="";
	//exchangeID = -1;
	internalExchangeID=-1;
	//marketID = -1;
	internalMarketID=-1;
	symbolID=-1;
	//ModelManager.getInstance().updateBestOrders(null);
}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 9 || event.keyCode == 13)
	{
		updateBestOrders();
			//applyFilter();
	}
}

protected function btnRefresh_clickHandler(event:MouseEvent):void
{
	updateBestOrders();
}

public function updateBestOrders():void
{
//	txtSymbol.text=txtSymbol.text.toUpperCase();
	internalSymbolID=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);
	symbolID=ModelManager.getInstance().exchangeModel.getSymbolID(internalExchangeID, internalMarketID, internalSymbolID);
	// added on 31/3/2011
	if (symbolID > -1)
	{
		ModelManager.getInstance().bestOrdersModel.isDirty=true;
		ModelManager.getInstance().updateBestOrders();
	}
	else
	{
		internalSymbolID=-1;
		symbolID=-1;
		txtSymbol.text="";
	}
}

// Start : added on 31/3/2011

protected function txtExchange_clickHandler_BestOrders(event:MouseEvent):void
{
	var menu:SelectionMenu=PopUpManager.createPopUp(this, SelectionMenu) as SelectionMenu;
	menu.lstList.dataProvider=exchangeList;
	positionMenu(event, menu);
	menu.addEventListener(Constants.EVENT_MENU_CLOSE, exchangeSelectionMenuClosed_BestOrders);
}

protected function txtMarket_clickHandler_BestOrders(event:MouseEvent):void
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
	menu.addEventListener(Constants.EVENT_MENU_CLOSE, marketSelectionMenuClosed_BestOrders);
}

protected function exchangeSelectionMenuClosed_BestOrders(event:Event):void
{
	if (!event.currentTarget.lstList.selectedItem)
	{
		return;
	}
	if (internalExchangeID != event.currentTarget.lstList.selectedItem.value)
	{
		txtExchange.text=event.currentTarget.lstList.selectedItem.label;
		internalExchangeID=event.currentTarget.lstList.selectedItem.value;
		txtMarket.text="";
		internalMarketID=-1;
		internalSymbolID=-1;
		applyFilter();
	}
}

protected function marketSelectionMenuClosed_BestOrders(event:Event):void
{
	if (!event.currentTarget.lstList.selectedItem)
	{
		return;
	}
	txtMarket.text=event.currentTarget.lstList.selectedItem.label;
	internalMarketID=event.currentTarget.lstList.selectedItem.value;
	txtSymbol.text="";
	internalSymbolID=-1;
	symbolID=-1;
	applyFilter();
}


// End : added on 31/3/2011

public function applyFilter():void
{
	txtTotalBuy.text="";
	txtTotalSell.text="";
	ModelManager.getInstance().bestOrdersModel.bestOrders.removeAll();
}
