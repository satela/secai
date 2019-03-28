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
		
		private function getTechStr(arr:Vector.<MaterialItemVo>):String
		{
			//var arr:Vector.<MaterialItemVo> = PaintOrderModel.instance.curSelectMat.nextMatList;
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					return arr[i].preProc_Name + "-" + getTechStr(arr[i].nextMatList);
				}
			}
			return "";
		}
		
		public function getTotalPrice(area:Number):Number
		{
			var prices:Number = area*(unit_price + additional_unitFee);
			var allprices:Array = [];
			for(var i:int=0;i < prcessCatList.length;i++)
			{
				if(prcessCatList[i].selected)
				{
					allprices = allprices.concat(getTechPrice(prcessCatList[i].nextMatList));					
				}
				
			}
			for(i=0;i < allprices.length;i++)
			{
				prices += area * allprices[i];
			}
			return parseFloat(prices.toFixed(2));
		}
		
		private function getTechPrice(arr:Vector.<MaterialItemVo>):Array
		{
			var prices:Array = [];
			if(arr == null)
				return [];
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					prices.push(arr[i].preProc_Price);
					prices = prices.concat(getTechPrice(arr[i].nextMatList));
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
					
					prolist.push({proc_description:arr[i].preProc_Name,proc_attachpath:arr[i].attchMentFileId});
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
					arr.push({proc_description:prcessCatList[i].procCat_Name,proc_attachpath:""});
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