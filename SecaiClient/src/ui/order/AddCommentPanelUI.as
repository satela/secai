/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;
	import utils.AddMsgControl;

	public class AddCommentPanelUI extends View {
		public var inputmsg:TextInput;
		public var btnok:Button;
		public var btncancel:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1920,"height":1080},"compId":2,"child":[{"type":"Image","props":{"y":10,"x":10,"top":0,"skin":"commers/blackbg.png","right":0,"left":0,"bottom":0,"alpha":0.8},"compId":3},{"type":"Panel","props":{"y":10,"x":10,"top":0,"right":0,"left":0,"bottom":100},"compId":4,"child":[{"type":"Image","props":{"y":370,"x":320,"width":1280,"skin":"commers/whitebg.png","height":331},"compId":6},{"type":"Image","props":{"y":300,"x":320,"width":1280,"skin":"commers/blackbg.png","height":74,"alpha":0.3},"compId":7},{"type":"Label","props":{"y":319,"x":849,"text":"添加备注","fontSize":36,"color":"#eedfdf","bold":true},"compId":8},{"type":"TextInput","props":{"y":391,"x":344,"width":1235,"var":"inputmsg","skin":"comp/textinput.png","prompt":"添加备注","height":210,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":10},{"type":"Sprite","props":{"y":644,"x":826},"compId":13,"child":[{"type":"Button","props":{"width":112,"var":"btnok","skin":"comp/button.png","labelSize":20,"label":"确定","height":30},"compId":14},{"type":"Button","props":{"x":159,"width":112,"var":"btncancel","skin":"comp/button.png","labelSize":20,"label":"取消","height":30},"compId":15}]}]},{"type":"Script","props":{"runtime":"utils.AddMsgControl"},"compId":16}],"loadList":["commers/blackbg.png","commers/whitebg.png","comp/textinput.png","comp/button.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}