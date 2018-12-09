package script.picUpload
{
	import ui.uploadpic.UpLoadItemUI;
	
	public class FileUpLoadItem extends UpLoadItemUI
	{
		public function FileUpLoadItem()
		{
			super();
		}
		
		public function setData(filedata:Object):void
		{
			this.filename.text = filedata.name;
			this.prog.text = "0%";
			
			var mm:int =  Math.floor(filedata.size/(1024*1024));
			//var kk:Number = (filedata.size%(1024*1024))/1024;
			//var bytes:
			var sizestr:String = "";
			if(mm > 0)
				sizestr = (filedata.size/(1024*1024)).toFixed(2).toString() + "m";
			else
				sizestr = ((filedata.size/1024).toFixed(2)).toString() + "k";
			this.prgbar.value = 0;
			this.filesize.text = sizestr;
		}
	}
}