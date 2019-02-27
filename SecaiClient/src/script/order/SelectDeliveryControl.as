package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.orderModel.DeliveryTypeVo;
	import model.orderModel.PaintOrderModel;
	
	import script.ViewManager;
	
	import ui.order.SelectDeliveryPanelUI;
	
	public class SelectDeliveryControl extends Script
	{
		private var uiSkin:SelectDeliveryPanelUI;
		
		public var param:Object;
		public function SelectDeliveryControl()
		{
			super();
		}
		override public function onStart():void
		{
			uiSkin = this.owner as SelectDeliveryPanelUI;
			
			uiSkin.list_delivery.itemRender = DeliveryTypeItem;
			uiSkin.list_delivery.vScrollBarSkin = "";
			uiSkin.list_delivery.selectEnable = true;
			uiSkin.list_delivery.spaceY = 8;
			uiSkin.list_delivery.renderHandler = new Handler(this, updateAddressItem);
			
			uiSkin.list_delivery.selectHandler = new Handler(this,onSlecteDelivery);
			
			//			var temparr:Array = [];
			//			var addrs:Array = ["130921100","210905002","371323"];
			//			for(var i:int=0;i < 3;i++)
			//			{
			//				var fvo:FactoryInfoVo = new FactoryInfoVo({addr:addrs[i],name:"测试地址1"});
			//				temparr.push(fvo);
			//			}
			uiSkin.list_delivery.array = [];
			
			uiSkin.cancelbtn.on(Event.CLICK,this,onCloseView);
			uiSkin.okbtn.on(Event.CLICK,this,onConfirmSelectAddress);
			
			if(param != null)
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDeliveryList + param + "&addr_id=" + PaintOrderModel.instance.selectAddress.searchZoneid,this,onGetDeliveryBack,null,null);

		}
		
		private function onGetDeliveryBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				PaintOrderModel.instance.deliveryList = [];
				for(var i:int=0;i < result.length;i++)
				{
					PaintOrderModel.instance.deliveryList.push(new DeliveryTypeVo(result[i]));
				}
				uiSkin.list_delivery.array = PaintOrderModel.instance.deliveryList;
			}
		}
		
		private function onSlecteDelivery(index:int):void
		{
			// TODO Auto Generated method stub
			for each(var item:DeliveryTypeItem in uiSkin.list_delivery.cells)
			{
				item.ShowSelected = item.deliveryVo == uiSkin.list_delivery.array[index];
			}
			PaintOrderModel.instance.selectDelivery = uiSkin.list_delivery.array[index];
		}
		
		private function updateAddressItem(cell:SelAddressItem):void
		{
			cell.setData(cell.dataSource);
		}
		
		private function onConfirmSelectAddress(index:int):void
		{
			// TODO Auto Generated method stub
			if(PaintOrderModel.instance.selectDelivery != null)
				EventCenter.instance.event(EventCenter.SELECT_DELIVERY_TYPE);
			onCloseView();
		}
		
		private function onCloseView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_DELIVERY_TYPE);
		}
	}
}