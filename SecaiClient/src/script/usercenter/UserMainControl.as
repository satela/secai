package script.usercenter
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.Label;
	import laya.ui.View;
	import laya.utils.Mouse;
	
	import script.ViewManager;
	
	import ui.usercenter.EnterPrizeInfoPaneUI;
	import ui.usercenter.UserMainPanelUI;
	
	public class UserMainControl extends Script
	{
		private var uiSkin:UserMainPanelUI;
		
		private var viewArr:Array;
		private var btntxtArr:Array;
		public function UserMainControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as UserMainPanelUI;
			
			uiSkin.panel_main.vScrollBarSkin = "";
			uiSkin.firstpage.on(Event.CLICK,this,onBackToMain);
			
			viewArr = [EnterPrizeInfoPaneUI,null,null];
			
			
			
			btntxtArr = [];
			for(var i:int=0;i < 9;i++)
			{
				uiSkin["btntxt" + i].on(Event.CLICK,this,onShowEditView,[i]);
				uiSkin["btntxt" + i].on(Event.MOUSE_OVER,this,onMouseOverHandler);
				uiSkin["btntxt" + i].on(Event.MOUSE_OUT,this,onMouseOutHandler);
				btntxtArr.push(uiSkin["btntxt" + i]);

			}
			onShowEditView(0);
		}
		
		private function onMouseOutHandler():void
		{
			// TODO Auto Generated method stub
			Mouse.cursor = "auto";
		}
		
		private function onMouseOverHandler():void
		{
			// TODO Auto Generated method stub
			Mouse.cursor = "hand";

		}
		
		private function onShowEditView(index:int):void
		{
			while(uiSkin.sp_container.numChildren > 0)
				uiSkin.sp_container.removeChildAt(0);
			for(var i:int=0;i < btntxtArr.length;i++)
			{
				(btntxtArr[i] as Label).color = "#272524";
			}
			btntxtArr[index].color = "#FF00000";
			
			if(viewArr[index])
			{
				var viewpanel:View = new viewArr[index]();
				uiSkin.sp_container.addChild(viewpanel);
				uiSkin.sp_container.height = viewpanel.height;
			}
			else
				uiSkin.sp_container.height = 0;
			uiSkin.panel_main.scrollTo(0,0);
		}
		private function onBackToMain():void

		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_USERCENTER);
		}
	}
}