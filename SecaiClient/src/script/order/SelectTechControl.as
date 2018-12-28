package script.order
{
	import laya.components.Script;
	import laya.events.Event;
	
	import model.orderModel.TechMainVo;
	
	import script.ViewManager;
	
	import ui.order.SelectTechPanelUI;
	
	public class SelectTechControl extends Script
	{
		private var uiSKin:SelectTechPanelUI;
		public function SelectTechControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSKin = this.owner as SelectTechPanelUI;
			
			var list:Array = [];
			
			var num:int = Math.random()*18;
			var startpos:int = 0;
			this.uiSKin.techcontent.vScrollBarSkin = "";
			for(var i:int=0;i < num;i++)
			{
				var tcvo:TechMainVo = new TechMainVo();
				var itembox:TechBoxItem = new TechBoxItem(tcvo);
				
				itembox.y = startpos;
				startpos += itembox.height + 20;
				this.uiSKin.techcontent.addChild(itembox);
			}
			this.uiSKin.btnok.on(Event.CLICK,this,onCloseView);
		}
		
		private function onCloseView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_TECHNORLOGY);
		}
	}
}