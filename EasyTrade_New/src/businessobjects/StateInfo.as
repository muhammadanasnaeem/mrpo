package businessobjects
{

	public class StateInfo
	{
		public function StateInfo(stateValue:String, startDateTimeValue:String)
		{
			state=stateValue;
			startDateTime=startDateTimeValue;
		}

		private var startDateTime_:String="";

		[Bindable]
		public function get startDateTime():String
		{
			return startDateTime_;
		}

		public function set startDateTime(value:String):void
		{
			startDateTime_=value;
		}

		private var state_:String="";

		[Bindable]
		public function get state():String
		{
			return state_;
		}

		public function set state(value:String):void
		{
			state_=value;
		}

		private var name_:String;

		public function get name():String
		{
			return name_;
		}

		public function set name(value:String):void
		{
			name_=value;
		}

		private var description_:String;

		public function get description():String
		{
			return description_;
		}

		public function set description(value:String):void
		{
			description_=value;
		}

	}
}
