package script.usercenter
{
	import laya.components.Script;
	import laya.events.Event;
	
	import script.ViewManager;
	
	import ui.usercenter.NewAddressPanelUI;
	
	public class AddressEditControl extends Script
	{
		private var uiSkin:NewAddressPanelUI;
		public function AddressEditControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as NewAddressPanelUI;
			
			this.uiSkin.btnok.on(Event.CLICK,this,onCloseView);
			this.uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
		}
		
		private function onCloseView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_ADD_NEW_ADDRESS);
		}		
		
	}
}