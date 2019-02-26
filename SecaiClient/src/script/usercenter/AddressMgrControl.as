package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.Userdata;
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
//			for(var i:int=0;i < 6;i++)
//			{
//				var addvo:AddressVo = new AddressVo();
//				temparr.push(addvo);
//			}
			uiSkin.addlist.array = temparr;
			
			uiSkin.btnaddAddress.on(Event.CLICK,this,onClickAdd);
			
			if(Userdata.instance.addressList.length <= 0)
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.addressManageUrl,this,getMyAddressBack,"opt=list&page=1","post");
			else
				uiSkin.addlist.array = Userdata.instance.addressList;

			EventCenter.instance.on(EventCenter.UPDATE_MYADDRESS_LIST,this,updateList);

		}
		private function updateList():void
		{
			uiSkin.addlist.array = Userdata.instance.addressList;

		}
		private function getMyAddressBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				Userdata.instance.initMyAddress(result.data as Array);
				uiSkin.addlist.array = Userdata.instance.addressList;
			}
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
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.UPDATE_MYADDRESS_LIST,this,updateList);

		}
	}
}