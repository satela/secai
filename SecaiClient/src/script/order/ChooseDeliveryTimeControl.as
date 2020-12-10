package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.Constast;
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.orderModel.OrderConstant;
	import model.orderModel.PackageVo;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PicOrderItemVo;
	
	import script.ViewManager;
	
	import ui.order.ChooseDeliveryTimePanelUI;
	
	import utils.UtilTool;
	
	public class ChooseDeliveryTimeControl extends Script
	{
		private var uiSkin:ChooseDeliveryTimePanelUI;
		
		private var param:Object;
		
		private var orderDatas:Array;
		
		private var delaypay:Boolean = false;
		
		private var requestnum:int = 0;
		
		private var curclicknum:int = 0;
		
		private var FORBIDTIME:Array = [0,30000,60000,180000];
		
		private var canoccypay:Boolean = true;
		
		private var leftforbidtime:int = 0;
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
			
			uiSkin.timepreferRdo.selectedIndex = PaintOrderModel.instance.curTimePrefer - 1;
			
			//uiSkin.confirmpreferbtn.on(Event.CLICK,this,resetTimePrefer);
			uiSkin.setdefaultbtn.on(Event.CLICK,this,setDefaultTimePrefer);
			uiSkin.timepreferRdo.on(Event.CHANGE,this,resetTimePrefer);

			var total:Number = 0;
			for(var i:int=0;i < orderDatas.length;i++)
			{
				var ordermoney:Number = Number(orderDatas[i].item_priceStr) * Number(orderDatas[i].item_number);
				
				ordermoney = parseFloat(ordermoney.toFixed(1));

				total += ordermoney;
			}
			
			uiSkin.rawprice.text = total.toFixed(1) + "元";
			uiSkin.disountprice.text = total.toFixed(1) + "元";
			uiSkin.countdown.visible = false;

			
			Laya.timer.loop(1000,this,onCountDownTime);
			
			EventCenter.instance.on(EventCenter.UPDATE_PRICE_BY_DELIVERYDATE,this,updatePrice);
			updatePrice();
			

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
			if(leftforbidtime > 0)
			{
				leftforbidtime--;
				uiSkin.countdown.text = "（" + leftforbidtime + "秒之后可重新选择交付策略）";
				uiSkin.countdown.visible = true;
			}
			else
			{
				uiSkin.countdown.visible = false;

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
							(uiSkin.orderlist.cells[j] as ChooseDelTimeOrderItem).resetDeliveryDates();
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
				
				var paylefttime:int = getPayLeftTime();
				if(paylefttime > 0)
					ViewManager.instance.openView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL,false,{amount:Number(totalmoney.toFixed(2)),orderid:allorders,lefttime:paylefttime});
				else
					ViewManager.showAlert("支付超时，请重新选择交付时间");
				
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
				var paylefttime:int = getPayLeftTime();
				if(paylefttime > 0)
					ViewManager.instance.openView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL,false,{amount:Number(totalmoney.toFixed(2)),orderid:allorders,lefttime:paylefttime});
				else
					ViewManager.showAlert("支付超时，请重新选择交付时间");
				
			}
		}
		
		private function getPayLeftTime():int
		{
			var arr:Array = orderDatas;
			var leftime:int = 0;
			for(var i:int=0;i < orderDatas.length;i++)
			{
				if(orderDatas[i].is_urgent == 1  ||  orderDatas[i].delivery_date != null)
				{
					if(orderDatas[i].lefttime < leftime || leftime == 0)
					{
						leftime = orderDatas[i].lefttime;
					}
				}
			}
			
			return leftime;
		}
		
		private function resetDeliveryTime():void
		{
			for(var i:int=0;i < orderDatas.length;i++)
			{
				orderDatas[i].is_urgent = false;
				orderDatas[i].delivery_date = null;
				
				orderDatas[i].outtime = false;
				orderDatas[i].lefttime = 0;
				
				orderDatas[i].discount = 1;
				
			}
			uiSkin.orderlist.array = orderDatas;
			updatePrice();
			
			
		}
		
		private function setDefaultTimePrefer():void
		{
			UtilTool.setLocalVar("timePrefer",uiSkin.timepreferRdo.selectedIndex);
			ViewManager.showAlert("设置成功");
		}
		private function resetTimePrefer():void
		{
			
			if(canoccypay == false)
			{
				ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"您操作的太频繁了，请稍后再试"});
				//uiSkin.timepreferRdo.selectedIndex = PaintOrderModel.instance.curTimePrefer - 1;
				return;
			}
			canoccypay = false;
			curclicknum++;
			
			uiSkin.timepreferRdo.mouseEnabled = false;
			if(curclicknum > 3)
				curclicknum = 3;
			
			leftforbidtime = FORBIDTIME[curclicknum]/1000;
			
			Laya.timer.once(FORBIDTIME[curclicknum],this,enableClickOccupy);
			var arr:Array = PaintOrderModel.instance.finalOrderData;
			
			requestnum = 0;
			
			PaintOrderModel.instance.curTimePrefer = uiSkin.timepreferRdo.selectedIndex + 1;

			resetDeliveryTime();
			//if(PaintOrderModel.instance.curTimePrefer == uiSkin.timepreferRdo.selectedIndex + 1)
			//	return;

			for(var i:int=0;i < arr.length;i++)
			{
				
				
				var datas:String = PaintOrderModel.instance.getOrderCapcaityData(arr[i],uiSkin.timepreferRdo.selectedIndex + 1);
				
				
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDeliveryTimeList,this,ongetAllAvailableDateBack,{data:datas},"post");
				
				
			}
			//ViewManager.instance.openView(ViewManager.VIEW_CHOOSE_DELIVERY_TIME_PANEL,false,orderDatas);
			//PaintOrderModel.instance.packageList = new Vector.<PackageVo>();
			
		}
		
		private function enableClickOccupy():void
		{
			canoccypay = true;
			uiSkin.timepreferRdo.mouseEnabled = true;

		}
		private function ongetAllAvailableDateBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				var alldates:Array = result as Array;
				for(var i:int=0;i < alldates.length;i++)
				{
					
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn] = {};
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].canUrgent = false;
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList = [];
					
					var orderdata:Object = PaintOrderModel.instance.getSingleProductOrderData(alldates[i].orderItem_sn);
					orderdata.delivery_date = null;
					orderdata.is_urgent = false;
					
					var currentdate:String = alldates[i].current_date;
					
					if(orderdata != null && alldates[i].default_deliveryDate != null && alldates[i].default_deliveryDate != "")
					{
						orderdata.delivery_date = alldates[i].default_deliveryDate;
						
						orderdata.is_urgent = (orderdata.delivery_date == currentdate && PaintOrderModel.instance.curTimePrefer == Constast.ORDER_TIME_PREFER_URGENT);
						
						orderdata.lefttime = OrderConstant.OCCUPY_CAPACITY_COUNTDOWN;

					}
					
					for(var j:int=0;j < alldates[i].deliveryDateList.length;j++)
					{
						if(alldates[i].deliveryDateList[j].urgent == false)
						{
							if(alldates[i].deliveryDateList[j].discount == 0)
								alldates[i].deliveryDateList[j].discount = 1;
							
							if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent==false)
							{
								orderdata.discount = alldates[i].deliveryDateList[j].discount;
							}
							
							PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList.push(alldates[i].deliveryDateList[j]);
						}
						else if(currentdate == alldates[i].deliveryDateList[j].availableDate)
						{
							if(alldates[i].deliveryDateList[j].discount == 0)
								alldates[i].deliveryDateList[j].discount = 1;
							
							if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent)
							{
								orderdata.discount = alldates[i].deliveryDateList[j].discount;
							}
							
							PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].urgentDate = alldates[i].deliveryDateList[j];
						}
						
						
					}										
					
				}
				requestnum++;
				if(requestnum == PaintOrderModel.instance.finalOrderData.length)
				{
					uiSkin.orderlist.array = orderDatas;
					updatePrice();
				}
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
					
					if(itemlist[j].discount == null)
					{
						ViewManager.showAlert("请重新选择交货时间");
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
					//delete itemlist[j].discount;
										
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
			Laya.timer.clearAll(this);

		}
	}
}