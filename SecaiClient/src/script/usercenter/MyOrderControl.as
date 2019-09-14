package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	
	import ui.usercenter.MyOrdersPanelUI;
	
	public class MyOrderControl extends Script
	{
		private var uiSkin:MyOrdersPanelUI;
		public function MyOrderControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as MyOrdersPanelUI;
			
			uiSkin.orderList.itemRender = OrderCheckListItem;
			
			uiSkin.orderList.vScrollBarSkin = "";
			uiSkin.orderList.repeatX = 1;
			uiSkin.orderList.spaceY = 2;
			
			uiSkin.orderList.renderHandler = new Handler(this, updateOrderList);
			uiSkin.orderList.selectEnable = false;
			uiSkin.orderList.array = [];
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.checkOrderList,this,onGetOrderListBack,null,"post");
			EventCenter.instance.on(EventCenter.PAY_ORDER_SUCESS,this,onRefreshOrder);

		}
		
		private function onRefreshOrder():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.checkOrderList,this,onGetOrderListBack,null,"post");
		}
		private function onGetOrderListBack(data:Object):void
		{
			if (data == null || data == "")
				return;
			
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				uiSkin.orderList.array = (result.orders as Array).reverse();
			}
		}
		public function updateOrderList(cell:OrderCheckListItem):void
		{
			cell.setData(cell.dataSource);
		}
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.PAY_ORDER_SUCESS,this,onRefreshOrder);

		}
	}
}