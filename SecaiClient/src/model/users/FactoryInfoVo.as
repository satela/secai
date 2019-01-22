package model.users
{
	public class FactoryInfoVo
	{
		public var addr:String = "";
		
		public var name:String = "测试输入地址1";
		
		public var org_code:String = "368525478";
		public var contactor:String = "368525478";

		public var contact_phone:String = "18956589865";
		
		public function FactoryInfoVo(fvo:Object)
		{
			for(var key in fvo)
				this[key] = fvo[key];
		}
	}
}