package script.picUpload
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import ui.uploadpic.UpLoadItemUI;
	
	public class FileUpLoadItem extends UpLoadItemUI
	{
		public var fileobj:Object;
		public function FileUpLoadItem()
		{
			super();
		}
		
		public function setData(filedata:Object):void
		{
			fileobj = filedata;
			this.filename.text = filedata.name;
			this.prog.text = "0%";
			this.finishimg.visible = false;
			var mm:int =  Math.floor(filedata.size/(1024*1024));
			//var kk:Number = (filedata.size%(1024*1024))/1024;
			//var bytes:
			var sizestr:String = "";
			if(mm > 0)
				sizestr = (filedata.size/(1024*1024)).toFixed(2).toString() + "m";
			else
				sizestr = ((filedata.size/1024).toFixed(2)).toString() + "k";
			//this.prgbar.width = 0;
			this.filesize.text = sizestr;
			this.btncancel.on(Event.CLICK,this,onCancelUpload);
			updateProgress();
		}
		
		private function onCancelUpload():void
		{
			EventCenter.instance.event(EventCenter.CANCAEL_UPLOAD_ITEM,this);
		}
		public function updateProgress():void
		{
			if(fileobj == null)
				return;
			
			var pp:Number = Number(fileobj.progress);
			if(pp >= 100)
			{
				pp = 100;
				this.finishimg.visible = true;
				this.prog.visible = false;
			}
			else
				this.prog.visible = true;
			this.prgbar.width = pp/100 * 1084;
			this.prog.text = pp + "%";
		}
	}
}