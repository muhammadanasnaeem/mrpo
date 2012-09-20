package components
{
	import mx.collections.ArrayList;

	public class ComboBoxContent
	{
		private var list_:Array;

		public function get list():Array
		{
			return list_;
		}

		private var index_:int;

		public function get index():int
		{
			return index_;
		}

		public function set index(val:int):void
		{
			index_=val;
		}

		public function get value():Object
		{
			if (index_ < list.length)
				return list[index_];
			else
				return null;
		}

		public function ComboBoxContent(list:Array, index:int=-1)
		{
			list_=list;
			index_=index;
		}
	}

}
