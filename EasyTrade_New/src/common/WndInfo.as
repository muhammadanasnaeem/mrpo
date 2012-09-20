package common
{

	public class WndInfo
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var hasFocus:Boolean;

		/*private var id_:String = "";

		public function get id():String
		{
			return id_;
		}

		public function set id(value:String):void
		{
			id_ = value;
		}

		private var width_:Number = 0;

		public function get width():Number
		{
			return width_;
		}

		public function set width(value:Number):void
		{
			width_ = value;
		}

		private var height_:Number = 0;

		public function get height():Number
		{
			return height_;
		}

		public function set height(value:Number):void
		{
			height_ = value;
		}

		private var left_:Object;

		public function get left():Object
		{
			return left_;
		}

		public function set left(value:Object):void
		{
			left_ = value;
		}

		private var top_:Object = 0;

		public function get top():Object
		{
			return top_;
		}

		public function set top(value:Object):void
		{
			top_ = value;
		}

		private var nestLevel_:int = 0;

		public function get nestLevel():int
		{
			return nestLevel_;
		}

		public function set nestLevel(value:int):void
		{
			nestLevel_ = value;
		}*/

		public function WndInfo()
		{
		}

//		public function serialize():String
//		{
//			var value:String = "{";
//			for (var key:String in this)
//			{
//				value += key;
//				value += ":";
//				value += this[key];
//				value += ",";
//			}
//			if (value.length > 1)
//			{
//				value = value.substring(0, value.length - 1);
//			}
//			value += "}";
//			return value;
//		}
//
//		public function deSerialize(value:String):void
//		{
//			if (value.indexOf("{") != 0 || value.indexOf("}") != value.length - 1)
//			{
//				throw(new Error("Malformed object"));
//			}
//			try
//			{
//				value = value.substring(1, value.length - 1);
//				var kvPairs:Array = value.split(",");
//				for (var key:String in kvPairs)
//				{
//					var kvPair:Array = (kvPairs[key] as String).split(":");
//					this[kvPair[0]] = kvPair[1];
//				}
//			}
//			catch(e:Error)
//			{
//				throw(new Error("Malformed object"));
//			}
//		} 
	}
}
