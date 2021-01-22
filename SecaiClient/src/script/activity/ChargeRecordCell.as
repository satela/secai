package script.activity
{
	import laya.events.Event;
	
	import script.ViewManager;
	
	import ui.chargeActivity.ChargeRecordItemUI;
	
	public class ChargeRecordCell extends ChargeRecordItemUI
	{
		public function ChargeRecordCell()
		{
			super();
			
			this.cancelbtn.on(Event.CLICK,this,onCancelCharge);
		}
		
		public function setData(data:*):void
		{
			
		}
		
		private function onCancelCharge():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"撤回的金额将不享受活动额外的返现金额,确定撤回这次充值吗?",caller:this,callback:onConfirmCancle});
		}
		
		private function onConfirmCancle(sure:Boolean):void
		{
			if(sure)
			{
				trace("jjkkkk");
			}
		}
				
		
	}
}