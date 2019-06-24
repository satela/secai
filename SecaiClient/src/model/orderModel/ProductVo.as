package model.orderModel
{
	//产品列表 vo
	public class ProductVo
	{
		public var prod_code:String = "";//  产品编码
		public var prod_name:String = "";// 产品名称
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
		public var additional_unitFee: Number = 0;//  单位附加金额

		public var prcessCatList:Vector.<ProcessCatVo>;//工艺类列表
		
		private var hasDoublePrint:int = 1; //如果有双面打印的工艺，这个等于2，用于主材料计算价格
		public function ProductVo(data:Object)
		{
			for(var key in data)
				this[key] = data[key];
		}
		
		public function getTechDes():String
		{
			var techstr:String = "";
			for(var i:int=0;i < prcessCatList.length;i++)
			{
				if(prcessCatList[i].selected)
				{
					//techstr += prcessCatList[i].procCat_Name;
					var childtech:String = getTechStr(prcessCatList[i].nextMatList);
					if(childtech != "")
						techstr +=  childtech.substr(0,childtech.length - 1);
					techstr += "-";
				}
				
				//techstr += ",";
			}
			return techstr.substring(0,techstr.length - 1);
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
		private function getTechStr(arr:Vector.<MaterialItemVo>):String
		{
			//var arr:Vector.<MaterialItemVo> = PaintOrderModel.instance.curSelectMat.nextMatList;
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
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
						return arr[i].preProc_Name + "(" + peijian.substr(0,peijian.length-1) + ")" +  "-" + getTechStr(arr[i].nextMatList);
					else 
						return arr[i].preProc_Name +  "-" + getTechStr(arr[i].nextMatList);
						
				}
			}
			return "";
		}
		
		public function getTotalPrice(area:Number,perimeter:Number):Number
		{
			if(measure_unit == OrderConstant.MEASURE_UNIT_AREA)
				var prices:Number = area*(unit_price + additional_unitFee);
			else
				prices = perimeter*(unit_price + additional_unitFee);
			
			hasDoublePrint = 1;
			
			var allprices:Array = [];
			for(var i:int=0;i < prcessCatList.length;i++)
			{
				if(prcessCatList[i].selected)
				{
					allprices = allprices.concat(getTechPrice(prcessCatList[i].nextMatList,area,perimeter));					
				}
				
			}
			
			prices *= hasDoublePrint;
			
			for(i=0;i < allprices.length;i++)
			{
				prices +=  allprices[i];
			}
			return parseFloat(prices.toFixed(2));
		}
		
		private function getTechPrice(arr:Vector.<MaterialItemVo>,area:Number,perimeter:Number):Array
		{
			var prices:Array = [];
			if(arr == null)
				return [];
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					var totalprice:Number = 0;
					
					if(arr[i].preProc_Price > 0 && arr[i].measure_unit == OrderConstant.MEASURE_UNIT_AREA)
						totalprice = arr[i].preProc_Price * area;
					else if(arr[i].preProc_Price > 0)
						totalprice = arr[i].preProc_Price * perimeter;
					
					if(arr[i].preProc_Price < 0)
						hasDoublePrint = 2;
					if(arr[i].selectAttachVoList != null && arr[i].selectAttachVoList.length > 0)
					{
						if(arr[i].selectAttachVoList[0].measure_unit == OrderConstant.MEASURE_UNIT_AREA)
						{
							totalprice += arr[i].selectAttachVoList[0].accessory_price * area;
						}
						else
							totalprice += arr[i].selectAttachVoList[0].accessory_price * perimeter;
					}
					
					prices.push(totalprice);
					
					prices = prices.concat(getTechPrice(arr[i].nextMatList,area,perimeter));
				}
			}
			return prices;
		}
		
		private function getMaterialProInfoList(arr:Vector.<MaterialItemVo>):Array
		{
			var prolist:Array = [];
			if(arr == null)
				return [];
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					var procname:String = arr[i].preProc_Name;
					if(arr[i].selectAttachVoList != null && arr[i].selectAttachVoList.length > 0)
						procname += "(" + arr[i].selectAttachVoList[0].accessory_name + ")";
					
					prolist.push({proc_Code:arr[i].preProc_Code,proc_description:procname,proc_attachpath:arr[i].attchMentFileId});
					prolist = prolist.concat(getMaterialProInfoList(arr[i].nextMatList));
					
				}
				
			}
			return prolist;
		}
		
		public function getProInfoList():Array
		{
			var arr:Array = [];
			
			for(var i:int=0;i < prcessCatList.length;i++)
			{
				if(prcessCatList[i].selected)
				{
					//arr.push({proc_Code:prcessCatList[i].procCat_Name,proc_description:prcessCatList[i].procCat_Name,proc_attachpath:""});
					arr = arr.concat(getMaterialProInfoList(prcessCatList[i].nextMatList));
				}
			}
			return arr;
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