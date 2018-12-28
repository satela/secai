package script.prefabScript
{
	//import flash.ui.MouseCursor;
	
	import laya.components.Script;
	import laya.display.Text;
	import laya.events.Event;
	import laya.utils.Mouse;
	
	public class LinkTextControl extends Script
	{
		private var txt:Text;
		
		/** @prop {name:undercolor,tips:"下划线颜色",type:String}*/
		public var undercolor:String = "#222222";
		public function LinkTextControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			txt = this.owner as Text;
			txt.underline = true;
			txt.underlineColor = undercolor;
			
			txt.on(Event.MOUSE_OVER,this,onMouseOverHandler);
			txt.on(Event.MOUSE_OUT,this,onMouseOutHandler);

		}
		
		private function onMouseOutHandler():void
		{
			// TODO Auto Generated method stub
			Mouse.cursor = "auto";

		}
		
		private function onMouseOverHandler():void
		{
			// TODO Auto Generated method stub
			Mouse.cursor = "hand";
		}
	}
}