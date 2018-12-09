package script
{
	import laya.display.Sprite;
	import laya.ui.View;
	import laya.utils.Browser;
	
	import ui.PicManagePanelUI;
	import ui.login.LogPanelUI;
	import ui.login.RegisterPanelUI;
	import ui.login.ResetPwdPanelUI;
	import ui.uploadpic.UpLoadPanelUI;

	public class ViewManager
	{
		private static var _instance:ViewManager;
		
		private var viewContainer:Sprite;
		
		private var openViewList:Object;
		
		public static const VIEW_lOGPANEL:String = "loginview"; //登陆页面
		public static const VIEW_REGPANEL:String = "registerview";//注册界面;
		public static const VIEW_CHANGEPWD:String = "changepwdview";//注册界面;

		public static const VIEW_MYPICPANEL:String = "myPicUploadView";//图片资源管理界面

		public static const VIEW_PICMANAGER:String = "picmanagerView";//图片管理下单界面

		
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
			
			openViewList = {};
			
			viewDict = new Object();
			viewDict[VIEW_lOGPANEL] = LogPanelUI;
			viewDict[VIEW_REGPANEL] = RegisterPanelUI;
			viewDict[VIEW_CHANGEPWD] = ResetPwdPanelUI;
			viewDict[VIEW_MYPICPANEL] = UpLoadPanelUI;
			viewDict[VIEW_PICMANAGER] = PicManagePanelUI;

		}
		
		public static function showAlert(mesg:String):void
		{
			Browser.window.alert(mesg);

		}
		public function openView(viewClass:String,closeOther:Boolean=false):void
		{
			if(openViewList[viewClass] != null)
				return;
			if(viewDict[viewClass] == null)
				return;
			if(closeOther)
			{
				for each(var oldview in openViewList)
				{
					viewContainer.removeChild(oldview);
				}
				openViewList = {};
			}
			var view:View = new viewDict[viewClass]();
			viewContainer.addChild(view);
			openViewList[viewClass] = view;
		}
		
		public function closeView(viewClass:String):void
		{
			if(openViewList[viewClass] == null)
				showAlert("不存在的界面");
			viewContainer.removeChild(openViewList[viewClass]);
			openViewList[viewClass] = null;

		}
	}
}