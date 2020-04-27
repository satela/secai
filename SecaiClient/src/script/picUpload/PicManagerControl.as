package script.picUpload
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Label;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.orderModel.PaintOrderModel;
	import model.picmanagerModel.DirectoryFileModel;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	
	import ui.PicManagePanelUI;
	
	import utils.UtilTool;
	
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
			//uiSkin.main_panel.vScrollBarSkin = "";
			uiSkin.btnNewFolder.on(Event.CLICK,this,onCreateNewFolder);
			uiSkin.btnorder.on(Event.CLICK,this,onshowOrder);

			createbox = uiSkin.boxNewFolder;
			createbox.visible = false;
			//uiSkin.firstpage.underline = true;
			//uiSkin.firstpage.underlineColor = "#121212";
			
			//uiSkin.firstpage.on(Event.CLICK,this,onBackToMain);
			
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
			//uiSkin.picList.scrollBar.autoHide = true;
			uiSkin.picList.selectEnable = false;
			uiSkin.picList.spaceY = 0;
			uiSkin.picList.renderHandler = new Handler(this, updatePicInfoItem);
			uiSkin.flder0.visible = false;
			uiSkin.flder1.visible = false;
			uiSkin.flder2.visible = false;
			for(var i=0;i < 3;i++)
			uiSkin["flder" + i].on(Event.CLICK,this,onClickTopDirectLbl,[i]);

			//uiSkin.btnprevfolder.on(Event.CLICK,this,onClickParentFolder);
			
			uiSkin.btnroot.on(Event.CLICK,this,backToRootDir);
			uiSkin.btnUploadPic.on(Event.CLICK,this,onShowUploadView);
			
			uiSkin.filetypeRadio.visible = false;
			uiSkin.radiosel.on(Event.CLICK,this,onSelectAllPic);
			uiSkin.freshbtn.on(Event.CLICK,this,onFreshList);
			//Laya.timer.once(10,this,function():void
			//{
				//uiSkin.folderList.array =  ["南京","武打片","日本","电视","你妹的"];
				//uiSkin.folderList.array = [];
				uiSkin.picList.array = [];
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDirectoryList,this,onGetTopDirListBack,"path=0|","post");

			//});
			
			initFileOpen();
			
			//uiSkin.htmltext.style.fontSize = 20;
			//uiSkin.htmltext.innerHTML =  "<span color='#222222' size='20'>已选择</span>" + "<span color='#FF0000' size='20'>0</span>" + "<span color='#222222' size='20'>张图片</span>";
			uiSkin.selectNum.text = 0 + "";
			uiSkin.btnSureCreate.on(Event.CLICK,this,onSureCreeate);
			EventCenter.instance.on(EventCenter.SELECT_FOLDER,this,onSelectChildFolder);
			EventCenter.instance.on(EventCenter.UPDATE_FILE_LIST,this,getFileList);

			EventCenter.instance.on(EventCenter.SELECT_PIC_ORDER,this,seletPicToOrder);
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

			DirectoryFileModel.instance.haselectPic = {};
			uiSkin.searchInput.on(Event.INPUT,this,onSearchInput);
			uiSkin.on(Event.REMOVED,this,onRemovedFromStage);
			var fixedheight:Number = Browser.height;
			if(Browser.height > Laya.stage.height)
			{
				fixedheight = Laya.stage.height;
			}
			uiSkin.main_panel.height = fixedheight;
			uiSkin.main_panel.width = Browser.width;
			uiSkin.main_panel.hScrollBarSkin = "";
			uiSkin.picList.height =  fixedheight - 120;
			
			DirectoryFileModel.instance.curFileList = [];
			DirectoryFileModel.instance.curSelectDir = DirectoryFileModel.instance.rootDir;
			

		}
		private function onResizeBrower():void
		{
			// TODO Auto Generated method stub
			var fixedheight:Number = Browser.height;
			if(Browser.height > Laya.stage.height)
			{
				fixedheight = Laya.stage.height;
			}
			uiSkin.main_panel.height = fixedheight;
			uiSkin.picList.height =  fixedheight - 120;
			uiSkin.main_panel.width = Browser.width;

		}
		
		private function onGetLeftCapacitBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(uiSkin == null || uiSkin.destroyed)
				return;
				
			if(result.status == 0)
			{
				var  size:Number = parseInt(result.size)/1024/1024;
				var maxsize:int = parseInt(result.maxsize)/1024/1024/1024;
				if( parseInt(result.size) < parseInt(result.maxsize))
					uiSkin.prgcap.value = parseInt(result.size)/parseInt(result.maxsize);
				else
					uiSkin.prgcap.value = 1;
									
				uiSkin.leftcapacity.text = size.toFixed(0) + "M/" + maxsize + "G";
			}
		}
		private function onSelectAllPic():void
		{
			var allfilse:Array = DirectoryFileModel.instance.curFileList;
			if(allfilse == null)
				return;
			
			for(var i:int=0;i < allfilse.length;i++)
			{
				if(allfilse[i].picType == 1)
				{
					if(uiSkin.radiosel.selected)
					{
						var hasfic:Boolean = DirectoryFileModel.instance.haselectPic.hasOwnProperty(allfilse[i].fid)
						if( !hasfic && UtilTool.checkFileIsImg(allfilse[i]) && allfilse[i].picPhysicWidth != 0)
						{
							//delete DirectoryFileModel.instance.haselectPic[fvo.fid];
							DirectoryFileModel.instance.haselectPic[allfilse[i].fid] = allfilse[i];
						}
							
					}
					else
					{
						var hasfic:Boolean = DirectoryFileModel.instance.haselectPic.hasOwnProperty(allfilse[i].fid)
						if( hasfic)
						{
							delete DirectoryFileModel.instance.haselectPic[allfilse[i].fid];
						}
					}
				}
			}
			for(var i:int=0;i < uiSkin.picList.cells.length;i++)
			{
				if((uiSkin.picList.cells[i] as PicInfoItem).picInfo != null && UtilTool.checkFileIsImg((uiSkin.picList.cells[i] as PicInfoItem).picInfo) && (uiSkin.picList.cells[i] as PicInfoItem).picInfo.picPhysicWidth != 0)
				{
					(uiSkin.picList.cells[i] as PicInfoItem).sel.visible = uiSkin.radiosel.selected;
					(uiSkin.picList.cells[i] as PicInfoItem).sel.selected = uiSkin.radiosel.selected;
				}
			}
			var num:int = 0;
			for each(var picvo in DirectoryFileModel.instance.haselectPic)
			{
				num++;
			}
			uiSkin.selectNum.text =  num + "";

			
		}
		
		private function initFileOpen():void
		{
			file = Browser.document.createElement("input");
			
			file.style="filter:alpha(opacity=0);opacity:0;width: 100;height:34px;left:395px;top:-248";
			
//			if(param && param.type == "License")
//				file.multiple="";
//			else
			file.multiple="multiple";
			
			file.accept = ".jpg,.jpeg,.tif,.zip";
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
			var hassrgb:Boolean = false;
			
			for each(var pic:PicInfoVo in DirectoryFileModel.instance.haselectPic)
			{
				if(pic.colorspace.toUpperCase() == "SRGB")
				{
					hassrgb = true;
					break;
				}
			}
			
			if(hassrgb)
			{
				ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"RGB格式的图片直接生产会产生色差，是否继续?",caller:this,callback:confirmOrderNow});
			}
			else
				ViewManager.instance.openView(ViewManager.VIEW_PAINT_ORDER,true);
		}
		
		private function confirmOrderNow(b:Boolean):void
		{
			if(b)
			{
				ViewManager.instance.openView(ViewManager.VIEW_PAINT_ORDER,true);

			}
		}
		private function seletPicToOrder(data:Array):void
		{
			var fvo:PicInfoVo = data[0];
			
			if(UtilTool.checkFileIsImg(fvo) && fvo.picPhysicWidth != 0)
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
				uiSkin.selectNum.text =  num + "";
			}

		}
		private function onGetTopDirListBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				DirectoryFileModel.instance.initTopDirectoryList(result);
				
				//uiSkin.folderList.array = DirectoryFileModel.instance.topDirectList;
				uiSkin.radiosel.selected = false;
				uiSkin.picList.array = DirectoryFileModel.instance.topDirectList;
				curFileList = DirectoryFileModel.instance.topDirectList;
				DirectoryFileModel.instance.curFileList = [];
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo,this,onGetLeftCapacitBack,null,"post");

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
			else if(result.status == 205)
			{
				ViewManager.instance.openView(ViewManager.VIEW_USERCENTER,true);
			}
			
		}
		
		private function getFileList():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDirectoryList,this,onGetDirFileListBack,"path=" + DirectoryFileModel.instance.curSelectDir.dpath,"post");
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo,this,onGetLeftCapacitBack,null,"post");

		}
		
		private function onGetDirFileListBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				uiSkin.radiosel.selected = false;

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
				uiSkin.radiosel.selected = false;

				uiSkin.picList.array = temparr;
			}
			
		}
		override public function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.SELECT_FOLDER,this,onSelectChildFolder);
			EventCenter.instance.off(EventCenter.UPDATE_FILE_LIST,this,getFileList);
			EventCenter.instance.off(EventCenter.SELECT_PIC_ORDER,this,seletPicToOrder);
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

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
			if(DirectoryFileModel.instance.curSelectDir == null || DirectoryFileModel.instance.curSelectDir.directId == "0")
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
					uiSkin.radiosel.selected = false;

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
		
		private function onClickParentFolder():void
		{
			if(directTree.length > 1)
			{
				DirectoryFileModel.instance.curSelectDir = directTree[directTree.length - 2];
				directTree.splice(directTree.length - 1,1);
				updateCurDirectLabel();
				getFileList();
			}
			else
			{
				backToRootDir();
				
			}
		}
		
		private function onFreshList():void
		{
			getFileList();
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
					if(i > 0)
					{
						this.uiSkin["flder" + i].x = this.uiSkin["flder" + (i - 1)].x + (this.uiSkin["flder" + (i - 1)] as Label).textField.textWidth + 2;
					}
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