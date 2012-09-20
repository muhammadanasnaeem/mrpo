package assets.skins
{
	import spark.components.TextInput;

	public class SmallSkinnedTextInputView extends TextInput
	{
		[SkinPart(required="true")]
		public var txtSymbol:TextInput;

		public function SmallSkinnedTextInputView()
		{
			super();
//			this.setStyle("skinClass", SmallSkinnedTextInput);
		}
	}
	//Add EventListeners to the textview for FocusEvent
//		override protected function partAdded(partName:String, instance:Object):void {
//			super.partAdded(partName, instance);
////			if (instance == this.textView) {
////				trace ("Adding TextView");
////				this.textView.addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
////				this.textView.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
//			}
//		}

	//Clean up EventListeners and stuff...
//		override protected function partRemoved(partName:String, instance:Object):void {
//			super.partRemoved(partName, instance);
////			if (instance == this.textView) {
////				this.textView.removeEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
////				this.textView.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
//			}
//		}
}
//}
