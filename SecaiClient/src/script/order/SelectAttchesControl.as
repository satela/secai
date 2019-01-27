package script.order
{
	import laya.components.Script;
	import laya.utils.Handler;
	
	import ui.order.SelectAttachPanelUI;
	
	public class SelectAttchesControl extends Script
	{
		private var uiSkin:SelectAttachPanelUI;
		public function SelectAttchesControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as SelectAttachPanelUI; 
			
			uiSkin.attachCatList.itemRender = MaterialClassBtn;
			uiSkin.attachCatList.vScrollBarSkin = "";
			uiSkin.attachCatList.selectEnable = true;
			uiSkin.attachCatList.spaceY = 2;
			uiSkin.attachCatList.renderHandler = new Handler(this, updateAttachClassItem);
			
			uiSkin.attachCatList.selectHandler = new Handler(this,onSlecteAttachCat);
			
			uiSkin.attchesList.itemRender = MaterialItem;
			uiSkin.attchesList.vScrollBarSkin = "";
			uiSkin.attchesList.selectEnable = true;
			uiSkin.attchesList.spaceY = 10;
			uiSkin.attchesList.renderHandler = new Handler(this, updateMatNameItem);
			
			//uiSkin.matlist.selectHandler = new Handler(this,onSlecteMat);
		}
		
		private function updateAttachClassItem():void
		{
			
		}
		
		private function onSlecteAttachCat(index:int):void
		{
			
		}
		
		private function updateMatNameItem():void
		{
			
		}
	}
}