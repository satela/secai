package script.picUpload
{
	
	import laya.events.Event;
	
	import ui.picManager.DirectItemUI;
	
	public class DirectFolderItem extends DirectItemUI
	{
		private var isSeleted:Boolean = false;
		public function DirectFolderItem()
		{
			super();
		}
		
		public function setData(filedata:Object):void
		{
			this.foldname.text = filedata as String;
			
			this.on(Event.MOUSE_OVER,this,onMouseOver);
			this.on(Event.MOUSE_OUT,this,onMouseOut);
			//this.on(Event.CLICK,this,onMouseClick);

		}
		
		
		
		public function set ShowSelected(value:Boolean):void
		{
			isSeleted = value;
			if(value)
				this.foldname.color = "#FF0000";
			else				
				this.foldname.color = "#FFFFFF";

		}
		private function onMouseOut():void
		{
			if(isSeleted)
				return;
			// TODO Auto Generated method stub
			this.foldname.color = "#FFFFFF";

		}
		
		private function onMouseOver():void
		{
			if(isSeleted)
				return;
			// TODO Auto Generated method stub
			this.foldname.color = "#FF0000";
		}
	}
}