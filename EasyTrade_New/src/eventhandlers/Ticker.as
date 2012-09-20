import common.Constants;

import components.ticker.Ticker;
import components.ticker.TickerType;

import controller.ModelManager;

import flash.events.MouseEvent;
import flash.events.TimerEvent;

import mx.events.ResizeEvent;

protected function startTicker(t:Ticker, items:Array):void
{
	t.width=this.screen.width;
	t.queueItems(items);
	t.animate();
}

private function addItemsToQueue(t:Ticker, items:Array):void
{
	if (!t.hasVisibleItems() /* || t.itemQueue.length < items.length*/)
	{
		t.queueItems(items);
	}
}

private function handleRollOver(event:MouseEvent):void
{
	pauseTicker(event.target as Ticker);
}

private function handleRollOut(event:MouseEvent):void
{
	resumeTicker(event.target as Ticker);
}

private function handleQueueFillTimer(event:TimerEvent):void
{
	if (symbolTapeTicker.queueRunningLow())
	{
		addItemsToQueue(symbolTapeTicker, ModelManager.getInstance().symbolTickerFeedModel.feed);
	}

	if (newsTapeTicker.queueRunningLow())
	{
		addItemsToQueue(newsTapeTicker, ModelManager.getInstance().newsTickerFeedModel.feed);
	}
}

private function handleResize(event:ResizeEvent):void
{
	newsTapeTicker.dispatchEvent(event);
	symbolTapeTicker.dispatchEvent(event);
}

private function pauseTicker(t:Ticker):void
{
	if (t)
	{
		t.pause(Constants.TICKER_PAUSE_REASON_MOUSE_OVER);
	}
}

private function resumeTicker(t:Ticker):void
{
	if (t)
	{
		t.resume(Constants.TICKER_PAUSE_REASON_MOUSE_OVER);
	}
}
