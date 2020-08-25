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
	
	import utils.UtilTool;
	
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
			this.on(Event.MOUSE_OUT,this,onMouseOutHandler);

			this.btndelete.visible = false;
			this.frame.visible = false;

			
			this.selYixingBtn.on(Event.CLICK,this,onSelectYixingImg);
			this.selBackBtn.on(Event.CLICK,this,onSelectBackImg);

			this.btndelete.on(Event.CLICK,this,onDeleteHandler);
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

				this.img.width = 156;
				this.img.height = 156;
				
				this.selYixingBtn.visible = false;
				this.selBackBtn.visible = false;
				
				this.img.x = 126;
				
			}
			else
			{
				this.fileinfo.visible = true;
				this.filename.text =  picInfo.directName;
				this.img.x = 87;

				if( picInfo.isProcessing)
				{
					this.fileinfo.text = "处理中...";
					this.img.skin = "upload/fold.png";
					this.picClassTxt.visible = false;
					this.colorspacetxt.visible = false;
					
					this.img.width = 156;
					this.img.height = 156;
					return;
				}
				if(picInfo.picWidth > picInfo.picHeight)
				{
					this.img.width = 156;					
					this.img.height = 156/picInfo.picWidth * picInfo.picHeight;
					
					this.yixingimg.width = 78;
					
					this.yixingimg.height = 78/picInfo.picWidth * picInfo.picHeight;
					
					this.backimg.width = 78;
					this.backimg.height = this.yixingimg.height;

				}
				else
				{
					this.img.height = 156;
					this.img.width = 156/picInfo.picHeight * picInfo.picWidth;
					
					this.yixingimg.height = 78;
					
					this.yixingimg.width = 78/picInfo.picHeight * picInfo.picWidth;
					
					this.backimg.height = 78;
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
					
					this.selYixingBtn.visible = false;
					this.selYixingBtn.skin = "upload/deletbtn.png";
					this.btnyxtxt.text = "取消异形";
					this.btnyxtxt.color = "#FFFFFF";

				}
				else
				{
					this.selYixingBtn.visible = true;
					this.btnyxtxt.text = "选择异形";
					this.selYixingBtn.skin = "upload/addimg.png";
					this.btnyxtxt.color = "#444A4E";

				}
				if(picInfo.backFid != "" && picInfo.backFid != "0")
				{
					this.backimg.visible = true;
					this.backimg.skin = HttpRequestUtil.smallerrPicUrl + picInfo.backFid + ".jpg";
					this.selBackBtn.visible = false;
					this.btnfmtxt.text = "取消反面";
					
					this.selBackBtn.skin = "upload/deletbtn.png";
					this.btnfmtxt.color = "#FFFFFF";

				}
				else
				{
					this.selBackBtn.visible = true;
					this.btnfmtxt.text = "选择反面";
					
					this.selBackBtn.skin = "upload/addimg.png";
					this.btnfmtxt.color = "#444A4E";
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
			this.frame.visible = false;

			//this.selYixingBtn.visible = false;
			//this.selBackBtn.visible = false;
			
			if(picInfo.yixingFid != "" && picInfo.yixingFid != "0")
			{			
				
				this.selYixingBtn.visible = false;
				
			}
			
			if(picInfo.backFid != "" && picInfo.backFid != "0")
			{
				this.selBackBtn.visible = false;
			}
			

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
			this.frame.visible = true;
			if(this.picInfo.picType == 1)
			{
				this.selYixingBtn.visible = true;
//				if(this.picInfo.yixingFid == "0")
//					this.selYixingBtn.label = "选择异形";
//				else
//					this.selYixingBtn.label = "取消异形";
				
				this.selBackBtn.visible = true;
//				if(this.picInfo.backFid == "0")
//					this.selBackBtn.label = "选择反面";
//				else
//					this.selBackBtn.label = "取消反面";
					
			}


		}
		
		public function showYixingImg(fid:String):void
		{
			this.yixingimg.visible = true;
			this.yixingimg.skin = HttpRequestUtil.smallerrPicUrl + fid + ".jpg";
		}
		private function onClickHandler():void
		{
			// TODO Auto Generated method stub
			
			if(this.picInfo.picType == 1 && this.picInfo.picClass.toLocaleUpperCase() == "PNG")
				return;
			
			
			if(this.picInfo.picType == 1  && this.picInfo.picPhysicWidth > 0)
			{
				if(DirectoryFileModel.instance.curOperateFile != null)
				{
					if(DirectoryFileModel.instance.curOperateFile.fid == picInfo.fid)
					{
						return;
					}
					if(DirectoryFileModel.instance.curOperateSelType == 0 && UtilTool.isFitYixing(DirectoryFileModel.instance.curOperateFile,this.picInfo))
					{
						//trace("sel fid:" + this.picInfo.fid);
						
						var params:String = "fid=" + DirectoryFileModel.instance.curOperateFile.fid + "&fmaskid=" + this.picInfo.fid;							
						HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.setYixingRelated,this,onSetYixingBack,params,"post");
					
						DirectoryFileModel.instance.curOperateFile = null;
						EventCenter.instance.event(EventCenter.STOP_SELECT_RELATE_PIC);
						
					}
					else if(DirectoryFileModel.instance.curOperateSelType == 1 && UtilTool.isFitFanmain(DirectoryFileModel.instance.curOperateFile,this.picInfo))
					{
						//trace("sel fid:" + this.picInfo.fid);
						
						var params:String = "fid=" + DirectoryFileModel.instance.curOperateFile.fid + "&fbackid=" + this.picInfo.fid;							
						HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.setFanmianRelated,this,onSetFanmianBack,params,"post");
						
						DirectoryFileModel.instance.curOperateFile = null;
						EventCenter.instance.event(EventCenter.STOP_SELECT_RELATE_PIC);
						
					}
					
					return;

				}
				
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
				
				//UtilTool.getYixingImageCount("ddd.jpg",this);

			}
		}
		
		private function onSetYixingBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				//ViewManager.showAlert("设置成功");
				EventCenter.instance.event(EventCenter.UPDATE_FILE_LIST);

			}
		}
		private function onSetFanmianBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				//ViewManager.showAlert("设置成功");
				EventCenter.instance.event(EventCenter.UPDATE_FILE_LIST);

			}
		}
		private function onSelectYixingImg(e:Event):void
		{
			if(DirectoryFileModel.instance.curOperateFile != null)
				return;
			
			if(this.picInfo.yixingFid == "0")
			{
				DirectoryFileModel.instance.curOperateFile = this.picInfo;
				DirectoryFileModel.instance.curOperateSelType = 0;
				this.sel.selected = true;
				this.sel.visible = true;
				EventCenter.instance.event(EventCenter.START_SELECT_YIXING_PIC);
			}
			else
			{
				//this.picInfo.yixingFid = "";
				this.yixingimg.visible = false;
				
				var params:String = "fid=" + picInfo.fid + "&fmaskid=0";
				
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.setYixingRelated,this,onSetYixingBack,params,"post");

			}
			e.stopPropagation();
		}
		private function onSelectBackImg(e:Event):void
		{
			if(DirectoryFileModel.instance.curOperateFile != null)
				return;
			
			if(this.picInfo.backFid == "0")
			{
				DirectoryFileModel.instance.curOperateFile = this.picInfo;
				DirectoryFileModel.instance.curOperateSelType = 1;

				this.sel.selected = true;
				this.sel.visible = true;
				EventCenter.instance.event(EventCenter.START_SELECT_BACK_PIC);
			}
			else
			{
				//this.picInfo.yixingFid = "";
				this.backimg.visible = false;
				
				var params:String = "fid=" + picInfo.fid + "&fbackid=0";							
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.setFanmianRelated,this,onSetFanmianBack,params,"post");
				
			}
			e.stopPropagation();
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