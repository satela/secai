package model.orderModel
{
	//工艺类vo
	public class ProcessCatVo
	{
		public var procCat_Seq: int = 0;// 工艺类顺序
		public var procCat_Name: String = "";// 工艺类名称

		public var selected:Boolean = false;
		public var nextMatList:Vector.<MaterialItemVo>;
		public function ProcessCatVo(data:Object)
		{
			for(var key in data)
				this[key] = data[key];
		}
	}
}