package model.orderModel
{
	public class MaterialItemVo
	{
		public var preProc_Code:String = "";// 前置工艺编码
		public var preProc_Name:String= "";// 前置工艺名称
		public var preProc_AttachmentTypeList:String = "";//  前置工艺附件类型
		public var preProc_Price: Number = 0;//  前置工艺价格

		public var is_mandatory:int = 0;// 是否必选工艺
		
		public var procLvl:int = 0;//工艺层级
		
		public var nextMatList:Vector.<MaterialItemVo>;
		
		public var selected:Boolean = false;
		
		public var attchMentFileId:String = "";
		
		public function MaterialItemVo(data:Object)
		{
			if(data != null)
			{
				for(var key in data)
				{
					if(this.hasOwnProperty(key))
						this[key] = data[key];
				}
				var nextpro:Array = data.procProcList;
				nextMatList = new Vector.<MaterialItemVo>();

				if(nextpro && nextpro.length > 0)
				{
					for(var i:int=0;i < nextpro.length;i++)
					{
						if(PaintOrderModel.instance.getProcDataByProcName(nextpro[i].postProc_name) != null)
						{
							nextMatList.push(new MaterialItemVo(PaintOrderModel.instance.getProcDataByProcName(nextpro[i].postProc_name)));
						}
						else
						{
							var matvo:MaterialItemVo = new MaterialItemVo({});
							matvo.is_mandatory = 0;
							matvo.preProc_AttachmentTypeList = nextpro[i].PostProc_AttachmentTypeList;
							matvo.preProc_Code =  nextpro[i].postProc_code;
							matvo.preProc_Name = nextpro[i].postProc_name;
							matvo.procLvl = 2;
							matvo.preProc_Price = nextpro[i].postProc_price;
							nextMatList.push(matvo);
						}
					}
				}
			}
		}
		
		public function resetData():void
		{
			selected = false;
			attchMentFileId = "";
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