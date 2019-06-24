/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package {
	import laya.utils.ClassUtils;
	import laya.ui.View;
	import laya.webgl.WebGL;
	import utils.LoadingPrgControl;
	import script.login.LogPanelControl;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;
	import script.login.RegisterCntrol;
	import script.login.ResetPwdControl;
	import script.MainPageControl;
	import utils.AddMsgControl;
	import script.order.PayTypeSelectControl;
	import script.order.SelectAddressControl;
	import script.order.SelectAttchesControl;
	import script.order.SelectDeliveryControl;
	import script.order.SelectFactoryControl;
	import script.order.SelectMaterialControl;
	import script.order.SelectPicControl;
	import laya.html.dom.HTMLDivElement;
	import script.prefabScript.TopBannerControl;
	import script.order.PaintOrderControl;
	import script.picUpload.PicManagerControl;
	import script.picUpload.PictureCheckControl;
	import utils.PopUpWindowControl;
	import script.product.BuyProductControl;
	import script.product.ProductMainControl;
	import script.picUpload.UpLoadAndOrderContrl;
	import script.usercenter.AddressMgrControl;
	import script.usercenter.ChargeControl;
	import script.usercenter.EnterPrizeInfoControl;
	import script.usercenter.MyOrderControl;
	import script.usercenter.AddressEditControl;
	import script.usercenter.OrderDetailControl;
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
		public static var startScene:* = "usercenter/OrderDetailPanel.scene";
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
			reg("script.prefabScript.LinkTextControl",LinkTextControl);
			reg("script.login.RegisterCntrol",RegisterCntrol);
			reg("script.login.ResetPwdControl",ResetPwdControl);
			reg("script.MainPageControl",MainPageControl);
			reg("utils.AddMsgControl",AddMsgControl);
			reg("script.order.PayTypeSelectControl",PayTypeSelectControl);
			reg("script.order.SelectAddressControl",SelectAddressControl);
			reg("script.order.SelectAttchesControl",SelectAttchesControl);
			reg("script.order.SelectDeliveryControl",SelectDeliveryControl);
			reg("script.order.SelectFactoryControl",SelectFactoryControl);
			reg("script.order.SelectMaterialControl",SelectMaterialControl);
			reg("script.order.SelectPicControl",SelectPicControl);
			reg("laya.html.dom.HTMLDivElement",HTMLDivElement);
			reg("script.prefabScript.TopBannerControl",TopBannerControl);
			reg("script.order.PaintOrderControl",PaintOrderControl);
			reg("script.picUpload.PicManagerControl",PicManagerControl);
			reg("script.picUpload.PictureCheckControl",PictureCheckControl);
			reg("utils.PopUpWindowControl",PopUpWindowControl);
			reg("script.product.BuyProductControl",BuyProductControl);
			reg("script.product.ProductMainControl",ProductMainControl);
			reg("script.picUpload.UpLoadAndOrderContrl",UpLoadAndOrderContrl);
			reg("script.usercenter.AddressMgrControl",AddressMgrControl);
			reg("script.usercenter.ChargeControl",ChargeControl);
			reg("script.usercenter.EnterPrizeInfoControl",EnterPrizeInfoControl);
			reg("script.usercenter.MyOrderControl",MyOrderControl);
			reg("script.usercenter.AddressEditControl",AddressEditControl);
			reg("script.usercenter.OrderDetailControl",OrderDetailControl);
			reg("script.usercenter.UserMainControl",UserMainControl);
		}
		GameConfig.init();
	}
}