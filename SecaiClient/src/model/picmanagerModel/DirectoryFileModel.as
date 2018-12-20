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
		public static function get instance():DirectoryFileModel
		{
			if(_instance == null)
				_instance = new DirectoryFileModel();
			return _instance;
		}
		
		public function DirectoryFileModel()
		{
			directoryList = [];
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
		}
		
	}
}