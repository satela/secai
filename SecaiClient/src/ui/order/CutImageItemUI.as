/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;

	public class CutImageItemUI extends View {
		public var paintimg:Image;
		public var cuttyperad:RadioGroup;
		public var cutnumrad:RadioGroup;
		public var hbox:HBox;
		public var hinput0:TextInput;
		public var hinput1:TextInput;
		public var hinput2:TextInput;
		public var hinput3:TextInput;
		public var hinput4:TextInput;
		public var hinput5:TextInput;
		public var hinput6:TextInput;
		public var vbox:VBox;
		public var vinput0:TextInput;
		public var vinput1:TextInput;
		public var vinput2:TextInput;
		public var vinput3:TextInput;
		public var vinput4:TextInput;
		public var vinput5:TextInput;
		public var vinput6:TextInput;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":0,"height":0},"compId":2,"child":[{"type":"Image","props":{"y":65,"x":0,"width":402,"skin":"upload/inoutbg.png","sizeGrid":"3,3,3,3","height":402},"compId":3,"child":[{"type":"Image","props":{"y":201,"x":201,"width":400,"var":"paintimg","skin":"comp/image.png","height":400,"anchorY":0.5,"anchorX":0.5},"compId":4}]},{"type":"Label","props":{"y":3,"x":5,"text":"裁切方向：","fontSize":18,"font":"SimHei"},"compId":5},{"type":"RadioGroup","props":{"y":7,"x":95,"var":"cuttyperad","skin":"commers/checksingle.png","labels":"竖拼裁切 ,横拼裁切","labelSize":18,"labelFont":"SimHei"},"compId":7},{"type":"Label","props":{"y":34,"x":5,"text":"裁切份数：","fontSize":18,"font":"SimHei"},"compId":8},{"type":"RadioGroup","props":{"y":38,"x":95,"var":"cutnumrad","skin":"commers/checksingle.png","labels":"3 ,4 ,5 , 6","labelSize":18,"labelFont":"SimHei"},"compId":9},{"type":"HBox","props":{"y":469,"x":5,"width":400,"var":"hbox","height":30},"compId":20,"child":[{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"hinput0","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":13},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"hinput1","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":15},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"hinput2","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":17},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"hinput3","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":22},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"hinput4","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":24},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"hinput5","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":25},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"hinput6","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":33}]},{"type":"VBox","props":{"y":65,"x":405,"width":50,"var":"vbox","height":400},"compId":26,"child":[{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"vinput0","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":27},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"vinput1","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":28},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"vinput2","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":29},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"vinput3","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":30},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"vinput4","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":31},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"vinput5","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":32},{"type":"TextInput","props":{"y":0,"x":0,"width":50,"var":"vinput6","text":"100","skin":"comp/textinput.png","fontSize":18,"font":"SimSun","sizeGrid":"6,15,7,14"},"compId":34}]}],"loadList":["upload/inoutbg.png","comp/image.png","commers/checksingle.png","comp/textinput.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}