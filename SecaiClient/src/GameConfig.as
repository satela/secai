/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package {
	import laya.utils.ClassUtils;
	import laya.ui.View;
	import laya.webgl.WebGL;
	import script.login.LogPanelControl;
	import laya.display.Text;
	import script.login.RegisterCntrol;
	import script.login.ResetPwdControl;
	import script.MainPageControl;
	import laya.html.dom.HTMLDivElement;
	import script.picUpload.PicManagerControl;
	import script.picUpload.PictureCheckControl;
	import script.picUpload.UpLoadAndOrderContrl;
	/**
	 * 游戏初始化配置
	 */
	public class GameConfig {
		public static var width:int = 640;
		public static var height:int = 1136;
		public static var scaleMode:String = "fixedwidth";
		public static var screenMode:String = "none";
		public static var alignV:String = "top";
		public static var alignH:String = "left";
		public static var startScene:* = "picManager/PicShortItem.scene";
		public static var sceneRoot:String = "";
		public static var debug:Boolean = false;
		public static var stat:Boolean = false;
		public static var physicsDebug:Boolean = false;
		public static var exportSceneToJson:Boolean = true;
		
		public static function init():void {
			//注册Script或者Runtime引用
			var reg:Function = ClassUtils.regClass;
			reg("script.login.LogPanelControl",LogPanelControl);
			reg("laya.display.Text",Text);
			reg("script.login.RegisterCntrol",RegisterCntrol);
			reg("script.login.ResetPwdControl",ResetPwdControl);
			reg("script.MainPageControl",MainPageControl);
			reg("laya.html.dom.HTMLDivElement",HTMLDivElement);
			reg("script.picUpload.PicManagerControl",PicManagerControl);
			reg("script.picUpload.PictureCheckControl",PictureCheckControl);
			reg("script.picUpload.UpLoadAndOrderContrl",UpLoadAndOrderContrl);
		}
		GameConfig.init();
	}
}