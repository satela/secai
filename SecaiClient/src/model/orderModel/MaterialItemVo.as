package model.orderModel
{
	import model.HttpRequestUtil;

	public class MaterialItemVo
	{
		public var preProc_Code:String = "";// 前置工艺编码
		public var preProc_Name:String= "";// 前置工艺名称
		public var preProc_attachmentTypeList:String = "";//  前置工艺附件类型
		public var preProc_Price: Number = 0;//  前置工艺价格

		public var baseprice: Number = 0;//  底价

		public var is_mandatory:int = 0;// 是否必选工艺
		public var measure_unit:String = "";//计价单位
		public var procLvl:int = 0;//工艺层级
		
		public var is_startProc:int = 0;//是否起始工艺
		public var is_endProc:int = 0;//是否结束工艺

		public var nextMatList:Vector.<MaterialItemVo>;
		
		public var selected:Boolean = false;
		
		public var attchMentFileId:String = "";
		
		//附件的文件id
		public var attchFileId:String = "";

		public var attachList:Array;
		public var selectAttachVoList:Vector.<AttchCatVo>;//选择的配件
		
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

				//trace(preProc_Name + "," + preProc_attachmentTypeList);
				
//				var priceInfo:Array = PaintOrderModel.instance.getProcePriceUnit(PaintOrderModel.instance.curSelectMat.manufacturer_code,this.preProc_Code);
//				if(priceInfo != null && priceInfo.length == 2)
//				{
//					this.measure_unit = priceInfo[0];
//					this.preProc_Price = priceInfo[1];
//				}

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
							matvo.preProc_attachmentTypeList = nextpro[i].preProc_attachmentTypeList;
							matvo.preProc_Code =  nextpro[i].postProc_code;
							matvo.preProc_Name = nextpro[i].postProc_name;
							matvo.procLvl = 2;
							matvo.preProc_Price = nextpro[i].postProc_price;
							matvo.measure_unit = nextpro[i].measure_unit;
							nextMatList.push(matvo);
												

						}
					}
				}
			}
		}
		
		private function onAccCatlistBack(data:String):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				if(result[0] != null)
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.GetAccessorylist + "manufacturer_code=" + PaintOrderModel.instance.curSelectMat.manufacturer_code + "&accessoryCat_name=" + result[0].accessoryCat_Name,this,onGetAccessorylistBack,null,null);

			}
		}
		
		private function onGetAccessorylistBack(data:String):void
		{
			var result:Array = JSON.parse(data as String) as Array;
			if(result)
			{
				attachList = [];
				for(var i:int=0;i < result.length;i++)
				{
					var attachVo:AttchCatVo = new AttchCatVo(result[i]);
					attachVo.materialItemVo = this;
					attachList.push(attachVo);
				}
			}
			
		}
		public function resetData():void
		{
			selected = false;
			attchMentFileId = "";
			attchFileId = "";
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