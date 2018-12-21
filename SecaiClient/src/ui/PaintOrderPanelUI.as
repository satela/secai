/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.order.PaintOrderControl;

	public class PaintOrderPanelUI extends View {
		public var firstpage:Text;
		public var panel_main:Panel;
		public var changemyadd:Text;
		public var myaddresstxt:Label;
		public var changefactory:Text;
		public var factorytxt:Label;
		public var btnaddpic:Button;
		public var mainvbox:VBox;
		public var ordervbox:VBox;
		public var btn_addattach:Button;
		public var partvbox:VBox;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1920,"height":1080,"fontSize":24},"compId":2,"child":[{"type":"Image","props":{"top":0,"skin":"commers/whitebg.png","right":0,"left":0,"bottom":0},"compId":3},{"type":"Sprite","props":{"y":65,"x":320},"compId":20,"child":[{"type":"Image","props":{"width":1280,"skin":"commers/blackbg.png","height":93,"alpha":0.2},"compId":11},{"type":"Label","props":{"y":17,"width":300,"text":"会员等级：黄金","mouseEnabled":true,"fontSize":24,"color":"#312b2b","align":"center"},"compId":12},{"type":"Label","props":{"y":17,"x":326,"width":300,"text":"会员等级：黄金","mouseEnabled":true,"fontSize":24,"color":"#312b2b","align":"center"},"compId":13},{"type":"Label","props":{"y":17,"x":652,"width":300,"text":"会员等级：黄金","mouseEnabled":true,"fontSize":24,"color":"#312b2b","align":"center"},"compId":14},{"type":"Label","props":{"y":17,"x":978,"width":300,"text":"会员等级：黄金","mouseEnabled":true,"fontSize":24,"color":"#312b2b","align":"center"},"compId":15},{"type":"Label","props":{"y":61,"width":300,"text":"会员等级：黄金","mouseEnabled":true,"fontSize":24,"color":"#312b2b","align":"center"},"compId":16},{"type":"Label","props":{"y":61,"x":326,"width":300,"text":"会员等级：黄金","mouseEnabled":true,"fontSize":24,"color":"#312b2b","align":"center"},"compId":17},{"type":"Label","props":{"y":61,"x":652,"width":300,"text":"会员等级：黄金","mouseEnabled":true,"fontSize":24,"color":"#312b2b","align":"center"},"compId":18},{"type":"Label","props":{"y":61,"x":978,"width":300,"text":"会员等级：黄金","mouseEnabled":true,"fontSize":24,"color":"#312b2b","align":"center"},"compId":19}]},{"type":"Image","props":{"y":0,"x":320,"width":1280,"skin":"commers/whitebg.png","height":60},"compId":5,"child":[{"type":"Label","props":{"x":30,"top":20,"text":"欢迎来到用户中心！","styleSkin":"comp/label.png","fontSize":20},"compId":6},{"type":"Label","props":{"y":18,"x":1070,"text":"我的订单","mouseEnabled":true,"fontSize":20},"compId":7},{"type":"Label","props":{"y":17,"text":"|","right":117,"fontSize":20},"compId":8},{"type":"Label","props":{"y":18,"x":1168.1953125,"text":"退出","mouseEnabled":true,"fontSize":20},"compId":9},{"type":"Text","props":{"y":19,"x":210,"var":"firstpage","text":"首页","mouseEnabled":true,"fontSize":20,"runtime":"laya.display.Text"},"compId":10}]},{"type":"Panel","props":{"var":"panel_main","top":160,"right":0,"left":0,"bottom":100},"compId":4,"child":[{"type":"Box","props":{"y":0,"x":320},"compId":24,"child":[{"type":"Label","props":{"text":"收货信息","fontSize":30},"compId":21},{"type":"Text","props":{"y":5,"x":132,"var":"changemyadd","text":"更改收货信息","fontSize":24,"color":"#3028ea","runtime":"laya.display.Text"},"compId":22},{"type":"Label","props":{"y":42,"width":1046,"var":"myaddresstxt","text":"收货信息","height":30,"fontSize":24},"compId":23}]},{"type":"Box","props":{"y":80,"x":320},"compId":26,"child":[{"type":"Label","props":{"text":"输出中心","fontSize":30},"compId":27},{"type":"Text","props":{"y":5,"x":132,"var":"changefactory","text":"更改输出中心","fontSize":24,"color":"#3028ea","runtime":"laya.display.Text"},"compId":28},{"type":"Label","props":{"y":42,"x":0,"width":425,"var":"factorytxt","text":"收货信息","height":30,"fontSize":24},"compId":29},{"type":"Button","props":{"y":47,"x":444,"width":62,"skin":"comp/button.png","label":"qq交谈","height":23},"compId":30}]},{"type":"Box","props":{"y":160,"x":320,"width":1280,"height":112},"compId":31,"child":[{"type":"Label","props":{"text":"批量修改","fontSize":30},"compId":32},{"type":"Image","props":{"y":36,"x":0,"width":1280,"skin":"commers/blackbg.png","height":74,"alpha":0.2},"compId":36},{"type":"Label","props":{"y":44,"x":162,"text":"商品名称","fontSize":24},"compId":37},{"type":"Label","props":{"y":44.5,"x":749,"text":"工艺","fontSize":24},"compId":38},{"type":"Label","props":{"y":44,"x":1180,"text":"数量","fontSize":24},"compId":39},{"type":"Label","props":{"y":83,"x":0,"width":415,"text":"请选择产品","height":20,"fontSize":20,"align":"center"},"compId":40},{"type":"Text","props":{"y":83,"x":456,"text":"更好材料","fontSize":20,"color":"#3028ea","runtime":"laya.display.Text"},"compId":41},{"type":"Label","props":{"y":74,"x":540,"text":"|","fontSize":30},"compId":42},{"type":"Label","props":{"y":83,"x":572,"width":424,"text":"请选择工艺","height":20,"fontSize":20,"align":"center"},"compId":43},{"type":"Text","props":{"y":83,"x":1006,"text":"更换工艺","fontSize":20,"color":"#3028ea","runtime":"laya.display.Text"},"compId":44},{"type":"TextInput","props":{"y":79,"x":1180,"width":85,"text":"1","skin":"comp/textinput.png","height":30,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":45}]},{"type":"Label","props":{"y":282,"x":320,"text":"产品清单","fontSize":30},"compId":46},{"type":"Button","props":{"y":280,"x":462,"width":100,"var":"btnaddpic","skin":"comp/button.png","labelSize":20,"label":"添加产品","height":30},"compId":47},{"type":"Label","props":{"y":286,"x":582,"width":714,"text":"绿色字体为自动识别选择，请仔细核对。注：文件名的信息越详细，识别越精准。","height":30,"fontSize":20,"color":"#325a2d"},"compId":48},{"type":"Box","props":{"y":334,"x":320},"compId":62,"child":[{"type":"Image","props":{"y":0,"x":0,"width":1280,"skin":"commers/blackbg.png","height":45,"alpha":0.2},"compId":49},{"type":"Label","props":{"y":10,"text":"序号","fontSize":24},"compId":50},{"type":"Label","props":{"y":10,"x":74,"text":"稿件","fontSize":24},"compId":51},{"type":"Label","props":{"y":10,"x":209,"text":"稿件名","fontSize":24},"compId":52},{"type":"Label","props":{"y":10,"x":436,"text":"材料","fontSize":24},"compId":53},{"type":"Label","props":{"y":10,"x":595,"text":"图片编辑","fontSize":24},"compId":54},{"type":"Label","props":{"y":10,"x":783,"text":"工艺","fontSize":24},"compId":55},{"type":"Label","props":{"y":10,"x":897,"text":"会员价","fontSize":24},"compId":56},{"type":"Label","props":{"y":10,"x":986,"text":"数量","fontSize":24},"compId":57},{"type":"Label","props":{"y":10,"x":1051,"text":"单价","fontSize":24},"compId":58},{"type":"Label","props":{"y":10,"x":1119,"text":"总价","fontSize":24},"compId":59},{"type":"Label","props":{"y":10,"x":1207,"text":"操作","fontSize":24},"compId":60}]},{"type":"VBox","props":{"y":383,"x":320,"width":1280,"var":"mainvbox","space":10},"compId":63,"child":[{"type":"VBox","props":{"var":"ordervbox","space":20,"right":0,"left":0},"compId":64},{"type":"VBox","props":{"y":100,"x":0,"space":10,"right":0,"left":0},"compId":65,"child":[{"type":"Box","props":{"y":50,"x":0},"compId":68,"child":[{"type":"Image","props":{"y":0,"x":0,"width":1280,"skin":"commers/blackbg.png","height":45,"alpha":0.2},"compId":69},{"type":"Label","props":{"y":10,"x":89,"text":"商品名称","fontSize":24},"compId":70},{"type":"Label","props":{"y":10,"x":344,"text":"物料规格","fontSize":24},"compId":72},{"type":"Label","props":{"y":10,"x":578,"text":"数量","fontSize":24},"compId":77},{"type":"Label","props":{"y":10,"x":773,"text":"单价","fontSize":24},"compId":78},{"type":"Label","props":{"y":10,"x":1017,"text":"总价","fontSize":24},"compId":79},{"type":"Label","props":{"y":10,"x":1207,"text":"操作","fontSize":24},"compId":80}]},{"type":"Box","props":{"y":0,"x":0},"compId":83,"child":[{"type":"Label","props":{"y":0,"x":0,"text":"配件清单","fontSize":30},"compId":66},{"type":"Button","props":{"y":0,"x":168,"width":100,"var":"btn_addattach","skin":"comp/button.png","labelSize":20,"label":"选择配件","height":30},"compId":67}]}]},{"type":"VBox","props":{"y":200,"x":0,"var":"partvbox","right":0,"left":0},"compId":82},{"type":"Box","props":{"y":319,"x":0},"compId":84,"child":[{"type":"Label","props":{"text":"配送方式","fontSize":30},"compId":85},{"type":"Text","props":{"y":5,"x":132,"text":"更改配送方式","fontSize":24,"color":"#3028ea","runtime":"laya.display.Text"},"compId":86},{"type":"Label","props":{"y":42,"x":0,"width":425,"text":"送货上门 手宋家：0元","height":30,"fontSize":24},"compId":87}]},{"type":"Box","props":{"y":400,"x":0},"compId":91,"child":[{"type":"Label","props":{"text":"添加批量备注","fontSize":30},"compId":89},{"type":"Label","props":{"y":4,"x":213,"width":857,"text":"注：备注以每个产品后面的“添加备注”优先，“添加备注”没有内容才会显示“添加批量备注”内容。","height":30,"fontSize":20,"color":"#fb1006"},"compId":90}]},{"type":"TextInput","props":{"y":441,"x":0,"width":1280,"valign":"top","text":"请添加备注","skin":"comp/textinput.png","height":93,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":92},{"type":"Label","props":{"y":543,"x":789,"width":490,"text":"结算前请务必要核对确认 材料 尺寸 工艺 数量 等信息！","height":30,"fontSize":20,"color":"#fb1006"},"compId":93},{"type":"Box","props":{"y":591,"x":959},"compId":96,"child":[{"type":"Button","props":{"width":120,"skin":"comp/button.png","labelSize":20,"label":"保存订单","height":40},"compId":94},{"type":"Button","props":{"x":159,"width":120,"skin":"comp/button.png","labelSize":20,"label":"去结算","height":40},"compId":95}]}]}]},{"type":"Script","props":{"runtime":"script.order.PaintOrderControl"},"compId":97}],"loadList":["commers/whitebg.png","commers/blackbg.png","comp/label.png","comp/button.png","comp/textinput.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}