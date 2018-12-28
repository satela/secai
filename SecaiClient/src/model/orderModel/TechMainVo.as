package model.orderModel
{
	public class TechMainVo
	{
		public var totalName:String = "包边";
		public var techlist:Array ;
		public function TechMainVo()
		{
			techlist = new Array();
			
			var num:int = Math.random()*28;
			for(var i:int=0;i < num;i++)
			{
				var tech:SingleTechVo = new SingleTechVo();
				techlist.push(tech);
			}
			
		}
	}
}