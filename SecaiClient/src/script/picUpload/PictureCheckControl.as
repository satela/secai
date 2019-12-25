package script.picUpload
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Browser;
	
	import model.HttpRequestUtil;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	
	import ui.picManager.PicCheckPanelUI;
	
	public class PictureCheckControl extends Script
	{
		private var uiSkin:PicCheckPanelUI;
		
		public var param:Object;
		
		public function PictureCheckControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as PicCheckPanelUI;
			
			uiSkin.closeBtn.on(Event.CLICK,this,onClosePanel);
			uiSkin.mainpanel.on(Event.CLICK,this,onClosePanel);
			uiSkin.mainpanel.vScrollBarSkin = "";
			
			uiSkin.mainpanel.hScrollBarSkin = "";
			
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;
			
			uiSkin.yixingimg.visible = false;
			
			if(param is Array)
			{
				var picvo:PicInfoVo = param[0];
				var yixingimg:String =  param[1];
				var scalex:Number = param[2];
			}
			else
				picvo = param as PicInfoVo;

			if(param != null)
			{
				this.uiSkin.img.skin = HttpRequestUtil.biggerPicUrl + picvo.fid + ".jpg";
				
				if(picvo.picWidth > picvo.picHeight)
				{
					this.uiSkin.img.width = 750;
					
					this.uiSkin.img.height = 750/picvo.picWidth * picvo.picHeight;
					
				}
				else
				{
					this.uiSkin.img.height = 750;
					this.uiSkin.img.width = 750/picvo.picHeight * picvo.picWidth;
					
				}
				
				if(yixingimg != null)
				{
					uiSkin.yixingimg.visible = true;
					uiSkin.yixingimg.skin = yixingimg;
					uiSkin.yixingimg.width = this.uiSkin.img.width;
					uiSkin.yixingimg.height = this.uiSkin.img.height;
					uiSkin.yixingimg.scaleX = scalex;

				}
			}
			
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			
		}
		
		private function onResizeBrower():void
		{
			
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;
			
		}
		
		public override function onDestroy():void
		{
			Laya.loader.clearTextureRes(HttpRequestUtil.biggerPicUrl + (param as PicInfoVo).fid + ".jpg");
		}
		private function onClosePanel():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_PICTURE_CHECK);
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

		}
	}
}