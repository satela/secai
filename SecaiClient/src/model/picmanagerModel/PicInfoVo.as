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
		
		public var roadNum:int = 0;
		public var roadLength:int = 0;
		
		public var yixingFid:String = "";
		public var backFid:String = "";
		
		public var yixingPicClass:String = "";
		public var backPicClass:String = "";
		
		
		public var relatedRoadNum:int = 0;
		public var relatedRoadLength:int = 0;
		
		public var relatedPicWidth:int = 0;
		
		public var connectnum:int = 0;//连通域数量
		public var area:int = 0;//面积
		
		public var leftDeleteDays:int = 0;
		
		public var istiaofuValid:Boolean = false;
		
		public var iswhitebg:Boolean = false;
		//public var max
		
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
					
					yixingFid = fileinfo.fmaskid;
					backFid = fileinfo.fbackid;
					
					if(fileinfo.fdate != null)
					{
						var updatetime:Date = new Date(Date.parse(UtilTool.convertDateStr(fileinfo.fdate)));
						//updatetime.time = Date.parse(UtilTool.convertDateStr(fileinfo.fdate));
						
						var passtime:int = Math.ceil(((new Date()).getTime() - updatetime.getTime() + 8 * 3600 * 1000)/(3600*24*1000));
						
						leftDeleteDays = 30 - passtime;
						if(leftDeleteDays < 0)
							leftDeleteDays = 0;
					}
					
					if(fattr.hasOwnProperty("whitebg") && fattr.hasOwnProperty("vsize") && fattr.hasOwnProperty("hsize"))
					{
						iswhitebg = fattr.whitebg;
						if(iswhitebg)
						{
							var longside:Number = Math.max(picWidth,picHeight);

							if(this.picHeight > this.picWidth)
							{
								var hside:Number = (fattr.hsize/this.picWidth)*longside/1000*this.picPhysicWidth;
								if(hside <= 51)
									istiaofuValid = true;
							}
							else
							{
								var vside:Number = (fattr.vsize/this.picHeight)*longside/1000*this.picPhysicHeight;
								if(hside <= 51)
									istiaofuValid = true;
							}
						}
						
					}
					if(fattr.hasOwnProperty("roadnum")) 
					{
						roadNum = fattr.roadnum;
						var longside:Number = Math.max(picWidth,picHeight);
						roadLength = Math.floor( fattr.totallen * longside/1000);
						//trace("raodNum:" + roadNum + "," + roadLength);
					}
					if(fattr.hasOwnProperty("connectnum"))
					{
						connectnum = fattr.connectnum;
						var longside:Number = Math.max(picWidth,picHeight);

						area = Math.floor(fattr.area *  longside/1000 * longside/1000)/(picWidth*picHeight) * picPhysicWidth * picPhysicHeight/10000;
						//trace("connectnum:" + connectnum + "," + area);
					}
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
				if(isCdr)
					picClass = "zip";
				
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
		
		public function initYixingData():void
		{
			if(yixingFid != "0")
			{
				var info:Array = DirectoryFileModel.instance.getQiegeData(yixingFid);
				
				this.relatedRoadNum = info[0];
				this.relatedRoadLength = info[1];
				this.relatedPicWidth = info[2];
				this.yixingPicClass = info[3];

			}
			
			if(backFid != "0")
			{
				var info:Array = DirectoryFileModel.instance.getQiegeData(backFid);
								
				this.backPicClass = info[3];
				
			}
		}
		public function get dpath():String
		{
			return parentDirect + directId + "|";
		}
	}
}