package model.picmanagerModel
{
	public class PicInfoVo
	{
		public var picType:int = 0;// 0 目录 1 图片
		
		public var directName:String = "";//目录名 全目录 类似 1|2|3
		
		public var parentDirect:String = "";
		
		public var directId:String = "";

		public var fid:String = "";
		
		public function PicInfoVo(fileinfo:Object,dtype:int)
		{
			picType = dtype;
			if(picType == 0)
			{
				directName = fileinfo.dname;
				parentDirect = fileinfo.dpath;
				directId = fileinfo.did;
			}
			else
			{
				fid = fileinfo.fid;
				
				directName = fileinfo.fname;
				parentDirect = fileinfo.fpath;
				
			}
		}
		
		public function get dpath():String
		{
			return parentDirect + directId + "|";
		}
	}
}