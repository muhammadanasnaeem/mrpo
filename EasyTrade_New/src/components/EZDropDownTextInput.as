package components
{
	import assets.skins.SkinnedDropDownList;
	import assets.skins.SkinnedTextInput;
	import assets.skins.SmallSkinnedTextInput;

	import flash.events.Event;

	import mx.controls.Image;
	import mx.controls.TextInput;
	import mx.events.ResizeEvent;


	public class EZDropDownTextInput extends TextInput
	{
		[Embed(source='../../images/ddtb.png')]
		private var ddArrowIcon:Class;
		private var ddArrowImg:Image=new Image();

		public function EZDropDownTextInput()
		{
			super();
		}

		override protected function createChildren():void
		{
			super.createChildren();
			ddArrowImg.source=ddArrowIcon;
			ddArrowImg.height=this.height + 1;
			ddArrowImg.width=this.height;
			ddArrowImg.x=this.width - ddArrowImg.width - 1;
			ddArrowImg.y=this.height - ddArrowImg.height + 3;
			addChild(ddArrowImg);
			setStyle("padding", 0);
			this.addEventListener(ResizeEvent.RESIZE, onResize);
		}

		private function onResize(event:ResizeEvent):void
		{
			ddArrowImg.x=event.currentTarget.width - ddArrowImg.width;
		}
	}
}
