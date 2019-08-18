package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Browser;
	
	import model.HttpRequestUtil;
	import model.Userdata;
	
	import script.ViewManager;
	
	import ui.order.ConfirmOrderPanelUI;
	
	public class PayTypeSelectControl extends Script
	{
		private var uiSkin:ConfirmOrderPanelUI;
		
		public var param:Object;
		public function PayTypeSelectControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ConfirmOrderPanelUI;
			
			uiSkin.payall.selected = true;
			
			uiSkin.paytype.selectedIndex = 0 ;
			
			uiSkin.accountmoney.text = "0元";
			
			uiSkin.needpay.text = param.amount + "元";
			uiSkin.realpay.text =  param.amount + "元";
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo,this,getCompanyInfoBack,null,"post");

			uiSkin.paybtn.on(Event.CLICK,this,onPayOrder);
			uiSkin.cancelbtn.on(Event.CLICK,this,onCancel);
			
			

		}
		private function getCompanyInfoBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				Userdata.instance.money = Number(result.balance);
				uiSkin.accountmoney.text = Userdata.instance.money.toString() + "元";
				
			}
		}	
		private function onPayOrder():void
		{
			var ordrid:String = (param.orderid as Array).join(",");

			if(uiSkin.paytype.selectedIndex == 0)
			{
				Browser.window.open("about:self","_self").location.href = HttpRequestUtil.httpUrl + HttpRequestUtil.chargeRequest + "amount=0&orderid=" + param.orderid;
				//ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"是否支付成功？",caller:this,callback:confirmSucess,ok:"是",cancel:"否"});
			}
			else
			{
				if(Userdata.instance.money < param.amount)
				{
					ViewManager.showAlert("余额不足");
					return;
				}
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.payOrderByMoney,this,payMoneyBack,"orderid=" + ordrid,"post");

			}
		}
		
		private function payMoneyBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				ViewManager.showAlert("支付成功");
				EventCenter.instance.event(EventCenter.PAY_ORDER_SUCESS);
				ViewManager.instance.closeView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL);

			}
		}
		
		private function confirmSucess(result:Boolean):void
		{
			if(result)
			{
				EventCenter.instance.event(EventCenter.PAY_ORDER_SUCESS);
				ViewManager.instance.closeView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL);
				
			}
		}
		private function onCancel():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"确定取消支付吗？取消支付您可以到订单界面查询支付状态或继续支付。",caller:this,callback:confirmCancel});		
		}
		
		private function confirmCancel(b:Boolean):void
		{
			if(b)
			{
				ViewManager.instance.closeView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL);
				EventCenter.instance.event(EventCenter.CANCEL_PAY_ORDER);
			}

		}
	}
}