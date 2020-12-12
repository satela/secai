package script.activity
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Ease;
	import laya.utils.Tween;
	
	import script.ViewManager;
	
	import ui.ChargeAdvertisePanelUI;
	
	public class ActivityAdvertiseController extends Script
	{
		private var uiSkin:ChargeAdvertisePanelUI;
		
		private var param:Object;
		public function ActivityAdvertiseController()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ChargeAdvertisePanelUI;
			
			uiSkin.mainview.scaleX = 0.2;
			uiSkin.mainview.scaleY = 0.2;
			
			Tween.to(uiSkin.mainview,{scaleX:1,scaleY:1},300,Ease.backOut);
			if(param != null)
			{
				uiSkin.ruletxt.text = param.ra_text;
				
			}
			uiSkin.gotocharge.on(Event.CLICK,this,gotoChargePanel);
			uiSkin.closebtn.on(Event.CLICK,this,closeView);

		}
		
		private function gotoChargePanel():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_USERCENTER,true,5);
		}
		
		private function closeView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_ACTIVITY_ADVETISE_PANEL);
		}
	}
}