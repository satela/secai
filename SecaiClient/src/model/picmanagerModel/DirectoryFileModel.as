package model.picmanagerModel
{
	
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
						return [curfiles[i].roadNum,curfiles[i].roadLength,curfiles[i].picWidth,curfiles[i].dpi];
					}
				}
			}
			
			return [0,0];
		}
		
	}
}