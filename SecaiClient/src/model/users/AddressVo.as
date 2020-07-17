package model.users
{
	import model.ChinaAreaModel;

	public class AddressVo
	{
		public static var ADDRESS_DELETE:String = "delete";
		public static var ADDRESS_UPDATE:String = "update";
		public static var ADDRESS_INSERT:String = "insert";
		public static var ADDRESS_LIST:String = "list";

		public var receiverName:String = "王晓明";
		
		public var phone:String = "15256565485";
		
		public var zoneid:String = "";
		
		public var searchZoneid:String = "";
		
		//public var city:String = "浦东新区";
		
		//public var town:String = "周浦镇";
		
		public var address:String = "汇腾南苑612好23号";
		
		public var id:String;
		
		public var preAddName:String;
		
		public var status:int = 0;
		
		public function AddressVo(data:Object)
		{
			receiverName = data.cnee;
			phone = data.pn;
			address= data.addr;
			id = data.id;
			
			preAddName = data.zonename;
			status = data.status;
			
			var addid:Array = data.zone.split("|");
			zoneid = addid[0];
			searchZoneid = addid[1];
		}
		
		public function get addressDetail():String
		{
			return receiverName + "-" + phone + " " + preAddName + address;
		}
		public function get proCityArea():String
		{
			return  preAddName + " " + address;
		}
	}
}