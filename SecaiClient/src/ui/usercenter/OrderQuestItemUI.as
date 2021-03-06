/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;

	public class OrderQuestItemUI extends Scene {
		public var bgimg:Image;
		public var picimg:Image;
		public var isurgent:Label;
		public var itemseq:Label;
		public var money:Label;
		public var comment:Box;
		public var commentmark:Label;
		public var widthtxt:Label;
		public var heighttxt:Label;
		public var matname:Label;
		public var pronum:Label;
		public var detailbtn:Text;
		public var tech:Label;
		public var filename:Label;
		public var deliverydate:Label;
		public var detailbox:VBox;
		public var txtDetailInfo:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Scene","props":{"width":1175,"height":0},"compId":2,"child":[{"type":"Image","props":{"y":0,"x":0,"width":1175,"var":"bgimg","skin":"commers/inputbg.png","sizeGrid":"5,5,5,5","height":165},"compId":3,"child":[{"type":"Image","props":{"y":42,"x":140,"width":80,"var":"picimg","skin":"comp/image.png","height":80,"anchorY":0.5,"anchorX":0.5},"compId":27},{"type":"Label","props":{"y":6.5,"x":8,"var":"isurgent","valign":"middle","text":"加急","fontSize":18,"font":"SimHei","color":"#f3300b","align":"center"},"compId":58},{"type":"Label","props":{"y":35,"x":41,"width":30,"var":"itemseq","text":"1","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":28},{"type":"Label","props":{"y":26.5,"x":856,"width":58,"var":"money","text":"175.2","fontSize":16,"font":"SimHei","color":"#152326","bold":true,"align":"center"},"compId":30},{"type":"Box","props":{"y":26.5,"x":1034,"var":"comment"},"compId":31,"child":[{"type":"Text","props":{"text":"备注","fontSize":16,"font":"SimHei","color":"#262B2E","runtime":"laya.display.Text"},"compId":35},{"type":"Label","props":{"y":-13,"x":36,"width":14,"var":"commentmark","valign":"middle","text":"'''","height":17,"fontSize":24,"font":"Helvetica","color":"#39B25A","align":"center"},"compId":37},{"type":"Box","props":{"y":26,"x":1034},"compId":56,"child":[{"type":"Text","props":{"text":"备注","fontSize":16,"font":"SimHei","color":"#262B2E","runtime":"laya.display.Text"},"compId":57}]}]},{"type":"Box","props":{"y":12,"x":541},"compId":32,"child":[{"type":"Label","props":{"y":1,"x":0,"width":30,"text":"宽","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":38},{"type":"Label","props":{"y":29,"x":0,"width":30,"text":"高","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":39},{"type":"Label","props":{"y":1,"x":30,"width":46,"var":"widthtxt","text":"10000","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":48},{"type":"Label","props":{"y":29,"x":30,"width":46,"var":"heighttxt","text":"10","height":21,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":49}]},{"type":"Sprite","props":{"y":15,"x":363,"width":158,"height":43},"compId":33,"child":[{"type":"Label","props":{"y":0,"x":0,"wordWrap":true,"width":187,"var":"matname","valign":"middle","text":"展架专用布","overflow":"hidden","height":42,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":42}]},{"type":"Label","props":{"y":21,"x":796,"width":53,"var":"pronum","valign":"middle","text":"10","height":30,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":50},{"type":"Text","props":{"y":27,"x":1105,"var":"detailbtn","text":"详情","presetID":1,"fontSize":16,"font":"SimHei","color":"#52B232","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":51,"child":[{"type":"Script","props":{"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":52}]},{"type":"Label","props":{"y":5,"x":626,"wordWrap":true,"width":162,"var":"tech","valign":"middle","text":"10","height":60,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":53},{"type":"Label","props":{"y":0,"x":197,"wordWrap":true,"width":160,"var":"filename","valign":"middle","text":"展架专用布","overflow":"scroll","height":74,"fontSize":16,"font":"SimHei","color":"#262B2E","align":"center"},"compId":55},{"type":"Label","props":{"y":28,"x":930,"width":86,"var":"deliverydate","text":"2012-12-25","height":16,"fontSize":16,"font":"SimHei","color":"#152326","bold":false,"align":"center"},"compId":59}]},{"type":"VBox","props":{"y":91,"var":"detailbox","space":0,"right":5,"left":2},"compId":13,"child":[{"type":"Label","props":{"y":0,"x":0,"wordWrap":true,"width":1170,"var":"txtDetailInfo","valign":"top","text":"产品状态","height":71,"fontSize":18,"align":"left"},"compId":21}]}],"loadList":["commers/inputbg.png","comp/image.png","prefabs/LinksText.prefab"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}