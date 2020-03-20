package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import script.usercenter.item.MemberItem;
	import script.usercenter.item.OrganizeItem;
	
	import ui.usercenter.OrganizeMgrPanelUI;
	
	public class OrganizeMrgControl extends Script
	{
		private var uiSkin:OrganizeMgrPanelUI;
		public function OrganizeMrgControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as OrganizeMgrPanelUI;
			
			uiSkin.organizelist.itemRender = OrganizeItem;
			
			uiSkin.organizelist.vScrollBarSkin = "";
			uiSkin.organizelist.repeatX = 7;
			uiSkin.organizelist.spaceY = 5;
			uiSkin.organizelist.spaceX = 15;

			uiSkin.organizelist.renderHandler = new Handler(this, updateOrganizeList);
			uiSkin.organizelist.selectEnable = true;
			uiSkin.organizelist.selectHandler = new Handler(this,selectOrganize);
			
			uiSkin.memberlist.itemRender = MemberItem;
			
			uiSkin.memberlist.vScrollBarSkin = "";
			uiSkin.memberlist.repeatX = 1;
			uiSkin.memberlist.spaceY = 5;

			uiSkin.memberlist.renderHandler = new Handler(this, updateMemberList);
			uiSkin.memberlist.selectEnable = false;
			
			uiSkin.distributePanel.visible = false;
			
			var temparr:Array = new Array(20);
			
			uiSkin.memberlist.array = temparr;
			
			uiSkin.organizelist.array = temparr;
			
			uiSkin.memberlist.on(Event.MOUSE_OVER,this,pauseParentScroll);
			uiSkin.memberlist.on(Event.MOUSE_OUT,this,resumeParentScroll);
			
		}
		
		private function pauseParentScroll():void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,false);
		}
		private function resumeParentScroll():void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);
		}
		
		private function updateMemberList(cell:MemberItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		private function updateOrganizeList(cell:OrganizeItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		
		private function selectOrganize(index:int):void
		{
			for each(var item:OrganizeItem in uiSkin.organizelist.cells)
			{
				item.selected = false;
			}
			(uiSkin.organizelist.cells[index] as OrganizeItem).selected = true;
						
		}
	}
}