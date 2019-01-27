package script.order
{
	import model.orderModel.DeliveryTypeVo;
	import model.orderModel.PaintOrderModel;
	
	import ui.order.OrderAddressItemUI;

	public class DeliveryTypeItem extends OrderAddressItemUI
	{
		public var deliveryVo:DeliveryTypeVo;
		public function DeliveryTypeItem()
		{
			super();
		}
		
		public function setData(devo:Object):void
		{
			deliveryVo = devo as DeliveryTypeVo;
			this.addresstxt.text = deliveryVo.deliveryDesc;
			ShowSelected = deliveryVo == PaintOrderModel.instance.selectDelivery;
		}
		public function set ShowSelected(value:Boolean):void
		{
			if(value)
				this.addresstxt.borderColor = "#FF0000";
			else
				this.addresstxt.borderColor = "#222222";
			
		}
	}
}