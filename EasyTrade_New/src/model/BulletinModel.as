package model
{
	import businessobjects.Bulletin;
	
	import common.Messages;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.AnnouncerClient;

	public class BulletinModel implements IModel
	{
		private var isDirty_:Boolean=true;

		public function get isDirty():Boolean
		{
			return isDirty_;
		}

		public function set isDirty(value:Boolean):void
		{
			isDirty_=value;
		}

		private var bulletin_:Bulletin=new Bulletin();

		public function get bulletin():Bulletin
		{
			return bulletin_;
		}

		public function set bulletin(value:Bulletin):void
		{
			bulletin_=value;
		}


		public function BulletinModel()
		{
		}

		public function execute():void
		{
			AnnouncerClient.getInstance().SubmitBulletin(bulletin);
		}

		public function onResult(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
		}

		public function onFault(event:FaultEvent):void
		{
			isDirty=true;
			Alert.show(event.fault.faultDetail, ResourceManager.getInstance().getString('marketwatch','error'));
			CursorManager.removeBusyCursor();
		}
	}
}
