package script.login
{
	import laya.components.Script;
	import laya.events.Event;
	
	import script.ViewManager;
	
	import ui.login.ResetPwdPanelUI;
	
	public class ResetPwdControl extends Script
	{
		private var uiSkin:ResetPwdPanelUI;
		public function ResetPwdControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as ResetPwdPanelUI; 
			uiSkin.btnClose.on(Event.CLICK,this,onCloseScen);

			
		}
		
		private function onCloseScen():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_CHANGEPWD);
		}
	}
}