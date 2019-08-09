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
		private var trytime:int = 0;
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
			this.on(Event.MOUSE_OUT,this,onMouseOutHandler);

			this.btndelete.visible = false;
			
			this.btndelete.on(Event.CLICK,this,onDeleteHandler);
			trytime = 0;
			this.sel.visible = DirectoryFileModel.instance.haselectPic.hasOwnProperty(picInfo.fid);
			this.sel.selected = this.sel.visible;

			if(picInfo.picType == 0 ||(picInfo.picClass.toLocaleUpperCase() != "JPEG" && picInfo.picClass.toLocaleUpperCase() != "JPG" && picInfo.picClass.toLocaleUpperCase() != "TIF" && picInfo.picClass.toLocaleUpperCase() != "PNG"))
			{
				this.img.skin = "upload/fold.png";
				this.filename.text = picInfo.directName;
				this.fileinfo.visible = false;
				this.picClassTxt.visible = false;
				this.colorspacetxt.visible = false;

				this.img.width = 108;
				this.img.height = 101;
			}
			else
			{
				this.fileinfo.visible = true;
				this.filename.text =  picInfo.directName;
				
				if( picInfo.isProcessing)
				{
					this.fileinfo.text = "处理中...";
					this.img.skin = "upload/fold.png";
					this.picClassTxt.visible = false;
					this.colorspacetxt.visible = false;
					
					this.img.width = 108;
					this.img.height = 101;
					return;
				}
				if(picInfo.picWidth > picInfo.picHeight)
				{
					this.img.width = 128;					
					this.img.height = 128/picInfo.picWidth * picInfo.picHeight;
					
				}
				else
				{
					this.img.height = 128;
					this.img.width = 128/picInfo.picHeight * picInfo.picWidth;

				}
				
				if(this.img.skin != "upload/fold.png")
					Laya.loader.clearTextureRes(this.img.skin);

				this.img.skin = null;				
				this.img.skin = HttpRequestUtil.smallerrPicUrl + picInfo.fid + ".jpg";
			
				
				var str:String = "宽:" + picInfo.picPhysicWidth + ";高:" +  picInfo.picPhysicHeight + "\n";
				
				str += "dpi:" + picInfo.dpi;
				this.fileinfo.text = str;
				
				
				this.picClassTxt.text = picInfo.picClass.toLocaleUpperCase();
				this.picClassTxt.visible = true;
				//if(this.picInfo.colorspace)
				this.colorspacetxt.text = picInfo.colorspace.toLocaleUpperCase();
				this.colorspacetxt.visible = true;
				
				//this.fileinfo.text = picInfo.directName;

			}
		}
		
		private function onDeleteHandler(e:Event):void
		{
			// TODO Auto Generated method stub
			e.stopPropagation();
			if(picInfo.picType == 1)
				ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"确定删除该图片吗？",caller:this,callback:confirmDelete});
			else
				ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"确定删除该目录吗？",caller:this,callback:confirmDelete});

		
		}
		
		private function confirmDelete(result:Boolean):void
		{
			if(result)
			{
				if(this.sel.visible)
				{
					EventCenter.instance.event(EventCenter.SELECT_PIC_ORDER,picInfo);
				}
				if(picInfo.picType == 1)
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.deletePic,this,onDeleteFileBack,"fid=" + picInfo.fid,"post");
				else
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.deleteDirectory,this,onDeleteFileBack,"path=" + picInfo.dpath,"post");
			}
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
				this.sel.selected = this.sel.visible;
				EventCenter.instance.event(EventCenter.SELECT_PIC_ORDER,picInfo);

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