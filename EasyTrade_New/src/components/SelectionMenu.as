import common.Constants;
import common.Messages;

import components.ComboBoxItem;
import components.EZDropDownTextInput;
import components.FormPrintView;

import controller.ModelManager;
import controller.ProfileManager;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.managers.PopUpManager;
import mx.resources.ResourceManager;

import spark.components.CheckBox;
import spark.components.TextInput;

import view.BulletinControl;
import view.MarketSummary;
import view.SelectionMenu;

[Bindable]
public var internalExchangeID:Number=-1;
//public var marketID:Number = -1;
[Bindable]
public var internalMarketID:Number=-1;
public var internalSymbolID:Number=-1;
public var symbolID:Number=-1;

[Bindable]
private var exchangeList:ArrayList=new ArrayList();

[Bindable]
private var marketList:ArrayList=new ArrayList();

protected function txtExchange_clickHandler(event:MouseEvent):void
{
	if (txtExchange && !txtExchange.enabled)
	{
		return;
	}
	var menu:SelectionMenu=PopUpManager.createPopUp(this, SelectionMenu) as SelectionMenu;
	menu.layoutDirection = (FlexGlobals.topLevelApplication.parameters.LOCALE == 'ar_SA')?'rtl':'ltr';
	menu.lstList.dataProvider=exchangeList;
	positionMenu(event, menu);
	menu.addEventListener(Constants.EVENT_MENU_CLOSE, exchangeSelectionMenuClosed);
}

protected function txtMarket_clickHandler(event:MouseEvent):void
{
	if (txtMarket && !txtMarket.enabled)
	{
		return;
	}
	if (internalExchangeID < 0)
	{
		Alert.show(ResourceManager.getInstance().getString('marketwatch','selectExchange'), ResourceManager.getInstance().getString('marketwatch','error'));
		return;
	}
	var menu:SelectionMenu=PopUpManager.createPopUp(this, SelectionMenu) as SelectionMenu;
	marketList=ModelManager.getInstance().exchangeModel.getexchangeMarkets(internalExchangeID);
	menu.lstList.dataProvider=marketList;
	positionMenu(event, menu);
	menu.addEventListener(Constants.EVENT_MENU_CLOSE, marketSelectionMenuClosed);
}

private function positionMenu(event:MouseEvent, menu:SelectionMenu):void
{
	
	var ptCell:Point=new Point(event.currentTarget.x, event.currentTarget.y);
	var ptMenu:Point=this.contentToGlobal(ptCell);
	if (menu.height + ptMenu.y > event.currentTarget.parent.height)
	{
		ptCell=new Point(event.currentTarget.x, event.currentTarget.y);
		ptMenu=this.contentToGlobal(ptCell);
	}
	menu.lstList.width=event.currentTarget.width;
	menu.move(ptMenu.x, ptMenu.y);
}

protected function exchangeSelectionMenuClosed(event:Event):void
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

		var cm:CheckBox=null;
		try
		{
			cm=this["chkAllMarkets"];
			if (cm)
			{
				cm.selected=false;
			}
		}
		catch (e0:Error)
		{
			trace(e0.errorID + " : " + e0.message);
		}
		try
		{
			var etm:EZDropDownTextInput=this["txtMarket"];
			if (etm)
			{
				etm.text="";
				if (cm && !cm.selected)
				{
					etm.enabled=true;
				}
			}
		}
		catch (e1:Error)
		{
			trace(e1.errorID + " : " + e1.message);
		}

		var cs:CheckBox=null;
		try
		{
			cs=this["chkAllSymbols"];
			if (cs)
			{
				cs.selected=false;
			}
		}
		catch (e2:Error)
		{
			trace(e2.errorID + " : " + e2.message);
		}
		try
		{
			var ets:EZDropDownTextInput=this["txtSymbol"];
			if (ets)
			{
				ets.text="";
				if (cs && !cs.selected)
				{
					ets.enabled=true;
				}
			}
		}
		catch (e3:Error)
		{
			trace(e3.errorID + " : " + e3.message);
		}

		applyFilter();
	}
}

protected function exchangeSelectorRefreshButton(event:MouseEvent):void
{
	if(event.currentTarget.id == "refreshButton")
	{
//		txtExchange.text=event.currentTarget.lstList.selectedItem.label;
//		internalExchangeID=event.currentTarget.lstList.selectedItem.value;
		txtMarket.text="";
		internalMarketID=-1;
		internalSymbolID=-1;
		
		var cm:CheckBox=null;
		try
		{
			cm=this["chkAllMarkets"];
			if (cm)
			{
				cm.selected=false;
			}
		}
		catch (e0:Error)
		{
			trace(e0.errorID + " : " + e0.message);
		}
		try
		{
			var etm:EZDropDownTextInput=this["txtMarket"];
			if (etm)
			{
				etm.text="";
				if (cm && !cm.selected)
				{
					etm.enabled=true;
				}
			}
		}
		catch (e1:Error)
		{
			trace(e1.errorID + " : " + e1.message);
		}
		
		var cs:CheckBox=null;
		try
		{
			cs=this["chkAllSymbols"];
			if (cs)
			{
				cs.selected=false;
			}
		}
		catch (e2:Error)
		{
			trace(e2.errorID + " : " + e2.message);
		}
		try
		{
			var ets:EZDropDownTextInput=this["txtSymbol"];
			if (ets)
			{
				ets.text="";
				if (cs && !cs.selected)
				{
					ets.enabled=true;
				}
			}
		}
		catch (e3:Error)
		{
			trace(e3.errorID + " : " + e3.message);
		}
		
		applyFilter();		
	}
}

protected function marketSelectionMenuClosed(event:Event):void
{
	if (!event.currentTarget.lstList.selectedItem)
	{
		return;
	}
	txtMarket.text=event.currentTarget.lstList.selectedItem.label;
	internalMarketID=event.currentTarget.lstList.selectedItem.value;
	internalSymbolID=-1;
	symbolID=-1;
	try
	{
		var ts:TextInput=this["txtSymbol"];
		if (ts)
		{
			ts.text="";
		}
	}
	catch (e1:Error)
	{
		trace(e1.errorID + " : " + e1.message);
	}
	var cs:CheckBox=null;
	try
	{
		cs=this["chkAllSymbols"];
		if (cs)
		{
			cs.selected=false;
		}
	}
	catch (e2:Error)
	{
		trace(e2.errorID + " : " + e2.message);
	}
	try
	{
		var ets:EZDropDownTextInput=this["txtSymbol"];
		if (ets)
		{
			ets.text="";
			if (cs && !cs.selected)
			{
				ets.enabled=true;
			}
		}
	}
	catch (e3:Error)
	{
		trace(e3.errorID + " : " + e3.message);
	}
	applyFilter();
}

public function setDefaultExchangeAndMarket():void
{
	// added on 24/12/2010
	if (ProfileManager.getInstance().defaultInternalExchangeId > -1 && ProfileManager.getInstance().defaultInternalMarketId > -1)
	{
		internalExchangeID=ProfileManager.getInstance().defaultInternalExchangeId;
		internalMarketID=ProfileManager.getInstance().defaultInternalMarketId;


		//for each (var cbiObj:ComboBoxItem in exchangeList)
		for (var x:int=0; x < exchangeList.length; x++)
		{
			var cbiExObj:ComboBoxItem=exchangeList.getItemAt(x) as ComboBoxItem;
			if (cbiExObj.value == internalExchangeID.toString())
			{
				if (txtExchange)
				{
					txtExchange.text=cbiExObj.label;
					txtMarket.text="";

					marketList=ModelManager.getInstance().exchangeModel.getexchangeMarkets(internalExchangeID);

					for (var y:int=0; y < marketList.length; y++)
					{
						var cbiMaObj:ComboBoxItem=marketList.getItemAt(y) as ComboBoxItem;
						if (cbiMaObj.value == internalMarketID.toString())
						{
							txtMarket.text=cbiMaObj.label;
							break;
						}
					}
					applyFilter();
					break;
				}
			}
		}
	}
}
