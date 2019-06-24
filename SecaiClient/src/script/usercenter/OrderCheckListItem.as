package script.usercenter
{
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
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.cancelOrder,this,deleteOrderBack,null,"get");

		}
		
		private function deleteOrderBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				
			}
		}
		
		private function onClickPay():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL,false,{amount:Number(this.paymoney.text),orderid:[orderdata.or_id]});

		}
	}
}