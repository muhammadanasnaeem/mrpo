import components.ComboBoxItem;
import components.EZNumberFormatter;

import controller.ModelManager;

import mx.events.FlexEvent;

import view.ExchangeStatsIndices;

protected function group1_initializeHandler(event:FlexEvent):void
{
	for (var i:int=0; i < ModelManager.getInstance().exchangeModel.exchanges.length; ++i)
	{
		var obj:Object=ModelManager.getInstance().exchangeModel.exchanges.getItemAt(i);
		var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		exchangeList.addItem(cbi);
	}
	internalExchangeID=-1;
}

public function applyFilter():void
{
	ModelManager.getInstance().exchangeStatsModel.exchangeID=internalExchangeID;
	ModelManager.getInstance().updateExchangeStats();
}
