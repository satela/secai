package script.activity
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import script.ViewManager;
	
	import ui.chargeActivity.ChargeActRecordPanelUI;
	
	public class ChargeActRecordController extends Script
	{
		private var uiSkin:ChargeActRecordPanelUI;
		
		private var param:Object;
		public function ChargeActRecordController()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ChargeActRecordPanelUI;
			
			
			uiSkin.recordlist.itemRender = ChargeRecordCell;
			
			//uiSkin.applylist.vScrollBarSkin = "";
			uiSkin.recordlist.repeatX = 1;
			uiSkin.recordlist.spaceY = 5;
			
			uiSkin.recordlist.renderHandler = new Handler(this, updateRecordList);
			uiSkin.recordlist.selectEnable = false;
			
			uiSkin.recordlist.array = new Array(12);
			
			uiSkin.closebtn.on(Event.CLICK,this,closePanel);
		}
		
		private function updateRecordList(cell:ChargeRecordCell,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		
		private function closePanel():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_CHARGE_RECORD_PANEL);
		}
		
		
	}
}