/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;

	public class AvgCutImageItemUI extends View {
		public var paintimg:Image;
		public var horiInput:TextInput;
		public var horiAdd:Button;
		public var horiSub:Button;
		public var vertInput:TextInput;
		public var verAdd:Button;
		public var verSub:Button;
		public var heightNum:Label;
		public var widthNum:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{},"compId":2,"child":[{"type":"Image","props":{"y":65,"x":0,"width":402,"skin":"upload/inoutbg.png","sizeGrid":"3,3,3,3","height":402},"compId":3,"child":[{"type":"Image","props":{"y":201,"x":201,"width":400,"var":"paintimg","skin":"comp/image.png","height":400,"anchorY":0.5,"anchorX":0.5},"compId":4}]},{"type":"Label","props":{"y":3,"x":5,"text":"竖向份数：","fontSize":18,"font":"SimHei"},"compId":5},{"type":"Label","props":{"y":34,"x":5,"text":"横向份数：","fontSize":18,"font":"SimHei"},"compId":8},{"type":"Sprite","props":{"y":3,"x":100},"compId":12,"child":[{"type":"TextInput","props":{"y":1,"x":19,"width":40,"var":"horiInput","valign":"middle","text":"10","skin":"commers/inputbg.png","sizeGrid":"3,3,3,3","height":22,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":13},{"type":"Button","props":{"x":60,"var":"horiAdd","skin":"order/addbtn.png"},"compId":14},{"type":"Button","props":{"var":"horiSub","skin":"order/subtbn.png"},"compId":15}]},{"type":"Sprite","props":{"y":33,"x":100},"compId":16,"child":[{"type":"TextInput","props":{"y":1,"x":19,"width":40,"var":"vertInput","text":"10","skin":"commers/inputbg.png","sizeGrid":"3,3,3,3","height":22,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":17},{"type":"Button","props":{"x":60,"var":"verAdd","skin":"order/addbtn.png"},"compId":18},{"type":"Button","props":{"var":"verSub","skin":"order/subtbn.png"},"compId":19}]},{"type":"Label","props":{"y":3,"x":219,"var":"heightNum","text":"120","fontSize":18,"font":"SimHei","align":"left"},"compId":20},{"type":"Label","props":{"y":35,"x":219,"var":"widthNum","text":"120","fontSize":18,"font":"SimHei","align":"left"},"compId":21},{"type":"Label","props":{"y":3,"x":190,"text":"宽:","fontSize":18,"font":"SimHei"},"compId":22},{"type":"Label","props":{"y":35,"x":190,"text":"宽:","fontSize":18,"font":"SimHei"},"compId":23}],"loadList":["upload/inoutbg.png","comp/image.png","commers/inputbg.png","order/addbtn.png","order/subtbn.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}