package script.picUpload
{	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import script.ViewManager;
	
	import ui.uploadpic.UpLoadPanelUI;
	
	public class UpLoadAndOrderContrl extends Script
	{
		private var uiSkin:UpLoadPanelUI;
		private var fileListData:Array;

		public function UpLoadAndOrderContrl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as UpLoadPanelUI; 
			uiSkin.btnClose.on(Event.CLICK,this,onCloseScene);
			uiSkin.bgimg.alpha = 0.7;
			uiSkin.fileList.itemRender = FileUpLoadItem;
			uiSkin.fileList.vScrollBarSkin = "";
			uiSkin.fileList.selectEnable = false;
			uiSkin.fileList.spaceY = 4;
			uiSkin.fileList.renderHandler = new Handler(this, updateFileItem);
			uiSkin.fileList.array = [];
			initFileOpen();
			
		}
		
		private function initFileOpen():void
		{
			var file:Object = Browser.document.createElement("input");
			
			file.style="filter:alpha(opacity=0);opacity:0;width: 100;height:34px;left:360px;top:48";
			
			file.multiple="multiple";
			file.accept = ".jpg,.jpeg,.png,.tif";
			file.type ="file";
			file.style.position ="absolute";
			file.style.zIndex = 999;
			Browser.document.body.appendChild(file);//添加到舞台
			file.onchange = function(e):void
			{
				if(file.files.length <= 0)
					return;
				fileReader.readAsBinaryString(file.files[0]);
				
				fileListData = [];
				for(var i:int=0;i < file.files.length;i++)
				{
					fileListData.push(file.files[i]);
				}
				
				uiSkin.fileList.array = fileListData;
			};
			var fileReader:Object = new  Browser.window.FileReader();
			fileReader.onload = function(evt):void
			{  
				if(Browser.window.FileReader.DONE==fileReader.readyState)
				{
					//var bytearr:ByteArray = new ByteArray();
					//bytearr.readBytes(fileReader.result);
				}
			}
		}
		
		private function updateFileItem(cell:FileUpLoadItem):void 
		{
			cell.setData(cell.dataSource);
		}
		private function onCloseScene():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_MYPICPANEL);
		}		
		
		
	}
}