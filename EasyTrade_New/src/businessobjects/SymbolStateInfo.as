package businessobjects
{

	public class SymbolStateInfo extends ExchangeMarketSymbolID
	{
		private var startDateTime:Date=new Date();

		[Bindable]
		public function get startDateTime_():Date
		{
			return startDateTime;
		}

		public function set startDateTime_(value:Date):void
		{
			startDateTime=value;
		}

		private var state:String="";

		[Bindable]
		public function get state_():String
		{
			return state;
		}

		public function set state_(value:String):void
		{
			state=value;
		}

		private var name:String="";

		[Bindable]
		public function get name_():String
		{
			return name;
		}

		public function set name_(value:String):void
		{
			name=value;
		}

		private var description:String="";

		[Bindable]
		public function get description_():String
		{
			return description;
		}

		public function set description_(value:String):void
		{
			description=value;
		}

		private var persist:Boolean=false;

		public function get persist_():Boolean
		{
			return persist;
		}

		public function set persist_(value:Boolean):void
		{
			persist=value;
		}
	}
}
