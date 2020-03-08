package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	
	import script.ViewManager;
	
	import ui.usercenter.OrderListItemUI;
	
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
			
			if(status == 0)
			{
				this.orderstatus.text = "未支付";
				this.orderstatus.color = "#FF0000";
				this.payagain.visible = true;
			}
			else if(status == 1)
			{
				this.orderstatus.text = "已支付";
				this.orderstatus.color = "#52B232";
				this.payagain.visible = false;
			}
			else if(status == 4)
			{
				this.orderstatus.text = "已撤单";
				this.orderstatus.color = "#52B232";
				this.payagain.visible = false;
				this.deletebtn.visible = false;
				this.payagain.visible = false;
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

		}
		
		private function onShowDetail():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_ORDER_DETAIL_PANEL,false,orderdata);
		}
		
		private function onClickDelete():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"订单删除之后将无法恢复，确定删除吗？",caller:this,callback:confirmDelete,ok:"确定",cancel:"取消"});

		}
		
		private function confirmDelete():void
		{
			var detail:Object = JSON.parse(orderdata.or_text);
			
			//var orderdataStr:Object = {"order_sn":orderdata.or_id,"Client_Code":"CL10200","Refund_amount":Number(detail.money_paidStr).toFixed(2)};
			var orderdataStr:Object = {"orderid":orderdata.or_id,"client_code":"CL10200"};
			//var param:String = "orderid=" + orderdata.or_id;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.cancelOrder,this,deleteOrderBack,{data:JSON.stringify(orderdataStr)},"post");
			//HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.cancelOrder,this,deleteOrderBack,param,"post");

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
				ViewManager.showAlert("删除订单失败");
			}
		}
		
		private function onClickPay():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL,false,{amount:Number(this.paymoney.text),orderid:[orderdata.or_id]});

		}
	}
}