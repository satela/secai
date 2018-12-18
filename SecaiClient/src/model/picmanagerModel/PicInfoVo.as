package model.picmanagerModel
{
	public class PicInfoVo
	{
		public var picType:int = 0;// 0 目录 1 图片
		
		public var directName:String = "";//目录名 全目录 类似 1|2|3
		
		public var parentDirect:String = "";
		
		public var directId:String = "";

		public var fid:String = "";
		
		public var picWidth:int;
		public var picHeight:int;
		
		public var colorType:String = "";
		
		public var picClass:String = "";
		public var dpi:Number;
		
		
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
				var fattr:Object = JSON.parse(fileinfo.fattr);
				picWidth = fattr.width;
				picHeight = fattr.height;
				dpi = fattr.dpi;
				picClass = fileinfo.ftype;
				
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