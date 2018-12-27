package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.picmanagerModel.DirectoryFileModel;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	import script.picUpload.DirectFolderItem;
	import script.picUpload.PicInfoItem;
	
	import ui.order.SelectPicPanelUI;
	
	public class SelectPicControl extends Script
	{
		private var uiSkin:SelectPicPanelUI;
		
		private var directTree:Array = [];
	
		public function SelectPicControl()
		{
			super();
		}
		override public function onStart():void
		{
			
			uiSkin = this.owner as SelectPicPanelUI; 
			
			directTree = [];

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
			uiSkin.flder0.visible = false;
			uiSkin.flder1.visible = false;
			uiSkin.flder2.visible = false;
			for(var i=0;i < 3;i++)
				uiSkin["flder" + i].on(Event.CLICK,this,onClickTopDirectLbl,[i]);
			
		
			Laya.timer.once(10,this,function():void
			{
				//uiSkin.folderList.array =  ["南京","武打片","日本","电视","你妹的"];
				uiSkin.folderList.array = [];
				uiSkin.picList.array = [];
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDirectoryList,this,onGetTopDirListBack,"path=0|","post");
				
			});
			
			uiSkin.htmltext.style.fontSize = 20;
			uiSkin.htmltext.innerHTML =  "<span color='#222222' size='20'>已选择</span>" + "<span color='#FF0000' size='20'>0</span>" + "<span color='#222222' size='20'>张图片</span>";
			
			uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
			uiSkin.btnok.on(Event.CLICK,this,onConfirmSelect);

			EventCenter.instance.on(EventCenter.SELECT_FOLDER,this,onSelectChildFolder);
			EventCenter.instance.on(EventCenter.UPDATE_FILE_LIST,this,getFileList);
			
			EventCenter.instance.on(EventCenter.SELECT_PIC_ORDER,this,seletPicToOrder);
		}
		
		private function onConfirmSelect():void
		{
			// TODO Auto Generated method stub
			EventCenter.instance.event(EventCenter.ADD_PIC_FOR_ORDER);
			onCloseView();
		}
		
		private function onCloseView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_PIC_TO_ORDER);
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
				
				uiSkin.folderList.array = DirectoryFileModel.instance.topDirectList;
				uiSkin.picList.array = DirectoryFileModel.instance.curFileList;
				if(DirectoryFileModel.instance.topDirectList.length > 0)
				{
					//curDirect += (DirectoryFileModel.instance.topDirectList[0] as PicInfoVo).directName + "|";
					DirectoryFileModel.instance.curSelectDir = DirectoryFileModel.instance.topDirectList[0] as PicInfoVo;
					directTree.push(DirectoryFileModel.instance.curSelectDir);
					
					updateCurDirectLabel();
					//uiSkin.flder0.visible = true;
					//uiSkin.flder0.text = (DirectoryFileModel.instance.topDirectList[0] as PicInfoVo).directName + ">";
					(uiSkin.folderList.cells[0] as DirectFolderItem).ShowSelected = true;
					getFileList();
				}
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
				
			}
		}
	
		override public function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.SELECT_FOLDER,this,onSelectChildFolder);
			EventCenter.instance.off(EventCenter.UPDATE_FILE_LIST,this,getFileList);
			EventCenter.instance.off(EventCenter.SELECT_PIC_ORDER,this,seletPicToOrder);
		}
	
	
		private function onSlecteDirect(index:int):void
		{
			for each(var item:DirectFolderItem in uiSkin.folderList.cells)
			{
				item.ShowSelected = item.directData == uiSkin.folderList.array[index];
			}
			//(uiSkin.folderList.cells[index] as DirectFolderItem).ShowSelected = true;
			var picinfo:PicInfoVo =  uiSkin.folderList.array[index];
			//curDirect = picinfo.parentDirect + picinfo.directName + "|";
			DirectoryFileModel.instance.curSelectDir = picinfo;
			
			directTree = [];
			directTree.push(DirectoryFileModel.instance.curSelectDir);
			
			
			updateCurDirectLabel();
			getFileList();
			
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