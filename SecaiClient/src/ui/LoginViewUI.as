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
		public var txt_login:Text;
		public var txt_reg:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Scene","props":{"width":1920,"height":1080},"compId":2,"child":[{"type":"Image","props":{"top":0,"sizeGrid":"5,5,5,5","right":0,"left":0,"bottom":0},"compId":29,"child":[{"type":"Rect","props":{"width":1920,"lineWidth":1,"height":1080,"fillColor":"#f8f6f6"},"compId":60}]},{"type":"Panel","props":{"x":0,"width":1920,"var":"panel_main","top":0,"height":1800},"compId":3,"child":[{"type":"Sprite","props":{"y":0,"width":1920,"texture":"mainpage/mainbg.jpg","height":1080},"compId":12},{"type":"Sprite","props":{"y":22,"x":320,"texture":"commers/logotxt.png","scaleY":1,"scaleX":1},"compId":11},{"type":"Label","props":{"y":370,"x":680,"width":560,"text":"广告全产业链生态平台","height":77,"fontSize":56,"font":"Microsoft YaHei","color":"#FFFFFF"},"compId":18},{"type":"Text","props":{"y":34,"x":541,"width":92,"var":"btnUpload","text":"我的图库","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":40,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":41}]},{"type":"Text","props":{"y":34,"x":661,"width":92,"var":"paintOrderBtn","text":"喷印下单","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":42,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":43}]},{"type":"Text","props":{"y":34,"x":781,"width":92,"text":"字牌下单","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":44,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":45}]},{"type":"Text","props":{"y":34,"x":901,"width":92,"text":"印刷下单","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":46,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":47}]},{"type":"Text","props":{"y":34,"x":1020,"width":92,"var":"btnproduct","text":"商品下单","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":48,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":49}]},{"type":"Text","props":{"y":34,"x":1140,"width":92,"text":"视觉资料","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":50,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":51}]},{"type":"Text","props":{"y":34,"x":1260,"width":92,"var":"btnUserCenter","text":"用户中心","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":52,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":53}]},{"type":"Text","props":{"y":34,"x":1365,"width":140,"var":"txt_login","text":"登陆","presetID":1,"overflow":"hidden","height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","align":"right","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":54,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":55}]},{"type":"Text","props":{"y":34,"x":1512,"width":73,"var":"txt_reg","text":"[注册]","presetID":1,"height":26,"fontSize":20,"font":"Microsoft YaHei","color":"#EDFFEC","align":"left","isPresetRoot":true,"runtime":"laya.display.Text"},"compId":56,"child":[{"type":"Script","props":{"txttype":1,"presetID":2,"runtime":"script.prefabScript.LinkTextControl"},"compId":57}]},{"type":"Label","props":{"y":464,"x":525,"width":869,"text":"All-in Industrial Internet Platform of Advertising Industry","height":42,"fontSize":32,"font":"Microsoft YaHei","color":"#EDFFEC"},"compId":58},{"type":"Label","props":{"y":534,"x":443,"width":1033,"text":"开放 Open/智能 Intelligent/协同 Collaborative/共享 Shared","height":55,"fontSize":38,"font":"Helvetica","color":"#FCFA64","bold":true},"compId":59}]},{"type":"Script","props":{"runtime":"script.MainPageControl"},"compId":27}],"loadList":["mainpage/mainbg.jpg","commers/logotxt.png","prefabs/LinksText.prefab"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}