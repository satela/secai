/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;
	import script.order.SelectMaterialControl;

	public class SelectMaterialPanelUI extends View {
		public var main_panel:Panel;
		public var matlist:List;
		public var btnok:Button;
		public var btncancel:Button;
		public var tablist:List;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("order/SelectMaterialPanel");

		}

	}
}