/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;

	public class ApplyJoinItemUI extends View {
		public var account:Label;
		public var msg:Label;
		public var reqdate:Label;
		public var refusebtn:Text;
		public var agreebtn:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{},"compId":2,"child":[{"type":"Image","props":{"y":0,"x":0,"width":706,"skin":"commers1/inputbg.png","sizeGrid":"3,3,3,3","height":28},"compId":12},{"type":"Label","props":{"y":0,"x":0,"width":108,"var":"account","valign":"middle","text":"13589898989","height":29,"fontSize":16,"font":"SimHei","align":"center"},"compId":3},{"type":"Label","props":{"y":0,"x":148,"width":161,"var":"msg","valign":"middle","text":"13568986989","height":29,"fontSize":16,"font":"SimHei","align":"center"},"compId":4},{"type":"Label","props":{"y":0,"x":328,"width":176,"var":"reqdate","valign":"middle","text":"2020-05-12 12:00:00","height":29,"fontSize":16,"font":"SimHei","align":"center"},"compId":5},{"type":"Text","props":{"y":3,"x":658,"var":"refusebtn","text":"拒绝","presetID":1,"fontSize":16,"font":"SimHei","color":"#ef0e0b","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":10,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":11}]},{"type":"Text","props":{"y":3,"x":618,"var":"agreebtn","text":"同意","presetID":1,"fontSize":16,"font":"SimHei","color":"52B232","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":13,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":14}]}],"loadList":["commers1/inputbg.png","prefabs/LinksText.prefab"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}