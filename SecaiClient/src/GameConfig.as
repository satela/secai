/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package {
	import laya.utils.ClassUtils;
	import laya.ui.View;
	import laya.webgl.WebGL;
	import utils.LoadingPrgControl;
	import script.login.LogPanelControl;
	import laya.display.Text;
	import script.login.RegisterCntrol;
	import script.login.ResetPwdControl;
	import script.MainPageControl;
	import utils.AddMsgControl;
	import script.prefabScript.LinkTextControl;
	import script.order.SelectAddressControl;
	import script.order.SelectFactoryControl;
	import script.order.SelectMaterialControl;
	import laya.html.dom.HTMLDivElement;
	import script.order.SelectPicControl;
	import script.order.SelectTechControl;
	import script.order.PaintOrderControl;
	import script.picUpload.PicManagerControl;
	import script.picUpload.PictureCheckControl;
	import utils.PopUpWindowControl;
	import script.picUpload.UpLoadAndOrderContrl;
	import script.usercenter.AddressMgrControl;
	import script.usercenter.EnterPrizeInfoControl;
	import script.usercenter.AddressEditControl;
	import script.usercenter.UserMainControl;
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
		public static var startScene:* = "PaintOrderPanel.scene";
		public static var sceneRoot:String = "";
		public static var debug:Boolean = false;
		public static var stat:Boolean = false;
		public static var physicsDebug:Boolean = false;
		public static var exportSceneToJson:Boolean = true;
		
		public static function init():void {
			//注册Script或者Runtime引用
			var reg:Function = ClassUtils.regClass;
			reg("utils.LoadingPrgControl",LoadingPrgControl);
			reg("script.login.LogPanelControl",LogPanelControl);
			reg("laya.display.Text",Text);
			reg("script.login.RegisterCntrol",RegisterCntrol);
			reg("script.login.ResetPwdControl",ResetPwdControl);
			reg("script.MainPageControl",MainPageControl);
			reg("utils.AddMsgControl",AddMsgControl);
			reg("script.prefabScript.LinkTextControl",LinkTextControl);
			reg("script.order.SelectAddressControl",SelectAddressControl);
			reg("script.order.SelectFactoryControl",SelectFactoryControl);
			reg("script.order.SelectMaterialControl",SelectMaterialControl);
			reg("laya.html.dom.HTMLDivElement",HTMLDivElement);
			reg("script.order.SelectPicControl",SelectPicControl);
			reg("script.order.SelectTechControl",SelectTechControl);
			reg("script.order.PaintOrderControl",PaintOrderControl);
			reg("script.picUpload.PicManagerControl",PicManagerControl);
			reg("script.picUpload.PictureCheckControl",PictureCheckControl);
			reg("utils.PopUpWindowControl",PopUpWindowControl);
			reg("script.picUpload.UpLoadAndOrderContrl",UpLoadAndOrderContrl);
			reg("script.usercenter.AddressMgrControl",AddressMgrControl);
			reg("script.usercenter.EnterPrizeInfoControl",EnterPrizeInfoControl);
			reg("script.usercenter.AddressEditControl",AddressEditControl);
			reg("script.usercenter.UserMainControl",UserMainControl);
		}
		GameConfig.init();
	}
}