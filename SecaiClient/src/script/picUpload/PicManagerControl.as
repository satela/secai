package script.picUpload
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.utils.Handler;
	
	import script.ViewManager;
	
	import ui.PicManagePanelUI;
	
	public class PicManagerControl extends Script
	{
		private var uiSkin:PicManagePanelUI;
		private var createbox:Box;
		public function PicManagerControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as PicManagePanelUI; 
			uiSkin.btnNewDir.on(Event.CLICK,this,onCreateNewDirect);
			createbox = uiSkin.boxNewFolder;
			createbox.visible = false;
			uiSkin.firstpage.underline = true;
			uiSkin.firstpage.underlineColor = "#121212";
			
			uiSkin.firstpage.on(Event.CLICK,this,onBackToMain);
			
			uiSkin.input_folename.maxChars = 50;
			uiSkin.btnCloseInput.on(Event.CLICK,this,onCloseCreateFolder);

			uiSkin.folderList.itemRender = DirectFolderItem;
			uiSkin.folderList.vScrollBarSkin = "";
			uiSkin.folderList.selectEnable = true;
			uiSkin.folderList.spaceY = 2;
			uiSkin.folderList.renderHandler = new Handler(this, updateDirectItem);
			
			uiSkin.folderList.selectHandler = new Handler(this,onSlecteDirect);
			
			uiSkin.picList.itemRender = PicInfoItem;
			uiSkin.picList.vScrollBarSkin = "";
			uiSkin.picList.selectEnable = false;
			uiSkin.picList.spaceY = 0;
			uiSkin.picList.renderHandler = new Handler(this, updatePicInfoItem);
			//uiSkin.picList.array = [];
			
			//uiSkin.folderList.array = ["南京","武打片","日本","电视","你妹的"];
			
			uiSkin.btnUploadPic.on(Event.CLICK,this,onShowUploadView);
			
			Laya.timer.once(10,null,function():void
			{
				uiSkin.folderList.array =  ["南京","武打片","日本","电视","你妹的"];
				uiSkin.picList.array = [];

			});
			
			uiSkin.btnSureCreate.on(Event.CLICK,this,onSureCreeate);
		}
		
		private function onBackToMain():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_PICMANAGER);
		}
		
		private function onShowUploadView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_MYPICPANEL);
		}
		
		private function onSureCreeate():void
		{
			if(uiSkin.input_folename.text == "")
				return;
			else
			{
				uiSkin.folderList.addItem(uiSkin.input_folename.text);
				createbox.visible = false;
			}
		}
		
		private function onSlecteDirect(index:int):void
		{
			for each(var item:DirectFolderItem in uiSkin.folderList.cells)
			{
				item.ShowSelected = false;
			}
			(uiSkin.folderList.cells[index] as DirectFolderItem).ShowSelected = true;
		}
		private function updateDirectItem(cell:DirectFolderItem):void 
		{
			cell.setData(cell.dataSource);
		}
		
		private function updatePicInfoItem(cell:PicInfoItem):void 
		{
			cell.setData(cell.dataSource);
		}
		
		private function onCloseCreateFolder():void
		{
			// TODO Auto Generated method stub
			createbox.visible = false;
		}		
		
		private function onCreateNewDirect():void
		{
			// TODO Auto Generated method stub
			createbox.visible = true;
			
		}
	}
}