/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.login {
	import laya.ui.*;
	import laya.display.*;
	import utils.LoadingPrgControl;

	public class LoadingPanelUI extends View {
		public var prg:ProgressBar;
		public var prgtxt:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1920,"height":1080},"compId":2,"child":[{"type":"ProgressBar","props":{"y":445,"x":587,"width":818,"var":"prg","skin":"comp/progress.png","sizeGrid":"2,1,1,2","height":14},"compId":3},{"type":"Label","props":{"y":400,"x":781.5,"width":357,"var":"prgtxt","text":"10%","height":31,"fontSize":24,"color":"#f3e4e4","align":"center"},"compId":4},{"type":"Script","props":{"runtime":"utils.LoadingPrgControl"},"compId":5}],"loadList":["comp/progress.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}