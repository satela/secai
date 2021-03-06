package model.users
{
	import model.HttpRequestUtil;
	import model.orderModel.PaintOrderModel;

	public class FactoryInfoVo
	{
		public var addr:String = "";
		
		public var name:String = "测试输入地址1";
		
		public var org_code:String = "368525478";
		public var contactor:String = "368525478";

		public var contact_phone:String = "18956589865";
		
		public var manu_priority:int = 0;//优先级
		
		public function FactoryInfoVo(fvo:Object)
		{
			for(var key in fvo)
				this[key] = fvo[key];
			if(PaintOrderModel.instance.allManuFacutreMatProcPrice[org_code] == null)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getManuFactureMatProcPrice + org_code,this,function(dataStr:*):void{
					
					PaintOrderModel.instance.initManuFacuturePrice(org_code,dataStr);
					
				},null,null);
			}
		}
	}
}