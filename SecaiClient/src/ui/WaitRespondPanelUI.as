/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui {
	import laya.ui.*;
	import laya.display.*;

	public class WaitRespondPanelUI extends Scene {
		public var zhuanq:Image;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Scene","props":{"width":1920,"height":1080},"compId":2,"child":[{"type":"Image","props":{"top":0,"skin":"commers/blackbg.png","right":0,"mouseEnabled":true,"left":0,"bottom":0,"alpha":0.9,"sizeGrid":"22,17,16,17"},"compId":3},{"type":"Image","props":{"y":540,"x":960,"var":"zhuanq","skin":"commers/circlebg.png","anchorY":0.5,"anchorX":0.5,"alpha":0.9},"compId":4}],"loadList":["commers/blackbg.png","commers/circlebg.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}