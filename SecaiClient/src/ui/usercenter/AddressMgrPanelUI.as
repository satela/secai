/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import script.usercenter.AddressMgrControl;

	public class AddressMgrPanelUI extends View {
		public var btnaddAddress:Button;
		public var addlist:List;
		public var numAddress:Label;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("usercenter/AddressMgrPanel");

		}

	}
}