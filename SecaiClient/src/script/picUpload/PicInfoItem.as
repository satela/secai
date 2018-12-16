package script.picUpload
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.picmanagerModel.DirectoryFileModel;
	import model.picmanagerModel.PicInfoVo;
	
	import org.osmf.net.StreamingURLResource;
	
	import script.ViewManager;
	
	import ui.picManager.PicShortItemUI;
	
	public class PicInfoItem extends PicShortItemUI
	{
		public var picInfo:PicInfoVo;
		public function PicInfoItem()
		{
			super();
		}
		
		public function setData(filedata:PicInfoVo):void
		{
			picInfo = filedata;
			this.offAll();
			this.on(Event.DOUBLE_CLICK,this,onDoubleClick);

			this.on(Event.CLICK,this,onClickHandler);
			this.on(Event.MOUSE_OVER,this,onMouseOverHandler);
			//this.on(Event.MOUSE_OUT,this,onMouseOutHandler);

			this.btndelete.visible = true;
			
			this.btndelete.on(Event.CLICK,this,onDeleteHandler);

			this.sel.visible = DirectoryFileModel.instance.haselectPic.indexOf(picInfo.fid) >= 0;
			if(picInfo.picType == 0)
			{
				this.img.skin = "commers/fold.png";
				this.fileinfo.text = picInfo.directName;
			}
			else
			{
				this.img.skin = HttpRequestUtil.smallerrPicUrl + picInfo.fid + ".jpg";
				this.fileinfo.text = picInfo.directName;

			}
		}
		
		private function onDeleteHandler(e:Event):void
		{
			// TODO Auto Generated method stub
			e.stopPropagation();
			if(this.sel.visible)
			{
				EventCenter.instance.event(EventCenter.SELECT_PIC_ORDER,picInfo.fid);
			}
			if(picInfo.picType == 1)
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.deletePic,this,onDeleteFileBack,"fid=" + picInfo.fid,"post");
			else
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.deleteDirectory,this,onDeleteFileBack,"path=" + picInfo.dpath,"post");

				
		}
		
		private function onDeleteFileBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				EventCenter.instance.event(EventCenter.UPDATE_FILE_LIST);

			}
		}
		private function onMouseOutHandler():void
		{
			// TODO Auto Generated method stub
			this.btndelete.visible = false;

		}
		
		private function onMouseOverHandler():void
		{
			// TODO Auto Generated method stub
			this.btndelete.visible = true;

		}
		
		private function onClickHandler():void
		{
			// TODO Auto Generated method stub
			if(this.picInfo.picType == 1)
			{
				this.sel.visible = !this.sel.visible;
				EventCenter.instance.event(EventCenter.SELECT_PIC_ORDER,picInfo.fid);

			}
		}
		
		private function onDoubleClick():void
		{
			if(this.picInfo.picType == 0)
			{
				EventCenter.instance.event(EventCenter.SELECT_FOLDER,picInfo);
			}
			else
			{
				ViewManager.instance.openView(ViewManager.VIEW_PICTURE_CHECK,false,this.picInfo);
			}
		}
		
	}
}