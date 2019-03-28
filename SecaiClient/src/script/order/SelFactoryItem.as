package script.order
{
	import model.ChinaAreaModel;
	import model.orderModel.PaintOrderModel;
	import model.users.FactoryInfoVo;
	
	import ui.order.OrderAddressItemUI;
	import ui.order.OrderItemUI;
	
	public class SelFactoryItem extends OrderAddressItemUI
	{
		public var factoryvo:FactoryInfoVo;
		public function SelFactoryItem()
		{
			super();
		}
		
		public function setData(data:Object):void
		{
			factoryvo = data as FactoryInfoVo;
			this.addresstxt.text = factoryvo.name + "(" + factoryvo.addr+ ")";
			//ShowSelected =PaintOrderModel.instance.selectFactoryAddress == factoryvo;
		}
		
		public function set ShowSelected(value:Boolean):void
		{
			this.btnsel.selected = value;
			this.selCheck.selected = value;
			
		}
	}
}