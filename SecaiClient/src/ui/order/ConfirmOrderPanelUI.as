/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;
	import script.order.PayTypeSelectControl;

	public class ConfirmOrderPanelUI extends View {
		public var cancelbtn:Button;
		public var paybtn:Button;
		public var accountmoney:Label;
		public var needpay:Label;
		public var payall:Radio;
		public var paytype:RadioGroup;
		public var realpay:Label;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("order/ConfirmOrderPanel");

		}

	}
}