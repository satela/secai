package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import script.usercenter.item.ApplyJoinItem;
	
	import ui.usercenter.ApplyJoinMgrPanelUI;
	
	public class ApplyJoinMgrControl extends Script
	{
		private var uiSkin:ApplyJoinMgrPanelUI;
		public function ApplyJoinMgrControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ApplyJoinMgrPanelUI;
			uiSkin.applylist.itemRender = ApplyJoinItem;
			
			//uiSkin.applylist.vScrollBarSkin = "";
			uiSkin.applylist.repeatX = 1;
			uiSkin.applylist.spaceY = 5;
			
			uiSkin.applylist.renderHandler = new Handler(this, updateApplyList);
			uiSkin.applylist.selectEnable = false;
			
			uiSkin.distributePanel.visible = false;
			
			var temparr:Array = new Array(20);
			for(var i:int=0;i < 20;i++)
			{
				temparr[i] = {"account":"zhangsan" + i};
			}
			
			uiSkin.applylist.array = temparr;
			
			uiSkin.applylist.on(Event.MOUSE_OVER,this,pauseParentScroll);
			uiSkin.applylist.on(Event.MOUSE_OUT,this,resumeParentScroll);

		}
		
		private function pauseParentScroll():void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,false);
		}
		private function resumeParentScroll():void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);
		}
		
		private function updateApplyList(cell:ApplyJoinItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
	}
}