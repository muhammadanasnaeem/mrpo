import common.Constants;

import components.ComboBoxItem;

import controller.ModelManager;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.net.FileReference;

import flashx.textLayout.events.UpdateCompleteEvent;

import model.UserTradeHistoryModel;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;

public var fr:FileReference = new FileReference();
public var userID:Number;
private var isExpanded:Boolean=false;
[Bindable]
private var tradersList:ArrayCollection=new ArrayCollection();


protected function group1_initializeHandler(event:FlexEvent):void
{
	for (var i:int=0; i < ModelManager.getInstance().exchangeModel.exchanges.length; ++i)
	{
		var obj:Object=ModelManager.getInstance().exchangeModel.exchanges.getItemAt(i);
		//var cbi:ComboBoxItem = new ComboBoxItem(obj.EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		exchangeList.addItem(cbi);
	}
	//exchangeID = -1;
	internalExchangeID=-1;
	//marketID = -1;
	internalMarketID=-1;
	symbolID=-1;

	// added on 16/3/2011
	tradersList=ModelManager.getInstance().userProfileModel.getTraders("UserTradeHistory");
}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 9 || event.keyCode == 13)
	{
		txtSymbol.text=txtSymbol.text.toUpperCase();
		internalSymbolID=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);
		applyFilter();
	}
}

protected function adgUserTradeHistory_headerReleaseHandler(event:DataGridEvent):void
{
	event.preventDefault();
//	// Start : Temp Added
//	var sort:Sort = new Sort();
//	
//	//get the column clicked
//	var currentCol:DataGridColumn = DataGridColumn(event.itemRenderer.data);
//	
//	//reverse the current sort
//	currentCol.sortDescending = !currentCol.sortDescending;
//	
//	//add the new sort to the collection so the grid can use it
//	//to update the header display
//	sort.fields = [new SortField(currentCol.dataField,
//		true,currentCol.sortDescending)];
//	adgUserTradeHistory.collectioView.sort = sort;
//	
//	//reset the colums array for our sort arrow display
//	//to take effect
//	adgUserTradeHistory.columns = adgUserTradeHistory.columns;
//	// End : Temp Added

	if (event.dataField == "SYMBOL_CODE")
	{
		if (event.dataField == ModelManager.getInstance().userTradeHistoryModel.sortColumnName)
		{
			ModelManager.getInstance().userTradeHistoryModel.decending=ModelManager.getInstance().userTradeHistoryModel.decending ? false : true;
		}

		ModelManager.getInstance().userTradeHistoryModel.makeUserTradeHistorySymbolGroups(event.dataField, ModelManager.getInstance().userTradeHistoryModel.decending);
	}
	else if (event.dataField == "CLIENT_CODE")
	{
		if (event.dataField == ModelManager.getInstance().userTradeHistoryModel.sortColumnName)
		{
			ModelManager.getInstance().userTradeHistoryModel.decending=ModelManager.getInstance().userTradeHistoryModel.decending ? false : true;
		}

		ModelManager.getInstance().userTradeHistoryModel.makeUserTradeHistoryAccountGroups(event.dataField, ModelManager.getInstance().userTradeHistoryModel.decending);
	}

	ModelManager.getInstance().userTradeHistoryModel.sortColumnName=event.dataField;

//	event.preventDefault();
}

public function applyFilter():void
{
	//ModelManager.getInstance().userTradeHistoryModel.userTradeHistory.refresh();
	var sortColumnName:String=ModelManager.getInstance().userTradeHistoryModel.sortColumnName;
	if (sortColumnName == "SYMBOL_CODE")
	{
		ModelManager.getInstance().userTradeHistoryModel.makeUserTradeHistorySymbolGroups(sortColumnName, ModelManager.getInstance().userTradeHistoryModel.decending);
	}
	else if (sortColumnName == "CLIENT_CODE")
	{
		ModelManager.getInstance().userTradeHistoryModel.makeUserTradeHistoryAccountGroups(sortColumnName, ModelManager.getInstance().userTradeHistoryModel.decending);
	}
}

protected function btnRefresh_clickHandler(event:MouseEvent):void
{
	ModelManager.getInstance().updateUserTradeHistory();
}
