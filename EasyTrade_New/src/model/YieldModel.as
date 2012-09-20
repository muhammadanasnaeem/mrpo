package model
{
	import common.Messages;
	
	import components.EZNumberFormatter;
	
	import controller.WindowManager;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class YieldModel implements IModel
	{
		public function YieldModel()
		{
		}

		public function execute():void
		{
		}

		public function onResult(event:ResultEvent):void
		{
			if (!event.result)
			{
				return;
			}
			var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
			numberFormatter.precision=4;
			WindowManager.getInstance().viewManager.yieldCalculator.txtRate.text=numberFormatter.format(event.result.rate * 100);
			CursorManager.removeBusyCursor();
		}
		
		public function onResult2(event:ResultEvent):void
		{
			if (!event.result)
			{
				return;
			}
			var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
			numberFormatter.precision=4;
			WindowManager.getInstance().viewManager.sellOrder.txtCalculatedYield.text=numberFormatter.format(event.result.rate * 100);
			CursorManager.removeBusyCursor();
		}
		
		public function onResult1(event:ResultEvent):void
		{
			if (!event.result)
			{
				return;
			}
			var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
			numberFormatter.precision=4;
			WindowManager.getInstance().viewManager.buyOrder.txtCalculatedYield.text=numberFormatter.format(event.result.rate * 100);
			CursorManager.removeBusyCursor();
		}
		
		public function onResult3(event:ResultEvent):void
		{
			try
			{
				
				if (!event.result)
				{
					return;
				}
				var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
				numberFormatter.precision=4;
				WindowManager.getInstance().viewManager.buyOrder.txtBondBidYield.text=numberFormatter.format(event.result.rate * 100);
				CursorManager.removeBusyCursor();
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}
		
		public function onResult4(event:ResultEvent):void
		{
			try
			{
				if (!event.result)
				{
					return;
				}
				var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
				numberFormatter.precision=4;
				WindowManager.getInstance().viewManager.sellOrder.txtBondBidYield.text=numberFormatter.format(event.result.rate * 100);
				CursorManager.removeBusyCursor();	
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}
		
		public function onResult5(event:ResultEvent):void
		{
			try
			{
				if (!event.result)
				{
					return;
				}
				var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
				numberFormatter.precision=4;
				WindowManager.getInstance().viewManager.buyOrder.txtBondAskYield.text=numberFormatter.format(event.result.rate * 100);
				CursorManager.removeBusyCursor();
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}
		
		public function onResult6(event:ResultEvent):void
		{
			try
			{
				if (!event.result)
				{
					return;
				}
				var numberFormatter:EZNumberFormatter=new EZNumberFormatter();
				numberFormatter.precision=4;
				WindowManager.getInstance().viewManager.sellOrder.txtBondAskYield.text=numberFormatter.format(event.result.rate * 100);
				CursorManager.removeBusyCursor();
			}
			catch(e:Error)
			{
				
			}
		}

		public function onFault(event:FaultEvent):void
		{
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}

		public function set isDirty(value:Boolean):void
		{
		}
	}
}
