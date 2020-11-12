package model.picmanagerModel
{
	import eventUtil.EventCenter;
	
	import model.HttpRequestUtil;
	
	import utils.UtilTool;
	
	public class DirectoryFileModel
	{
		private static var _instance:DirectoryFileModel;
		
		public var topDirectList:Array = [];//一级目录
		public var directoryList:Array;
		
		public var curFileList:Array = [];
		
		public var curSelectDir:PicInfoVo;
		
		public var haselectPic:Object = {};
		
		public var rootDir:PicInfoVo;
		
		public var curOperateFile:PicInfoVo;
		public var curOperateSelType:int = 0; //0选择异形 1 选择反面

		public static function get instance():DirectoryFileModel
		{
			if(_instance == null)
				_instance = new DirectoryFileModel();
			return _instance;
		}
		
		public function DirectoryFileModel()
		{
			rootDir = new PicInfoVo({dname:"根目录",dpath:"",did:"0"},0);
		}
		
		//一级目录
		public function initTopDirectoryList(dirInfo:Object):void
		{
			topDirectList = [];
			var dirList:Array = dirInfo.dirs;
			for(var i:int=0;i < dirList.length;i++)
			{
				topDirectList.push(new PicInfoVo(dirList[i],0));
			}
			var picList:Array = dirInfo.files;
			for( i=0;i < picList.length;i++)
			{
				topDirectList.push(new PicInfoVo(picList[i],1));
			}
		}
		
		public function addNewTopDir(dir:Object):void
		{
			topDirectList.push(new PicInfoVo(dir,0));
		}
		
		public function initCurDirFiles(fileinfo:Object):void
		{
			curFileList = [];
			
			var dirList:Array = fileinfo.dirs;
			for(var i:int=0;i < dirList.length;i++)
			{
				curFileList.push(new PicInfoVo(dirList[i],0));
			}
			
			var picList:Array = fileinfo.files;
			for( i=0;i < picList.length;i++)
			{
				curFileList.push(new PicInfoVo(picList[i],1));
			}
			
			for( i=0;i < curFileList.length;i++)
			{
				curFileList[i].initYixingData();
			}
			for(var picfid in haselectPic)
			{
				for( var j:int=0;j < curFileList.length;j++)
				{
					if(curFileList[j].fid == picfid)
						haselectPic[picfid] = curFileList[j];
				}
				
			}
			
		}
		
		public function getQiegeData(fid:String):Array
		{
			var curfiles:Array = this.curFileList;
			if(curfiles != null)
			{
				for(var i:int=0;i < curfiles.length;i++)
				{
					if(curfiles[i].fid == fid)
					{
						return [curfiles[i].roadNum,curfiles[i].roadLength,curfiles[i].picWidth,curfiles[i].picClass];
					}
				}
			}
			
			return [0,0];
		}
		
		public function setYingxingImg(picInfo:PicInfoVo):void
		{
			var num:int = 0;
			
			if(curOperateFile != null && !haselectPic.hasOwnProperty(curOperateFile.fid))
			{
				haselectPic[curOperateFile.fid] = curOperateFile;
			}
			for each(var picvo in haselectPic)
			{
				trace("nums:" + num++);
				if(DirectoryFileModel.instance.curOperateSelType == 0 && UtilTool.isFitYixing(picvo,picInfo) && picvo.yixingFid == "0")
				{
					//trace("sel fid:" + this.picInfo.fid);
					
					var params:String = "fid=" + picvo.fid + "&fmaskid=" + picInfo.fid;							
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.setYixingRelated,this,onSetRelatedBack,params,"post");
					
					DirectoryFileModel.instance.curOperateFile = null;
					///EventCenter.instance.event(EventCenter.STOP_SELECT_RELATE_PIC);
					
				}
				else if(DirectoryFileModel.instance.curOperateSelType == 1 && UtilTool.isFitFanmain(picvo,picInfo) && picvo.backFid == "0")
				{
					//trace("sel fid:" + this.picInfo.fid);
				
					var params:String = "fid=" + picvo.fid + "&fbackid=" + picInfo.fid;							
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.setFanmianRelated,this,onSetRelatedBack,params,"post");
					
					DirectoryFileModel.instance.curOperateFile = null;
					//EventCenter.instance.event(EventCenter.STOP_SELECT_RELATE_PIC);
					
				}
			}
		}
		
		private function onSetRelatedBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				trace("设置成功");
				//ViewManager.showAlert("设置成功");
				EventCenter.instance.event(EventCenter.UPDATE_FILE_LIST);
				
			}
		}
		
	}
}