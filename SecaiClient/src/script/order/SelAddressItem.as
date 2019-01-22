package script.order
{
	import model.orderModel.PaintOrderModel;
	import model.users.AddressVo;
	
	import ui.order.OrderAddressItemUI;
	
	public class SelAddressItem extends OrderAddressItemUI
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
			if(value)
				this.addresstxt.borderColor = "#FF0000";
			else
				this.addresstxt.borderColor = "#222222";
			
		}
	}
}