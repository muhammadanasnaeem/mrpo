package configuration
{
	import flash.events.Event;
	
	import flexlib.mdi.effects.IMDIEffectsDescriptor;
	import flexlib.mdi.events.MDIManagerEvent;
	import flexlib.mdi.managers.MDIManager;
	
	import mx.core.UIComponent;
	
	public class CustomMDIManager extends MDIManager
	{
		public function CustomMDIManager(container:UIComponent, effects:IMDIEffectsDescriptor=null)
		{
			super(container, effects);
		}
		
		override public function executeDefaultBehavior(event:Event):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
		}
	}
}