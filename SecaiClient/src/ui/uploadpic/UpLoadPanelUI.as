/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.uploadpic {
	import laya.ui.*;
	import laya.display.*;
	import script.picUpload.UpLoadAndOrderContrl;

	public class UpLoadPanelUI extends View {
		public var bgimg:Image;
		public var btnClose:Button;
		public var btnOpenFile:Button;
		public var btnBegin:Button;
		public var fileList:List;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("uploadpic/UpLoadPanel");

		}

	}
}