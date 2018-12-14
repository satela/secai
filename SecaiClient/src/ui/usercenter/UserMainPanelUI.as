/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;

	public class UserMainPanelUI extends View {

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1920,"height":1080},"compId":2,"child":[{"type":"Image","props":{"top":0,"skin":"commers/whitebg.png","right":0,"left":0,"bottom":0},"compId":3},{"type":"Panel","props":{"top":0,"right":0,"left":0,"bottom":100},"compId":4,"child":[{"type":"Rect","props":{"y":100,"x":320,"width":235,"lineWidth":1,"lineColor":"#252323","height":666,"fillColor":"#f8f3f3"},"compId":12},{"type":"Label","props":{"y":113,"x":389,"text":"用户中心","fontSize":24,"color":"#f8f0ef"},"compId":14},{"type":"Rect","props":{"y":100,"x":320,"width":235,"lineWidth":1,"height":48,"fillColor":"#c50505"},"compId":13},{"type":"VBox","props":{"y":148,"x":321,"space":2},"compId":5,"child":[{"type":"Box","props":{"y":50,"x":2,"width":232,"height":127},"compId":20,"child":[{"type":"Label","props":{"y":12,"x":68.5,"text":"企业设置","fontSize":24,"color":"#272524","bold":true},"compId":17,"child":[{"type":"Rect","props":{"y":-12,"x":-69,"width":231,"lineWidth":1,"height":48,"fillColor":"#a19595"},"compId":16}]},{"type":"VBox","props":{"y":53,"x":0,"width":230,"space":20},"compId":26,"child":[{"type":"Label","props":{"text":"企业资料","right":10,"left":10,"fontSize":24,"color":"#272524","align":"center"},"compId":18},{"type":"Label","props":{"y":43,"text":"收货地址","right":10,"left":10,"fontSize":24,"color":"#272524","align":"center"},"compId":19}]}]},{"type":"Box","props":{"y":182,"x":2,"width":232,"height":171},"compId":21,"child":[{"type":"Label","props":{"y":12,"x":68.5,"text":"订单管理","fontSize":24,"color":"#272524","bold":true},"compId":22,"child":[{"type":"Rect","props":{"y":-12,"x":-69,"width":231,"lineWidth":1,"height":48,"fillColor":"#a19595"},"compId":23}]},{"type":"VBox","props":{"y":53,"x":0,"width":230,"space":20},"compId":27,"child":[{"type":"Label","props":{"y":0,"text":"购物车","right":10,"left":10,"height":24,"fontSize":24,"color":"#272524","align":"center"},"compId":24},{"type":"Label","props":{"y":44,"text":"我的订单","right":10,"left":10,"fontSize":24,"color":"#272524","align":"center"},"compId":25},{"type":"Label","props":{"y":88,"text":"委托订单","right":10,"left":10,"fontSize":24,"color":"#272524","align":"center"},"compId":28}]}]},{"type":"Box","props":{"y":353,"x":2,"width":232,"height":127},"compId":29,"child":[{"type":"Label","props":{"y":12,"x":68.5,"text":"财务管理","fontSize":24,"color":"#272524","bold":true},"compId":30,"child":[{"type":"Rect","props":{"y":-12,"x":-69,"width":231,"lineWidth":1,"height":48,"fillColor":"#a19595"},"compId":31}]},{"type":"VBox","props":{"y":53,"x":0,"width":230,"space":20},"compId":32,"child":[{"type":"Label","props":{"y":0,"text":"账户充值","right":10,"left":10,"height":24,"fontSize":24,"color":"#272524","align":"center"},"compId":33},{"type":"Label","props":{"y":44,"text":"我的账单","right":10,"left":10,"fontSize":24,"color":"#272524","align":"center"},"compId":34}]}]},{"type":"Box","props":{"y":508,"x":2,"width":232,"height":117},"compId":36,"child":[{"type":"Label","props":{"y":12,"x":68.5,"text":"个人管理","fontSize":24,"color":"#272524","bold":true},"compId":37,"child":[{"type":"Rect","props":{"y":-12,"x":-69,"width":231,"lineWidth":1,"height":48,"fillColor":"#a19595"},"compId":38}]},{"type":"VBox","props":{"y":53,"x":0,"width":230,"space":20},"compId":39,"child":[{"type":"Label","props":{"y":0,"text":"修改密码","right":10,"left":10,"height":24,"fontSize":24,"color":"#272524","align":"center"},"compId":40},{"type":"Label","props":{"y":33,"text":"我的图库","right":10,"left":10,"fontSize":24,"color":"#272524","align":"center"},"compId":41}]}]}]},{"type":"Image","props":{"y":1,"x":320,"width":1280,"skin":"commers/whitebg.png","height":60},"compId":6,"child":[{"type":"Label","props":{"x":30,"top":20,"text":"欢迎来到用户中心！","styleSkin":"comp/label.png","fontSize":20},"compId":7},{"type":"Label","props":{"y":18,"x":1070,"text":"我的订单","mouseEnabled":true,"fontSize":20},"compId":8},{"type":"Label","props":{"y":17,"text":"|","right":117,"fontSize":20},"compId":9},{"type":"Label","props":{"y":18,"x":1168.1953125,"text":"退出","mouseEnabled":true,"fontSize":20},"compId":10},{"type":"Text","props":{"y":19,"x":210,"text":"首页","mouseEnabled":true,"fontSize":20,"runtime":"laya.display.Text"},"compId":11}]},{"type":"Rect","props":{"y":140,"x":600,"width":800,"lineWidth":1,"lineColor":"#322f2f","height":1,"fillColor":"#453a3a"},"compId":48},{"type":"Label","props":{"y":108,"x":603,"text":"企业资料","fontSize":24,"color":"#c3221f"},"compId":49}]}],"loadList":["commers/whitebg.png","comp/label.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}