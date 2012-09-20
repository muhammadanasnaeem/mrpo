package components
{
	// Author Anas
	// This class(custom dropdownlist component) was created to eliminate duplication of items in the combo box 
	// used in the QuickOrder window there by extending this class from Combox and using HashMap based implementation for it.
	import businessobjects.QuickOrdersBO;
	
	import common.Messages;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.ComboBase;
	import mx.controls.ComboBox;
	
	import spark.components.DropDownList;
	import spark.components.List;
	import spark.effects.easing.EasingFraction;
	
	public class DedupeComboBox extends DropDownList 
	{
		override public function set dataProvider(value:IList):void
		{
			try
			{
				var _localArray:Array = ( value is ArrayCollection ) ? ( value as ArrayCollection ).source : value as Array;
				var _map:Dictionary = new Dictionary( true );
					if ( labelField.length > 0 ) {
						_localArray.forEach( function( item:*, index:int, array:Array ):void {
							_map[ item[ this ] ] = item; // in the loop, this == labelField
						}, labelField );
					}
				
				var _returnArray:ArrayCollection = new ArrayCollection;
				for each ( var object:Object in _map ) {
						if(object.SYMBOL != null)
						{
							_returnArray.addItem( object );
						}
				}
				super.dataProvider = _returnArray;//.sortOn(labelField,Array.CASEINSENSITIVE);
			}catch(e:Error)
			{
				trace(e.message);
			}
		}
		
		public function DedupeComboBox()
		{
			super();
			
		}
		
	}
}