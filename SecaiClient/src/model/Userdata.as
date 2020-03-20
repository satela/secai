package model
{
	import model.users.AddressVo;
	
	import ui.usercenter.AddressMgrPanelUI;

	public class Userdata
	{
		private static var _instance:Userdata;
		
		public var userId:int;
		public var userSession:String;
		
		public var userAccount:String;
		
		public var userName:String;
		
		public var company:String;
		public var companyShort:String;
		
		public var addressList:Array = [];
		public var defaultAddId:String = "";//默认收货地址
		
		public var money:Number;
		
		public var isLogin:Boolean = false;
		
		public var defaultAddrid:String = "0";
		
		public var loginTime:Number = 0;
		
		public var accountType:int = 0;//0 公司创建者  1 公司职员

		public static function get instance():Userdata
		{
			if(_instance == null)
				_instance = new Userdata();
			return _instance;
		}
		public function Userdata()
		{
			
		}
		
		public function initMyAddress(adddata:Array):void
		{
			addressList = [];
			for(var i:int=0;i < adddata.length;i++)
			{
				addressList.push(new AddressVo(adddata[i]));
			}
		}
		
		public function addNewAddress(adddata:Object):void
		{
			if(addressList == null)
				addressList = [];
			addressList.push(new AddressVo(adddata));

		}
		
		public function updateAddress(adddata:Object):void
		{
			for(var i:int=0;i < addressList.length;i++)
			{
				if(addressList[i].id == adddata.id)
				{
					addressList[i] = new AddressVo(adddata);
					break;
				}
			}
		}
		public function deleteAddr(id:String):void
		{
			for(var i:int=0;i < addressList.length;i++)
			{
				if(addressList[i].id == id)
				{
					addressList.splice(i,1);
					break;
				}
			}
		}
		
		public function getDefaultAddress():AddressVo
		{
			if(addressList == null || addressList.length == 0)
				return null;
			else
			{
				for(var i:int=0;i < addressList.length;i++)
				{
					if(addressList[i].id == defaultAddId)
						return addressList[i];
				}
			}
			
			return addressList[0];
		}
	}
}