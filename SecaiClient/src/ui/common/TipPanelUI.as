/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.common {
	import laya.ui.*;
	import laya.display.*;

	public class TipPanelUI extends View {
		public var backimg:Image;
		public var tips:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":0,"height":0},"compId":2,"child":[{"type":"Image","props":{"y":0,"x":0,"width":160,"var":"backimg","skin":"commers/choosebg.png","sizeGrid":"8,8,8,8","height":36},"compId":3,"child":[{"type":"Label","props":{"y":5,"x":5,"wordWrap":true,"width":150,"var":"tips","text":"这是一个tips,可以很长","fontSize":16,"font":"SimHei"},"compId":4}]}],"loadList":["commers/choosebg.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}