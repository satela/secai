package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.orderModel.PaintOrderModel;
	
	import script.ViewManager;
	
	import ui.usercenter.OrderListItemUI;
	
	import utils.TipsUtil;
	
	public class OrderCheckListItem extends OrderListItemUI
	{
		private var orderdata:Object;
		public function OrderCheckListItem()
		{
			super();
		}
		
		
		public function setData(data:Object):void
		{
			orderdata = data;
			//var orderdetal:Object = JSON
			this.orderid.text = orderdata.or_id;
			this.ordertime.text = orderdata.or_date;
			var status:int = parseInt(orderdata.or_status);
			this.retrybtn.visible = false;

			this.deletebtn.visible = false;
			
			if(status == 0)
			{
				this.orderstatus.text = "未支付";
				this.orderstatus.color = "#FF0000";
				this.payagain.visible = true;
			}
			else if(status == 1)
			{
				this.orderstatus.text = "已支付排产成功";
				this.orderstatus.color = "#52B232";
				this.payagain.visible = false;
				this.deletebtn.visible = true;

			}
			else if(status == 2 || status == 3)
			{
				this.orderstatus.text = "已支付排产中";
				this.orderstatus.color = "#0022EE";
				this.payagain.visible = false;
				
				this.deletebtn.visible = false;
				//this.retrybtn.visible = true;
			}
			
			else if(status == 4)
			{
				this.orderstatus.text = "已撤单";
				this.orderstatus.color = "#52B232";
				this.payagain.visible = false;
				this.deletebtn.visible = false;
			}
			else if(status == 100)
			{
				this.orderstatus.text = "已支付排产失败";
				this.orderstatus.color = "#EE4400";
				this.payagain.visible = false;
				this.deletebtn.visible = true;
				this.retrybtn.visible = true;
				this.deletebtn.visible = true;

			}
			
			else
			{
				this.orderstatus.text = "订单异常";
				this.orderstatus.color = "#52B232";
				this.payagain.visible = false;
			}
			var detail:Object = JSON.parse(orderdata.or_text);
			this.paymoney.text = Number(detail.money_paidStr).toFixed(2);
			this.productnum.text = detail.orderItemList.length + "";
			
			this.detailbtn.on(Event.CLICK,this,onShowDetail);
			this.deletebtn.on(Event.CLICK,this,onClickDelete);
			this.payagain.on(Event.CLICK,this,onClickPay);
			this.retrybtn.on(Event.CLICK,this,onClickRetry);

			TipsUtil.getInstance().addTips(this.deletebtn,"未开始生产的订单可原价撤回");

		}
		
		private function onShowDetail():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_ORDER_DETAIL_PANEL,false,orderdata);
		}
		
		private function onClickDelete():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"订单撤回之后将无法恢复，确定删除吗？",caller:this,callback:confirmDelete,ok:"确定",cancel:"取消"});

		}
		
		private function confirmDelete(b:Boolean):void
		{
			if(b)
			{
				var status:int = parseInt(orderdata.or_status);

				if(status == 100)
				{
					var prams:String = "orderid=" + orderdata.or_id;
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.cancelExceptOrder,this,deleteExceptOrderBack,prams,"post");
					return;
				}
					//var detail:Object = JSON.parse(orderdata.or_text);
					
					//var orderdataStr:Object = {"order_sn":orderdata.or_id,"Client_Code":"CL10200","Refund_amount":Number(detail.money_paidStr).toFixed(2)};
					var orderdataStr:Object = {"orderid":orderdata.or_id,"client_code":"CL10200"};
					//var param:String = "orderid=" + orderdata.or_id;
					
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.cancelOrder,this,deleteOrderBack,{data:JSON.stringify(orderdataStr)},"post");
			}
			//HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.cancelOrder,this,deleteOrderBack,param,"post");

		}
		
		private function deleteExceptOrderBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				EventCenter.instance.event(EventCenter.DELETE_ORDER_BACK);
			}
			else
			{
				ViewManager.showAlert("订单取消失败");
			}
			
		}
		private function deleteOrderBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.code == 0)
			{
				EventCenter.instance.event(EventCenter.DELETE_ORDER_BACK);
			}
			else if( result.code == 1)
			{
				var detail:Object = JSON.parse(orderdata.or_text);

				ViewManager.showAlert("订单已开始生产，请联系厂家取消订单，联系电话" + detail.contact_phone);
			}
			else
			{
				//var detail:Object = JSON.parse(orderdata.or_text);
				
				//ViewManager.showAlert("订单已开始生产，请联系厂家取消订单，联系电话" + detail.contact_phone);
				ViewManager.showAlert("撤回订单失败");
			}
		}
		
		private function onClickPay():void
		{
			var orderinfo:Object = JSON.parse(orderdata.or_text);
			
			if(PaintOrderModel.instance.allManuFacutreMatProcPrice[orderinfo.manufacturer_code] == null)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getManuFactureMatProcPrice + orderinfo.manufacturer_code,this,function(dataStr:*):void{
					
					PaintOrderModel.instance.initManuFacuturePrice(orderinfo.manufacturer_code,dataStr);
					
					
					requestAvailableDate(orderinfo);
					
					
					
				},null,null);
			}
			else
			{
				requestAvailableDate(orderinfo);

			}
						

		}
		
		private function requestAvailableDate(orderinfo:Object):void
		{
		
			var itemlist:Array = orderinfo.orderItemList;
			for(var i:int=0;i < itemlist.length;i++)
			{
				delete itemlist[i].lefttime;
				delete itemlist[i].delivery_date;
				delete itemlist[i].is_urgent;

			}
			PaintOrderModel.instance.finalOrderData = [orderinfo];
			
			var datas:String = PaintOrderModel.instance.getOrderCapcaityData(orderinfo);
			
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDeliveryTimeList,this,ongetAvailableDateBack,{data:datas},"post");
			
		}
		
		private function ongetAvailableDateBack(data:*):void
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
					
				}
				
				ViewManager.instance.openView(ViewManager.VIEW_CHOOSE_DELIVERY_TIME_PANEL,false,{orders:PaintOrderModel.instance.finalOrderData[0].orderItemList,delaypay:true});
				
			}
		}
		
		private function onClickRetry():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.payExceptOrder,this,payMoneyBack,"orderid=" + orderdata.or_id,"post");

		}
		
		private function payMoneyBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				ViewManager.showAlert("订单排产成功");
				EventCenter.instance.event(EventCenter.PAY_ORDER_SUCESS);
				
			}
			else
			{
				ViewManager.showAlert("订单排产失败，您可以撤回订单，重新下单");
			}
		}
	}
}