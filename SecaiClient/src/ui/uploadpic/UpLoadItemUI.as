/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.uploadpic {
	import laya.ui.*;
	import laya.display.*;

	public class UpLoadItemUI extends View {
		public var prgbar:Sprite;
		public var filename:Label;
		public var prog:Label;
		public var filesize:Label;
		public var btncancel:Button;
		public var finishimg:Sprite;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{},"compId":2,"child":[{"type":"Sprite","props":{"y":0,"x":0,"width":1084,"texture":"commers/分割线.png","height":1},"compId":12},{"type":"Sprite","props":{"y":1,"x":0,"width":800,"var":"prgbar","texture":"upload/prgbg.png","height":76,"sizeGrid":"2,2,2,2"},"compId":14},{"type":"Label","props":{"y":30.5,"x":92.5,"width":445,"var":"filename","text":"文件名","overflow":"hidden","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"left"},"compId":3},{"type":"Label","props":{"y":30.5,"x":776.5,"width":70,"var":"prog","text":"10%","height":18,"fontSize":16,"font":"SimHei","color":"#262B2E"},"compId":6},{"type":"Label","props":{"y":30.5,"x":674.5,"width":78,"var":"filesize","text":"12k","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"right"},"compId":7},{"type":"Button","props":{"y":32.5,"x":1020.5,"var":"btncancel","stateNum":1,"skin":"upload/关闭.png"},"compId":9},{"type":"Sprite","props":{"y":20,"x":32,"texture":"upload/图icon.png"},"compId":11},{"type":"Sprite","props":{"y":76,"x":0,"width":1084,"texture":"commers/分割线.png","height":1},"compId":13},{"type":"Sprite","props":{"y":28.5,"x":776.5,"var":"finishimg","texture":"upload/完成.png"},"compId":15}],"loadList":["commers/分割线.png","upload/prgbg.png","upload/关闭.png","upload/图icon.png","upload/完成.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}