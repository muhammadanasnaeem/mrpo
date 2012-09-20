package components
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class DupedLessArrayCollection extends ArrayCollection
	{
		
		private var _dedupeProperty:String = "";
		
		public function set dedupeProperty( value:String ):void {
			_dedupeProperty = value;
			this.source = this.source;
		}
		public function get dedupeProperty():String {
			return _dedupeProperty;
		}
		
		override public function set source( value:Array ):void {
			var _returnArray:Array = value;
			
			if ( value && dedupeProperty.length > 0 ) {
				var _map:Dictionary = new Dictionary( true );
				
				value.forEach( function( item:*, index:int, array:Array ):void {
					_map[ item[ this ] ] = item; // in the loop, this == dedupeProperty
				}, dedupeProperty );
				
				_returnArray = [];
				for each ( var object:Object in _map ) {
					_returnArray.push( object );
				}
			}
			
			super.source = _returnArray;
		}
		
		
		public function DupedLessArrayCollection(source:Array=null)
		{
			super(source);
		}
	}
}