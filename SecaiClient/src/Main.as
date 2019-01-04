package {
	import eventUtil.EventCenter;
	
	import laya.display.Scene;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.AtlasInfoManager;
	import laya.net.Loader;
	import laya.net.ResourceVersion;
	import laya.net.URL;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.utils.Utils;
	
	import org.osmf.layout.ScaleMode;
	
	import script.ViewManager;
	
	import ui.LoginViewUI;
	import ui.login.LoadingPanelUI;
	
	public class Main {
		
		private var tt:Number;

		public function Main() {
			//根据IDE设置初始化引擎		
			
			if (window["Laya3D"]) window["Laya3D"].init(1920, 1080);
			else Laya.init(1920, 1080, Laya["WebGL"]);
			//Laya["Physics"] && Laya["Physics"].enable();
			//Laya["DebugPanel"] && Laya["DebugPanel"].enable();
			Laya.stage.scaleMode = Stage.SCALE_NOSCALE; // "noscale";//GameConfig.scaleMode;
			Laya.stage.screenMode = GameConfig.screenMode;
			Laya.stage.alignV = GameConfig.alignV;
			Laya.stage.alignH = GameConfig.alignH;
			//兼容微信不支持加载scene后缀场景
			URL.exportSceneToJson = GameConfig.exportSceneToJson;
			
			//tt = (new Date()).getTime();
			console.log("now time:" + tt);

			//打开调试面板（IDE设置调试模式，或者url地址增加debug=true参数，均可打开调试面板）
			if (GameConfig.debug || Utils.getQueryString("debug") == "true") Laya.enableDebugPanel();
			if (GameConfig.physicsDebug && Laya["PhysicsDebugDraw"]) Laya["PhysicsDebugDraw"].enable();
			if (GameConfig.stat) Stat.show();
			Laya.alertGlobalError = true;
			
			//激活资源版本控制，版本文件由发布功能生成
			ResourceVersion.enable("version.json", Handler.create(this, this.onVersionLoaded), ResourceVersion.FILENAME_VERSION);
		}
		
		private function onVersionLoaded():void {
			//激活大小图映射，加载小图的时候，如果发现小图在大图合集里面，则优先加载大图合集，而不是小图
			Laya.loader.load([{url:"res/atlas/comp.atlas",type:Loader.ATLAS}], Handler.create(this, onLoadedComp), null, Loader.ATLAS);

		}
		
		private function onLoadedComp():void
		{
			AtlasInfoManager.enable("fileconfig.json", Handler.create(null, onConfigLoaded));

		}
		private function onConfigLoaded():void {
			//加载场景
			

			Laya.stage.addChild(new LoginViewUI());
			ViewManager.instance.openView(ViewManager.VIEW_LOADING_PRO);
			//Laya.stage.on(Event.RESIZE,this,onResizeBrower);

			//ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE);
			//GameConfig.startScene && Scene.open("LoginView.scene",true,null,new Handler(this,onCompleteShowView),new Handler(this,onLoadingPrg));
			
			//console.log("times:" + ((new Date()).getTime()));
		}
		
		private function onResizeBrower():void
		{
			// TODO Auto Generated method stub
			EventCenter.instance.event(EventCenter.BROWER_WINDOW_RESIZE);
		}		
	
	}
}