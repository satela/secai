/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.usercenter.EnterPrizeInfoControl;

	public class EnterPrizeInfoPaneUI extends View {
		public var input_companyname:TextInput;
		public var btnSelProv:Button;
		public var province:Label;
		public var btnSelCity:Button;
		public var citytxt:Label;
		public var btnSelArea:Button;
		public var areatxt:Label;
		public var provbox:Image;
		public var provList:List;
		public var citybox:Image;
		public var cityList:List;
		public var areabox:Image;
		public var areaList:List;
		public var btnsave:Button;
		public var btnSelTown:Button;
		public var towntxt:Label;
		public var townbox:Image;
		public var townList:List;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("usercenter/EnterPrizeInfoPane");

		}

	}
}