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
			{
				if(this.hasOwnProperty(key))
				this[key] = data[key];
			}
		}
		
		public function initProcFlow(flowdata:Object):void
		{
			var proclist:Array = flowdata as Array;
			nextMatList = new Vector.<MaterialItemVo>();
			for(var i:int=0;i < proclist.length;i++)
			{
				if(proclist[i].procLvl  == 1)
				{
					nextMatList.push(new MaterialItemVo(proclist[i]));
				}
			}
		}
		
		public function resetData():void
		{
			selected = false;
			if(nextMatList != null)
			{
				for(var i:int=0;i < nextMatList.length;i++)
				{
					nextMatList[i].resetData();
				}
			}
		}
	}
}