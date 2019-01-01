package model.users
{
	public class AddressVo
	{
		public var receiverName:String = "王晓明";
		
		public var phone:String = "15256565485";
		
		public var province:String = "上海市";
		
		public var city:String = "浦东新区";
		
		public var town:String = "周浦镇";
		
		public var address:String = "汇腾南苑612好23号";
		
		
		public function AddressVo()
		{
		}
		
		public function get addressDetail():String
		{
			return receiverName + "-" + phone + " " + province + " " + city + " " + town + " " + address;
		}
		public function get proCityArea():String
		{
			return  province + " " + city + " " + town + " " + address;
		}
	}
}