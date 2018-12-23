package script.order
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.orderModel.MatetialClassVo;
	
	import script.ViewManager;
	
	import ui.order.SelectMaterialPanelUI;
	
	public class SelectMaterialControl extends Script
	{
		private var uiSkin:SelectMaterialPanelUI;
		public function SelectMaterialControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as SelectMaterialPanelUI; 
			
			uiSkin.tablist.itemRender = MaterialClassBtn;
			uiSkin.tablist.vScrollBarSkin = "";
			uiSkin.tablist.selectEnable = true;
			uiSkin.tablist.spaceY = 2;
			uiSkin.tablist.renderHandler = new Handler(this, updateMatClassItem);
			
			uiSkin.tablist.selectHandler = new Handler(this,onSlecteMatClass);
			
			uiSkin.matlist.itemRender = MaterialItem;
			uiSkin.matlist.vScrollBarSkin = "";
			uiSkin.matlist.selectEnable = true;
			uiSkin.matlist.spaceY = 10;
			uiSkin.matlist.renderHandler = new Handler(this, updateMatNameItem);
			
			uiSkin.matlist.selectHandler = new Handler(this,onSlecteMat);
			
			var arr:Array = [];
			for(var i:int=0;i < 10;i++)
			{
				arr.push(new MatetialClassVo());
			}
			uiSkin.tablist.array = arr;
			uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
			uiSkin.btnok.on(Event.CLICK,this,onConfirmSelectAddress);
		}
		
		private function updateMatClassItem(cell:MaterialClassBtn):void
		{
			cell.setData(cell.dataSource);
		}
		private function onSlecteMatClass(index:int):void
		{
			for each(var item:MaterialClassBtn in uiSkin.tablist.cells)
			{
				item.ShowSelected = item.matclassvo == uiSkin.tablist.array[index];
			}
			
			uiSkin.matlist.array = (uiSkin.tablist.array[index] as MatetialClassVo).childMatList;
		}
		
		private function updateMatNameItem(cell:MaterialItem):void
		{
			cell.setData(cell.dataSource);
		}
		private function onSlecteMat(index:int):void
		{
			for each(var item:MaterialItem in uiSkin.matlist.cells)
			{
				item.ShowSelected = item.matvo == uiSkin.matlist.array[index];
			}
		}
		
		private function onConfirmSelectAddress(index:int):void
		{
			// TODO Auto Generated method stub
			onCloseView();
		}
		
		private function onCloseView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_MATERIAL);
		}
	}
}