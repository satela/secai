package script {
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.display.Scene;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.events.MouseManager;
	import laya.net.HttpRequest;
	import laya.ui.Button;
	import laya.ui.Label;
	import laya.ui.Panel;
	import laya.utils.Browser;
	import laya.utils.Log;
	
	import model.ChinaAreaModel;
	import model.HttpRequestUtil;
	import model.Userdata;
	
	import script.login.LogPanelControl;
	
	import ui.login.LogPanelUI;
	import ui.login.RegisterPanelUI;
	
	/**
	 * 本示例采用非脚本的方式实现，而使用继承页面基类，实现页面逻辑。在IDE里面设置场景的Runtime属性即可和场景进行关联
	 * 相比脚本方式，继承式页面类，可以直接使用页面定义的属性（通过IDE内var属性定义），比如this.tipLbll，this.scoreLbl，具有代码提示效果
	 * 建议：如果是页面级的逻辑，需要频繁访问页面内多个元素，使用继承式写法，如果是独立小模块，功能单一，建议用脚本方
	 */
	

	public class MainPageControl extends Script {
		
		private var hr:HttpRequest;

		private var txtLogin:Label;
		private var txtReg:Label;
		
		public function MainPageControl():void {
			//关闭多点触控，否则就无敌了
			MouseManager.multiTouchEnabled = false;
		}
		
		override public function onStart():void
		{
			 txtLogin = this.owner["txt_login"];
			txtLogin.on(Event.CLICK,this,onShowLogin);
			
			 txtReg = this.owner["txt_reg"];
			txtReg.on(Event.CLICK,this,onShowReg);
			
			var uploadbtn:Button = this.owner["btnUpload"];
			uploadbtn.on(Event.CLICK,this,onShowUpload);

			EventCenter.instance.on(EventCenter.LOGIN_SUCESS, this,onSucessLogin);

		}
		
		private function onShowUpload():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_PICMANAGER,true);
			//ViewManager.instance.openView(ViewManager.VIEW_USERCENTER,true);

			
		}
		private function onShowLogin(e:Event):void
		{
			if(!Userdata.instance.isLogin)
				ViewManager.instance.openView(ViewManager.VIEW_lOGPANEL);
			//this.owner.addChild(new LogPanelUI());
		}
		
		private function onShowReg(e:Event):void
		{
			if(!Userdata.instance.isLogin)
				ViewManager.instance.openView(ViewManager.VIEW_REGPANEL);
			else
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.loginOutUrl,this,onLoginOutBack,"","post");

			}


			//this.owner.addChild(new RegisterPanelUI());
		}
		
		private function onLoginOutBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				Userdata.instance.isLogin = false;
				txtLogin.text = "登录";
				txtReg.text = "注册";

			}
		}
		private function onSucessLogin(e:Object):void
		{
			txtLogin.text = e as String;
			txtReg.text = "退出";
		}
		override public function onEnable():void {
			
			MouseManager.multiTouchEnabled = false;

			var panel:Panel = this.owner["panel_main"];
			panel.vScrollBarSkin = "";

		}
		private function onHttpRequestError(e:*=null):void
		{
			trace(e);
		}
		
		private function onHttpRequestProgress(e:*=null):void
		{
			trace(e)
		}
		
		private function onHttpRequestComplete(data:Object):void
		{
			trace(data);
			//logger.text += "收到数据：" + hr.data;
		}
		
		private function onBrowerResize(e:Event):void
		{
			trace("wid:" + Browser.width);
			var scene:Scene = this.owner as Scene;
		}
		
		public function onTipClick(e:Event):void {
			
		}
		
		
	}
}