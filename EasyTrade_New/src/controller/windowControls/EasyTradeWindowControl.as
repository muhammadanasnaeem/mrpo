package controller.windowControls
{
	import flexlib.mdi.containers.MDIWindowControlsContainer;

	public class EasyTradeWindowControl extends MDIWindowControlsContainer
	{
		public function EasyTradeWindowControl()
		{
			super();
		}

		override protected function createChildren():void
		{
			super.createChildren();

			setStyle("horizontalGap", 0);
		}
	}
}
