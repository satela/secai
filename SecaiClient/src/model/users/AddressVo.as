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
		
		public function AddressVo(data:Object)
		{
			receiverName = data.cnee;
			phone = data.pn;
			address= data.addr;
			id = data.id;
			zoneid = data.zone;
			searchZoneid = ChinaAreaModel.instance.getParentId(zoneid);
		}
		
		public function get addressDetail():String
		{
			return receiverName + "-" + phone + " " + ChinaAreaModel.instance.getFullAddressByid(zoneid) + address;
		}
		public function get proCityArea():String
		{
			return  ChinaAreaModel.instance.getFullAddressByid(zoneid) + " " + address;
		}
	}
}