package script.picUpload
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.picmanagerModel.DirectoryFileModel;
	import model.picmanagerModel.PicInfoVo;
	
	import org.osmf.net.StreamingURLResource;
	
	import script.ViewManager;
	
	import ui.picManager.PicPaintItemUI;
	
	import utils.UtilTool;
	
	public class PicPaintItem extends PicPaintItemUI
	{
		public var picInfo:PicInfoVo;
		private var trytime:int = 0;
		public function PicPaintItem()
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
			this.sel.visible = DirectoryFileModel.instance.haselectPic.hasOwnProperty(picInfo.fid) || DirectoryFileModel.instance.curOperateFile == picInfo;
			this.sel.selected = this.sel.visible;
			this.yixingimg.visible = false;
			this.backimg.visible = false;

			if(picInfo.picType == 0 || !UtilTool.checkFileIsImg(picInfo))
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
					this.img.width = 124;					
					this.img.height = 124/picInfo.picWidth * picInfo.picHeight;
					
					this.yixingimg.width = 50;
					
					this.yixingimg.height = 50/picInfo.picWidth * picInfo.picHeight;
					
					this.backimg.width = 50;
					this.backimg.height = this.yixingimg.height;
					
				}
				else
				{
					this.img.height = 124;
					this.img.width = 124/picInfo.picHeight * picInfo.picWidth;
					
					this.yixingimg.height = 50;
					
					this.yixingimg.width = 50/picInfo.picHeight * picInfo.picWidth;
					
					this.backimg.height = 50;
					this.backimg.width = this.yixingimg.width;
					
					
				}
				
				if(this.img.skin != "upload/fold.png")
					Laya.loader.clearTextureRes(this.img.skin);
				
				this.img.skin = null;				
				this.img.skin = HttpRequestUtil.smallerrPicUrl + picInfo.fid + ".jpg";
				
				
				var str:String = "宽:" + picInfo.picPhysicWidth + ";高:" +  picInfo.picPhysicHeight + "\n";
				
				str += "dpi:" + picInfo.dpi;
				this.fileinfo.text = str;
				
				if(picInfo.isCdr)
					this.picClassTxt.text = "CDR";
				else
					this.picClassTxt.text = picInfo.picClass.toLocaleUpperCase();
				
				if(picInfo.yixingFid != "" && picInfo.yixingFid != "0")
				{
					this.yixingimg.visible = true;
					this.yixingimg.skin = HttpRequestUtil.smallerrPicUrl + picInfo.yixingFid + ".jpg";
					
				}
				if(picInfo.backFid != "" && picInfo.backFid != "0")
				{
					this.backimg.visible = true;
					this.backimg.skin = HttpRequestUtil.smallerrPicUrl + picInfo.backFid + ".jpg";
					
				}
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
					var datainfo:Array = [];
					datainfo.push(picInfo);
					datainfo.push(this.img);
					datainfo.push(this);
					
					EventCenter.instance.event(EventCenter.SELECT_PIC_ORDER,[datainfo]);
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
		
		public function canCelSelected():void
		{
			this.sel.visible = false;
			this.sel.selected = false;
		}
		
		private function onMouseOverHandler():void
		{
			// TODO Auto Generated method stub
			this.btndelete.visible = true;
						
			
		}
		
		
		private function onClickHandler():void
		{
			// TODO Auto Generated method stub
			
			if(this.picInfo.picType == 1 && this.picInfo.picClass.toLocaleUpperCase() == "PNG")
				return;
			
			
			if(this.picInfo.picType == 1  && this.picInfo.picPhysicWidth > 0)
			{
								
				if(!DirectoryFileModel.instance.haselectPic.hasOwnProperty(picInfo.fid))
				{
					this.sel.visible = true;
					this.sel.selected = true;
				}
				else
				{
					this.sel.visible = false;
					this.sel.selected = false;
				}
				
				var datainfo:Array = [];
				datainfo.push(picInfo);
				datainfo.push(this.img);
				datainfo.push(this);
				
				EventCenter.instance.event(EventCenter.SELECT_PIC_ORDER,[datainfo]);
				
				//UtilTool.getYixingImageCount("circle.jpg",this);
				
			}
		}
		
			
		private function getPixelInfo(pixel:Object):void
		{
			var imgdata = pixel;
			UtilTool.getCutCountLength(imgdata);
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