/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;

	public class PackageItemUI extends View {
		public var packname:TextInput;
		public var delbtn:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{},"compId":2,"child":[{"type":"Image","props":{"width":55,"skin":"commers1/inputbg.png","sizeGrid":"2,2,2,2","height":50},"compId":3,"child":[{"type":"TextInput","props":{"y":0,"x":0,"wordWrap":true,"width":55,"var":"packname","text":"浦东南汇包裹","skin":"comp/textinput.png","height":50,"sizeGrid":"6,15,7,14"},"compId":6},{"type":"Button","props":{"var":"delbtn","top":1,"skin":"commers1/btnclose.png","right":0},"compId":5}]}],"loadList":["commers1/inputbg.png","comp/textinput.png","commers1/btnclose.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}