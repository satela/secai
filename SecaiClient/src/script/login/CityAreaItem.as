package script.login
{
	import ui.login.CityAreaItemUI;
	
	public class CityAreaItem extends CityAreaItemUI
	{
		public var cityname:String;
		public function CityAreaItem()
		{
			super();
		}
		
		public function setData(str:String):void
		{
			cityname = str;
			productname.text = str;
		}
	}
}