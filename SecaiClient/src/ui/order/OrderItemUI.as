/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.order {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;

	public class OrderItemUI extends Scene {
		public var bgimg:Image;
		public var fileimg:Image;
		public var backimg:Image;
		public var yingxback:Image;
		public var yixingimg:Image;
		public var numindex:Label;
		public var filename:Label;
		public var price:Label;
		public var total:Label;
		public var operatebox:Box;
		public var addmsg:Text;
		public var deleteorder:Text;
		public var hascomment:Label;
		public var editbox:Box;
		public var editwidth:TextInput;
		public var editheight:TextInput;
		public var lockratio:Image;
		public var architype:Label;
		public var matbox:Sprite;
		public var mattxt:Label;
		public var changemat:Text;
		public var checkSel:CheckBox;
		public var numbox:Sprite;
		public var inputnum:TextInput;
		public var addbtn:Button;
		public var subtn:Button;
		public var timebox:Box;
		public var estimatelbl:Label;
		public var timebtn0:Button;
		public var timebtn1:Button;
		public var timebtn2:Button;
		public var timebtn3:Button;
		public var timebtn4:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Scene","props":{"width":1280},"compId":2,"child":[{"type":"Image","props":{"y":0,"x":0,"width":1280,"var":"bgimg","skin":"commers/inputbg.png","sizeGrid":"5,5,5,5","height":82},"compId":26},{"type":"Image","props":{"y":40,"x":109,"width":80,"var":"fileimg","skin":"comp/image.png","height":80,"anchorY":0.5,"anchorX":0.5},"compId":4},{"type":"Image","props":{"y":42,"x":206,"width":80,"var":"backimg","skin":"comp/image.png","height":80,"anchorY":0.5,"anchorX":0.5},"compId":38},{"type":"Image","props":{"y":42,"x":206,"width":80,"var":"yingxback","skin":"comp/image.png","scaleX":-1,"mouseEnabled":false,"height":80,"anchorY":0.5,"anchorX":0.5,"alpha":0.5},"compId":40},{"type":"Image","props":{"y":40,"x":109,"width":80,"var":"yixingimg","skin":"comp/image.png","height":80,"anchorY":0.5,"anchorX":0.5,"alpha":0.5},"compId":39},{"type":"Label","props":{"y":34,"x":35,"width":30,"var":"numindex","text":"1","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":3},{"type":"Label","props":{"y":0,"x":258,"wordWrap":true,"width":118,"var":"filename","valign":"middle","text":"PP纸无背胶（海报、展架）.tif","overflow":"hidden","height":82,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":5},{"type":"Label","props":{"y":35.5,"x":916,"width":58,"visible":false,"var":"price","text":"175.2","fontSize":16,"font":"SimHei","color":"#152326","bold":true,"align":"center"},"compId":15},{"type":"Label","props":{"y":17,"x":1109,"width":50,"var":"total","text":"12680","fontSize":16,"font":"SimHei","color":"#262B2E","bold":true,"align":"center"},"compId":17},{"type":"Box","props":{"y":9,"x":1191,"var":"operatebox"},"compId":21,"child":[{"type":"Text","props":{"y":8,"x":0,"var":"addmsg","text":"添加备注","fontSize":16,"font":"SimHei","color":"#262B2E","runtime":"laya.display.Text"},"compId":18},{"type":"Text","props":{"y":24,"x":0,"var":"deleteorder","text":"删除订单","fontSize":16,"font":"SimHei","color":"#262B2E","runtime":"laya.display.Text"},"compId":19},{"type":"Label","props":{"y":-13,"x":65,"width":14,"var":"hascomment","valign":"middle","text":"'''","height":17,"fontSize":24,"font":"Helvetica","color":"#39B25A","align":"center"},"compId":36}]},{"type":"Box","props":{"y":12,"x":560,"var":"editbox"},"compId":22,"child":[{"type":"Label","props":{"y":1,"width":58,"text":"宽(cm)","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":8},{"type":"Label","props":{"y":38,"x":0,"width":58,"text":"高(cm)","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":9},{"type":"TextInput","props":{"x":58,"width":74,"var":"editwidth","text":"16","skin":"commers/inputbg.png","sizeGrid":"5,5,5,5","mouseEnabled":true,"height":22,"fontSize":16,"font":"SimHei","color":"#262B2E"},"compId":10},{"type":"TextInput","props":{"y":39,"x":58,"width":74,"var":"editheight","text":"16","skin":"commers/inputbg.png","sizeGrid":"3,3,3,3","mouseEnabled":true,"height":22,"fontSize":16,"font":"SimHei","color":"#262B2E"},"compId":11},{"type":"Image","props":{"y":17,"x":142,"width":20,"var":"lockratio","skin":"commers/lock.png","height":20},"compId":37}]},{"type":"VBox","props":{"y":29.5,"x":733,"space":0},"compId":24,"child":[{"type":"Label","props":{"y":7,"x":0,"wordWrap":true,"width":176,"var":"architype","valign":"top","text":"户外材料--白胶车贴","height":30,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":12}]},{"type":"Sprite","props":{"y":15,"x":394,"width":158,"var":"matbox","height":43},"compId":25,"child":[{"type":"Label","props":{"width":187,"var":"mattxt","text":"展架专用布","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":6},{"type":"Text","props":{"y":25,"x":59,"var":"changemat","text":"更换材料","presetID":1,"fontSize":16,"font":"SimHei","color":"#39B25A","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":27,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":28}]}]},{"type":"CheckBox","props":{"y":36,"x":14,"var":"checkSel","skin":"commers/multicheck.png","scaleY":1,"scaleX":1},"compId":31},{"type":"Sprite","props":{"y":13,"x":998,"var":"numbox"},"compId":35,"child":[{"type":"TextInput","props":{"y":1,"x":19,"width":40,"var":"inputnum","text":"10","skin":"commers/inputbg.png","sizeGrid":"3,3,3,3","height":22,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":16},{"type":"Button","props":{"x":60,"var":"addbtn","skin":"order/addbtn.png"},"compId":33},{"type":"Button","props":{"var":"subtn","skin":"order/subtbn.png"},"compId":34}]},{"type":"Box","props":{"x":973,"var":"timebox","bottom":2},"compId":51,"child":[{"type":"Label","props":{"y":1,"var":"estimatelbl","text":"预计交付：","fontSize":16,"font":"SimHei"},"compId":43},{"type":"HBox","props":{"x":80,"space":3},"compId":44,"child":[{"type":"Button","props":{"y":0,"x":0,"width":30,"var":"timebtn0","skin":"commers/btn2.png","labelSize":16,"label":"12","height":20},"compId":45},{"type":"Button","props":{"y":0,"x":0,"width":30,"var":"timebtn1","skin":"commers/btn2.png","labelSize":16,"label":"12","height":20},"compId":46},{"type":"Button","props":{"y":0,"x":0,"width":30,"var":"timebtn2","skin":"commers/btn2.png","labelSize":16,"label":"12","height":20},"compId":47},{"type":"Button","props":{"y":0,"x":0,"width":30,"var":"timebtn3","skin":"commers/btn2.png","labelSize":16,"label":"12","height":20},"compId":48},{"type":"Button","props":{"y":0,"x":45,"width":30,"var":"timebtn4","skin":"commers/btn2.png","labelSize":16,"label":"12","height":20},"compId":49}]}]}],"loadList":["commers/inputbg.png","comp/image.png","commers/lock.png","prefabs/LinksText.prefab","commers/multicheck.png","order/addbtn.png","order/subtbn.png","commers/btn2.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}