package script.login
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.display.Input;
	import laya.display.Scene;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.events.Keyboard;
	import laya.ui.Button;
	import laya.utils.Browser;
	
	import model.HttpRequestUtil;
	import model.Userdata;
	
	import script.ViewManager;
	
	import ui.login.LogPanelUI;
	
	import utils.UtilTool;
	
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
			uiSKin.closebtn .on(Event.CLICK,this,onCloseScene);
			//uiSKin.bgimg.alpha = 0.95;
			
			uiSKin.mainpanel.hScrollBarSkin = "";
			uiSKin.mainpanel.width = Browser.width;
			uiSKin.mainpanel.height = Browser.height;
			uiSKin.mainpanel.vScrollBarSkin = "";

			
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
			
			uiSKin.input_account.on(Event.KEY_DOWN,this,onAccountKeyUp);

			uiSKin.input_pwd.on(Event.KEY_DOWN,this,onAccountKeyUp);
			
			uiSKin.input_account.focus = true;
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

		}
		
		private function onResizeBrower():void
		{
			
			
			uiSKin.mainpanel.height = Browser.height;
			uiSKin.mainpanel.width = Browser.width;
			
		}
		
		private function onAccountKeyUp(e:Event):void
		{
			if(e.keyCode == Keyboard.TAB)
			{
				if(uiSKin.input_account.focus)
					uiSKin.input_pwd.focus = true;
				else if(uiSKin.input_pwd.focus)
					uiSKin.input_account.focus = true;
			}
			if(e.keyCode == Keyboard.ENTER)
			{
				onLogin();
			}
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
				Userdata.instance.userAccount = uiSKin.input_account.text;
				Userdata.instance.accountType = result.usertype;
				Userdata.instance.privilege = result.priv;

				//ViewManager.showAlert("登陆成功");
				EventCenter.instance.event(EventCenter.LOGIN_SUCESS, uiSKin.input_account.text);
				UtilTool.setLocalVar("useraccount",uiSKin.input_account.text);
				UtilTool.setLocalVar("userpwd",uiSKin.input_pwd.text);
				
				Userdata.instance.loginTime = (new Date()).getTime();
				UtilTool.setLocalVar("loginTime",Userdata.instance.loginTime);
				
				ViewManager.instance.closeView(ViewManager.VIEW_lOGPANEL);
				ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE);
				
				console.log(Browser.document.cookie.split("; "));
			}
			
		}
		private function onRegister():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_REGPANEL,true);

		}
		
		private function onResetpwd():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_CHANGEPWD,false);

		}
		override public function onEnable():void
		{
		}
		
		
		private function onCloseScene():void
		{
			// TODO Auto Generated method stub
			//Scene.close("login/LogPanel.scene");
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

			ViewManager.instance.closeView(ViewManager.VIEW_lOGPANEL);
			ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE);
		}		
		
	}
}