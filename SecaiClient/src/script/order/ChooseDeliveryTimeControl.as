package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.RadioGroup;
	import laya.utils.Handler;
	
	import model.Constast;
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.orderModel.DeliveryTypeVo;
	import model.orderModel.OrderConstant;
	import model.orderModel.PackageVo;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PicOrderItemVo;
	
	import script.ViewManager;
	
	import ui.order.ChooseDeliveryTimePanelUI;
	
	import utils.TimeManager;
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
		
		private var placeorderNum:int = 0;
		
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

			uiSkin.paybtn.on(Event.CLICK,this,onPayOrder);

			orderDatas = param.orders as Array;
			delaypay = param.delaypay;
			
			uiSkin.savebtn.visible = !delaypay;
			
			uiSkin.orderlist.array = orderDatas;
			
			uiSkin.timepreferRdo.selectedIndex = PaintOrderModel.instance.curTimePrefer - 1;
			
			//uiSkin.confirmpreferbtn.on(Event.CLICK,this,resetTimePrefer);
			uiSkin.setdefaultbtn.on(Event.CLICK,this,setDefaultTimePrefer);
			uiSkin.timepreferRdo.on(Event.CHANGE,this,resetTimePrefer);
			
			PaintOrderModel.instance.curCommmonDeliveryType = "";
			PaintOrderModel.instance.curUrgentDeliveryType = "";
			
			uiSkin.commondelType.labels = "";
			uiSkin.urgentdeltype.labels = "";
			
			var manufactcode:String = "";
			var searchzoneid:String = "";
			for(var i:int=0;i < PaintOrderModel.instance.finalOrderData.length;i++)
			{
				manufactcode = PaintOrderModel.instance.finalOrderData[i].manufacturer_code;
				searchzoneid = PaintOrderModel.instance.finalOrderData[i].addressId;
				break;
			}
			if(PaintOrderModel.instance.deliveryList == null || PaintOrderModel.instance.deliveryList.length == 0)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDeliveryList + manufactcode + "&addr_id=" + searchzoneid,this,onGetDeliveryBack,null,null);
			}
			else
				initDeliveryInfo();
			
	

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
		
		private function onGetDeliveryBack(data:Object):void
		{
			if(this.destroyed)
				return;
			var result:Object = JSON.parse(data as String);
			
			if(!result.hasOwnProperty("status"))
			{
				PaintOrderModel.instance.deliveryList = [];
				
				for(var i:int=0;i < result.length;i++)
				{
					var tempdevo:DeliveryTypeVo = new DeliveryTypeVo(result[i]);
					PaintOrderModel.instance.deliveryList.push(tempdevo);
					PaintOrderModel.instance.selectDelivery = tempdevo;
				}
				initDeliveryInfo();
			}
		}
		
		private function initDeliveryInfo():void
		{
			uiSkin.commondelType.labels = PaintOrderModel.instance.getDeliveryTypeStr(false);
			
			uiSkin.urgentdeltype.labels = PaintOrderModel.instance.getDeliveryTypeStr(true);
			
			PaintOrderModel.instance.curCommmonDeliveryType = "";
			PaintOrderModel.instance.curUrgentDeliveryType = "";
			
			uiSkin.commondelType.on(Event.CHANGE,this,selectCommonDelType);
			
			//uiSkin.urgentdeltype.on(Event.CHANGE,this,selectUrgentDelType);
			
			var deltypelist:Array = uiSkin.commondelType.labels.split(",");
			
			for(var i:int=0;i < deltypelist.length;i++)
			{
				if(deltypelist[i].indexOf(OrderConstant.DELIVERY_TYPE_BY_MANUFACTURER) >= 0)
				{
					uiSkin.commondelType.selectedIndex = i;
					PaintOrderModel.instance.curCommmonDeliveryType = OrderConstant.DELIVERY_TYPE_BY_MANUFACTURER;
					break;
				}
			}
			
			var deltypelisturgent:Array = uiSkin.urgentdeltype.labels.split(",");
			
			for(i=0;i < deltypelisturgent.length;i++)
			{
				if(deltypelisturgent[i].indexOf(OrderConstant.DELIVERY_TYPE_BY_MANUFACTURER) >= 0)
				{
					uiSkin.urgentdeltype.selectedIndex = i;
					PaintOrderModel.instance.curUrgentDeliveryType = OrderConstant.DELIVERY_TYPE_BY_MANUFACTURER;
					break;
				}
			}
			
			uiSkin.urgentdeltype.selectHandler = new Handler(this,selectUrgentDelType);
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
							//retryGetAvailableDate(orderDatas[i]);
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
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList = [];
					
					var orderdata:Object = PaintOrderModel.instance.getSingleProductOrderData(alldates[i].orderItem_sn);
					orderdata.delivery_date = null;
					orderdata.is_urgent = false;
					
					var currentdate:String = alldates[i].current_date;
					
					var curtime:Number = Date.parse(currentdate.replace("-","/"));
					TimeManager.instance.serverDate = curtime/1000;
					
					currentdate = currentdate.split(" ")[0];
					PaintOrderModel.instance.currentDayStr = currentdate;

										
					for(var j:int=0;j < alldates[i].deliveryDateList.length;j++)
					{
						if(alldates[i].deliveryDateList[j].urgent == false)
						{
							if(alldates[i].deliveryDateList[j].discount == 0)
								alldates[i].deliveryDateList[j].discount = 1;
							
//							if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent==false)
//							{
//								orderdata.discount = alldates[i].deliveryDateList[j].discount;
//							}
//							
							PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList.push(alldates[i].deliveryDateList[j]);
						}
						else if(currentdate == alldates[i].deliveryDateList[j].availableDate)
						{
							if(alldates[i].deliveryDateList[j].discount == 0)
								alldates[i].deliveryDateList[j].discount = 1;
							
//							if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent)
//							{
//								orderdata.discount = alldates[i].deliveryDateList[j].discount;
//							}
							
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
			var commomitemManuNum:Array = [];
			var urgentitemManuNum:Array = []
			for(var i:int=0;i < orderDatas.length;i++)
			{
				var ordermoney:Number = Number(orderDatas[i].item_priceStr) * Number(orderDatas[i].item_number);
				
				if(orderDatas[i].is_urgent == 1 || orderDatas[i].delivery_date != null)
				{
					ordermoney = ordermoney*orderDatas[i].discount;
					
				}
				var manucode:String = PaintOrderModel.instance.getManufacturerCode(orderDatas[i].orderItem_sn);
				if(orderDatas[i].is_urgent == 1 && urgentitemManuNum.indexOf(manucode) < 0)
				{
					urgentitemManuNum.push(manucode);
				}
				else if(orderDatas[i].is_urgent == 0 && commomitemManuNum.indexOf(manucode) < 0)
				{
					commomitemManuNum.push(manucode);

				}
				ordermoney = parseFloat(ordermoney.toFixed(1));
				total += ordermoney;
			}
			
			var commondelprice:Number = PaintOrderModel.instance.getDeliveryPrice(PaintOrderModel.instance.curCommmonDeliveryType) * commomitemManuNum.length;
			var urgentdelprice:Number = PaintOrderModel.instance.getDeliveryPrice(PaintOrderModel.instance.curUrgentDeliveryType) * urgentitemManuNum.length;
			
			//if(hasUrgentOrderItem() == false)
			//	urgentdelprice = 0;

			//if(hasCommonOrderItem() == false)
			//	commondelprice = 0;
			
			uiSkin.delmoney.text = (commondelprice + urgentdelprice).toFixed(1) + "元";
			var totals:Number = parseFloat((commondelprice + urgentdelprice).toFixed(1)) + parseFloat(total.toFixed(1));
			uiSkin.disountprice.text = totals + "元";
		}
		
		private function onPayOrder():void
		{
			//trace("oderdara:" + JSON.stringify(PaintOrderModel.instance.finalOrderData));
			
			var arr:Array = getOrderData();
			if(arr == null)
				return;
			uiSkin.paybtn.disabled = true;
			
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
			uiSkin.paybtn.disabled = false;

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
			uiSkin.paybtn.disabled = false;

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
		
		private function hasUrgentOrderItem():Boolean
		{
			for(var i:int=0;i < orderDatas.length;i++)
			{
				if(orderDatas[i].is_urgent == 1  &&  orderDatas[i].delivery_date != null)
				{
					return true;
				}
			}
			return false;
		}
		
		private function hasCommonOrderItem():Boolean
		{
			for(var i:int=0;i < orderDatas.length;i++)
			{
				if(orderDatas[i].is_urgent == false  &&  orderDatas[i].delivery_date != null)
				{
					return true;
				}
			}
			return false;
		}
		private function selectUrgentDelType(index:int):void
		{
			if(index == -1)
				return;

			var temptype:String = getDelivertyType(uiSkin.urgentdeltype);
			if(PaintOrderModel.instance.isValidDeliveryType(temptype))
			{
				PaintOrderModel.instance.curUrgentDeliveryType = temptype;
				updatePrice();
			}
			else
			{
				ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"送货上门班次没有了，请选择其他配送方式"});
				Laya.timer.frameOnce(2,this,function(){
					uiSkin.urgentdeltype.selectedIndex = -1;
				});
				
				PaintOrderModel.instance.curUrgentDeliveryType = "";

				//ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"送货上门班次没有了，请选择其他配送方式"});
//				for(var i=0;i < deltypelisturgent.length;i++)
//				{
//					if(deltypelisturgent[i].indexOf(OrderConstant.DELIVERY_TYPE_BY_SELF) >= 0)
//					{
//						uiSkin.urgentdeltype.selectedIndex = -1;
//						PaintOrderModel.instance.curUrgentDeliveryType = OrderConstant.DELIVERY_TYPE_BY_SELF;
//						break;
//					}
//				}
			}
		}
		
		private function selectCommonDelType():void
		{
			PaintOrderModel.instance.curCommmonDeliveryType = getDelivertyType(uiSkin.commondelType);

			updatePrice();
		}
		
		private function getDelivertyType(radgroup:RadioGroup):String
		{
			var labellst:Array = radgroup.labels.split(",");
			var index:int = radgroup.selectedIndex;
			
			return labellst[index].split("(")[0];
			
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
//				for(var i:int=0;i < alldates.length;i++)
//				{
//					
//					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn] = {};
//					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList = [];
//					
//					var orderdata:Object = PaintOrderModel.instance.getSingleProductOrderData(alldates[i].orderItem_sn);
//					orderdata.delivery_date = null;
//					orderdata.is_urgent = false;
//					
//					var currentdate:String = alldates[i].current_date;
//					
//					var curtime:Number = Date.parse(currentdate.replace("-","/"));
//					TimeManager.instance.serverDate = curtime/1000;
//					
//					currentdate = currentdate.split(" ")[0];
//					PaintOrderModel.instance.currentDayStr = currentdate;
//
//					
//					if(orderdata != null && alldates[i].default_deliveryDate != null && alldates[i].default_deliveryDate != "")
//					{
//						orderdata.delivery_date = alldates[i].default_deliveryDate;
//						
//						orderdata.is_urgent = (orderdata.delivery_date == currentdate && PaintOrderModel.instance.curTimePrefer == Constast.ORDER_TIME_PREFER_URGENT);
//						
//						orderdata.lefttime = OrderConstant.OCCUPY_CAPACITY_COUNTDOWN;
//
//					}
//					
//					for(var j:int=0;j < alldates[i].deliveryDateList.length;j++)
//					{
//						if(alldates[i].deliveryDateList[j].urgent == false)
//						{
//							if(alldates[i].deliveryDateList[j].discount == 0)
//								alldates[i].deliveryDateList[j].discount = 1;
//							
//							if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent==false)
//							{
//								orderdata.discount = alldates[i].deliveryDateList[j].discount;
//							}
//							
//							PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList.push(alldates[i].deliveryDateList[j]);
//						}
//						else if(currentdate == alldates[i].deliveryDateList[j].availableDate)
//						{
//							if(alldates[i].deliveryDateList[j].discount == 0)
//								alldates[i].deliveryDateList[j].discount = 1;
//							
//							if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent)
//							{
//								orderdata.discount = alldates[i].deliveryDateList[j].discount;
//							}
//							
//							PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].urgentDate = alldates[i].deliveryDateList[j];
//						}
//						
//						
//					}										
//					
//				}
				for(var i:int=0;i < alldates.length;i++)
				{
					
					var currentdate:String = alldates[i].current_date;
					
					var curtime:Number = Date.parse(currentdate.replace("-","/"));
					TimeManager.instance.serverDate = curtime/1000;
					
					currentdate = currentdate.split(" ")[0];
					
					PaintOrderModel.instance.currentDayStr = currentdate;
					
					
					
					var orderdataList:Array = PaintOrderModel.instance.getProductOrderDataList(alldates[i].orderItem_sn);
					
					for(var k:int=0;k < orderdataList.length;k++)
					{
						var orderdata:Object = orderdataList[k];
						
						PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn] = {};
						PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList = [];
						
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
								
								PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList.push(alldates[i].deliveryDateList[j]);
								
								if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent == false)
								{
									orderdata.discount = alldates[i].deliveryDateList[j].discount;
								}
							}
							else if(currentdate == alldates[i].deliveryDateList[j].availableDate)
							{
								if(alldates[i].deliveryDateList[j].discount == 0)
									alldates[i].deliveryDateList[j].discount = 1;
								
								if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent)
								{
									orderdata.discount = alldates[i].deliveryDateList[j].discount;
								}
								
								PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].urgentDate = alldates[i].deliveryDateList[j];
							}
							
							
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
			
			if(hasUrgentOrderItem() && (PaintOrderModel.instance.curUrgentDeliveryType == null || PaintOrderModel.instance.curUrgentDeliveryType == ""))
			{
				ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"请选择加急配送方式"});
				return null;
			}
			
			if(hasCommonOrderItem() && (PaintOrderModel.instance.curCommmonDeliveryType == null || PaintOrderModel.instance.curCommmonDeliveryType == ""))
			{
				ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"请选择普通配送方式"});
				return null;
			}
			var commondelName:String = PaintOrderModel.instance.getDeliveryOrgCode() + "#" + PaintOrderModel.instance.curCommmonDeliveryType;
			var urgentdelName:String = PaintOrderModel.instance.getDeliveryOrgCode() + "#" + PaintOrderModel.instance.curUrgentDeliveryType;

			var commondelprice:Number = PaintOrderModel.instance.getDeliveryPrice(PaintOrderModel.instance.curCommmonDeliveryType);
			var urgentdelprice:Number = PaintOrderModel.instance.getDeliveryPrice(PaintOrderModel.instance.curUrgentDeliveryType);
			
			if(hasUrgentOrderItem() == false)
				urgentdelprice = 0;
			
			if(hasCommonOrderItem == false)
				commondelprice = 0;
			
			for(var i:int=0;i < manuarr.length;i++)
			{
				var itemlist:Array = manuarr[i].orderItemList;
				var totalprice:Number = 0;
				
				manuarr[i].logistic_code  = commondelName;
				
				//manuarr[i].paydelay = delaypay?1:0;
				
				manuarr[i].placeorderNum = itemlist[0].orderItem_sn;
				
				var hascommonDelItem:Boolean = false;
				var hsurgentDelItem:Boolean = false;
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
					
					if(itemlist[j].is_urgent == 1)
					{
						itemlist[j].logistics_type = urgentdelName;
						hsurgentDelItem = true
					}
					else
					{
						delete itemlist[j].logistics_type;
						hascommonDelItem = true;
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
				manuarr[i].shipping_feeStr = (commondelprice * (hascommonDelItem?1:0) + urgentdelprice * (hsurgentDelItem?1:0) as Number).toFixed(1);
				manuarr[i].money_paidStr = (manuarr[i].order_amountStr + commondelprice * (hascommonDelItem?1:0) + urgentdelprice * (hsurgentDelItem?1:0)).toFixed(1);
				manuarr[i].order_amountStr = (manuarr[i].order_amountStr).toFixed(1);
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
			uiSkin.savebtn.disabled = true;
			
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
			uiSkin.savebtn.disabled = false;

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
			PaintOrderModel.instance.resetData();
			Laya.timer.clearAll(this);

		}
	}
}