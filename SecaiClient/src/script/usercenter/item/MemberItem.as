package script.usercenter.item
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	
	import script.ViewManager;
	
	import ui.usercenter.OrganizeMemberItemUI;
	
	public class MemberItem extends OrganizeMemberItemUI
	{
		private var memberdata:Object;
		public function MemberItem()
		{
			super();
			
			this.movebtn.on(Event.CLICK,this,onMoveMember);
			this.deletebtn.on(Event.CLICK,this,onDeleteMember);
			this.authoritytxt.on(Event.CLICK,this,onSetAuthority);


		}
		private function onDeleteMember():void
		{
			
			ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"确定删除" + memberdata.phonenumber + "吗？",caller:this,callback:confirmDelete});
			
			
		}
		
		private function confirmDelete(b:Boolean):void
		{
			if(b)
			{
				var params:String = "dept=0" + "&uid=" + memberdata.uid;
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.moveOrganizeMembers,this,ondeleteMemberBack,params,"post");
				
			}
		}
		
		private function ondeleteMemberBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				EventCenter.instance.event(EventCenter.DELETE_DEPT_MEMBER);
			}
		}
		
		private function onSetAuthority():void
		{
			EventCenter.instance.event(EventCenter.SET_MEMEBER_AUTHORITY,memberdata);

		}
		private function onMoveMember():void
		{
			EventCenter.instance.event(EventCenter.MOVE_MEMBER_DEPT,memberdata);
		}
		public function setData(data:*):void
		{
			memberdata = data;
			this.nickname.text = data.uid;
			this.account.text = data.phonenumber;
			this.jointime.text = data.regdate;
		}
	}
}