/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;

	public class OrderListItemUI extends View {
		public var orderid:Label;
		public var ordertime:Label;
		public var productnum:Label;
		public var paymoney:Label;
		public var orderstatus:Label;
		public var detailbtn:Text;
		public var deletebtn:Text;
		public var payagain:Text;
		public var retrybtn:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":0,"height":0},"compId":2,"child":[{"type":"Image","props":{"y":0,"x":0,"width":838,"skin":"commers/inputbg.png","sizeGrid":"3,3,3,3","height":28},"compId":12},{"type":"Label","props":{"y":0,"x":0,"width":108,"var":"orderid","valign":"middle","text":"18014398509481987","height":29,"fontSize":16,"font":"SimHei","align":"center"},"compId":3},{"type":"Label","props":{"y":0,"x":148,"width":161,"var":"ordertime","valign":"middle","text":"2019-05-22 15:30:00","height":29,"fontSize":16,"font":"SimHei","align":"center"},"compId":4},{"type":"Label","props":{"y":0,"x":328,"width":63,"var":"productnum","valign":"middle","text":"1","height":29,"fontSize":16,"font":"SimHei","align":"center"},"compId":5},{"type":"Label","props":{"y":0,"x":412,"width":74,"var":"paymoney","valign":"middle","text":"17.88","height":29,"fontSize":16,"font":"SimHei","align":"center"},"compId":6},{"type":"Label","props":{"y":0,"x":496,"width":106,"var":"orderstatus","valign":"middle","text":"已支付","height":26,"fontSize":16,"font":"SimHei","align":"center"},"compId":7},{"type":"Text","props":{"y":3,"x":642,"var":"detailbtn","text":"详情","presetID":1,"fontSize":16,"font":"SimHei","color":"#0022EE","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":8,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":9}]},{"type":"Text","props":{"y":3,"x":685,"var":"deletebtn","text":"撤回","presetID":1,"fontSize":16,"font":"SimHei","color":"#ef0e0b","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":10,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":11}]},{"type":"Text","props":{"y":3,"x":727,"var":"payagain","text":"支付","presetID":1,"fontSize":16,"font":"SimHei","color":"52B232","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":13,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":14}]},{"type":"Text","props":{"y":3,"x":727,"var":"retrybtn","text":"重试","presetID":1,"fontSize":16,"font":"SimHei","color":"52B232","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":15,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":16}]}],"loadList":["commers/inputbg.png","prefabs/LinksText.prefab"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}