import businessobjects.MarketScheduleBO;
import businessobjects.MarketStateInfo;

import common.Constants;
import common.States;

import components.ComboBoxItem;

import controller.ModelManager;
import controller.ViewManager;
import controller.WindowManager;

import flash.events.Event;
import flash.events.MouseEvent;

import flashx.textLayout.operations.ApplyFormatOperation;

import flexlib.mdi.containers.MDIWindow;

import mx.collections.ArrayList;
import mx.controls.DateField;
import mx.core.IVisualElement;
import mx.events.FlexEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;

import view.Order;
import view.SelectionMenu;

[Bindable]
public var modelManager:ModelManager=ModelManager.getInstance();

[Bindable]
private var marketSchedule:MarketScheduleBO;

[Bindable]
private var marketStateList:ArrayList=new ArrayList();

private var selectedState:Number=-1;
private var isTimeChanged:Boolean=false;

protected function group1_initializeHandler(event:FlexEvent):void
{
	for (var i:int=0; i < ModelManager.getInstance().exchangeModel.exchanges.length; ++i)
	{
		var obj:Object=ModelManager.getInstance().exchangeModel.exchanges.getItemAt(i);
		var cbi:ComboBoxItem=new ComboBoxItem(obj.INTERNAL_EXCHANGE_ID.toString(), obj.EXCHANGE_CODE);
		exchangeList.addItem(cbi);
	}

	obj=null;

	for (obj in States.MARKET_STATES)
	{
		if (obj != "StateCount")
		{
			cbi=new ComboBoxItem(States.MARKET_STATES[obj].toString(), obj.toString());
			marketStateList.addItem(cbi);
		}
	}
	resetFields();
}

public function applyFilter():void
{
	marketSchedule=modelManager.exchangeScheduleModel.getMarketSchedule(internalExchangeID, internalMarketID);
	var marketCurrentState:Number=modelManager.exchangeModel.getMarketState(internalExchangeID, internalMarketID);

	if (marketCurrentState != -1)
	{
		for (var obj:Object in States.MARKET_STATES)
		{
			if (States.MARKET_STATES[obj] == marketCurrentState)
			{
				txtCurrentState.text=obj.toString();
				break;
			}
		}
	}
	else
	{
		// added on 17/1/2011
		if (txtCurrentState)
			txtCurrentState.text="";
	}
}

protected function dgMarketStates_clickHandler(event:MouseEvent):void
{
	var windowManager:WindowManager=WindowManager.getInstance();
	if (!this.dgMarketStates.selectedItem)
	{
		return;
	}

	txtRequestedMarketState.text=this.dgMarketStates.selectedItem.state_;
	selectedState=States.MARKET_STATES[txtRequestedMarketState.text];
}

protected function btnReset_clickHandler(event:MouseEvent):void
{
	resetFields();
}

public function resetFields(clearAll:Boolean=true):void
{
	if (clearAll)
	{
		txtExchange.text="";
		txtMarket.text="";
		txtRequestedMarketState.text="";

		internalExchangeID=-1;
		internalMarketID=-1;
		internalSymbolID=-1;
		symbolID=-1;
		selectedState=-1;
		txtStatus.text="";

	}
	applyFilter();
	// modified of 18/1/2011 to avoid null pointer exception
	if (txtTimeInput)
		txtTimeInput.value=new Date();
	isTimeChanged=false;
}

protected function txtRequestedMarketState_clickHandler(event:MouseEvent):void
{
	var menu:SelectionMenu=PopUpManager.createPopUp(this, SelectionMenu) as SelectionMenu;
	menu.lstList.dataProvider=marketStateList;
	positionMenu(event, menu);
	menu.addEventListener(Constants.EVENT_MENU_CLOSE, requestedMarketStateMenuClosed);
}

protected function requestedMarketStateMenuClosed(event:Event):void
{
	try
	{
		if (!event.currentTarget.lstList.selectedItem)
		{
			return;
		}
		txtRequestedMarketState.text=event.currentTarget.lstList.selectedItem.label;
		selectedState=event.currentTarget.lstList.selectedItem.value;
		if ((marketSchedule && marketSchedule.SCHEDULE.length == States.MARKET_STATES.StateCount) || (selectedState != States.MARKET_STATES.Suspend))
		{
			for (var i:int=0; i < marketSchedule.SCHEDULE.length; ++i)
			{
				if (event.currentTarget.lstList.selectedItem.label == marketSchedule.SCHEDULE[i].state_)
				{
					selectedState=i;
					break;
				}
			}
			dgMarketStates.selectedIndex=selectedState;
		}
		else
		{
			dgMarketStates.selectedIndex=-1;
		}
		dgMarketStates_clickHandler(null);
	}catch(e:Error)
	{
		trace(e.message);
	}
}

protected function btnUpdate_clickHandler(event:MouseEvent):void
{
	var marketStateInfo:MarketStateInfo=new MarketStateInfo();
	marketStateInfo.exchangeID.internalID_=internalExchangeID;
	marketStateInfo.exchangeID.actualID_=modelManager.exchangeModel.getExchangeID(internalExchangeID);

	marketStateInfo.marketID.internalID_=internalMarketID;
	marketStateInfo.marketID.actualID_=modelManager.exchangeModel.getMarketID(internalExchangeID, internalMarketID);

	if (txtCurrentState.text == txtRequestedMarketState.text)
		return;

	marketStateInfo.state_=txtRequestedMarketState.text;

	marketStateInfo.startDateTime_.date=txtTimeInput.value.getDate();
	marketStateInfo.startDateTime_.month=txtTimeInput.value.getMonth();
	marketStateInfo.startDateTime_.fullYear=txtTimeInput.value.getFullYear();

	marketStateInfo.startDateTime_.hours=new Number(txtTimeInput.value.getHours());
	marketStateInfo.startDateTime_.minutes=txtTimeInput.value.getMinutes();
	marketStateInfo.startDateTime_.seconds=txtTimeInput.value.getSeconds();
	marketStateInfo.startDateTime_.milliseconds=txtTimeInput.value.getMilliseconds();

	if (marketStateInfo.state_ == '')
		return;
	if (!isTimeChanged)
	{
		marketStateInfo.startDateTime_.hours=0;
		marketStateInfo.startDateTime_.minutes=0;
		marketStateInfo.startDateTime_.seconds=0;
		marketStateInfo.startDateTime_.milliseconds=0;
		marketStateInfo.isNullTime_=true;
	}
	else
	{
		marketStateInfo.isNullTime_=false;
	}
	modelManager.MarketStateChange(marketStateInfo);
}

protected function txtTimeInput_changeHandler(event:Event):void
{
	isTimeChanged=true;
}

public function updateStatus(statusMsg:String):void
{
	// added on 23/12/2010 
	if (txtStatus)
	{
		txtStatus.text=statusMsg;
		applyFilter();
	}
} //