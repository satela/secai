/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;

	public class TechorItemUI extends View {
		public var grayimg:Image;
		public var shineimg:Image;
		public var techBtn:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{},"compId":2,"child":[{"type":"Image","props":{"y":0,"x":0,"width":140,"var":"grayimg","skin":"commers/graydisable.jpg","sizeGrid":"2,2,2,2","height":40,"gray":true},"compId":10},{"type":"Image","props":{"y":0,"x":0,"width":140,"var":"shineimg","skin":"commers/inputfocus.png","sizeGrid":"5,5,5,5","height":40},"compId":11},{"type":"Button","props":{"y":0,"x":0,"width":140,"var":"techBtn","skin":"order1/selection.png","sizeGrid":"3,3,3,3","labelSize":16,"labelFont":"SimHei","labelColors":"#262B2E,#262B2E,#262B2E","label":"户内PP背胶","height":40},"compId":9}],"loadList":["commers/graydisable.jpg","commers/inputfocus.png","order1/selection.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}