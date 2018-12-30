/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.usercenter.EnterPrizeInfoControl;

	public class EnterPrizeInfoPaneUI extends View {
		public var btnSelProv:Button;
		public var province:Label;
		public var btnSelCity:Button;
		public var citytxt:Label;
		public var btnSelArea:Button;
		public var areatxt:Label;
		public var provbox:Image;
		public var provList:List;
		public var citybox:Image;
		public var cityList:List;
		public var areabox:Image;
		public var areaList:List;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":800,"height":1200},"compId":2,"child":[{"type":"Label","props":{"y":20,"x":35,"text":"账户资料","fontSize":20,"bold":true},"compId":3},{"type":"Label","props":{"y":53,"x":20,"width":150,"text":"企业账户：","fontSize":20,"bold":false,"align":"right"},"compId":4},{"type":"Label","props":{"y":53,"x":169,"text":"1325969696","fontSize":20,"bold":false},"compId":5},{"type":"Label","props":{"y":83,"x":20,"width":150,"text":"账户余额：","fontSize":20,"bold":false,"align":"right"},"compId":6},{"type":"Label","props":{"y":83,"x":169,"width":117,"text":"3258.6元","height":20,"fontSize":20,"color":"#e81d1a","bold":false},"compId":7},{"type":"Text","props":{"y":81,"x":297,"text":"充值","fontSize":20,"color":"#0d2897","runtime":"laya.display.Text"},"compId":8},{"type":"Label","props":{"y":114,"x":20,"width":150,"text":"我的服务店：","fontSize":20,"bold":false,"align":"right"},"compId":9},{"type":"Label","props":{"y":114,"x":169,"text":"1325969696","fontSize":20,"bold":false},"compId":10},{"type":"Rect","props":{"y":148,"x":25,"width":750,"lineWidth":1,"height":1,"fillColor":"#453e3e"},"compId":11},{"type":"Label","props":{"y":163,"x":35,"text":"企业信息","fontSize":20,"bold":true},"compId":12},{"type":"Box","props":{"y":195,"x":47},"compId":13,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"企业名称：","fontSize":20,"font":"Arial"},"compId":14},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":15},{"type":"Label","props":{"y":8,"text":"*","fontSize":20,"color":"#ef0d09"},"compId":17}]},{"type":"Label","props":{"y":258,"x":56.619140625,"text":"所在地：","fontSize":20,"font":"Arial"},"compId":18},{"type":"Label","props":{"y":252,"x":45,"text":"*","fontSize":20,"color":"#ef0d09"},"compId":19},{"type":"Button","props":{"y":248,"x":174,"width":170,"var":"btnSelProv","stateNum":1,"height":35},"compId":20,"child":[{"type":"Label","props":{"y":0,"x":0,"width":170,"var":"province","valign":"middle","text":"北京市","height":35,"fontSize":20,"color":"#201e1e","borderColor":"#3e3939","align":"center"},"compId":23},{"type":"Image","props":{"y":11,"x":136,"skin":"commers/combxbtn.png"},"compId":24}]},{"type":"Button","props":{"y":248,"x":368,"width":170,"var":"btnSelCity","stateNum":1,"height":35},"compId":29,"child":[{"type":"Label","props":{"y":0,"x":0,"width":170,"var":"citytxt","valign":"middle","text":"北京市","height":35,"fontSize":20,"color":"#201e1e","borderColor":"#3e3939","align":"center"},"compId":30},{"type":"Image","props":{"y":11,"x":136,"skin":"commers/combxbtn.png"},"compId":31}]},{"type":"Button","props":{"y":248,"x":561,"width":170,"var":"btnSelArea","stateNum":1,"height":35},"compId":32,"child":[{"type":"Label","props":{"y":0,"x":0,"width":170,"var":"areatxt","valign":"middle","text":"北京市","height":35,"fontSize":20,"color":"#201e1e","borderColor":"#3e3939","align":"center"},"compId":33},{"type":"Image","props":{"y":11,"x":136,"skin":"commers/combxbtn.png"},"compId":34}]},{"type":"Box","props":{"y":300,"x":47},"compId":41,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"详细地址：","fontSize":20,"font":"Arial"},"compId":42},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":43},{"type":"Label","props":{"y":8,"text":"*","fontSize":20,"color":"#ef0d09"},"compId":44}]},{"type":"Box","props":{"y":354,"x":47},"compId":45,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"公司电话：","fontSize":20,"font":"Arial"},"compId":46},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":47}]},{"type":"Box","props":{"y":407,"x":47},"compId":49,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"公司传真：","fontSize":20,"font":"Arial"},"compId":50},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":51}]},{"type":"Rect","props":{"y":463,"x":25,"width":750,"lineWidth":1,"height":1,"fillColor":"#453e3e"},"compId":53},{"type":"Label","props":{"y":474,"x":35,"text":"企业信息","fontSize":20,"bold":true},"compId":54},{"type":"Box","props":{"y":506,"x":47,"width":385},"compId":55,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"开票名称：","fontSize":20,"font":"Arial"},"compId":56},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":57}]},{"type":"Box","props":{"y":557,"x":47,"width":385},"compId":59,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"开票名称：","fontSize":20,"font":"Arial"},"compId":60},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":61}]},{"type":"Box","props":{"y":607,"x":47,"width":385},"compId":63,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"开票名称：","fontSize":20,"font":"Arial"},"compId":64},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":65}]},{"type":"Box","props":{"y":658,"x":47,"width":385},"compId":67,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"开票名称：","fontSize":20,"font":"Arial"},"compId":68},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":69}]},{"type":"Box","props":{"y":708,"x":47,"width":385},"compId":71,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"开票名称：","fontSize":20,"font":"Arial"},"compId":72},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":73}]},{"type":"Box","props":{"y":759,"x":47,"width":385},"compId":75,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"开票名称：","fontSize":20,"font":"Arial"},"compId":76},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":77}]},{"type":"Rect","props":{"y":810,"x":25,"width":750,"lineWidth":1,"height":1,"fillColor":"#453e3e"},"compId":79},{"type":"Label","props":{"y":826,"x":35,"text":"企业信息","fontSize":20,"bold":true},"compId":80},{"type":"Box","props":{"y":858,"x":47},"compId":81,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"联系人姓名：","fontSize":20,"font":"Arial"},"compId":82},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":83},{"type":"Label","props":{"y":8,"text":"*","fontSize":20,"color":"#ef0d09"},"compId":84}]},{"type":"Box","props":{"y":914,"x":47},"compId":85,"child":[{"type":"Label","props":{"y":10,"x":31,"text":"手机号码：","fontSize":20,"font":"Arial"},"compId":86},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":87},{"type":"Label","props":{"y":8,"x":18,"text":"*","fontSize":20,"color":"#ef0d09"},"compId":88}]},{"type":"Box","props":{"y":970,"x":47},"compId":89,"child":[{"type":"Label","props":{"y":10,"x":77,"text":"QQ：","fontSize":20,"font":"Arial"},"compId":90},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":91}]},{"type":"Box","props":{"y":1026,"x":47},"compId":93,"child":[{"type":"Label","props":{"y":10,"x":64,"text":"微信：","fontSize":20,"font":"Arial"},"compId":94},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":95}]},{"type":"Image","props":{"y":285,"x":173,"width":172,"var":"provbox","skin":"commers/blackbg.png","height":278,"alpha":0.8},"compId":35,"child":[{"type":"List","props":{"var":"provList","top":0,"right":0,"left":0,"bottom":0},"compId":38}]},{"type":"Image","props":{"y":285,"x":366,"width":172,"var":"citybox","skin":"commers/blackbg.png","height":278,"alpha":0.8},"compId":36,"child":[{"type":"List","props":{"var":"cityList","top":0,"right":0,"left":0,"bottom":0},"compId":39}]},{"type":"Image","props":{"y":285,"x":560,"width":172,"var":"areabox","skin":"commers/blackbg.png","height":278,"alpha":0.8},"compId":37,"child":[{"type":"List","props":{"var":"areaList","top":0,"right":0,"left":0,"bottom":0},"compId":40}]},{"type":"Button","props":{"y":1094,"x":350,"width":100,"skin":"comp/button.png","labelAlign":"center","label":"保存修改","height":30},"compId":97},{"type":"Script","props":{"runtime":"script.usercenter.EnterPrizeInfoControl"},"compId":98}],"loadList":["comp/textinput.png","commers/combxbtn.png","commers/blackbg.png","comp/button.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}