package script.order
{
	import model.orderModel.PaintOrderModel;
	import model.users.AddressVo;
	
	import ui.order.AddressItemUI;
	
	public class SelAddressItem extends AddressItemUI
	{
		public var address:AddressVo;
		
		
		public function SelAddressItem()
		{
			super();
		}
		
		public function setData(data:Object):void
		{
			address = data as AddressVo;
			this.addresstxt.text = address.addressDetail;
			ShowSelected = address == PaintOrderModel.instance.selectAddress;
		}
		
		public function set ShowSelected(value:Boolean):void
		{
			this.selimg.visible = value;
			
		}
	}
}