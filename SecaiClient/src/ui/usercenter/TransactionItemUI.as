/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;

	public class TransactionItemUI extends View {
		public var transtype:Label;
		public var transtime:Label;
		public var amounttxt:Label;
		public var orderinfo:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":0,"height":0},"compId":2,"child":[{"type":"Image","props":{"width":800,"skin":"commers/cutline.png"},"compId":3},{"type":"Label","props":{"x":0,"width":100,"var":"transtype","text":"充值","fontSize":20,"font":"SimSun","align":"center"},"compId":4},{"type":"Label","props":{"y":1,"x":143,"width":250,"var":"transtime","text":"2020-10-12 20:00:00","fontSize":20,"font":"SimSun","align":"center"},"compId":5},{"type":"Label","props":{"y":0,"x":437,"width":100,"var":"amounttxt","text":"12200.22","fontSize":20,"font":"SimSun","align":"center"},"compId":6},{"type":"Label","props":{"y":0,"x":580,"width":220,"var":"orderinfo","text":"订单号:1825656565656520","fontSize":20,"font":"SimSun","align":"center"},"compId":7}],"loadList":["commers/cutline.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}