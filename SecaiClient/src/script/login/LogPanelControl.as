package script.login
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.display.Input;
	import laya.display.Scene;
	import laya.events.Event;
	import laya.ui.Button;
	
	import model.HttpRequestUtil;
	import model.Userdata;
	
	import script.ViewManager;
	
	import ui.login.LogPanelUI;
	
	public class LogPanelControl extends Script
	{
		private var uiSKin:LogPanelUI;
		public var param:Object;

		public function LogPanelControl()
		{
			//super();
		}
		
		override public function onStart():void
		{
			uiSKin = this.owner as LogPanelUI;
			this.owner["closebtn"].on(Event.CLICK,this,onCloseScene);
			this.owner["bgimg"].alpha = 0.5;
			
			uiSKin.input_account.maxChars = 11;
			uiSKin.input_account.restrict = "0-9";
			
			uiSKin.input_pwd.maxChars = 20;
			uiSKin.input_pwd.type = Input.TYPE_PASSWORD;
			
			
			uiSKin.txt_reg.underline = true;
			uiSKin.txt_reg.underlineColor =  "#121212";
			
			uiSKin.txt_forget.underline = true;
			uiSKin.txt_forget.underlineColor =  "#121212";
			
			uiSKin.txt_reg.on(Event.CLICK,this,onRegister);
			uiSKin.txt_forget.on(Event.CLICK,this,onResetpwd);

			uiSKin.btn_login.on(Event.CLICK,this,onLogin);


		}
		
		private function onLogin():void
		{
			// TODO Auto Generated method stub
			if(uiSKin.input_account.text.length != 11)
			{
				ViewManager.showAlert("请填写正确的账号");
				return;
			}
			if(uiSKin.input_pwd.text.length < 6)
			{
				ViewManager.showAlert("密码位数至少是6位");
				return;
			}
			
			var param:String = "phone=" + uiSKin.input_account.text + "&pwd=" + uiSKin.input_pwd.text + "&mode=0";
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.loginInUrl,this,onLoginBack,param,"post");
		}
		
		private function onLoginBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				Userdata.instance.isLogin = true;
				ViewManager.showAlert("登陆成功");
				EventCenter.instance.event(EventCenter.LOGIN_SUCESS, uiSKin.input_account.text);
				
				ViewManager.instance.closeView(ViewManager.VIEW_lOGPANEL);
			}
			
		}
		private function onRegister():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_REGPANEL,true);

		}
		
		private function onResetpwd():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_CHANGEPWD,true);

		}
		override public function onEnable():void
		{
		}
		
		
		private function onCloseScene():void
		{
			// TODO Auto Generated method stub
			//Scene.close("login/LogPanel.scene");
			
			ViewManager.instance.closeView(ViewManager.VIEW_lOGPANEL);
		}		
		
	}
}