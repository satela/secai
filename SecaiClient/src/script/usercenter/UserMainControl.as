package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.Label;
	import laya.ui.View;
	import laya.utils.Browser;
	import laya.utils.Mouse;
	
	import script.ViewManager;
	
	import ui.usercenter.AddressMgrPanelUI;
	import ui.usercenter.ChargePanelUI;
	import ui.usercenter.EnterPrizeInfoPaneUI;
	import ui.usercenter.MyOrdersPanelUI;
	import ui.usercenter.UserMainPanelUI;
	
	public class UserMainControl extends Script
	{
		private var uiSkin:UserMainPanelUI;
		
		private var viewArr:Array;
		private var btntxtArr:Array;
		
		private var curView:View;
		private var titleTxt:Array;
		public function UserMainControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as UserMainPanelUI;
			
			uiSkin.panel_main.vScrollBarSkin = "";
			//uiSkin.sp_container.autoSize = true;
			uiSkin.firstpage.on(Event.CLICK,this,onBackToMain);
			
			viewArr = [EnterPrizeInfoPaneUI,AddressMgrPanelUI,null,MyOrdersPanelUI,null,ChargePanelUI];
			
			
			
			btntxtArr = [];
			titleTxt = ["企业资料","收货地址","购物车","我的订单","委托订单","账户充值","我的订单"];
			for(var i:int=0;i < 9;i++)
			{
				uiSkin["btntxt" + i].on(Event.CLICK,this,onShowEditView,[i]);
				uiSkin["btntxt" + i].on(Event.MOUSE_OVER,this,onMouseOverHandler);
				uiSkin["btntxt" + i].on(Event.MOUSE_OUT,this,onMouseOutHandler);
				btntxtArr.push(uiSkin["btntxt" + i]);

			}
			onShowEditView(0);
			(uiSkin.panel_main).height = Browser.clientHeight - 20;

			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

		}
		private function onResizeBrower():void
		{
			// TODO Auto Generated method stub
			(uiSkin.panel_main).height = Browser.clientHeight - 50;
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
			if(index == 7)
			{
				ViewManager.instance.openView(ViewManager.VIEW_CHANGEPWD);
				return;
			}
			if(index == 8)
			{
				ViewManager.instance.openView(ViewManager.VIEW_PICMANAGER,true);
				return;
			}
			uiSkin.toptitle.text = titleTxt[index];
			while(uiSkin.sp_container.numChildren > 0)
			{
				(uiSkin.sp_container.getChildAt(0)).destroy(true);
				uiSkin.sp_container.removeChildAt(0);

			}
			for(var i:int=0;i < btntxtArr.length;i++)
			{
				(btntxtArr[i] as Label).color = "#272524";
			}
			btntxtArr[index].color = "#FF00000";
			
			if(viewArr[index])
			{
				curView = new viewArr[index]();
				curView.on(Event.RESIZE,this,onLoadComplete);
				uiSkin.sp_container.addChild(curView);
				uiSkin.sp_container.height = curView.height;
			}
			else
				uiSkin.sp_container.height = 0;
			uiSkin.panel_main.refresh();
			uiSkin.panel_main.scrollTo(0,0);
		}
		
		private function onLoadComplete():void
		{
			// TODO Auto Generated method stub
			if(curView)
			{
				uiSkin.sp_container.height = curView.height;
				uiSkin.panel_main.refresh();
			}
		}		
		
		private function onBackToMain():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
		}
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
		}
	}
}