package model.orderModel
{
	public class DeliveryTypeVo
	{
		public var delivery_code:String = "";//  配送方式编码
		public var delivery_name: String = "";// 配送方式名称
		public var start_weight: Number = 0;//  首重(kg)
		public var post_weight:  Number = 0;//  续重(kg)
		public var first_volume:  Number = 0;//  首体积(立方)
		public var post_volume:  Number = 0;//  续体积(立方)
		public var factor:  Number = 0;//  转换系数
		public var limit_weight:  Number = 0;//  限重(kg)
		public var limit_length:  Number = 0;//  限长(cm)
		public var limit_width:  Number = 0;//  限宽(cm)
		public var limit_height:  Number = 0;//  限高(cm)
		public var deliverynet_code: String = "";//  网点编码
		public var deliverynet_name: String = "";//  网点名称
		public var firstweight_price: Number = 0;//  首重价格
		public var addedweight_price: Number = 0;//  续重价格
		public var firstvol_price: Number = 0;//  首体积价格
		public var addedvol_price: Number = 0;//  续体积价格

		public function DeliveryTypeVo(data:Object)
		{
			for(var key in data)
				this[key] = data[key];
		}
		
		public function get deliveryDesc():String
		{
			return delivery_name + "，" + deliverynet_name + "，首重:" + start_weight + "kg," + "续重" + post_weight + "kg，" + "首重价格:" + firstweight_price + "元/kg，" + "续重价格:" + addedweight_price + "元/kg。";
		}
	}
}