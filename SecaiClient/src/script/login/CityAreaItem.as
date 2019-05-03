package script.login
{
	import laya.events.Event;
	
	import model.users.CityAreaVo;
	
	import ui.login.CityAreaItemUI;
	
	public class CityAreaItem extends CityAreaItemUI
	{
		public var areaVo:Object;
		public function CityAreaItem()
		{
			super();
			this.on(Event.MOUSE_OVER,this,onMouseOver);
			this.on(Event.MOUSE_OUT,this,onMouseOut);
			bg.visible = false;

		}
		
		private function onMouseOver():void
		{
			bg.visible = true;
		}
		private function onMouseOut():void
		{
			bg.visible = false;
		}
		public function setData(areavo:Object):void
		{
			areaVo = areavo;
			productname.text = areaVo.areaname;
		}
	}
}