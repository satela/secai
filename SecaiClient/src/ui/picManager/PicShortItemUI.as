/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.picManager {
	import laya.ui.*;
	import laya.display.*;

	public class PicShortItemUI extends View {
		public var img:Image;
		public var filename:Label;
		public var btndelete:Button;
		public var fileinfo:Label;
		public var picClassTxt:Label;
		public var colorspacetxt:Label;
		public var sel:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":128,"height":214},"compId":2,"child":[{"type":"Image","props":{"y":64,"x":64,"width":108,"var":"img","skin":"upload/fold.png","height":101,"anchorY":0.5,"anchorX":0.5},"compId":3},{"type":"Label","props":{"y":130,"wordWrap":true,"width":124,"var":"filename","valign":"middle","text":"名称.jpg 宽 3256 名称","right":2,"overflow":"hidden","left":2,"height":28,"fontSize":16,"font":"Helvetica","color":"#262B2E","align":"center"},"compId":4},{"type":"Button","props":{"y":2,"x":103,"var":"btndelete","stateNum":1,"skin":"upload/deletebtn.png","label":"X"},"compId":7},{"type":"Label","props":{"y":162,"wordWrap":true,"width":128,"var":"fileinfo","valign":"top","text":"名称.jpg 宽 3256/n可以啊","right":0,"overflow":"scroll","left":0,"height":52,"fontSize":16,"font":"Helvetica","color":"#262B2E","align":"center"},"compId":8},{"type":"Label","props":{"y":107,"x":0,"wordWrap":true,"width":48,"var":"picClassTxt","valign":"middle","text":"JPEG","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","bgColor":"#FFFFFFC9","align":"left"},"compId":9},{"type":"Label","props":{"y":107,"wordWrap":true,"width":48,"var":"colorspacetxt","valign":"middle","text":"CMYK","right":0,"height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","bgColor":"#FFFFFFC9","align":"right"},"compId":11},{"type":"Button","props":{"y":5,"x":9,"var":"sel","skin":"upload/imgselect.png"},"compId":12}],"loadList":["upload/fold.png","upload/deletebtn.png","upload/imgselect.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}