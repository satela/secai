/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;
	import script.MainPageControl;

	public class LoginViewUI extends Scene {
		public var panel_main:Panel;
		public var btnUpload:Text;
		public var paintOrderBtn:Text;
		public var btnproduct:Text;
		public var btnUserCenter:Text;
		public var btnact:Text;
		public var txt_login:Text;
		public var txt_reg:Text;
		public var characBtn:Text;
		public var enterinfo:Box;
		public var linktobus:Button;
		public var linkicp:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Scene","props":{"width":1920,"height":1080},"compId":2,"child":[{"type":"Image","props":{"top":0,"sizeGrid":"5,5,5,5","right":0,"left":0,"bottom":0},"compId":29,"child":[{"type":"Rect","props":{"width":1920,"lineWidth":1,"height":1080,"fillColor":"#f8f6f6"},"compId":60}]},{"type":"Panel","props":{"x":0,"width":1920,"var":"panel_main","top":0,"height":1080},"compId":3,"child":[{"type":"Sprite","props":{"y":0,"width":1920,"texture":"mainpage1/mainbg.jpg","height":1080},"compId":12},{"type":"Sprite","props":{"y":22,"x":320,"texture":"commers/logotxt.png","scaleY":1,"scaleX":1},"compId":11},{"type":"Label","props":{"y":370,"x":680,"width":560,"text":"广告全产业链生态平台","height":77,"fontSize":56,"font":"Microsoft YaHei","color":"#FFFFFF"},"compId":18},{"type":"Text","props":{"y":34,"x":541,"width":92,"var":"btnUpload","text":"我的图库","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":40,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":41}]},{"type":"Text","props":{"y":34,"x":654,"width":92,"var":"paintOrderBtn","text":"喷印下单","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":42,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":43}]},{"type":"Text","props":{"y":34,"x":879,"width":92,"var":"btnproduct","text":"商品下单","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":48,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":49}]},{"type":"Text","props":{"y":34,"x":991,"width":92,"text":"视觉资料","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":50,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":51}]},{"type":"Text","props":{"y":34,"x":1104,"width":92,"var":"btnUserCenter","text":"用户中心","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":52,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":53}]},{"type":"Text","props":{"y":34,"x":1238,"width":92,"var":"btnact","text":"充值活动","strokeColor":"#FFFAB1A0","stroke":3,"presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#FF2400","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":73,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":74},{"type":"Image","props":{"y":0,"x":-27,"skin":"chargeact/3f7c41316cc1f4f05f63532abc9e4fa.png"},"compId":75}]},{"type":"Text","props":{"y":34,"x":1365,"width":140,"var":"txt_login","text":"登陆","presetID":1,"overflow":"hidden","height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","align":"right","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":54,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":55}]},{"type":"Text","props":{"y":34,"x":1512,"width":73,"var":"txt_reg","text":"[注册]","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","align":"left","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":56,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":57}]},{"type":"Label","props":{"y":464,"x":525,"width":869,"text":"All-in Industrial Internet Platform of Advertising Industry","height":42,"fontSize":32,"font":"Microsoft YaHei","color":"#EDFFEC"},"compId":58},{"type":"Label","props":{"y":534,"x":443,"width":1033,"text":"开放 Open/智能 Intelligent/协同 Collaborative/共享 Shared","height":55,"fontSize":38,"font":"Helvetica","color":"#FCFA64","bold":true},"compId":59},{"type":"Text","props":{"y":34,"x":766,"width":92,"var":"characBtn","text":"字牌雕刻","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":70,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":71}]},{"type":"Label","props":{"y":150,"x":0,"width":1920,"visible":false,"text":"系统将于今晚11点（1月4号23:00)升级维护，预计维护1小时，请避开此时间段下单，敬请谅解！","fontSize":20,"font":"SimHei","color":"#ff0905","align":"center"},"compId":72}]},{"type":"Script","props":{"runtime":"script.MainPageControl"},"compId":27},{"type":"Box","props":{"y":940,"x":0,"var":"enterinfo","right":0,"left":0},"compId":65,"child":[{"type":"Image","props":{"skin":"commers/blackbg.png","sizeGrid":"2,2,2,2","right":0,"left":0,"height":80,"bottom":0,"alpha":0.5},"compId":62},{"type":"Label","props":{"y":5,"x":460,"wordWrap":true,"width":1000,"text":"Copyright  2019 CMYK.vip All Rights Reserved版权所有-色彩飞扬 ","leading":20,"height":25,"fontSize":20,"font":"Arial","color":"#f6f6ee","bold":false,"align":"center"},"compId":63},{"type":"Label","props":{"y":40,"x":623,"wordWrap":true,"width":1000,"text":" 本站法律顾问：夏瑜律师    色彩飞扬是网络服务平台，若您的权利被侵害，请联系 wwwcmykvip@163.com","leading":20,"height":33,"fontSize":20,"font":"Arial","color":"#f6f6ee","bold":false,"align":"center"},"compId":67},{"type":"Button","props":{"x":314,"var":"linktobus","stateNum":1,"skin":"commers/lz2.jpg","scaleY":0.8,"scaleX":0.8,"label":"label","bottom":9},"compId":66},{"type":"Text","props":{"y":40,"x":421,"var":"linkicp","text":"沪ICP备19015835号-2","presetID":1,"fontSize":20,"font":"Arial","color":"#f6eeee","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":68,"child":[{"type":"Script","props":{"undercolor":"#FFFFFF","presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":4}]}]}],"loadList":["mainpage1/mainbg.jpg","commers/logotxt.png","prefabs/LinksText.prefab","chargeact/3f7c41316cc1f4f05f63532abc9e4fa.png","commers/blackbg.png","commers/lz2.jpg"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}