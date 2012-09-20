package businessobjects
{
	import mx.collections.ArrayCollection;

	public class UserProfile
	{
		private var userId:Number=-1;
		public var roles:ArrayCollection;

		// added for client side processing

		public var userName:String;
		public var password:String;
		public var brokerId:int;
		public var grants:ArrayCollection;

		public var grantedUsers:ArrayCollection;

		public function UserProfile()
		{
		}
	}
}
