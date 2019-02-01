/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;

	public class OrderItemUI extends Scene {
		public var bgimg:Image;
		public var fileimg:Image;
		public var inputnum:TextInput;
		public var numindex:Label;
		public var filename:Label;
		public var viprice:Label;
		public var price:Label;
		public var total:Label;
		public var operatebox:Box;
		public var addmsg:Text;
		public var deleteorder:Text;
		public var editbox:Box;
		public var editwidth:TextInput;
		public var editheight:TextInput;
		public var architype:Label;
		public var changearchitxt:Text;
		public var matbox:Sprite;
		public var mattxt:Label;
		public var changemat:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Scene","props":{"width":1280},"compId":2,"child":[{"type":"Image","props":{"y":0,"x":0,"width":1281,"var":"bgimg","skin":"commers/sel.png","sizeGrid":"5,5,5,5","height":60},"compId":26},{"type":"Image","props":{"y":0,"x":54,"width":85,"var":"fileimg","skin":"comp/image.png","height":60},"compId":4},{"type":"TextInput","props":{"y":26,"x":993,"width":46,"var":"inputnum","text":"1","skin":"comp/textinput.png","height":22,"fontSize":18,"sizeGrid":"6,15,7,14"},"compId":16},{"type":"Label","props":{"y":21,"x":10,"width":30,"var":"numindex","text":"1","height":21,"fontSize":20,"align":"center"},"compId":3},{"type":"Label","props":{"y":15,"x":151,"wordWrap":true,"width":182,"var":"filename","text":"PP纸无背胶（海报、展架）.tif","height":38,"fontSize":18,"align":"center"},"compId":5},{"type":"Label","props":{"y":26,"x":911,"width":58,"var":"viprice","text":"0","height":21,"fontSize":18,"align":"center"},"compId":14},{"type":"Label","props":{"y":26,"x":1047,"width":58,"var":"price","text":"1","height":21,"fontSize":18,"align":"center"},"compId":15},{"type":"Label","props":{"y":26,"x":1110,"width":77,"var":"total","text":"7776.8","height":21,"fontSize":18,"align":"center"},"compId":17},{"type":"Box","props":{"y":10,"x":1203,"var":"operatebox"},"compId":21,"child":[{"type":"Text","props":{"var":"addmsg","text":"添加备注","fontSize":18,"color":"#094f28","runtime":"laya.display.Text"},"compId":18},{"type":"Text","props":{"y":26,"var":"deleteorder","text":"删除订单","fontSize":18,"color":"#094f28","runtime":"laya.display.Text"},"compId":19}]},{"type":"Box","props":{"y":10,"x":577,"var":"editbox"},"compId":22,"child":[{"type":"Label","props":{"y":1,"width":58,"text":"宽(cm)","height":21,"fontSize":18,"align":"center"},"compId":8},{"type":"Label","props":{"y":25,"width":58,"text":"高(cm)","height":21,"fontSize":18,"align":"center"},"compId":9},{"type":"TextInput","props":{"x":58,"width":74,"var":"editwidth","text":"20","skin":"comp/textinput.png","height":22,"fontSize":18,"sizeGrid":"6,15,7,14"},"compId":10},{"type":"TextInput","props":{"y":26,"x":58,"width":74,"var":"editheight","text":"20","skin":"comp/textinput.png","height":22,"fontSize":18,"sizeGrid":"6,15,7,14"},"compId":11}]},{"type":"VBox","props":{"y":10,"x":726,"space":0},"compId":24,"child":[{"type":"Label","props":{"y":5,"x":0,"wordWrap":true,"width":176,"var":"architype","valign":"top","text":"户外材料--白胶车贴","height":30,"fontSize":18,"align":"center"},"compId":12},{"type":"Text","props":{"y":31,"x":52,"var":"changearchitxt","text":"更换材料","presetID":1,"fontSize":18,"color":"#094f28","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":29,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":30}]}]},{"type":"Sprite","props":{"y":12,"x":360,"var":"matbox"},"compId":25,"child":[{"type":"Label","props":{"width":187,"var":"mattxt","height":21,"fontSize":18,"align":"center"},"compId":6},{"type":"Text","props":{"y":25,"x":60,"var":"changemat","text":"更换材料","presetID":1,"fontSize":18,"color":"#094f28","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":27,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":28}]}]}],"loadList":["commers/sel.png","comp/image.png","comp/textinput.png","prefabs/LinksText.prefab"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}