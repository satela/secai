package script.usercenter.item
{
	import laya.events.Event;
	
	import ui.usercenter.OrganizeItemUI;
	
	public class OrganizeItem extends OrganizeItemUI
	{
		public function OrganizeItem()
		{
			super();
			
			this.deltbn.visible = false;
			
			this.on(Event.MOUSE_OVER,this,showDeltbn);
			this.on(Event.MOUSE_OUT,this,hideDeltbn);

		}
		public function set selected(value:Boolean):void
		{
			this.hotbtm.selected = value;
		}
		private function showDeltbn():void
		{
			this.deltbn.visible = true;
		}
		
		private function hideDeltbn():void
		{
			this.deltbn.visible = false;
		}
		
		public function setData(data:*):void
		{
			
		}
	}
}