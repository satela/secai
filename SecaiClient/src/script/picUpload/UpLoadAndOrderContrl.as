package script.picUpload
{	
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.picmanagerModel.DirectoryFileModel;
	
	import script.ViewManager;
	
	import ui.uploadpic.UpLoadPanelUI;
	
	public class UpLoadAndOrderContrl extends Script
	{
		private var uiSkin:UpLoadPanelUI;
		private var fileListData:Array;

		private var allFileData:Array;
		private var curUploadIndex:int = 0;
		private var file:Object; 
		public var param:Object;

		public var isUploading:Boolean = false;
		public function UpLoadAndOrderContrl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as UpLoadPanelUI; 
			uiSkin.btnClose.on(Event.CLICK,this,onCloseScene);
			//uiSkin.btnBegin.on(Event.CLICK,this,onClickBegin);
			uiSkin.btnOpenFile.on(Event.CLICK,this,onClickOpenFile);

			//uiSkin.bgimg.alpha = 0.7;
			uiSkin.fileList.itemRender = FileUpLoadItem;
			uiSkin.fileList.vScrollBarSkin = "";
			uiSkin.fileList.selectEnable = false;
			uiSkin.fileList.spaceY = 4;
			uiSkin.fileList.renderHandler = new Handler(this, updateFileItem);
			initFileOpen();
			uiSkin.uploadinfo.visible = false;
			
			Browser.window.uploadApp = this;
			if(param != null && (param as Array) != null)
			{
				uiSkin.fileList.array = param as Array;
				fileListData = param as Array;
				onClickBegin();
			}
			else
				uiSkin.fileList.array = [];

			
			EventCenter.instance.on(EventCenter.CANCAEL_UPLOAD_ITEM,this,onDeleteItem);


		}
		
		private function onClickOpenFile():void
		{
			Laya.timer.clearAll(this);
			file.click();
			file.value ;
		}
		private function initFileOpen():void
		{
			 file = Browser.document.createElement("input");
			
			file.style="filter:alpha(opacity=0);opacity:0;width: 100;height:34px;left:395px;top:-248";
			
//			if(param && param.type == "License")
//				file.multiple="";
//			else
				file.multiple="multiple";

			file.accept = ".jpg,.jpeg,.png,.tif";
			file.type ="file";
			file.style.position ="absolute";
			file.style.zIndex = 999;
			Browser.document.body.appendChild(file);//添加到舞台
			file.onchange = function(e):void
			{
				uiSkin.uploadinfo.visible = false;
				
				if(isUploading)
					return;
				if(file.files.length <= 0)
					return;
				curUploadIndex = 0;
				//allFileData = [];
				//fileReader.readAsBinaryString(file.files[0]);
				
				fileListData = [];
				for(var i:int=0;i < file.files.length;i++)
				{
					file.files[i].progress = 0;
					fileListData.push(file.files[i]);
				}
				
				uiSkin.fileList.array = fileListData;
				onClickBegin();
			};
//			var fileReader:Object = new  Browser.window.FileReader();
//			fileReader.onload = function(evt):void
//			{  
//				if(Browser.window.FileReader.DONE==fileReader.readyState)
//				{
//					allFileData.push(fileReader.result);
//					//var bytearr:ByteArray = new ByteArray();
//					//bytearr.readBytes(fileReader.result);
//				}
//			}
		}
		
		private function onClickBegin():void
		{
			if(isUploading)
				return;
			isUploading = true;
			onBeginUpload();
			if(fileListData.length > 0)
			{
				uiSkin.uploadinfo.visible = true;
				uiSkin.uploadinfo.text = "正在上传" + "(" + curUploadIndex + "/" + fileListData.length + ")";
			}
		}
		private function onBeginUpload():void
		{
			if(fileListData && fileListData.length > curUploadIndex)
			{
				Browser.window.uploadPic({urlpath:HttpRequestUtil.httpUrl + HttpRequestUtil.uploadPic, path:DirectoryFileModel.instance.curSelectDir.dpath,file:fileListData[curUploadIndex]});
				//HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.uploadPic,this,onCompleteUpload,{path:"0|11|",file:file.files[0]},"post",onProgressHandler);
			}
			else
			{
				isUploading = false;
				uiSkin.uploadinfo.text = "上传完成，共上传文件" + fileListData.length;

				Laya.timer.once(5000,this,onCloseScene);
			}
		}
		
		private function onCompleteUpload(e:Object):void
		{
			if(fileListData[curUploadIndex])
			fileListData[curUploadIndex].progress = 100;
			updateProgress();
			curUploadIndex++;
			uiSkin.uploadinfo.text = "正在上传" + "(" + curUploadIndex + "/" + fileListData.length + ")";

			onBeginUpload();

		}
		
		private function onProgressHandler(e:Object):void
		{
			if(Number(e) >= 100)
				e = "99";
			if(fileListData[curUploadIndex])
			fileListData[curUploadIndex].progress = Number(e);
			updateProgress();
			//(this.uiSkin.fileList.cells[curUploadIndex] as FileUpLoadItem).updateProgress(e.toString());
			//trace("up progress" + JSON.stringify(e));
		}
		private function updateProgress():void
		{
			var cells:Vector.<Box> = uiSkin.fileList.cells;
			for(var i:int=0;i < cells.length;i++)
			{
				if(cells[i] as FileUpLoadItem != null && (cells[i] as FileUpLoadItem).fileobj == fileListData[curUploadIndex])
				{
					(cells[i] as FileUpLoadItem).updateProgress();
					break;
				}
			}
		}
		private function updateFileItem(cell:FileUpLoadItem):void 
		{
			cell.setData(cell.dataSource);
		}
		
		private function onDeleteItem(delitem:FileUpLoadItem):void
		{
			if(delitem.fileobj.progress >= 99)
				return;
			
			var index:int = fileListData.indexOf(delitem.fileobj);
			if(index == curUploadIndex)
			{
				Browser.window.cancelUpload();
				if(isUploading)
					onBeginUpload();
			}
			uiSkin.fileList.deleteItem(index);
			
			
		}
		private function onCloseScene():void
		{
			// TODO Auto Generated method stub
			Browser.window.uploadApp = null;

			EventCenter.instance.event(EventCenter.UPDATE_FILE_LIST);
			EventCenter.instance.off(EventCenter.CANCAEL_UPLOAD_ITEM,this,onDeleteItem);

			ViewManager.instance.closeView(ViewManager.VIEW_MYPICPANEL);
			
			Browser.document.body.removeChild(file);//添加到舞台

		}		
		
		
	}
}