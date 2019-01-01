package script.usercenter
{
	import model.users.AddressVo;
	
	import ui.usercenter.AddressItemUI;
	
	public class CompanyAddressItem extends AddressItemUI
	{
		public function CompanyAddressItem()
		{
			super();
		}
		
		public function setData(add:AddressVo):void
		{
			this.conName.text = add.receiverName;
			
			this.phone.text = add.phone;
			
			this.detailaddr.text = add.proCityArea;
		}
	}
}