package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.orderModel.PaintOrderModel;
	import model.users.AddressVo;
	
	import script.ViewManager;
	
	import ui.order.SelectAddressPanelUI;
	
	public class SelectAddressControl extends Script
	{
		private var uiSkin:SelectAddressPanelUI;
		
		public function SelectAddressControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as SelectAddressPanelUI;
			
			uiSkin.list_address.itemRender = SelAddressItem;
			uiSkin.list_address.vScrollBarSkin = "";
			uiSkin.list_address.selectEnable = true;
			uiSkin.list_address.spaceY = 2;
			uiSkin.list_address.renderHandler = new Handler(this, updateAddressItem);
			
			uiSkin.list_address.selectHandler = new Handler(this,onSlecteAddress);
			
			uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
			uiSkin.btnok.on(Event.CLICK,this,onConfirmSelectAddress);
			
			var arr:Array = [];
			for(var i:int=0;i < 20;i++)
			{
				var address:AddressVo = new AddressVo();
				address.city = "浦东新区" + i;
				arr.push(address);
			}
			uiSkin.list_address.array = arr;
			PaintOrderModel.instance.selectAddress = null;
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
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_ADDRESS);
		}
	}
}