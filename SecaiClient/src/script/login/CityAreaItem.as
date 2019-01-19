package script.login
{
	import model.users.CityAreaVo;
	
	import ui.login.CityAreaItemUI;
	
	public class CityAreaItem extends CityAreaItemUI
	{
		public var areaVo:CityAreaVo;
		public function CityAreaItem()
		{
			super();
		}
		
		public function setData(areavo:CityAreaVo):void
		{
			areaVo = areavo;
			productname.text = areaVo.areaName;
		}
	}
}