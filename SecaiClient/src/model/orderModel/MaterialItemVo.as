package model.orderModel
{
	import model.HttpRequestUtil;
	import model.picmanagerModel.PicInfoVo;
	
	import script.order.PicOrderItem;
	
	import utils.UtilTool;

	public class MaterialItemVo
	{
		public var preProc_Code:String = "";// 前置工艺编码
		public var preProc_Name:String= "";// 前置工艺名称
		public var preProc_attachmentTypeList:String = "";//  前置工艺附件类型
		public var preProc_Price: Number = 0;//  前置工艺价格

		public var baseprice: Number = 0;//  底价

		public var is_mandatory:int = 0;// 后置工艺是否必选
		public var measure_unit:String = "";//计价单位
		public var procLvl:int = 0;//工艺层级
		
		public var is_startProc:int = 0;//是否起始工艺
		public var is_endProc:int = 0;//是否结束工艺

		private var _nextMatList:Vector.<MaterialItemVo>;
		
		public var selected:Boolean = false;
		
		public var attchMentFileId:String = "";
		
		//附件的文件id
		public var attchFileId:String = "";
		
		public var unit_capacity:Number = 0;//正常产能
		public var unit_urgentCapacity:Number = 0;
		public var cap_uit:String = "";

		public var attachList:Array;
		public var selectAttachVoList:Vector.<AttchCatVo>;//选择的配件
		
		public var picInfoVo:PicInfoVo;//异形切割工艺计价需要图片信息
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
				_nextMatList = new Vector.<MaterialItemVo>();

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
							_nextMatList.push(new MaterialItemVo(PaintOrderModel.instance.getProcDataByProcName(nextpro[i].postProc_name)));
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
							_nextMatList.push(matvo);
												

						}
					}
				}
			}
		}
		
		public function get nextMatList():Vector.<MaterialItemVo>
		{
			var curselectProduct:ProductVo = PaintOrderModel.instance.curSelectMat;
			var curSelectPic:PicOrderItem = PaintOrderModel.instance.curSelectOrderItem;
			var allpics:Vector.<PicOrderItem> = new Vector.<PicOrderItem>();
			if(curSelectPic != null)
				allpics.push(curSelectPic);
			else
				allpics = PaintOrderModel.instance.batchChangeMatItems;
						
			if(curselectProduct != null && allpics.length > 0)
			{				
				
				if(this._nextMatList.length > 0)
				{
					if(this._nextMatList[0].preProc_attachmentTypeList.toUpperCase() == OrderConstant.CUTOFF_H_V)
					{
						var hasBeyongd:Boolean = false;
						for(var i:int=0;i < allpics.length;i++)
						{
							//var longside:Number = Math.max(allpics[i].finalWidth,allpics[i].finalHeight);
							//var shortside:Number = Math.min(allpics[i].finalWidth,allpics[i].finalHeight);
							var vec:Vector.<MaterialItemVo> = new Vector.<MaterialItemVo>();
							vec.push(this);
							var border:Number = UtilTool.getBorderDistance(vec);
							
							if(allpics[i].finalWidth + border > curselectProduct.mat_width && allpics[i].finalHeight + border > curselectProduct.mat_width)
							{
								hasBeyongd = true;
								break;
							}
						}
						if(hasBeyongd == true)
							return this._nextMatList;
						
						return this._nextMatList[0].nextMatList;
					}					
				}
			}
			
			return this._nextMatList;
			
			
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