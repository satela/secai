package utils
{
	import laya.components.Script;
	import laya.events.Event;
	
	import script.ViewManager;
	
	import ui.PopUpDialogUI;
	
	public class PopUpWindowControl extends Script
	{
		private var uiSkin:PopUpDialogUI;
		public var param:Object;
		public function PopUpWindowControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as PopUpDialogUI;
			uiSkin.closebtn.on(Event.CLICK,this,onCloseScene);
			
			uiSkin.msgtxt.text = param.msg;
			uiSkin.okbtn.on(Event.CLICK,this,onConfirmHandler);
			uiSkin.cancelbtn.on(Event.CLICK,this,onCancelHandler);

		}
		
		private function onConfirmHandler():void
		{
			// TODO Auto Generated method stub
			if(param.callback != null)
				(param.callback as Function).call(param.caller,true);
			onCloseScene();
		}
		
		private function onCancelHandler():void
		{
			// TODO Auto Generated method stub
			if(param.callback != null)
				(param.callback as Function).call(param.caller,false);
			onCloseScene();
		}
		
		private function onCloseScene():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_POPUPDIALOG);
			
		}
	}
}