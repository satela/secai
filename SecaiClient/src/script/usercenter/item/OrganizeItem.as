package script.usercenter.item
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	
	import script.ViewManager;
	
	import ui.usercenter.OrganizeItemUI;
	
	public class OrganizeItem extends OrganizeItemUI
	{
		private var orgData:Object;
		public function OrganizeItem()
		{
			super();
			
			this.deltbn.visible = false;
			
			this.on(Event.MOUSE_OVER,this,showDeltbn);
			this.on(Event.MOUSE_OUT,this,hideDeltbn);
			
			this.deltbn.on(Event.CLICK,this,ondeleteOrga);

		}
		
		public function setselected(curdept:int):void
		{
			if(orgData != null)
				selected = orgData.dt_id == curdept;
		}
		private function ondeleteOrga():void
		{
			
			ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"确定删除" + orgData.dt_name + "吗？",caller:this,callback:confirmDelete});


		}
		
		private function confirmDelete(b:Boolean):void
		{
			if(b)
			{
				var param:String = "id=" + orgData.dt_id;
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.deleteOrganize,this,onDeleteBack,param,"post");

			}
		}
		private function onDeleteBack(data:String):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				EventCenter.instance.event(EventCenter.DELETE_ORGANIZE_BACK);
			}
		}
		public function set selected(value:Boolean):void
		{
			this.hotbtm.selected = value;
		}
		private function showDeltbn():void
		{
			this.deltbn.visible = true;
		}
		
		private function hideDeltbn():void
		{
			this.deltbn.visible = false;
		}
		
		public function setData(data:*):void
		{
			orgData = data;
			this.hotbtm.label = data.dt_name;
		}
	}
}