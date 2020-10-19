package script.usercenter
{
	import laya.components.Script;
	
	import ui.usercenter.TransactionPanelUI;
	
	public class TransactionControl extends Script
	{
		private var uiSkin:TransactionPanelUI;

		public function TransactionControl()
		{
			super();
		}
		
		
		override public function onStart():void
		{
			uiSkin = this.owner as TransactionPanelUI;
			
		}
	}
}