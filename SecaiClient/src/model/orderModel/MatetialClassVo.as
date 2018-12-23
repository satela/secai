package model.orderModel
{
	public class MatetialClassVo
	{
		public var matclassname:String = "喷绘材料";
		
		public var childMatList:Array;
		public function MatetialClassVo()
		{
			childMatList = [];
			var arr:Array = ["喷绘材料","布类材料","印刷材料"];
			var ccc:int = Math.floor(Math.random()*arr.length);
			matclassname = arr[ccc];
			
			for(var i:int=0;i < 20;i++)
			{
				childMatList.push(new MaterialItemVo());
			}
		}
	}
}