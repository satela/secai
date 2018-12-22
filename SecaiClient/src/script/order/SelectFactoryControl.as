package script.order
{
	
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.orderModel.PaintOrderModel;
	
	import script.ViewManager;
	
	import ui.order.SelectFactoryPanelUI;
	
	public class SelectFactoryControl extends Script
	{
		private var uiSkin:SelectFactoryPanelUI;
		
		public function SelectFactoryControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as SelectFactoryPanelUI;
			
			uiSkin.list_address.itemRender = SelAddressItem;
			uiSkin.list_address.vScrollBarSkin = "";
			uiSkin.list_address.selectEnable = true;
			uiSkin.list_address.spaceY = 2;
			uiSkin.list_address.renderHandler = new Handler(this, updateAddressItem);
			
			uiSkin.list_address.selectHandler = new Handler(this,onSlecteAddress);
			
			
			uiSkin.cancelbtn.on(Event.CLICK,this,onCloseView);
			uiSkin.okbtn.on(Event.CLICK,this,onConfirmSelectAddress);
		}
		
		private function onSlecteAddress(index:int):void
		{
			// TODO Auto Generated method stub
			for each(var item:SelAddressItem in uiSkin.list_address.cells)
			{
				item.ShowSelected = item.address == uiSkin.list_address.array[index];
			}
			//(uiSkin.list_address.cells[index] as SelAddressItem).ShowSelected = true;
			PaintOrderModel.instance.selectAddress = uiSkin.list_address.array[index];
		}
		
		private function updateAddressItem(cell:SelAddressItem):void
		{
			cell.setData(cell.dataSource);
		}
		
		private function onConfirmSelectAddress(index:int):void
		{
			// TODO Auto Generated method stub
			if(PaintOrderModel.instance.selectAddress != null)
				EventCenter.instance.event(EventCenter.SELECT_ORDER_ADDRESS);
			onCloseView();
		}
		
		private function onCloseView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_FACTORY);
		}
	}
}