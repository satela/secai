package script.usercenter
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.users.AddressVo;
	
	import script.ViewManager;
	
	import ui.usercenter.AddressMgrPanelUI;
	
	public class AddressMgrControl extends Script
	{
		private var uiSkin:AddressMgrPanelUI;
		public function AddressMgrControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as AddressMgrPanelUI;
			uiSkin.addlist.itemRender = CompanyAddressItem;
			
			uiSkin.addlist.vScrollBarSkin = "";
			uiSkin.addlist.repeatX = 1;
			uiSkin.addlist.spaceY = 0;
			
			uiSkin.addlist.renderHandler = new Handler(this, updateAddressList);
			uiSkin.addlist.selectEnable = false;
			
			var temparr:Array = [];
			for(var i:int=0;i < 6;i++)
			{
				var addvo:AddressVo = new AddressVo();
				temparr.push(addvo);
			}
			uiSkin.addlist.array = temparr;
			
			uiSkin.btnaddAddress.on(Event.CLICK,this,onClickAdd);
		}
		
		private function onClickAdd():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_ADD_NEW_ADDRESS);
		}
		
		private function updateAddressList(cell:CompanyAddressItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
	}
}