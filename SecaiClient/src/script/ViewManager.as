package script
{
	import laya.components.Script;
	import laya.display.Sprite;
	import laya.ui.View;
	import laya.utils.Browser;
	
	import ui.LoginViewUI;
	import ui.PaintOrderPanelUI;
	import ui.PicManagePanelUI;
	import ui.PopUpDialogUI;
	import ui.login.LoadingPanelUI;
	import ui.login.LogPanelUI;
	import ui.login.RegisterPanelUI;
	import ui.login.ResetPwdPanelUI;
	import ui.order.AddCommentPanelUI;
	import ui.order.SelectAddressPanelUI;
	import ui.order.SelectAttchPanelUI;
	import ui.order.SelectDeliveryPanelUI;
	import ui.order.SelectFactoryPanelUI;
	import ui.order.SelectMaterialPanelUI;
	import ui.order.SelectPicPanelUI;
	import ui.picManager.PicCheckPanelUI;
	import ui.product.BuyProductPanelUI;
	import ui.product.ProductOrderPanelUI;
	import ui.uploadpic.UpLoadPanelUI;
	import ui.usercenter.NewAddressPanelUI;
	import ui.usercenter.UserMainPanelUI;

	public class ViewManager
	{
		private static var _instance:ViewManager;
		
		private var viewContainer:Sprite;
		
		private var openViewList:Object;
		
		public static const VIEW_FIRST_PAGE:String = "VIEW_FIRST_PAGE"; //首页页面

		public static const VIEW_lOGPANEL:String = "VIEW_lOGPANEL"; //登陆页面
		public static const VIEW_REGPANEL:String = "VIEW_REGPANEL";//注册界面;
		public static const VIEW_CHANGEPWD:String = "VIEW_CHANGEPWD";//注册界面;

		public static const VIEW_MYPICPANEL:String = "VIEW_MYPICPANEL";//图片资源管理界面

		public static const VIEW_PICMANAGER:String = "VIEW_PICMANAGER";//图片管理下单界面

		public static const VIEW_PICTURE_CHECK:String = "VIEW_PICTURE_CHECK";//图片预览

		public static const VIEW_PAINT_ORDER:String = "VIEW_PAINT_ORDER";//喷印下单

		public static const VIEW_USERCENTER:String = "VIEW_USERCENTER";//用户中心

		public static const VIEW_SELECT_ADDRESS:String = "VIEW_SELECT_ADDRESS";//选择收货地址
		
		public static const VIEW_SELECT_FACTORY:String = "VIEW_SELECT_FACTORY";//选择输出中心
		public static const VIEW_SELECT_PIC_TO_ORDER:String = "VIEW_SELECT_PIC_TO_ORDER";//添加喷印图片界面

		public static const VIEW_SELECT_MATERIAL:String = "VIEW_SELECT_MATERIAL";//选择材料界面
		public static const VIEW_ADD_MESSAGE:String = "VIEW_ADD_MESSAGE";//添加备注
		public static const VIEW_SELECT_DELIVERY_TYPE:String = "VIEW_SELECT_DELIVERY_TYPE";//选择配送方式 快递
		public static const VIEW_SELECT_ATTACH:String = "VIEW_SELECT_ATTACH";//选择配件界面

		
		public static const VIEW_PRODUCT_VIEW:String = "VIEW_PRODUCT_VIEW";//商品界面
		public static const VIEW_BUY_PRODUCT_VIEW:String = "VIEW_BUY_PRODUCT_VIEW";//购买商品界面

		
		public static const VIEW_LOADING_PRO:String = "VIEW_LOADING_PRO";//加载界面

		public static const VIEW_ADD_NEW_ADDRESS:String = "VIEW_ADD_NEW_ADDRESS";//添加收货地址

		public static const VIEW_POPUPDIALOG:String = "VIEW_POPUPDIALOG";//确认框

		public var viewDict:Object;
		public static function get instance():ViewManager
		{
			if(_instance == null)
				_instance = new ViewManager();
			return _instance;
		}
		
		public function ViewManager()
		{
			viewContainer = new Sprite();
			
			Laya.stage.addChild(viewContainer);
			
			var screenHeight:int = window.screen.height;
			var screenWidth:int = window.screen.width;
			
			//if(screenHeight < 1080)
			//	viewContainer.scaleY = screenHeight/1080;
			
			if(screenWidth < 1920)
			{
				viewContainer.scaleX = screenWidth/1920;
				viewContainer.x = (1920 - screenWidth)/2;
			}

			
			openViewList = {};
			
			viewDict = new Object();
			
			viewDict[VIEW_FIRST_PAGE] = LoginViewUI;

			viewDict[VIEW_lOGPANEL] = LogPanelUI;
			viewDict[VIEW_REGPANEL] = RegisterPanelUI;
			viewDict[VIEW_CHANGEPWD] = ResetPwdPanelUI;
			viewDict[VIEW_MYPICPANEL] = UpLoadPanelUI;
			viewDict[VIEW_PICMANAGER] = PicManagePanelUI;
			viewDict[VIEW_USERCENTER] = UserMainPanelUI;
			viewDict[VIEW_PICTURE_CHECK] = PicCheckPanelUI;
			viewDict[VIEW_POPUPDIALOG] = PopUpDialogUI;
			viewDict[VIEW_PAINT_ORDER] = PaintOrderPanelUI;

			viewDict[VIEW_SELECT_ADDRESS] = SelectAddressPanelUI;
			viewDict[VIEW_SELECT_FACTORY] = SelectFactoryPanelUI;
			viewDict[VIEW_SELECT_PIC_TO_ORDER] = SelectPicPanelUI;
			viewDict[VIEW_SELECT_MATERIAL] = SelectMaterialPanelUI;
			viewDict[VIEW_SELECT_DELIVERY_TYPE] = SelectDeliveryPanelUI;
			viewDict[VIEW_SELECT_ATTACH] = SelectAttchPanelUI;

			viewDict[VIEW_ADD_MESSAGE] = AddCommentPanelUI;
			viewDict[VIEW_ADD_NEW_ADDRESS] = NewAddressPanelUI;
			viewDict[VIEW_LOADING_PRO] = LoadingPanelUI;
			
			viewDict[VIEW_PRODUCT_VIEW] = ProductOrderPanelUI;
			viewDict[VIEW_BUY_PRODUCT_VIEW] = BuyProductPanelUI;


		}
		
		public static function showAlert(mesg:String):void
		{
			Browser.window.alert(mesg);

		}
		public function openView(viewClass:String,closeOther:Boolean=false,params:Object = null):void
		{
			
			
			if(closeOther)
			{
				for each(var oldview in openViewList)
				{
					viewContainer.removeChild(oldview);
					(oldview as View).destroy(true);
					
				}
				openViewList = {};
			}
			
			if(viewDict[viewClass] == null)
				return;
			
			if(openViewList[viewClass] != null)
				return;
			var view:View = new viewDict[viewClass]();
			view.param = params;
//			var control:Script = view.getComponent(Script);
//			if(control != null)
//			control["param"] = params;
			viewContainer.addChild(view);
			openViewList[viewClass] = view;
		}
		
		public function closeView(viewClass:String):void
		{
			if(openViewList[viewClass] == null)
				showAlert("不存在的界面");
			viewContainer.removeChild(openViewList[viewClass]);
			(openViewList[viewClass] as View).destroy(true);
			openViewList[viewClass] = null;
			delete openViewList[viewClass];

		}
	}
}