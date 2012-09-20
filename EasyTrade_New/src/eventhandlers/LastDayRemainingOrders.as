import businessobjects.OrderBO;

import common.Constants;

import components.ComboBoxItem;

import controller.ModelManager;
import controller.ViewManager;
import controller.WindowManager;

import flash.events.MouseEvent;

import flashx.textLayout.operations.ApplyFormatOperation;

import flexlib.mdi.containers.MDIWindow;
import flexlib.mdi.events.MDIWindowEvent;

import model.OrderModel;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.INavigatorContent;
import mx.events.FlexEvent;

import view.Order;

[Bindable]
public var modelManager:ModelManager=ModelManager.getInstance();

[Bindable]
public var selectionFlag:Boolean;


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
}


//protected function adgRemainingOrders_itemClickHandler(event:MouseEvent):void
//{
//	var windowManager:WindowManager = WindowManager.getInstance();
//	if (!this.adgRemainingOrders.selectedItem)
//	{
//		return;
//	}
//	if (this.adgRemainingOrders.selectedItem.SYMBOL_ID > 0)
//	{
//		var window:MDIWindow = null;
//		var orderVeiw:Order = null;
//		if (event.ctrlKey)
//		{
//			windowManager.viewManager.cancelOrder.isFromMenu = false;
//			windowManager.viewManager.cancelOrder.reset();
//			windowManager.viewManager.cancelOrder.isFirstSubmission = true;
//			if (windowManager.cancelOrderWindow && windowManager.canvas.windowManager.container.contains(windowManager.cancelOrderWindow))
//			{
//				windowManager.updateCancelOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
//				windowManager.canvas.windowManager.bringToFront(windowManager.cancelOrderWindow);
//			}
//			else
//			{
//				windowManager.initCancelOrderWindow();
//				windowManager.updateCancelOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
//				windowManager.canvas.windowManager.add(windowManager.cancelOrderWindow);
//			}
//			window = windowManager.cancelOrderWindow;
//			orderVeiw = windowManager.viewManager.cancelOrder;
//		}
//		else
//		{
//			windowManager.viewManager.changeOrder.isFromMenu = false;
//			windowManager.viewManager.changeOrder.disableFields(false);
//			windowManager.viewManager.changeOrder.reset();
//			windowManager.viewManager.changeOrder.isFirstSubmission = true;
//			if (windowManager.changeOrderWindow && windowManager.canvas.windowManager.container.contains(windowManager.changeOrderWindow))
//			{
//				windowManager.updateChangeOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
//				windowManager.canvas.windowManager.bringToFront(windowManager.changeOrderWindow);
//			}
//			else
//			{
//				windowManager.initChangeOrderWindow();
//				windowManager.updateChangeOrderWindow(this.adgRemainingOrders.selectedItem as OrderBO);
//				windowManager.canvas.windowManager.add(windowManager.changeOrderWindow);
//			}
//			window = windowManager.changeOrderWindow;
//			orderVeiw = windowManager.viewManager.changeOrder;
//		}
//		if (window != null)
//		{
//			if (this.adgRemainingOrders.selectedItem.SIDE == "buy")
//			{
//				windowManager.setWindowColor(window, orderVeiw, Constants.BUY_COLOR_INT);
//			}
//			else
//			{
//				windowManager.setWindowColor(window, orderVeiw, Constants.SELL_COLOR_INT);
//			}
//		}
//	}
//}

protected function txtSymbol_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 9 || event.keyCode == 13)
	{
		txtSymbol.text=txtSymbol.text.toUpperCase();
		internalSymbolID=ModelManager.getInstance().exchangeModel.getInternalSymbolIDByCode(internalExchangeID, internalMarketID, txtSymbol.text);
		applyFilter();
	}
}

public function applyFilter():void
{
	modelManager.lastDayRemainingOrdersModel.remainingOrders.refresh();
}

public function selectDeselectAll(event:MouseEvent):void
{
	var flag:Boolean=event.currentTarget.selected;

	for (var i:int=0; i < modelManager.lastDayRemainingOrdersModel.remainingOrders.length; i++)
	{
		modelManager.lastDayRemainingOrdersModel.remainingOrders.getItemAt(i).SELECTED=flag;
	}
}

public function changeSelection():void
{
	for (var i:int=0; i < modelManager.lastDayRemainingOrdersModel.remainingOrders.length; i++)
	{
		if (!modelManager.lastDayRemainingOrdersModel.remainingOrders.getItemAt(i).SELECTED)
		{
			selectionFlag=false;
			return;
		}
	}

	if (modelManager.lastDayRemainingOrdersModel.remainingOrders.length > 0)
	{
		selectionFlag=true;
	}
}

/*public var userID:Number;
private var isExpanded:Boolean = false;

public function handleExpandAll(event:ItemClickEvent):void
{
var lbl:String;
if (isExpanded)
{
isExpanded = false;
lbl = Constants.BTN_TEXT_EXPAND_ALL;
adgRemainingOrders.collapseAll();
}
else
{
isExpanded = true;
lbl = Constants.BTN_TEXT_COLLAPSE_ALL;
adgRemainingOrders.expandAll();
}
var dp:ArrayCollection = new ArrayCollection();
dp.addItem(lbl);
dp.addItem(Constants.BTN_TEXT_REFRESH);
//toolbar.dataProvider = dp;
}

public function reset():void
{
isExpanded = false;
var dp:ArrayCollection = new ArrayCollection();
dp.addItem(Constants.BTN_TEXT_EXPAND_ALL);
dp.addItem(Constants.BTN_TEXT_REFRESH);
//toolbar.dataProvider = dp;
}
*/

//protected function btnRefresh_clickHandler(event:MouseEvent):void
//{
//	ModelManager.getInstance().updateLastDayRemainingOrders();
//}

protected function btnSubmit_clickHandler(event:MouseEvent):void
{
	var submittedOrders:ArrayCollection=new ArrayCollection();
	var length:int=modelManager.lastDayRemainingOrdersModel.remainingOrders.length;
	for (var i:int=0; i < length; i++)
	{
		var orderBO:OrderBO=modelManager.lastDayRemainingOrdersModel.remainingOrders.getItemAt(i) as OrderBO;
		if (orderBO.SELECTED)
		{
			submittedOrders.addItem(orderBO);
		}
	}

	if (submittedOrders.length > 0)
	{
		modelManager.orderModel.executeLastDayRemainigOrders(submittedOrders);
	}
}

protected function btnCancel_clickHandler(event:MouseEvent):void
{
	var result:Boolean=WindowManager.getInstance().lastDayRemainingOrdersWindow.dispatchEvent(new MDIWindowEvent(MDIWindowEvent.CLOSE, WindowManager.getInstance().lastDayRemainingOrdersWindow, null, false));
}

protected function btnRefresh_clickHandler(event:MouseEvent):void
{
	modelManager.updateLastDayRemainingOrders();
}

