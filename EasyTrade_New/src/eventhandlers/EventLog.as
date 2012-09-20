import common.Constants;

import components.ComboBoxItem;

import controller.ModelManager;
import controller.ViewManager;
import controller.WindowManager;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.net.FileReference;

import flashx.textLayout.operations.ApplyFormatOperation;

import flexlib.mdi.containers.MDIWindow;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;

import view.Order;


public var fr:FileReference = new FileReference();

[Bindable]
public var modelManager:ModelManager=ModelManager.getInstance();

[Bindable]
private var tradersList:ArrayCollection=new ArrayCollection();



//private var windowManager:WindowManager = WindowManager.getInstance();
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

	// added on 16/3/2011
	tradersList=modelManager.userProfileModel.getTraders("EventLog");
}


protected function dgEventLog_itemClickHandler(event:MouseEvent):void
{
	var windowManager:WindowManager=WindowManager.getInstance();
	if (!this.dgEventLog.selectedItem)
	{
		return;
	}
}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 9 || event.keyCode == 13)
	{
//		txtSymbol.text=txtSymbol.text.toUpperCase();
		internalSymbolID=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);
		applyFilter();
	}
}

public function applyFilter():void
{
	modelManager.remainingOrdersModel.remainingOrders.refresh();
	modelManager.updateEventLog();
}

protected function btnRefresh_clickHandler(event:MouseEvent):void
{
	modelManager.updateEventLog();
}
