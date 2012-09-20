import common.Constants;

import controller.WindowManager;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexMouseEvent;
import mx.managers.PopUpManager;

protected function mouseDownOutsideHandler(event:FlexMouseEvent):void
{
	PopUpManager.removePopUp(this);
}

protected function mouseDownOutsideHandler1(event:FlexMouseEvent):void
{
	PopUpManager.removePopUp(this);
}

protected function clickHandler(event:MouseEvent):void
{
	try
	{
		if (!event.currentTarget.lstList.selectedItem)
		{
			return;
		}
		PopUpManager.removePopUp(this);
		this.dispatchEvent(new Event(Constants.EVENT_MENU_CLOSE));
	}catch(e:Error)
	{
		trace(e.message);
	}
}

