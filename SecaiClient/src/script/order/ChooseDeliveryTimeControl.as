package script.order
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PicOrderItemVo;
	
	import script.ViewManager;
	
	import ui.order.ChooseDeliveryTimePanelUI;
	
	public class ChooseDeliveryTimeControl extends Script
	{
		private var uiSkin:ChooseDeliveryTimePanelUI;
		
		private var param:Object;
		
		private var orderDatas:Array;
		public function ChooseDeliveryTimeControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ChooseDeliveryTimePanelUI;
			
			uiSkin.orderlist.itemRender = ChooseDelTimeOrderItem;
			uiSkin.orderlist.selectEnable = false;
			uiSkin.orderlist.spaceY = 2;
			uiSkin.orderlist.renderHandler = new Handler(this, updateOrderItem);
			
			uiSkin.cancelbtn.on(Event.CLICK,this,onCloseView);
			
			orderDatas = param as Array;
			
			uiSkin.orderlist.array = orderDatas;
			//uiSkin.
			
			
		}
		
		private function onCloseView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_CHOOSE_DELIVERY_TIME_PANEL);
		}
		private function updateOrderItem(cell:ChooseDelTimeOrderItem):void
		{
			cell.setData(cell.dataSource);
		}
		
		private function updateTotalPrice():void
		{
			
		}
	}
}