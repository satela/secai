/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;

	public class OutPutCenterUI extends View {
		public var qqContact:Button;
		public var factorytxt:Text;
		public var checkselect:CheckBox;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":0,"height":40},"compId":2,"child":[{"type":"Box","props":{"y":0,"x":0},"compId":3,"child":[{"type":"Button","props":{"y":0,"x":600,"width":128,"var":"qqContact","skin":"commers/btn1.png","sizeGrid":"3,3,3,3","labelSize":18,"labelFont":"SimHei","labelColors":"#FFFFFF,#FFFFFF,#FFFFFF","label":"qq交谈","height":40},"compId":5},{"type":"Text","props":{"y":5,"x":68,"var":"factorytxt","text":"更改输出中心","presetID":1,"fontSize":22,"font":"SimHei","color":"#39B25A","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":6,"child":[{"type":"Script","props":{"txttype":2,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":7}]},{"type":"CheckBox","props":{"y":11,"x":19,"var":"checkselect","skin":"commers/multicheck.png","scaleY":1,"scaleX":1,"mouseEnabled":false,"labelSize":20},"compId":8}]}],"loadList":["commers/btn1.png","prefabs/LinksText.prefab","commers/multicheck.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}