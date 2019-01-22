package model
{
	import model.users.AddressVo;

	public class Userdata
	{
		private static var _instance:Userdata;
		
		public var userId:int;
		public var userSession:String;
		
		public var userAccount:String;
		
		public var userName:String;
		
		public var company:String;
		
		public var addressList:Vector.<AddressVo>;
		
		public var money:Number;
		
		public var isLogin:Boolean = false;
		
		public var defaultAddrid:String = "0";
		

		public static function get instance():Userdata
		{
			if(_instance == null)
				_instance = new Userdata();
			return _instance;
		}
		public function Userdata()
		{
			
		}
	}
}