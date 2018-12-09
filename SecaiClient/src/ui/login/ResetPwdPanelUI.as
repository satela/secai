/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.login {
	import laya.ui.*;
	import laya.display.*;
	import script.login.ResetPwdControl;

	public class ResetPwdPanelUI extends View {
		public var input_phone:TextInput;
		public var input_conpwd:TextInput;
		public var input_phonecode:TextInput;
		public var btn_getcode:Button;
		public var btnClose:Button;
		public var btn_ok:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1920,"height":1080},"compId":2,"child":[{"type":"Image","props":{"top":0,"skin":"commers/whitebg.png","right":0,"left":0,"bottom":0},"compId":3},{"type":"Panel","props":{"x":0,"width":1920,"top":0,"bottom":100},"compId":4,"child":[{"type":"Label","props":{"y":12,"x":930,"text":"修改密码","fontSize":30,"font":"SimSun"},"compId":6},{"type":"Box","props":{"y":70,"x":660},"compId":7,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"手机号码","fontSize":20,"font":"Arial"},"compId":8},{"type":"TextInput","props":{"x":126,"width":250,"var":"input_phone","skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":9},{"type":"Label","props":{"y":10,"x":398,"text":"请输入11位手机号码","fontSize":20,"font":"Arial","color":"#5f5353"},"compId":10},{"type":"Label","props":{"y":8,"text":"*","fontSize":20,"color":"#ef0d09"},"compId":11}]},{"type":"Box","props":{"y":153,"x":660},"compId":12,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"新密码","fontSize":20,"font":"Arial","align":"right"},"compId":13},{"type":"TextInput","props":{"x":126,"width":250,"skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":14},{"type":"Label","props":{"y":10,"x":398,"text":"6-20位字母开头的字母、数字的组合","fontSize":20,"font":"Arial","color":"#5f5353"},"compId":15},{"type":"Label","props":{"y":8,"text":"*","fontSize":20,"color":"#ef0d09"},"compId":16}]},{"type":"Box","props":{"y":236,"x":660},"compId":17,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"确认密码","fontSize":20,"font":"Arial"},"compId":18},{"type":"TextInput","props":{"x":126,"width":250,"var":"input_conpwd","skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":19},{"type":"Label","props":{"y":10,"x":398,"text":"请输入11位手机号码","fontSize":20,"font":"Arial","color":"#5f5353"},"compId":20},{"type":"Label","props":{"y":8,"text":"*","fontSize":20,"color":"#ef0d09"},"compId":21}]},{"type":"Box","props":{"y":313,"x":660},"compId":46,"child":[{"type":"Label","props":{"y":10,"x":13,"text":"手机验证码","fontSize":20,"font":"Arial"},"compId":47},{"type":"TextInput","props":{"x":126,"width":250,"var":"input_phonecode","skin":"comp/textinput.png","height":40,"fontSize":20,"sizeGrid":"6,15,7,14"},"compId":48},{"type":"Label","props":{"y":8,"text":"*","fontSize":20,"color":"#ef0d09"},"compId":49},{"type":"Button","props":{"y":-1.5,"x":402,"width":150,"var":"btn_getcode","skin":"comp/button.png","label":"获取验证码","height":40},"compId":50}]},{"type":"Button","props":{"y":17,"x":1799,"width":100,"var":"btnClose","skin":"comp/button.png","label":"X","height":50},"compId":68},{"type":"Button","props":{"y":414,"x":826,"width":150,"var":"btn_ok","skin":"comp/button.png","labelSize":24,"label":"确认修改","height":40},"compId":71}]},{"type":"Script","props":{"runtime":"script.login.ResetPwdControl"},"compId":72}],"loadList":["commers/whitebg.png","comp/textinput.png","comp/button.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}