/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.chargeActivity {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;

	public class ChargeRecordItemUI extends View {
		public var chargemoney:Label;
		public var currentval:Label;
		public var totalval:Label;
		public var totalreturn:Label;
		public var chargetime:Label;
		public var cancelbtn:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":0,"height":0},"compId":2,"child":[{"type":"Image","props":{"y":0,"x":0,"width":1000,"skin":"commers/inputbg.png","sizeGrid":"5,5,5,5","height":60},"compId":3,"child":[{"type":"Sprite","props":{"y":0,"x":0},"compId":21,"child":[{"type":"Rect","props":{"width":1000,"lineWidth":1,"height":60,"fillColor":"#eff4ef"},"compId":22}]}]},{"type":"Label","props":{"y":5,"x":16,"wordWrap":true,"width":118,"var":"chargemoney","valign":"middle","text":"15000","overflow":"hidden","height":50,"fontSize":20,"font":"Arial","color":"#262B2E","align":"center"},"compId":7},{"type":"Label","props":{"y":5,"x":177,"wordWrap":true,"width":153,"var":"currentval","valign":"middle","text":"2","height":50,"fontSize":20,"font":"Arial","color":"#262B2E","align":"center"},"compId":27},{"type":"Label","props":{"y":5,"x":360,"wordWrap":true,"width":118,"var":"totalval","valign":"middle","text":"12","overflow":"hidden","height":50,"fontSize":20,"font":"Arial","color":"#262B2E","align":"center"},"compId":58},{"type":"Label","props":{"y":5,"x":520,"wordWrap":true,"width":118,"var":"totalreturn","valign":"middle","text":"15000","overflow":"hidden","height":50,"fontSize":20,"font":"Arial","color":"#262B2E","align":"center"},"compId":59},{"type":"Label","props":{"y":5,"x":695,"wordWrap":true,"width":200,"var":"chargetime","valign":"middle","text":"2021-12-12 15:00:00","overflow":"hidden","height":50,"fontSize":20,"font":"Arial","color":"#262B2E","align":"center"},"compId":60},{"type":"Text","props":{"y":3,"x":938,"var":"cancelbtn","valign":"middle","text":"退款","presetID":1,"height":50,"fontSize":20,"font":"SimHei","color":"#e25e52","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":61,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":62}]}],"loadList":["commers/inputbg.png","prefabs/LinksText.prefab"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}