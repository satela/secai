/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;

	public class MaterialNameItemUI extends View {
		public var matbtn:Button;
		public var grayimg:Image;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{},"compId":2,"child":[{"type":"Button","props":{"y":0,"x":0,"width":179,"var":"matbtn","skin":"commers/btn2.png","sizeGrid":"3,3,3,3","labelSize":16,"labelFont":"SimHei","labelColors":"#262B2E,#52B232,#49AA2D","labelAlign":"center","label":"户内PP背胶（户内写真）","height":40,"disabled":false},"compId":8,"child":[{"type":"Image","props":{"var":"grayimg","top":0,"skin":"commers/graydisable.jpg","sizeGrid":"2,2,2,2","right":0,"left":0,"bottom":0},"compId":9}]}],"loadList":["commers/btn2.png","commers/graydisable.jpg"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}