/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.login {
	import laya.ui.*;
	import laya.display.*;

	public class CityAreaItemUI extends View {
		public var bg:Image;
		public var productname:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":170,"height":26},"compId":2,"child":[{"type":"Image","props":{"var":"bg","top":0,"skin":"commers1/grayback.jpg","right":0,"left":0,"bottom":0},"compId":5},{"type":"Label","props":{"width":170,"var":"productname","valign":"middle","top":0,"text":"江西省","left":0,"height":24,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":3}],"loadList":["commers1/grayback.jpg"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}