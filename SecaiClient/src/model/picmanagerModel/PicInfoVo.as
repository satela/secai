package model.picmanagerModel
{
	import utils.UtilTool;

	public class PicInfoVo
	{
		public var picType:int = 0;// 0 目录 1 图片
		
		public var directName:String = "";//目录名 全目录 类似 1|2|3
		
		public var parentDirect:String = "";
		
		public var directId:String = "";

		public var fid:String = "";
		
		public var picWidth:int;
		public var picHeight:int;
		
		public var picPhysicWidth:Number = 0;
		public var picPhysicHeight:Number = 0;
		
		public var colorspace:String = "";
		
		public var picClass:String = "";
		public var dpi:Number;
		public var isProcessing:Boolean = false;
		
		public var isCdr:Boolean = false;
		
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
				try
				{
					var fattr:Object = JSON.parse(fileinfo.fattr);
					picWidth = Number(fattr.width);
					picHeight = Number(fattr.height);
					colorspace = fattr.colorspace;
					dpi = UtilTool.oneCutNineAdd(fattr.dpi);
					picPhysicWidth = UtilTool.oneCutNineAdd(picWidth/dpi*2.54);
					picPhysicHeight = UtilTool.oneCutNineAdd(picHeight/dpi*2.54);
					
					if(fattr != null && fattr.flag == 1)
					{
						picWidth = Math.round(Number(fattr.width)*dpi);
						picHeight =  Math.round(Number(fattr.height)*dpi);
						
						picPhysicWidth = UtilTool.oneCutNineAdd(fattr.width*2.54);
						picPhysicHeight = UtilTool.oneCutNineAdd(fattr.height*2.54);
						isCdr = true;
					}
				}
				catch(err:Error)
				{
					isProcessing = true;
				}

				picClass = fileinfo.ftype;
				
				if(fattr != null && fattr.flag == 1)
				{
					directName = fileinfo.fname;
					var strs:Array = directName.split(".");
					 strs.splice(strs.length - 1,1);
					 directName = strs.join() + ".cdr";
				}
				else
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