import components.ComboBoxItem;

import controller.ModelManager;
import controller.ProfileManager;
import controller.WindowManager;

import flash.events.MouseEvent;

import flexlib.mdi.events.MDIWindowEvent;

import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.core.IVisualElement;
import mx.events.FlexEvent;

import spark.components.CheckBox;

[Bindable]
public var modelManager:ModelManager=ModelManager.getInstance();

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

protected function group1_creationCompleteHandler(event:FlexEvent):void
{
	setDefaultExchangeAndMarket();
}

public function selectDeselectAll(event:MouseEvent):void
{
	var flag:Boolean=event.currentTarget.selected;

	for (var i:int=0; i < marketWatchGrid.numElements; i++)
	{
		var gr:GridRow=marketWatchGrid.getElementAt(i) as GridRow;

		for (var j:int=0; j < gr.numElements; j++)
		{
			var gi:GridItem=gr.getElementAt(j) as GridItem;

			for (var k:int=0; k < gi.numElements; k++)
			{
				var el:IVisualElement=gi.getElementAt(k);

				if (el is CheckBox)
					(el as CheckBox).selected=flag;
			}
		}

	}
}


public function applyFilter():void
{

}

protected function btnUpdate_clickHandler(event:MouseEvent):void
{
	var profileManager:ProfileManager=ProfileManager.getInstance();
	profileManager.defaultInternalExchangeId=internalExchangeID;
	profileManager.defaultInternalMarketId=internalMarketID;
}

protected function btnCancel_clickHandler(event:MouseEvent):void
{
	var profileManager:ProfileManager=ProfileManager.getInstance();
	txtExchange.text="";
	txtMarket.text="";
	profileManager.defaultInternalExchangeId=-1;
	profileManager.defaultInternalMarketId=-1;
	//var result:Boolean = WindowManager.getInstance().profileSettingsWindow.dispatchEvent(new MDIWindowEvent(MDIWindowEvent.CLOSE,WindowManager.getInstance().profileSettingsWindow,null, false));
}
