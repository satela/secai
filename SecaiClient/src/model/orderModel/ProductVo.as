package model.orderModel
{
	import model.HttpRequestUtil;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	import script.order.PicOrderItem;
	
	import utils.UtilTool;

	//产品列表 vo
	public class ProductVo
	{
		public var  prod_code:String = "";//  产品编码
		public var  prod_name:String = "";// 产品名称
		public var  min_length:Number = 0;//  最小长度
		public var  max_length: Number = 0;//  最大长度
		public var  min_width: Number = 0;//  最小宽度
		public var  max_width: Number = 0;//  最大宽度
		public var material_code: String = "";//  材料编码
		public var  material_name: String = "";//  材料名称
		public var  material_color: String = "";//  颜色
		public var  material_brand: String = "";//  材料品牌
		public var material_supplier: String = "";//  材料供应商
		public var measure_unit: String = "";// 计量单位
		public var unit_weight: Number = 0;//  单位重量
		public var manufacturer_code: String = "";//  输出中心编码
		public var manufacturer_name: String = "";//  输出中心名称
		public var unit_price: Number = 0;//  材料单位价格
		public var additional_unitfee: Number = 0;//  单位附加金额
		public var is_merchandise:Boolean = false;

		public var prcessCatList:Vector.<ProcessCatVo>;//工艺类列表
		
		private var hasDoublePrint:int = 1; //如果有双面打印的工艺，这个等于2，用于主材料计算价格
		
		public var merchanList:Array = [];
		
		public var priority:int = 0; //优先级，由所属输出中心优先级决定
		public function ProductVo(data:Object)
		{
			for(var key in data)
				this[key] = data[key];
		}
		
		public function getTechDes(ignoreWidth:Boolean,picwidth:Number=0,picheight:Number=0):String
		{
			if(prcessCatList == null)
				return "";
			var techstr:String = "";
			for(var i:int=0;i < prcessCatList.length;i++)
			{
				if(prcessCatList[i].selected)
				{
					//techstr += prcessCatList[i].procCat_Name;
					var childtech:String = getTechStr(prcessCatList[i].nextMatList,ignoreWidth,picwidth,picheight);
					if(childtech != "")
						techstr +=  childtech.substr(0,childtech.length - 1);
					techstr += "-";
				}
				
				//techstr += ",";
			}
			if(techstr.length > 0)
				return techstr.substring(0,techstr.length - 1);
			else
				return "";
		}
		
		/**
		 *获取所有已选工艺 
		 * @return 
		 * 
		 */		
		public function getAllSelectedTech():Array
		{
			var temp:Array = [];
			for(var i:int=0;i < prcessCatList.length;i++)
			{
				if(prcessCatList[i].selected)
				{
					//techstr += prcessCatList[i].procCat_Name;
					var childtech:Array = getChildSelectedTech(prcessCatList[i].nextMatList);
					temp = temp.concat(childtech);
				}
				
			}
			
			return temp;
		}
		
		private function getChildSelectedTech(arr:Vector.<MaterialItemVo>):Array
		{
			var temp:Array = [];
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					temp.push(arr[i]);
					temp = temp.concat(getChildSelectedTech(arr[i].nextMatList));
				}
			}
			return temp;
		}
		private function getTechStr(arr:Vector.<MaterialItemVo>,ignoreWidth:Boolean,picwidth:Number,picheight:Number):String
		{
			//var arr:Vector.<MaterialItemVo> = PaintOrderModel.instance.curSelectMat.nextMatList;
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					if( arr[i].preProc_attachmentTypeList.toUpperCase() !=  OrderConstant.CUTOFF_H_V || ignoreWidth || (arr[i].preProc_attachmentTypeList.toUpperCase() == OrderConstant.CUTOFF_H_V && picwidth > this.max_width && picheight > this.max_width))
					{
						var peijian:String = "";
						if(arr[i].selectAttachVoList != null)
						{
							for(var j:int=0;j < arr[i].selectAttachVoList.length;j++)
							{
								peijian += arr[i].selectAttachVoList[j].accessory_name + ",";
							}
						}
						if(peijian != "")
							return arr[i].preProc_Name + "(" + peijian.substr(0,peijian.length-1) + ")" +  "-" + getTechStr(arr[i].nextMatList,ignoreWidth,picwidth,picheight);
						else 
							return arr[i].preProc_Name +  "-" + getTechStr(arr[i].nextMatList,ignoreWidth,picwidth,picheight);
					}
					else
						return  getTechStr(arr[i].nextMatList,ignoreWidth,picwidth,picheight);
						
				}
			}
			return "";
		}
		
		public function getTotalPrice(picwidth:Number,picheight:Number,ignoreOther:Boolean = false,picinfovo:PicOrderItemVo = null):Number
		{
				
			var prices:Number = UtilTool.getProcessPrice(picwidth,picheight,measure_unit,unit_price + additional_unitfee,0);			
			
			hasDoublePrint = 1;
			
			var allprices:Array = [];
			var haselectTech:Array = getAllSelectedTech();
			for(var i:int=0;i < prcessCatList.length;i++)
			{
				if(prcessCatList[i].selected)
				{
					allprices = allprices.concat(getTechPrice(prcessCatList[i].nextMatList,picwidth,picheight,ignoreOther,picinfovo,haselectTech));					
				}
				
			}
			
			prices *= hasDoublePrint;
			
			for(i=0;i < allprices.length;i++)
			{
				prices +=  allprices[i];
			}
			if(prices < 0.1)
				prices = 0.1;
			return parseFloat(prices.toFixed(2));
		}
		
		public function getDanjia():Number
		{
			
			var	prices:Number = unit_price + additional_unitfee;
			
			
			var allprices:Array = [];
			for(var i:int=0;i < prcessCatList.length;i++)
			{
				if(prcessCatList[i].selected)
				{
					//allprices = allprices.concat(getTechPrice(prcessCatList[i].nextMatList,area,perimeter));					
				}
				
			}
			
			prices *= hasDoublePrint;
			
			for(i=0;i < allprices.length;i++)
			{
				prices +=  allprices[i];
			}
			
			return 0;
		}
		
		private function getTechPrice(arr:Vector.<MaterialItemVo>,picwidth:Number,picheight:Number,ignoreOther,picinfovo:PicOrderItemVo,techlist:Array):Array
		{
			var prices:Array = [];
			if(arr == null)
				return [];
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					if( arr[i].preProc_attachmentTypeList.toUpperCase() !=  OrderConstant.CUTOFF_H_V || (arr[i].preProc_attachmentTypeList.toUpperCase() == OrderConstant.CUTOFF_H_V && picwidth > this.max_width && picheight > this.max_width))
					{
						var totalprice:Number = 0;
						
						var priceInfo:Array = PaintOrderModel.instance.getProcePriceUnit(this.manufacturer_code,arr[i].preProc_Code,this.material_code,techlist);
						if(priceInfo != null && priceInfo.length == 3)
						{
							
							arr[i].measure_unit = priceInfo[0];
							arr[i].baseprice = priceInfo[1];
							arr[i].preProc_Price = priceInfo[2];
							//						if(arr[i].preProc_Price > 0 && arr[i].measure_unit == OrderConstant.MEASURE_UNIT_AREA)
							//							totalprice = arr[i].preProc_Price * area;
							//						else if(arr[i].preProc_Price > 0)
							//						{						
							//							totalprice = arr[i].preProc_Price * perimeter;
							//						}
							if(arr[i].preProc_Code == OrderConstant.UNNORMAL_CUT_TECHNO)
								totalprice = UtilTool.getYixingPrice(picinfovo.picinfo,arr[i].baseprice,arr[i].preProc_Price,picwidth,picheight);
							else if(arr[i].preProc_Code == OrderConstant.AVGCUT_TECHNO)
								totalprice = UtilTool.getAvgCutPrice(picinfovo,arr[i].baseprice,arr[i].preProc_Price,picwidth,picheight);
							else
								totalprice = UtilTool.getProcessPrice(picwidth,picheight,arr[i].measure_unit,arr[i].preProc_Price,arr[i].baseprice);
							
							//if(arr[i].preProc_Price < 0)
							//	hasDoublePrint = 2;
							if(arr[i].selectAttachVoList != null && arr[i].selectAttachVoList.length > 0)
							{
								//totalprice = UtilTool.getProcessPrice(picwidth,picheight,arr[i].selectAttachVoList[0].measure_unit,arr[i].preProc_Price,arr[i].baseprice);
								if(!UtilTool.isMeasureUnitByNum(arr[i].selectAttachVoList[0].measure_unit))
									totalprice += UtilTool.getProcessPrice(picwidth,picheight,arr[i].measure_unit,arr[i].selectAttachVoList[0].accessory_price,0);
								else if(!ignoreOther)
									totalprice += UtilTool.getProcessPrice(picwidth,picheight,arr[i].selectAttachVoList[0].measure_unit,arr[i].selectAttachVoList[0].accessory_price,0);
								//							if(arr[i].selectAttachVoList[0].measure_unit == OrderConstant.MEASURE_UNIT_AREA)
								//							{
								//								totalprice += arr[i].selectAttachVoList[0].accessory_price * area;
								//							}
								//							else if(arr[i].selectAttachVoList[0].measure_unit == OrderConstant.MEASURE_UNIT_PERIMETER)
								//							{
								//								if("SPAS42110" == arr[i].selectAttachVoList[0].accessory_code) //铝合金挂轴只计算宽
								//								{
								//									totalprice += arr[i].selectAttachVoList[0].accessory_price * picwidth*2;
								//								}
								//								else
								//									totalprice += arr[i].selectAttachVoList[0].accessory_price * perimeter;
								//							}
								//							else if(arr[i].selectAttachVoList[0].measure_unit == OrderConstant.MEASURE_UNIT_KILO && !ignoreOther)
								//								totalprice += arr[i].selectAttachVoList[0].accessory_price;						
								
							}
							
						}
					//if(arr[i].baseprice != 0)
					//	totalprice += arr[i].baseprice;
						prices.push(totalprice);
					}
					
					prices = prices.concat(getTechPrice(arr[i].nextMatList,picwidth,picheight,ignoreOther,picinfovo,techlist));
				}
			}
			return prices;
		}
		
		private function getMaterialProInfoList(arr:Vector.<MaterialItemVo>,picinfo:PicInfoVo,picwidth:Number,picheight:Number,orderitemvo:PicOrderItemVo):Array
		{
			var prolist:Array = [];
			if(arr == null)
				return [];
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					if( arr[i].preProc_attachmentTypeList.toUpperCase() !=  OrderConstant.CUTOFF_H_V || (arr[i].preProc_attachmentTypeList.toUpperCase() == OrderConstant.CUTOFF_H_V && picwidth > this.max_width && picheight > this.max_width))
					{
						var procname:String = arr[i].preProc_Name;
						if(arr[i].selectAttachVoList != null && arr[i].selectAttachVoList.length > 0)
							procname += "(" + arr[i].selectAttachVoList[0].accessory_name + ")";
						if(arr[i].preProc_Code == OrderConstant.UNNORMAL_CUT_TECHNO)
							prolist.push({proc_Code:arr[i].preProc_Code,proc_description:procname,proc_attachpath: HttpRequestUtil.originPicPicUrl + picinfo.yixingFid + "." + picinfo.picClass});
						else if(arr[i].preProc_Code == OrderConstant.DOUBLE_SIDE_UNSAME_TECHNO)
							prolist.push({proc_Code:arr[i].preProc_Code,proc_description:procname,proc_attachpath: HttpRequestUtil.originPicPicUrl + picinfo.backFid + "." + picinfo.picClass});
						else if(arr[i].preProc_attachmentTypeList.toUpperCase() == OrderConstant.CUTOFF_H_V)
						{
							var procname:String = "超幅裁切" + "(" + ["V","H"][orderitemvo.cuttype] + "-" +  orderitemvo.cutnum+ "-" + orderitemvo.eachCutLength.join(";") +")";//["竖拼裁切","横拼裁切"][orderitemvo.cuttype] + "(" + orderitemvo.cutnum+")";
							prolist.push({proc_Code:arr[i].preProc_Code,proc_description:procname,proc_attachpath:arr[i].attchMentFileId});
						}
						else if(arr[i].preProc_attachmentTypeList.toUpperCase() == OrderConstant.AVERAGE_CUTOFF)
						{
							var procname:String = procname + "(H-" + orderitemvo.verCutNum + ",V-" + orderitemvo.horiCutNum+  ")";
							prolist.push({proc_Code:arr[i].preProc_Code,proc_description:procname,proc_attachpath:arr[i].attchMentFileId});
						}
						else
							prolist.push({proc_Code:arr[i].preProc_Code,proc_description:procname,proc_attachpath:arr[i].attchMentFileId});
					}

						
					prolist = prolist.concat(getMaterialProInfoList(arr[i].nextMatList,picinfo,picwidth,picheight,orderitemvo));
					
				}
				
			}
			return prolist;
		}
		
		public function getProInfoList(picinfo:PicInfoVo,picwidth:Number,picheight:Number,orderitemvo:PicOrderItemVo):Array
		{
			var arr:Array = [];
			
			for(var i:int=0;i < prcessCatList.length;i++)
			{
				if(prcessCatList[i].selected)
				{
					//arr.push({proc_Code:prcessCatList[i].procCat_Name,proc_description:prcessCatList[i].procCat_Name,proc_attachpath:""});
					arr = arr.concat(getMaterialProInfoList(prcessCatList[i].nextMatList,picinfo,picwidth,picheight,orderitemvo));
				}
			}
			return arr;
		}
		
		public function checkCurTechValid():Boolean
		{
			var techArr:Array = getAllSelectedTech();
			for(var i:int=0;i < techArr.length;i++)
			{
				if( techArr[i].preProc_attachmentTypeList != null && techArr[i].preProc_attachmentTypeList != "" && techArr[i].preProc_attachmentTypeList.toLocaleUpperCase() != OrderConstant.ATTACH_NO && techArr[i].preProc_attachmentTypeList.toLocaleUpperCase() != OrderConstant.ATTACH_PEIJIAN)
				{
					if(techArr[i].attchFileId == null || techArr[i].attchFileId == "")
					{
						ViewManager.showAlert("有工艺未选择合适的附件图片");
						return false;
					}
				}
			}
			
			return true;
		}
		public function resetData():void
		{
			if(prcessCatList != null)
			{
				for(var i:int=0;i < prcessCatList.length;i++)
				{
					prcessCatList[i].resetData();
				}
			}
		}
	}
}