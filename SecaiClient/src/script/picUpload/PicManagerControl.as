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
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	
	import ui.PicManagePanelUI;
	
	public class PicManagerControl extends Script
	{
		private var uiSkin:PicManagePanelUI;
		private var createbox:Box;
				
		//private var isCreateTopDir:Boolean = true; //是否创建一级目录
		
		private var directTree:Array = [];
		public var param:Object;

		private var fileListData:Array;

		private var file:Object;
		
		private var curFileList:Array;
		
		public function PicManagerControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			directTree = [];
			uiSkin = this.owner as PicManagePanelUI; 
			//uiSkin.btnNewDir.on(Event.CLICK,this,onCreateNewDirect);
			
			uiSkin.btnNewFolder.on(Event.CLICK,this,onCreateNewFolder);
			uiSkin.btnorder.on(Event.CLICK,this,onshowOrder);

			createbox = uiSkin.boxNewFolder;
			createbox.visible = false;
			uiSkin.firstpage.underline = true;
			uiSkin.firstpage.underlineColor = "#121212";
			
			uiSkin.firstpage.on(Event.CLICK,this,onBackToMain);
			
			uiSkin.input_folename.maxChars = 10;
			uiSkin.btnCloseInput.on(Event.CLICK,this,onCloseCreateFolder);

//			uiSkin.folderList.itemRender = DirectFolderItem;
//			uiSkin.folderList.vScrollBarSkin = "";
//			uiSkin.folderList.selectEnable = true;
//			uiSkin.folderList.spaceY = 2;
//			uiSkin.folderList.renderHandler = new Handler(this, updateDirectItem);
//			
//			uiSkin.folderList.selectHandler = new Handler(this,onSlecteDirect);
			
			uiSkin.picList.itemRender = PicInfoItem;
			uiSkin.picList.vScrollBarSkin = "";
			uiSkin.picList.selectEnable = false;
			uiSkin.picList.spaceY = 0;
			uiSkin.picList.renderHandler = new Handler(this, updatePicInfoItem);
			uiSkin.flder0.visible = false;
			uiSkin.flder1.visible = false;
			uiSkin.flder2.visible = false;
			for(var i=0;i < 3;i++)
			uiSkin["flder" + i].on(Event.CLICK,this,onClickTopDirectLbl,[i]);

			uiSkin.btnroot.on(Event.CLICK,this,backToRootDir);
			uiSkin.btnUploadPic.on(Event.CLICK,this,onShowUploadView);
			
			//Laya.timer.once(10,this,function():void
			//{
				//uiSkin.folderList.array =  ["南京","武打片","日本","电视","你妹的"];
				//uiSkin.folderList.array = [];
				uiSkin.picList.array = [];
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDirectoryList,this,onGetTopDirListBack,"path=0|","post");

			//});
			
			initFileOpen();
			
			uiSkin.htmltext.style.fontSize = 20;
			uiSkin.htmltext.innerHTML =  "<span color='#222222' size='20'>已选择</span>" + "<span color='#FF0000' size='20'>0</span>" + "<span color='#222222' size='20'>张图片</span>";
			uiSkin.btnSureCreate.on(Event.CLICK,this,onSureCreeate);
			EventCenter.instance.on(EventCenter.SELECT_FOLDER,this,onSelectChildFolder);
			EventCenter.instance.on(EventCenter.UPDATE_FILE_LIST,this,getFileList);

			EventCenter.instance.on(EventCenter.SELECT_PIC_ORDER,this,seletPicToOrder);
			DirectoryFileModel.instance.haselectPic = {};
			uiSkin.searchInput.on(Event.INPUT,this,onSearchInput);
			uiSkin.on(Event.REMOVED,this,onRemovedFromStage);
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
				fileListData = [];
				for(var i:int=0;i < file.files.length;i++)
				{
					file.files[i].progress = 0;
					fileListData.push(file.files[i]);
				}
				
				ViewManager.instance.openView(ViewManager.VIEW_MYPICPANEL,false,fileListData);
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
		
		private function onshowOrder():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_PAINT_ORDER,true);
		}
		
		private function seletPicToOrder(fvo:PicInfoVo):void
		{
			var hasfic:Boolean = DirectoryFileModel.instance.haselectPic.hasOwnProperty(fvo.fid)
			if( hasfic)
			{
				delete DirectoryFileModel.instance.haselectPic[fvo.fid];
			}
			else
				DirectoryFileModel.instance.haselectPic[fvo.fid] = fvo;
			var num:int = 0;
			for each(var picvo in DirectoryFileModel.instance.haselectPic)
			{
				num++;
			}
			uiSkin.htmltext.innerHTML =  "<span color='#222222' size='20'>已选择</span>" + "<span color='#FF0000' size='20'>" + num + "</span>" + "<span color='#222222' size='20'>张图片</span>";

		}
		private function onGetTopDirListBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				DirectoryFileModel.instance.initTopDirectoryList(result);
				
				//uiSkin.folderList.array = DirectoryFileModel.instance.topDirectList;
				uiSkin.picList.array = DirectoryFileModel.instance.topDirectList;
				curFileList = DirectoryFileModel.instance.topDirectList;
//				if(DirectoryFileModel.instance.topDirectList.length > 0)
//				{
//					//curDirect += (DirectoryFileModel.instance.topDirectList[0] as PicInfoVo).directName + "|";
//					DirectoryFileModel.instance.curSelectDir = DirectoryFileModel.instance.topDirectList[0] as PicInfoVo;
//					directTree.push(DirectoryFileModel.instance.curSelectDir);
//					
//					updateCurDirectLabel();
//					//uiSkin.flder0.visible = true;
//					//uiSkin.flder0.text = (DirectoryFileModel.instance.topDirectList[0] as PicInfoVo).directName + ">";
//					(uiSkin.folderList.cells[0] as DirectFolderItem).ShowSelected = true;
//					getFileList();
//				}
			}
			
		}
		
		private function getFileList():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDirectoryList,this,onGetDirFileListBack,"path=" + DirectoryFileModel.instance.curSelectDir.dpath,"post");

		}
		
		private function onGetDirFileListBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				DirectoryFileModel.instance.initCurDirFiles(result);
				uiSkin.picList.array = DirectoryFileModel.instance.curFileList;
				curFileList = DirectoryFileModel.instance.curFileList;
			}
		}
		private function onBackToMain():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
		}
		private function onSearchInput():void
		{
			if(curFileList != null)
			{
				var temparr:Array = [];
				for(var i:int=0;i < curFileList.length;i++)
				{
					if((curFileList[i].directName as String).indexOf(uiSkin.searchInput.text) >= 0)
						temparr.push(curFileList[i]);
				}
				uiSkin.picList.array = temparr;
			}
			
		}
		override public function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.SELECT_FOLDER,this,onSelectChildFolder);
			EventCenter.instance.off(EventCenter.UPDATE_FILE_LIST,this,getFileList);
			EventCenter.instance.off(EventCenter.SELECT_PIC_ORDER,this,seletPicToOrder);
			Browser.document.body.removeChild(file);//添加到舞台

		}
		private function onRemovedFromStage():void
		{
			EventCenter.instance.off(EventCenter.SELECT_FOLDER,this,onSelectChildFolder);
			EventCenter.instance.off(EventCenter.UPDATE_FILE_LIST,this,getFileList);
			EventCenter.instance.off(EventCenter.SELECT_PIC_ORDER,this,seletPicToOrder);

		}
		private function onShowUploadView():void
		{
			// TODO Auto Generated method stub
			if(DirectoryFileModel.instance.curSelectDir == null)
			{
				ViewManager.showAlert("请先创建一个目录");
				return;
			}
			file.click();
			file.value;
		}
		
		private function onSureCreeate():void
		{
			if(uiSkin.input_folename.text == "")
				return;
			
			else
			{
				if(directTree.length > 0)
				{
					if(DirectoryFileModel.instance.curSelectDir == null)
					{
						ViewManager.showAlert("请选择一个父目录");
						return;
					}
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.createDirectory,this,onCreateDirBack,"path=" + DirectoryFileModel.instance.curSelectDir.dpath + "&name=" + uiSkin.input_folename.text,"post");
				}
				else
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.createDirectory,this,onCreateDirBack,"path=0|" + "&name=" + uiSkin.input_folename.text,"post");

				//uiSkin.folderList.addItem(uiSkin.input_folename.text);
				createbox.visible = false;
			}
		}
		
		private function onCreateDirBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				//if(isCreateTopDir)
				//{
//					var picinfo:PicInfoVo = new PicInfoVo(result.dir,0);
//					uiSkin.folderList.addItem(picinfo);
//					if(DirectoryFileModel.instance.topDirectList.length == 1)
//					{
//						(uiSkin.folderList.cells[0] as DirectFolderItem).ShowSelected = true;
//						DirectoryFileModel.instance.curSelectDir = DirectoryFileModel.instance.topDirectList[0];
//						directTree.push(DirectoryFileModel.instance.curSelectDir);
//
//						updateCurDirectLabel();
					//}
				//}
//				else
//				{
					 var picinfo:PicInfoVo = new PicInfoVo(result.dir,0);
					uiSkin.picList.addItem(picinfo);
					curFileList = uiSkin.picList.array;
//				}
			}
		}
		
		private function onSlecteDirect(index:int):void
		{
//			for each(var item:DirectFolderItem in uiSkin.folderList.cells)
//			{
//				item.ShowSelected = item.directData == uiSkin.folderList.array[index];
//			}
//			//(uiSkin.folderList.cells[index] as DirectFolderItem).ShowSelected = true;
//			var picinfo:PicInfoVo =  uiSkin.folderList.array[index];
//			//curDirect = picinfo.parentDirect + picinfo.directName + "|";
//			DirectoryFileModel.instance.curSelectDir = picinfo;
//			
//			directTree = [];
//			directTree.push(DirectoryFileModel.instance.curSelectDir);
//
//
//			updateCurDirectLabel();
//			getFileList();
			
		}
		
		private function onSelectChildFolder(filedata:PicInfoVo):void
		{
			DirectoryFileModel.instance.curSelectDir = filedata;
			
			directTree.push(DirectoryFileModel.instance.curSelectDir);

			updateCurDirectLabel();
			getFileList();
		}
		private function backToRootDir():void
		{
			if(directTree.length <= 0)
				return;
			DirectoryFileModel.instance.curSelectDir = DirectoryFileModel.instance.rootDir;
			directTree = [];
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDirectoryList,this,onGetTopDirListBack,"path=0|","post");
			updateCurDirectLabel();
		}
		private function onClickTopDirectLbl(index:int):void
		{
			if(index == directTree.length - 1)
				return;
			DirectoryFileModel.instance.curSelectDir = directTree[index];
			directTree.splice(index+1,directTree.length - index -1);
			updateCurDirectLabel();
			getFileList();
		}
		private function updateCurDirectLabel():void
		{
			this.uiSkin.flder0.visible = false;
			this.uiSkin.flder1.visible = false;
			this.uiSkin.flder2.visible = false;

			//var dirstr:Array = (DirectoryFileModel.instance.curSelectDir.parentDirect + DirectoryFileModel.instance.curSelectDir.directName).split("|");
			for(var i:int=0;i < directTree.length;i++)
			{
				if(i < 3)
				{
					this.uiSkin["flder" + i].text = directTree[i].directName + ">";
					this.uiSkin["flder" + i].visible = true;
				}
			}
			
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
			//isCreateTopDir = true;
			createbox.visible = true;
			
		}
		
		private function onCreateNewFolder():void
		{
			//isCreateTopDir = false;
			createbox.visible = true;
		}
			
	}
}