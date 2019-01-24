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
	}
}