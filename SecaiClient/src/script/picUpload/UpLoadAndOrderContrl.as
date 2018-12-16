package script.picUpload
{	
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
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
			uiSkin.btnBegin.on(Event.CLICK,this,onClickBegin);

			uiSkin.bgimg.alpha = 0.7;
			uiSkin.fileList.itemRender = FileUpLoadItem;
			uiSkin.fileList.vScrollBarSkin = "";
			uiSkin.fileList.selectEnable = false;
			uiSkin.fileList.spaceY = 4;
			uiSkin.fileList.renderHandler = new Handler(this, updateFileItem);
			uiSkin.fileList.array = [];
			initFileOpen();
			
			Browser.window.uploadApp = this;

			
		}
		
		private function initFileOpen():void
		{
			 file = Browser.document.createElement("input");
			
			file.style="filter:alpha(opacity=0);opacity:0;width: 100;height:34px;left:395px;top:48";
			
			file.multiple="multiple";
			file.accept = ".jpg,.jpeg,.png,.tif";
			file.type ="file";
			file.style.position ="absolute";
			file.style.zIndex = 999;
			Browser.document.body.appendChild(file);//添加到舞台
			file.onchange = function(e):void
			{
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
					fileListData.push(file.files[i]);
				}
				
				uiSkin.fileList.array = fileListData;
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
		}
		private function onBeginUpload():void
		{
			if(fileListData && fileListData.length > curUploadIndex)
			{
				Browser.window.uploadPic({path:DirectoryFileModel.instance.curSelectDir.dpath,file:fileListData[curUploadIndex]});
				//HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.uploadPic,this,onCompleteUpload,{path:"0|11|",file:file.files[0]},"post",onProgressHandler);
			}
			else
			{
				isUploading = false;
			}
		}
		
		private function onCompleteUpload(e:Object):void
		{
			(this.uiSkin.fileList.cells[curUploadIndex] as FileUpLoadItem).updateProgress("100");

			curUploadIndex++;
			onBeginUpload();
		}
		
		private function onProgressHandler(e:Object):void
		{
			if(Number(e) >= 100)
				e = "99";
			(this.uiSkin.fileList.cells[curUploadIndex] as FileUpLoadItem).updateProgress(e.toString());
			trace("up progress" + JSON.stringify(e));
		}
		private function updateFileItem(cell:FileUpLoadItem):void 
		{
			cell.setData(cell.dataSource);
		}
		private function onCloseScene():void
		{
			// TODO Auto Generated method stub
			Browser.window.uploadApp = null;

			EventCenter.instance.event(EventCenter.UPDATE_FILE_LIST);
			ViewManager.instance.closeView(ViewManager.VIEW_MYPICPANEL);
		}		
		
		
	}
}