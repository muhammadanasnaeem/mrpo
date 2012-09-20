package renderer
{
	import businessobjects.MarketWatchBO;

	import components.ComboBoxContent;

	import flash.events.Event;

	import mx.controls.ComboBox;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;

	public class ComboboxRenderer extends ComboBox
	{

		private var data_:Object;

		override public function get data():Object
		{
			return data_;
		}

		override public function set data(value:Object):void
		{
			data_=value;
		}

		private function valueChanged(event:DropdownEvent):void
		{
			try
			{
				var content:ComboBoxContent;
				var idx:int=event.target.listData.columnIndex;
				if (data_ is MarketWatchBO)
				{
					if (idx == 0)
					{
						content=(data_ as MarketWatchBO).MARKET as ComboBoxContent;
					}
					else if (idx == 1)
					{
						content=(data_ as MarketWatchBO).SYMBOL as ComboBoxContent;
					}
				}
				else
				{
					content=data_[idx] as ComboBoxContent;
				}
				//ComboBoxContent(data_[idx]).index = this.selectedIndex;
				content.index=this.selectedIndex;
			}
			catch (err:Error)
			{
			}
		}

		public function ComboboxRenderer()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
			addEventListener(DropdownEvent.CLOSE, valueChanged);
		}

		private function init(event:FlexEvent):void
		{
			try
			{
				var content:ComboBoxContent;
				var idx:int=event.target.listData.columnIndex;
				if (data_ is MarketWatchBO)
				{
					if (idx == 0)
					{
						content=(data_ as MarketWatchBO).MARKET as ComboBoxContent;
					}
					else if (idx == 1)
					{
						content=(data_ as MarketWatchBO).SYMBOL as ComboBoxContent;
					}
				}
				else
				{
					content=data_[idx] as ComboBoxContent;
				}
				var array:Array=content.list as Array;
				this.dataProvider=array;
				this.selectedIndex=content.index;
			}
			catch (err:Error)
			{
			}
		}

		//IFactory method
		public function newInstance():*
		{
		}
	}
}
