/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;

	public class AddressItemUI extends View {
		public var conName:Label;
		public var phone:Label;
		public var detailaddr:Label;
		public var btnDel:Text;
		public var btnEdit:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":788,"height":24},"compId":2,"child":[{"type":"Label","props":{"y":0,"x":1,"width":101,"var":"conName","valign":"middle","text":"徐建华","height":24,"fontSize":18,"align":"center"},"compId":3},{"type":"Label","props":{"y":0,"x":101,"width":170,"var":"phone","valign":"middle","text":"13564113173","height":24,"fontSize":18,"align":"center"},"compId":5},{"type":"Label","props":{"y":0,"x":270,"width":443,"var":"detailaddr","valign":"middle","text":"上海市浦东新区周浦镇瑞浦路612弄23号1001室","height":24,"fontSize":18,"align":"center"},"compId":6},{"type":"Rect","props":{"y":0,"x":0,"width":788,"lineWidth":1,"lineColor":"#1c1a1a","height":24},"compId":10},{"type":"Text","props":{"y":5,"x":753,"var":"btnDel","text":"删除","presetID":1,"color":"#1c893f","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":8,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":9}]},{"type":"Text","props":{"y":5,"x":718,"var":"btnEdit","text":"编辑","presetID":1,"color":"#1c893f","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":7,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":4}]}],"loadList":["prefabs/LinksText.prefab"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}