/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;
	import script.order.PackageOrderControl;

	public class PackagePanelUI extends View {
		public var okbtn:Button;
		public var cancelbtn:Button;
		public var packagebox:Box;
		public var addpackbtn:Button;
		public var productlist:List;
		public var timepreferRdo:RadioGroup;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("order/PackagePanel");

		}

	}
}