package model
{
	import model.users.AddressVo;
	
	import ui.usercenter.AddressMgrPanelUI;

	public class Userdata
	{
		public var version:String = "";
		private static var _instance:Userdata;
		
		public var curRandomStr:String;
		
		public var userId:int;
		public var userSession:String;
		
		public var userAccount:String;
		
		public var userName:String;
		
		public var company:String;
		public var companyShort:String;
		
		public var addressList:Array = [];
		public var defaultAddId:String = "";//默认收货地址
		
		public var money:Number;
		
		public var actMoney:Number;//活动返现
		
		public var frezeMoney:Number;
		
		public var isLogin:Boolean = false;
		
		public var defaultAddrid:String = "0";
		
		public var loginTime:Number = 0;
		
		public var accountType:int = 0;//1 公司创建者  0 公司职员
		
	
		public var privilege:Object;//用户权限
		public static function get instance():Userdata
		{
			if(_instance == null)
				_instance = new Userdata();
			return _instance;
		}
		public function Userdata()
		{
			
		}
		
		public function resetData():void
		{
			addressList = [];
			isLogin = false;
			money = 0;
			actMoney = 0;
			frezeMoney = 0;
			accountType = 0;
			
		}
		public function initMyAddress(adddata:Array):void
		{
			addressList = [];
			for(var i:int=0;i < adddata.length;i++)
			{
				addressList.push(new AddressVo(adddata[i]));
			}			
			
		}
		
		public function canAddNewAddress():Boolean
		{
			for(var i:int=0;i < addressList.length;i++)
			{
				if(addressList[i].status == 0)
					return false;
			}
			
			return true;
		}
		public function addNewAddress(adddata:Object):void
		{
			if(addressList == null)
				addressList = [];
			addressList.push(new AddressVo(adddata));

		}
		
		public function get passedAddress():Array
		{
			if(addressList == null || addressList.length == 0)
				return [];
			else
			{
				var tempaddr:Array = [];
				for(var i:int=0;i < addressList.length;i++)
				{
					if(addressList[i].status == 1)
						tempaddr.push(addressList[i]);
				}
				return tempaddr;
			}
			
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
			var validAddList:Array = passedAddress;
			
			if(validAddList == null || validAddList.length == 0)
				return null;
			else
			{
				for(var i:int=0;i < validAddList.length;i++)
				{
					if(validAddList[i].id == defaultAddId)
						return validAddList[i];
				}
			}
			
			return validAddList[0];
		}
		
		public function isHidePrice():Boolean
		{
			if(accountType == Constast.ACCOUNT_CREATER)
				return false;
			if(accountType == Constast.ACCOUNT_EMPLOYEE && privilege[Constast.PRIVILEGE_HIDE_PRICE] == "1")
				return true;
			else
				return false;
		}
	}
}