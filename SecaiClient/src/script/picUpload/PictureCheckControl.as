package script.picUpload
{
	import laya.components.Script;
	import laya.events.Event;
	
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
			uiSkin.mainpanel.vScrollBarSkin = "";
			if(param != null)
			{
				this.uiSkin.img.skin = HttpRequestUtil.biggerPicUrl + (param as PicInfoVo).fid + ".jpg";
				
				if(param.picWidth > param.picHeight)
				{
					this.uiSkin.img.width = 1000;
					
					this.uiSkin.img.height = 1000/param.picWidth * param.picHeight;
					
				}
				else
				{
					this.uiSkin.img.height = 1000;
					this.uiSkin.img.width = 1000/param.picHeight * param.picWidth;
					
				}
			}
			
		}
		
		public override function onDestroy():void
		{
			Laya.loader.clearTextureRes(HttpRequestUtil.biggerPicUrl + (param as PicInfoVo).fid + ".jpg");
		}
		private function onClosePanel():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_PICTURE_CHECK);
		}
	}
}