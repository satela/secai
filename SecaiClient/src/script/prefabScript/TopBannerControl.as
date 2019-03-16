package script.prefabScript
{
	import laya.components.Script;
	import laya.display.Text;
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.Userdata;
	
	import script.ViewManager;
	
	import ui.TopBannerUI;
	
	import utils.UtilTool;
	
	public class TopBannerControl extends Script
	{
		private var uiSkin:TopBannerUI;
		public function TopBannerControl()
		{
			super();
		}
		override public function onEnable():void {
			
			uiSkin = this.owner as TopBannerUI;
			
			var firstPage:Text = uiSkin.getChildByName("firstPage") as Text;
			var username:Text = uiSkin.getChildByName("userName") as Text;
			var logout:Text = uiSkin.getChildByName("logout") as Text;

			username.text = Userdata.instance.userAccount;
			
			firstPage.on(Event.CLICK,this,showFirstPage);
			logout.on(Event.CLICK,this,showLogOut);
		}
		
		override public function onStart():void
		{
			

		}
		
		private function showFirstPage():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
		}
		private function showLogOut():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.loginOutUrl,this,onLoginOutBack,"","post");

		}
		private function onLoginOutBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				UtilTool.setLocalVar("useraccount","");
				UtilTool.setLocalVar("userpwd","");

				Userdata.instance.isLogin = false;
				ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
				
			}
		}
	}
}