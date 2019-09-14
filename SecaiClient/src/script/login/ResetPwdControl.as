package script.login
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.events.Keyboard;
	
	import script.ViewManager;
	
	import ui.login.ResetPwdPanelUI;
	
	public class ResetPwdControl extends Script
	{
		private var uiSkin:ResetPwdPanelUI;
		public var param:Object;

		private var inputarr:Array;
		private var focusindex:int = 0;
		public function ResetPwdControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as ResetPwdPanelUI; 
			uiSkin.btnClose.on(Event.CLICK,this,onCloseScen);

			inputarr = [uiSkin.inputphone,uiSkin.inputpwd,uiSkin.inputcfmpwd,uiSkin.inputcode];
			for(var i:int=0;i < inputarr.length;i++)
			{
				inputarr[i].on(Event.KEY_DOWN,this,onAccountKeyUp);
			}
			
			Laya.stage.on(Event.FOCUS_CHANGE,this,onFocusChange);

			uiSkin.inputphone.focus = true;
			focusindex = 0;
		}
		
		private function onFocusChange(e:Event):void
		{
			
			if(inputarr.indexOf(Laya.stage.focus.parent) >= 0)
				focusindex = inputarr.indexOf(Laya.stage.focus.parent);

		}
		private function onAccountKeyUp(e:Event):void
		{
			if(e.keyCode == Keyboard.TAB)
			{
				focusindex = (++focusindex)%inputarr.length;
				inputarr[focusindex].focus = true;
			}
			if(e.keyCode == Keyboard.ENTER)
			{
				//onLogin();
			}
		}
		
		private function onCloseScen():void
		{
			// TODO Auto Generated method stub
			//ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
			ViewManager.instance.closeView(ViewManager.VIEW_CHANGEPWD);
			Laya.stage.off(Event.FOCUS_CHANGE,this,onFocusChange);

		}
	}
}