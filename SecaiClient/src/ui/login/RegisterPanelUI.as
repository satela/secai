/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.login {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;
	import script.login.RegisterCntrol;

	public class RegisterPanelUI extends View {
		public var mainpanel:Panel;
		public var bgimg:Image;
		public var input_phone:TextInput;
		public var input_pwd:TextInput;
		public var input_conpwd:TextInput;
		public var inputCode:TextInput;
		public var txtRefresh:Text;
		public var input_phonecode:TextInput;
		public var btnGetCode:Button;
		public var btnClose:Button;
		public var btnReg:Button;
		public var nameInput:TextInput;
		public var contractpanel:Panel;
		public var txtpanel:Panel;
		public var sevicepro:Text;
		public var agreebox:CheckBox;
		public var okbtn:Button;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("login/RegisterPanel");

		}

	}
}