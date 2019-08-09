package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.orderModel.MaterialItemVo;
	import model.picmanagerModel.DirectoryFileModel;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	import script.picUpload.DirectFolderItem;
	import script.picUpload.PicInfoItem;
	
	import ui.order.SelectPicPanelUI;
	
	import utils.UtilTool;
	
	public class SelectPicControl extends Script
	{
		private var uiSkin:SelectPicPanelUI;
		
		private var directTree:Array = [];
	
		public var param:Object;
		private var curFileList:Array;

		public function SelectPicControl()
		{
			super();
		}
		override public function onStart():void
		{
			
			uiSkin = this.owner as SelectPicPanelUI; 
			
			directTree = [];

//			uiSkin.folderList.itemRender = DirectFolderItem;
//			uiSkin.folderList.vScrollBarSkin = "";
//			uiSkin.folderList.selectEnable = true;
//			uiSkin.folderList.spaceY = 2;
//			uiSkin.folderList.renderHandler = new Handler(this, updateDirectItem);
//			
//			uiSkin.folderList.selectHandler = new Handler(this,onSlecteDirect);
			uiSkin.filetypeRadio.visible = false;

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
			uiSkin.btnprevfolder.on(Event.CLICK,this,onClickParentFolder);

			uiSkin.radiosel.on(Event.CLICK,this,onSelectAllPic);

			//Laya.timer.once(10,this,function():void
			//{
				//uiSkin.folderList.array =  ["南京","武打片","日本","电视","你妹的"];
				//uiSkin.folderList.array = [];
				uiSkin.picList.array = [];
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDirectoryList,this,onGetTopDirListBack,"path=0|","post");
				
			//});
			
			uiSkin.htmltext.style.fontSize = 20;
			uiSkin.htmltext.innerHTML =  "<span color='#222222' size='20'>已选择</span>" + "<span color='#FF0000' size='20'>0</span>" + "<span color='#222222' size='20'>张图片</span>";
			
			uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
			uiSkin.btnok.on(Event.CLICK,this,onConfirmSelect);
			uiSkin.searchInput.on(Event.INPUT,this,onSearchInput);

			EventCenter.instance.on(EventCenter.SELECT_FOLDER,this,onSelectChildFolder);
			EventCenter.instance.on(EventCenter.UPDATE_FILE_LIST,this,getFileList);
			
			EventCenter.instance.on(EventCenter.SELECT_PIC_ORDER,this,seletPicToOrder);
		}
		
		private function onConfirmSelect():void
		{
			// TODO Auto Generated method stub
			if(!(param is MaterialItemVo))
			{
				EventCenter.instance.event(EventCenter.ADD_PIC_FOR_ORDER);
			}
			onCloseView();
		}
		
		private function onCloseView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_PIC_TO_ORDER);
		}
		
		private function onSelectAllPic():void
		{
			var allfilse:Array = DirectoryFileModel.instance.curFileList;
			if(allfilse == null)
				return;
			if(param is MaterialItemVo)
			{
				return;
			}
			for(var i:int=0;i < allfilse.length;i++)
			{
				if(allfilse[i].picType == 1)
				{
					if(uiSkin.radiosel.selected)
					{
						var hasfic:Boolean = DirectoryFileModel.instance.haselectPic.hasOwnProperty(allfilse[i].fid)
						if( !hasfic && UtilTool.checkFileIsImg(allfilse[i]))
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
				if((uiSkin.picList.cells[i] as PicInfoItem).picInfo != null && UtilTool.checkFileIsImg((uiSkin.picList.cells[i] as PicInfoItem).picInfo))
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
			uiSkin.htmltext.innerHTML =  "<span color='#222222' size='20'>已选择</span>" + "<span color='#FF0000' size='20'>" + num + "</span>" + "<span color='#222222' size='20'>张图片</span>";
			
			
		}
		
		private function seletPicToOrder(fvo:PicInfoVo):void
		{
			if(param is MaterialItemVo)
			{
				if((param as MaterialItemVo).attchFileId == fvo.fid)
				{
					(param as MaterialItemVo).attchMentFileId = "";
					(param as MaterialItemVo).attchFileId = "";
				}
				else
				{
					(param as MaterialItemVo).attchMentFileId = HttpRequestUtil.originPicPicUrl + fvo.fid + "." + fvo.picClass;
					(param as MaterialItemVo).attchFileId = fvo.fid;

				}
				return;
			}
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
				curFileList = uiSkin.picList.array;
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
			EventCenter.instance.event(EventCenter.CLOSE_PANEL_VIEW,ViewManager.VIEW_SELECT_PIC_TO_ORDER);

			EventCenter.instance.off(EventCenter.SELECT_FOLDER,this,onSelectChildFolder);
			EventCenter.instance.off(EventCenter.UPDATE_FILE_LIST,this,getFileList);
			EventCenter.instance.off(EventCenter.SELECT_PIC_ORDER,this,seletPicToOrder);
		}
	
	
		private function onSlecteDirect(index:int):void
		{
//			for each(var item:DirectFolderItem in uiSkin.folderList.cells)
//			{
//				item.ShowSelected = item.directData == uiSkin.folderList.array[index];
//			}
//			//(uiSkin.folderList.cells[index] as DirectFolderItem).ShowSelected = true;
//			var picinfo:PicInfoVo =  uiSkin.folderList.array[index];
			//curDirect = picinfo.parentDirect + picinfo.directName + "|";
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
		
		private function onClickTopDirectLbl(index:int):void
		{
			if(index == directTree.length - 1)
				return;
			DirectoryFileModel.instance.curSelectDir = directTree[index];
			directTree.splice(index+1,directTree.length - index -1);
			updateCurDirectLabel();
			getFileList();
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
		
		private function backToRootDir():void
		{
			if(directTree.length <= 0)
				return;
			DirectoryFileModel.instance.curSelectDir = DirectoryFileModel.instance.rootDir;
			directTree = [];
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDirectoryList,this,onGetTopDirListBack,"path=0|","post");
			updateCurDirectLabel();
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
		
		
	}
}