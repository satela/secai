package model.orderModel
{
	public class MaterialItemVo
	{
		public var matName:String = "PVP塑料管";
		public var matId:int = 1;
		public var matClassType:int = 1;//材料大分类
		
		public var nextMatList:Vector.<MaterialItemVo>;
		
		public function MaterialItemVo()
		{
		}
	}
}