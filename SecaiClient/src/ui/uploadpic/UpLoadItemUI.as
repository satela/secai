/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.uploadpic {
	import laya.ui.*;
	import laya.display.*;

	public class UpLoadItemUI extends View {
		public var filename:Label;
		public var prgbar:ProgressBar;
		public var prog:Label;
		public var filesize:Label;
		public var btncancel:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{},"compId":2,"child":[{"type":"Label","props":{"y":9,"x":12,"width":115,"var":"filename","text":"文件名","overflow":"hidden","height":21,"fontSize":20,"color":"#f3ecec","align":"right"},"compId":3},{"type":"ProgressBar","props":{"y":13,"x":211,"width":152,"var":"prgbar","value":0.5,"skin":"comp/progress.png","height":14},"compId":5},{"type":"Label","props":{"y":10,"x":374,"width":45,"var":"prog","text":"10%","height":18,"fontSize":20,"color":"#f1e7e7"},"compId":6},{"type":"Label","props":{"y":9,"x":138,"width":61,"var":"filesize","text":"12k","height":21,"fontSize":20,"color":"#f1e2e2","align":"right"},"compId":7},{"type":"Button","props":{"y":9,"x":442,"width":65,"var":"btncancel","skin":"comp/button.png","label":"删除","height":23},"compId":9}],"loadList":["comp/progress.png","comp/button.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}