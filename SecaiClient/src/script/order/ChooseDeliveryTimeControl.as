package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PicOrderItemVo;
	
	import script.ViewManager;
	
	import ui.order.ChooseDeliveryTimePanelUI;
	
	public class ChooseDeliveryTimeControl extends Script
	{
		private var uiSkin:ChooseDeliveryTimePanelUI;
		
		private var param:Object;
		
		private var orderDatas:Array;
		
		private var delaypay:Boolean = false;
		
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
			
			uiSkin.savebtn.on(Event.CLICK,this,onSaveOrder);
			uiSkin.paybtn.on(Event.CLICK,this,onPayOrder);
			uiSkin.closebtn.on(Event.CLICK,this,onGiveUpOrder);

			orderDatas = param.orders as Array;
			delaypay = param.delaypay;
			
			uiSkin.savebtn.visible = !delaypay;
			
			uiSkin.orderlist.array = orderDatas;
			
			var total:Number = 0;
			for(var i:int=0;i < orderDatas.length;i++)
			{
				var ordermoney:Number = Number(orderDatas[i].item_priceStr) * Number(orderDatas[i].item_number);
				
				ordermoney = parseFloat(ordermoney.toFixed(1));

				total += ordermoney;
			}
			
			uiSkin.rawprice.text = total.toFixed(1) + "元";
			uiSkin.disountprice.text = total.toFixed(1) + "元";

			
			Laya.timer.loop(1000,this,onCountDownTime);
			
			EventCenter.instance.on(EventCenter.UPDATE_PRICE_BY_DELIVERYDATE,this,updatePrice);
			//uiSkin.
			
			
		}
		
		private function onCountDownTime():void
		{
			var arr:Array = orderDatas;
			for(var i:int=0;i < orderDatas.length;i++)
			{
				if(orderDatas[i].is_urgent == 1  ||  orderDatas[i].delivery_date != null)
				{
					if(orderDatas[i].lefttime > 0)
					{
						orderDatas[i].lefttime--;
						if(orderDatas[i].lefttime == 0)
						{
							orderDatas[i].is_urgent = 0;
							orderDatas[i].delivery_date = null;
							orderDatas[i].outtime = true;
							retryGetAvailableDate(orderDatas[i]);
						}
					}
				}
			}
		}
		
		private function retryGetAvailableDate(orderdata:Object):void
		{
				
			var datas:String = PaintOrderModel.instance.getSingleOrderItemCapcaityData(orderdata);
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDeliveryTimeList,this,ongetAvailableDateBack,{data:datas},"post");

		}
		
		private function ongetAvailableDateBack(data:*):void
		{
			if(this.destroyed)
				return;
			
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				var alldates:Array = result as Array;
				for(var i:int=0;i < alldates.length;i++)
				{
					
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn] = {};
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].canUrgent = false;
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList = [];
					
					for(var j:int=0;j < alldates[i].deliveryDateList.length;j++)
					{
						if(alldates[i].deliveryDateList[j].urgent == false)
						{
							if(alldates[i].deliveryDateList[j].discount == 0)
								alldates[i].deliveryDateList[j].discount = 1;
							
							PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList.push(alldates[i].deliveryDateList[j]);
						}
						else
						{
							if(alldates[i].deliveryDateList[j].discount == 0)
								alldates[i].deliveryDateList[j].discount = 1;
							PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].urgentDate = alldates[i].deliveryDateList[j];
						}
					}	
					
					for(var j:int=0;j < uiSkin.orderlist.cells.length;j++)
					{
						if((uiSkin.orderlist.cells[j] as ChooseDelTimeOrderItem).orderdata.orderItem_sn == alldates[i].orderItem_sn)
						{
							(uiSkin.orderlist.cells[j] as ChooseDelTimeOrderItem).resetDeliveryDates;
							break;
						}
					}
					
				}
				
				
			}
		}
		
		private function updatePrice():void
		{
			var total:Number = 0;
			for(var i:int=0;i < orderDatas.length;i++)
			{
				var ordermoney:Number = Number(orderDatas[i].item_priceStr) * Number(orderDatas[i].item_number);
				
				if(orderDatas[i].is_urgent == 1 || orderDatas[i].delivery_date != null)
				{
					ordermoney = ordermoney*orderDatas[i].discount;
					
				}
				ordermoney = parseFloat(ordermoney.toFixed(1));
				total += ordermoney;
			}
			
			uiSkin.disountprice.text = total.toFixed(1) + "元";
		}
		private function onPayOrder():void
		{
			//trace("oderdara:" + JSON.stringify(PaintOrderModel.instance.finalOrderData));
			
			var arr:Array = getOrderData();
			if(arr == null)
				return;
			
			if(delaypay)
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.updateOrder,this,onUpdateOrderBack,{data:JSON.stringify(arr)},"post");
			else				
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.placeOrder,this,onPlaceOrderBack,{data:JSON.stringify(arr)},"post");

		}
		
		private function onUpdateOrderBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				var totalmoney:Number = 0;
				var allorders:Array = [];
				for(var i:int=0;i < result.orders.length;i++)
				{
					var orderdata:Object = JSON.parse(result.orders[i]);
					totalmoney += Number(orderdata.money_paidStr);
					allorders.push(orderdata.order_sn);
				}
				ViewManager.instance.openView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL,false,{amount:Number(totalmoney.toFixed(2)),orderid:allorders});
				
			}
		}
		private function onPlaceOrderBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				//ViewManager.showAlert("下单成功");
				var totalmoney:Number = 0;
				var allorders:Array = [];
				for(var i:int=0;i < result.orders.length;i++)
				{
					var orderdata:Object = JSON.parse(result.orders[i]);
					totalmoney += Number(orderdata.money_paidStr);
					allorders.push(orderdata.order_sn);
				}
				ViewManager.instance.openView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL,false,{amount:Number(totalmoney.toFixed(2)),orderid:allorders});
				
			}
		}
		
		private function getOrderData():Array
		{
			var manuarr:Array = PaintOrderModel.instance.finalOrderData;
			
			for(var i:int=0;i < manuarr.length;i++)
			{
				var itemlist:Array = manuarr[i].orderItemList;
				var totalprice:Number = 0;
				for(var j:int=0;j < itemlist.length;j++)
				{
					if(itemlist[j].is_urgent == null || (itemlist[j].is_urgent == false && itemlist[j].delivery_date == null))
					{
						ViewManager.showAlert("有产品未设置交货时间");
						return null;
					}
					
					var ordermoney:Number = Number(itemlist[j].item_priceStr) * Number(itemlist[j].item_number) * itemlist[j].discount;
					
					ordermoney = parseFloat(ordermoney.toFixed(1));
					totalprice += ordermoney;
					
					//delete itemlist[j].outtime;
					//delete itemlist[j].lefttime;
					//delete itemlist[j].discount;
					
					
				}
				manuarr[i].order_amountStr = totalprice;
				
				
				if( (manuarr[i].order_amountStr as Number) < 2)
				{
					manuarr[i].order_amountStr = 2.00;
					//var itemarr:Array = odata.orderItemList;
					if(itemlist.length > 0)
					{
						var eachprice:Number = Number((2/itemlist.length).toFixed(2));
						
						var overflow:Number = 2 - eachprice*itemlist.length;
						for(var j:int=0;j < itemlist.length;j++)
						{
							if(j==0)
								itemlist[j].item_priceStr = (((eachprice + overflow)/itemlist[j].item_number) as Number).toFixed(2);
							else
								itemlist[j].item_priceStr =  ((eachprice/itemlist[j].item_number) as Number).toFixed(2);
						}
					}									
					
				}
				manuarr[i].money_paidStr = (manuarr[i].order_amountStr as Number).toFixed(1);
				manuarr[i].order_amountStr = (manuarr[i].order_amountStr as Number).toFixed(1);
			}
			
			for(var i:int=0;i < manuarr.length;i++)
			{
				var itemlist:Array = manuarr[i].orderItemList;
				for(var j:int=0;j < itemlist.length;j++)
				{										
					delete itemlist[j].outtime;
					delete itemlist[j].discount;
										
				}
			}
			var arr:Array = PaintOrderModel.instance.finalOrderData;
			
			return arr;
		}
		private function onSaveOrder():void
		{
			if(Userdata.instance.companyShort == null)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo ,this,function(data:Object){
					
					if(this.destroyed)
						return;
					var result:Object = JSON.parse(data as String);
					
					if(result.status == 0)
					{
						Userdata.instance.company = result.name;
						Userdata.instance.companyShort = result.shortname;
					}
					
					onSaveOrder();		
				}
					,null,"post");	
				
				return;
			}
			
			var arr:Array = PaintOrderModel.instance.finalOrderData;
			if(arr == null)
				return;
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.placeOrder,this,onSaveOrderBack,{data:JSON.stringify(arr)},"post");
		}
		
		private function onSaveOrderBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				ViewManager.showAlert("保存订单成功，您可以到我的订单继续支付");
				ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
				
			}
		}
		
		private function onGiveUpOrder():void
		{
			if(!delaypay)
				ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"确定关闭页面不保存订单吗？",caller:this,callback:confirmClose,ok:"确定",cancel:"取消"});
			else
			{
				ViewManager.instance.closeView(ViewManager.VIEW_CHOOSE_DELIVERY_TIME_PANEL);
				
			}

		}
		
		private function confirmClose(b:Boolean):void
		{
			if(b)
			{
				ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
			}
		}
		private function onCloseView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_CHOOSE_DELIVERY_TIME_PANEL);
		}
		private function updateOrderItem(cell:ChooseDelTimeOrderItem):void
		{
			cell.setData(cell.dataSource);
		}
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.UPDATE_PRICE_BY_DELIVERYDATE,this,updatePrice);

		}
	}
}