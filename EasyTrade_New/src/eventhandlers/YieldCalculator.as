import businessobjects.BondBO;

import common.Messages;

import components.ComboBoxItem;
import components.EZCurrencyFormatter;

import controller.ModelManager;
import controller.WindowManager;

import flash.events.FocusEvent;
import flash.events.KeyboardEvent;

import mx.controls.Alert;
import mx.core.IVisualElement;
import mx.events.FlexEvent;
import mx.resources.ResourceManager;

public var modelManager:ModelManager=ModelManager.getInstance();
public var windowManager:WindowManager=WindowManager.getInstance();
public var nextCouponDate:Date=new Date();
public var issueDate:Date=new Date();
public var maturityDate:Date=new Date();

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
}

public function applyFilter():void
{
	//modelManager.remainingOrdersModel.remainingOrders.refresh();
}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 13)
	{
		event.stopImmediatePropagation();
		txtSymbol_focusOutHandler(null);
	}
}

protected function txtSymbol_focusOutHandler(event:FocusEvent):void
{
	if (txtSymbol.text.length == 0)
	{
		return;
	}

	var modelManager:ModelManager=ModelManager.getInstance();
	txtSymbol.text=txtSymbol.text.toUpperCase();
	var internalSymbolID:Number=modelManager.exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);

	if (internalSymbolID < 0)
	{
		Alert.show(ResourceManager.getInstance().getString('marketwatch','invalidSymbol'),ResourceManager.getInstance().getString('marketwatch','error'));
		txtSymbol.text="";
		return;
	}
}

public function reset(clearFields:Boolean=true):void
{
	if (clearFields)
	{
		internalExchangeID=-1;
		internalMarketID=-1;
		internalSymbolID=-1;

		txtExchange.text="";
		txtMarket.text="";
		txtSymbol.text="";

		for (var j:int=0; j < numElements; ++j)
		{
			var el:IVisualElement=getElementAt(j);
			if (el is TextInput)
			{
				(el as TextInput).text="";
			}
		}
	}
	else
	{
		if (internalExchangeID > -1 && internalMarketID > -1 && internalSymbolID > -1)
		{
			var obj:Object=ModelManager.getInstance().exchangeModel.getSymbol(internalExchangeID, internalMarketID, internalSymbolID);
			if (obj.hasOwnProperty("SYMBOL_TYPE") && obj.SYMBOL_TYPE == "Bond")
			{
				var ezCurrencyFormatter:EZCurrencyFormatter=new EZCurrencyFormatter();
				var bondBO:BondBO=obj as BondBO;
				txtDiscountRate.text=ezCurrencyFormatter.format(bondBO.discountRate);
				txtEffectiveBaseRate.text=ezCurrencyFormatter.format(bondBO.baseRate);
				txtSpread.text=ezCurrencyFormatter.format(bondBO.spreadRate);
			}
		}
		else
		{
			reset();
		}
	}
}

