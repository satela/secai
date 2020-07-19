package script.characterpaint
{
	import laya.components.Script;
	
	import ui.characterpaint.CharacterPaintUI;
	
	public class CharacterMainControl extends Script
	{
		private var uiSkin:CharacterPaintUI;
		
		public function CharacterMainControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as CharacterPaintUI;
			
			uiSkin.panel_main.vScrollBarSkin = "";
			uiSkin.panel_main.hScrollBarSkin = "";
			
		}
	}
}