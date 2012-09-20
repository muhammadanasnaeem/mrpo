package components.ticker
{
	import flash.display.DisplayObject
	import flash.display.Sprite;
	import flash.events.Event;

	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;

	public class Ticker extends UIComponent
	{
		static public const QUEUE_RUNNING_LOW:String="queueRunningLow";

		static private const EDGE_PADDING:Number=5;

		static private const FRAME_RATE:Number=60;

		public var ITEM_WIDTH:Number=65;
		public var ITEM_HEIGHT:Number=50;

		static private const ITEM_PADDING:Number=0;
		static private const ITEM_BUFFER:Number=3;

		private var childContainer_:UIComponent=new UIComponent();
		private var itemDataQueue_:Array=new Array();
		private var items_:Array=new Array();
		private var unusedItems_:Array=new Array();
		private var speed_:Number=60;
		private var framesPerMove_:uint=1;
		private var pixelsToMove_:uint=1;
		private var frameCount_:Number=30;
		private var mask_:Sprite=new Sprite();
		private var maskInvalid_:Boolean=true;
		private var pauseReasonFlags_:int=0;
		private var nextPauseReasonFlag_:int=0;
		private var tickerType_:String=TickerType.UNDEFINED;

		public function get tickerType():String
		{
			return tickerType_;
		}

		public function set tickerType(value:String):void
		{
			tickerType_=value;
		}

		private var pauseReasonDetailOpen_:int;

		public function Ticker()
		{
			super();
			pauseReasonDetailOpen_=allocatePauseReasonFlag();
		}

		public function get itemQueue():Array
		{
			return itemDataQueue_;
		}

		public function queueItem(newItem:TickerItemData):Boolean
		{
			return queueItems([newItem]);
		}

		public function queueItems(newItems:Array):Boolean
		{
			var filteredItems:Array=new Array();
			var tickerQueueLookup:Object=new Object();
			for each (var tickerItem:IFlexDisplayObject in items_)
			{
				if (tickerType == TickerType.TAPE_TICKER_NEWS)
				{
					if ((tickerItem as NewsTapeTickerItem).data)
					{
						tickerQueueLookup[(tickerItem as NewsTapeTickerItem).data.guid]=true;
					}
				}
				else if (tickerType == TickerType.TAPE_TICKER_SYMBOL)
				{
					if ((tickerItem as SymbolTapeTickerItem).data)
					{
						tickerQueueLookup[(tickerItem as SymbolTapeTickerItem).data.guid]=true;
					}
				}
			}
			for each (var tickerItemData:TickerItemData in itemDataQueue_)
			{
				if (tickerItemData)
				{
					tickerQueueLookup[tickerItemData.guid]=true;
				}
			}
			for (var i:uint=0; i < newItems.length; i++)
			{
				if (newItems[i] == undefined || tickerQueueLookup[newItems[i].guid] == undefined)
				{
					if (newItems[i] != undefined)
					{
						tickerQueueLookup[newItems[i].guid]=true;
					}
					filteredItems.push(newItems[i]);
				}
			}
			for each (var item:TickerItemData in filteredItems)
			{
				itemDataQueue_.push(item);
			}
			fillItemsFromQueue();
			return (filteredItems.length > 0);
		}

		public function queueRunningLow():Boolean
		{
			return (itemDataQueue_.length < ITEM_BUFFER);
		}

		public function clearQueue():void
		{
			itemDataQueue_=new Array();
		}

		[Bindable]
		public function get speed():Number
		{
			return speed_;
		}

		public function set speed(value:Number):void
		{
			speed_=value;
			recalcSpeed();
		}

		private function recalcSpeed():void
		{
			var effectiveSpeed:Number=speed_;
			if (effectiveSpeed > FRAME_RATE)
			{
				framesPerMove_=1;
				pixelsToMove_=Math.floor(effectiveSpeed / FRAME_RATE);
			}
			else
			{
				framesPerMove_=Math.floor(FRAME_RATE / effectiveSpeed);
				pixelsToMove_=1;
			}
		}

		override protected function createChildren():void
		{
			childContainer_.cacheAsBitmap=true;
			addChild(childContainer_);
			addEventListener(ResizeEvent.RESIZE, handleResize);
			addEventListener(MoveEvent.MOVE, handleMove);
			doResize();
		}

		private function handleResize(event:ResizeEvent):void
		{
			doResize();
		}

		private function handleMove(event:MoveEvent):void
		{
			maskInvalid_=true;
			invalidateDisplayList();
		}

		private function doResize():void
		{
			maskInvalid_=true;
			invalidateDisplayList();

			childContainer_.width=width + (ITEM_WIDTH + ITEM_PADDING) * (ITEM_BUFFER + 1);
			childContainer_.height=height;

			for each (var tickerItem:IFlexDisplayObject in items_)
			{
				this.setItemWidth(tickerItem);
			}

			fillItemsFromQueue();
		}

		private function calcItemWidth():Number
		{
			return ITEM_WIDTH;
		}

		private function setItemWidth(tickerItem:IFlexDisplayObject):void
		{
			tickerItem.setActualSize(this.calcItemWidth(), tickerItem.height);
		}

		public function animate():void
		{
			childContainer_.x=width;
			childContainer_.y=EDGE_PADDING;
			frameCount_=0;
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		public function allocatePauseReasonFlag():int
		{
			return nextPauseReasonFlag_++;
		}

		public function pause(pauseReasonFlag:int):void
		{
			if (pauseReasonFlags_ == 0)
			{
				removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
			pauseReasonFlags_|=(1 << pauseReasonFlag);
		}

		public function resume(pauseReasonFlag:int):void
		{
			pauseReasonFlags_&=~(1 << pauseReasonFlag);
			if (pauseReasonFlags_ == 0)
			{
				frameCount_=0;
				addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
		}

		private function handleEnterFrame(event:Event):void
		{
			if (++frameCount_ >= framesPerMove_)
			{
				frameCount_=0;
				if (items_.length > 0)
				{
					childContainer_.move(childContainer_.x - pixelsToMove_, childContainer_.y);
				}
				else if (childContainer_.x < width)
				{
					childContainer_.x=width;
				}
				fillItemsFromQueue();
			}
		}

		private function fillItemsFromQueue():void
		{
			while (items_.length > 0)
			{
				var item:IFlexDisplayObject;
				if (tickerType == TickerType.TAPE_TICKER_NEWS)
				{
					item=NewsTapeTickerItem(items_[0]);
				}
				else if (tickerType == TickerType.TAPE_TICKER_SYMBOL)
				{
					item=SymbolTapeTickerItem(items_[0]);
				}

				if (childContainer_.x + item.x + item.width < 0)
				{
					childContainer_.removeChild(items_[0]);
					unusedItems_.push(items_[0]);
					items_.shift();
					childContainer_.move(childContainer_.x + ITEM_WIDTH + ITEM_PADDING, childContainer_.y);
					for (var i:Number=0; i < items_.length; i++)
					{
						if (tickerType == TickerType.TAPE_TICKER_NEWS)
						{
							item=NewsTapeTickerItem(items_[i]);
						}
						else if (tickerType == TickerType.TAPE_TICKER_SYMBOL)
						{
							item=SymbolTapeTickerItem(items_[i]);
						}
						item.move(item.x - ITEM_WIDTH - ITEM_PADDING, item.y);
					}
				}
				else
				{
					break;
				}
			}

			if (itemDataQueue_.length > 0)
			{
				var nextItemPos:Number;
				if (items_.length == 0)
				{
					nextItemPos=0;
				}
				else
				{
					//var lastItem:TickerItem = TickerItem(items_[items_.length - 1]);
					var lastItem:IFlexDisplayObject;
					if (tickerType == TickerType.TAPE_TICKER_NEWS)
					{
						lastItem=NewsTapeTickerItem(items_[items_.length - 1]);
					}
					else if (tickerType == TickerType.TAPE_TICKER_SYMBOL)
					{
						lastItem=SymbolTapeTickerItem(items_[items_.length - 1]);
					}

					nextItemPos=lastItem.x + lastItem.width + ITEM_PADDING;
				}
				while ((itemDataQueue_.length > 0) && (nextItemPos < childContainer_.width))
				{
					//var nextItem:TickerItem = unusedItems_.shift();
					var nextItem:DisplayObject;
					if (tickerType == TickerType.TAPE_TICKER_NEWS)
					{
						nextItem=unusedItems_.shift();
					}
					else if (tickerType == TickerType.TAPE_TICKER_SYMBOL)
					{
						nextItem=unusedItems_.shift();
					}

					if (nextItem == null)
					{
						//nextItem = new TickerItem();
						if (tickerType == TickerType.TAPE_TICKER_NEWS)
						{
							nextItem=new NewsTapeTickerItem();
						}
						else if (tickerType == TickerType.TAPE_TICKER_SYMBOL)
						{
							nextItem=new SymbolTapeTickerItem();
						}

					}
					//nextItem.data = itemDataQueue_.shift();
					//nextItem.imageSide = TickerItem.IMAGE_SIDE_LEFT;
					if (tickerType == TickerType.TAPE_TICKER_NEWS)
					{
						(nextItem as NewsTapeTickerItem).data=itemDataQueue_.shift();
					}
					else if (tickerType == TickerType.TAPE_TICKER_SYMBOL)
					{
						(nextItem as SymbolTapeTickerItem).data=itemDataQueue_.shift();
					}

					nextItem.x=nextItemPos;
					nextItem.y=0;
					items_.push(nextItem);
					//this.setItemWidth(nextItem);
					if (tickerType == TickerType.TAPE_TICKER_NEWS)
					{
						this.setItemWidth(nextItem as NewsTapeTickerItem);
					}
					else if (tickerType == TickerType.TAPE_TICKER_SYMBOL)
					{
						this.setItemWidth(nextItem as SymbolTapeTickerItem);
					}
					childContainer_.addChild(nextItem);
					nextItemPos+=ITEM_WIDTH + ITEM_PADDING;
				}
			}
			if (queueRunningLow())
			{
				dispatchEvent(new Event(QUEUE_RUNNING_LOW));
			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			if (maskInvalid_)
			{
				mask_.graphics.clear();
				mask_.graphics.beginFill(0xFFFFFF);
				mask_.graphics.drawRect(x, y, unscaledWidth, unscaledHeight);
				mask_.graphics.endFill();
				mask=mask_;
				maskInvalid_=false;
			}
		}

		public function hasVisibleItems():Boolean
		{
			return (items_.length > 0);
		}
	}
}
