package model.productModel
{
	public class MerchanVo
	{
		public var Prod_Code:String;//产品编码
		public var Prod_Name:String;//产品名称
		public var Measure_Unit:String;//计量单位
		public var Manufacturer_Code:String;//输出中心编码
		public var Manufacturer_Name:String;//输出中心名称
		public var Mer_volume:String;//成品商品体积（长*宽*高
		public var Mer_weight:Number;//成品商品重量
		public var Mer_price:Number;// 成品商品价格

		public function MerchanVo(data:Object)
		{
			if(data != null)
			{
				for(var key in data)
				{
					if(this.hasOwnProperty(key))
						this[key] = data[key];
				}
			}
		}
	}
}