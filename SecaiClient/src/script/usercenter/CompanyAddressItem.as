package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.users.AddressVo;
	
	import script.ViewManager;
	
	import ui.usercenter.AddressItemUI;
	
	public class CompanyAddressItem extends AddressItemUI
	{
		private var addvo:AddressVo;
		public function CompanyAddressItem()
		{
			super();
		}
		
		public function setData(add:AddressVo):void
		{
			addvo = add;
			this.conName.text = add.receiverName;
			
			this.phonetxt.text = add.phone;
			
			this.detailaddr.text = add.proCityArea;
			
			this.btnDel.on(Event.CLICK,this,onDeleteAddr);
			this.btnEdit.on(Event.CLICK,this,onEditAddr);
			this.btndefault.on(Event.CLICK,this,onSetDefaultAddr);
			this.btndefault.visible = Userdata.instance.defaultAddId != addvo.id;

		}
		
		private function onDeleteAddr():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"确定删除该地址吗？",caller:this,callback:confirmDelete});

		}
		
		private function confirmDelete(result:Boolean):void
		{
			if(result)
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.addressManageUrl,this,delMyAddressBack,"opt=delete&id=" + addvo.id,"post");

		}
		
		private function delMyAddressBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				Userdata.instance.deleteAddr(result.id);
				EventCenter.instance.event(EventCenter.UPDATE_MYADDRESS_LIST);

			}
		}
		
		private function onEditAddr():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_ADD_NEW_ADDRESS,false,addvo);

		}
		private function onSetDefaultAddr():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.addressManageUrl,this,defaultAddressBack,"opt=default&id=" + addvo.id,"post");
		}
		private function defaultAddressBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				Userdata.instance.defaultAddId = addvo.id;
				EventCenter.instance.event(EventCenter.UPDATE_MYADDRESS_LIST);
			}
		}
	}
}