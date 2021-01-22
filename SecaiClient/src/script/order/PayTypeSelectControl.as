package script.order
{
	import eventUtil.EventCenter;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Ease;
	import laya.utils.Tween;
	
	import model.Constast;
	import model.HttpRequestUtil;
	import model.Userdata;
	
	import script.ViewManager;
	
	import ui.order.ConfirmOrderPanelUI;
	
	import utils.UtilTool;
	
	public class PayTypeSelectControl extends Script
	{
		private var uiSkin:ConfirmOrderPanelUI;
		
		public var param:Object;
		
		public var paylefttime:int = 0;
		
		
		public function PayTypeSelectControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ConfirmOrderPanelUI;
			
			uiSkin.mainview.scaleX = 0.2;
			uiSkin.mainview.scaleY = 0.2;
			
			Tween.to(uiSkin.mainview,{scaleX:1,scaleY:1},300,Ease.backOut);
			
			uiSkin.payall.selected = true;
			
			//if(Userdata.instance.accountType == 1)
			uiSkin.paytype.selectedIndex = 0 ;
			
			if(Userdata.instance.accountType == Constast.ACCOUNT_EMPLOYEE && Userdata.instance.privilege[Constast.PRIVILEGE_PAYORDER_BY_SCAN] == "0" && Userdata.instance.privilege[Constast.PRIVILEGE_PAYORDER_BY_AMOUNT] == "1")
			{
				
				uiSkin.paytype.selectedIndex = 1;
				
				
			}
//			else
//			{
//				uiSkin.paytype.selectedIndex = 1 ;
//				uiSkin.paytype.mouseEnabled = false;
//			}
//			
			uiSkin.accountmoney.text = "0元";
			
			uiSkin.needpay.text = param.amount + "元";
			uiSkin.realpay.text =  param.amount + "元";
			
			paylefttime = param.lefttime;
			uiSkin.paytime.text = UtilTool.getCountDownString(paylefttime);
			//uiSkin.paytime.visible = false;
			Laya.timer.loop(1000,this,countdownpay);
			//uiSkin.needpay.visible = !Userdata.instance.isHidePrice();
			//uiSkin.realpay.visible = !Userdata.instance.isHidePrice();
			if(Userdata.instance.isHidePrice())
			{
				uiSkin.needpay.text = "****";
				uiSkin.realpay.text = "****";
			}

			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo,this,getCompanyInfoBack,null,"post");

			uiSkin.paybtn.on(Event.CLICK,this,onPayOrder);
			uiSkin.cancelbtn.on(Event.CLICK,this,onCancel);
			
			uiSkin.mainpanel.vScrollBarSkin = "";
			uiSkin.mainpanel.hScrollBarSkin = "";

			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;

			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);


		}
		
		private function countdownpay():void
		{
			if(paylefttime > 0)
			{
				paylefttime--;
				uiSkin.paytime.text = UtilTool.getCountDownString(paylefttime);
			}
			else
			{
				ViewManager.instance.closeView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL);
			}
		}
		
		
		private function onResizeBrower():void
		{
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;

		}
		private function getCompanyInfoBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				
				Userdata.instance.money = Number(result.balance);
				
				Userdata.instance.actMoney = Number(result.activity_balance);
				Userdata.instance.frezeMoney = Number(result.activity_locked_balance);
				
				uiSkin.accountmoney.text = Userdata.instance.money.toString() + "元";
				
				uiSkin.actmoney.text = Userdata.instance.actMoney.toString() + "元";
				
				
				if(Userdata.instance.actMoney >= param.amount)
					uiSkin.paytype.selectedIndex = 2;
				else if(Userdata.instance.money >= param.amount)
					uiSkin.paytype.selectedIndex = 1;
			
				
				if(Userdata.instance.isHidePrice())
				{
					uiSkin.accountmoney.text = "****";
					uiSkin.actmoney.text = "****";

				}
			}
		}	
		private function onPayOrder():void
		{
			var ordrid:String = (param.orderid as Array).join(",");

			if(uiSkin.paytype.selectedIndex == 0)
			{
				if(Userdata.instance.accountType == Constast.ACCOUNT_EMPLOYEE && Userdata.instance.privilege[Constast.PRIVILEGE_PAYORDER_BY_SCAN] == "0" || Userdata.instance.isHidePrice())
				{
					ViewManager.showAlert("您没有在线支付的权限,请联系管理者开放权限");
					return;
				}
				Browser.window.open("about:self","_self").location.href = HttpRequestUtil.httpUrl + HttpRequestUtil.chargeRequest + "amount=0&orderid=" + param.orderid;
				//ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"是否支付成功？",caller:this,callback:confirmSucess,ok:"是",cancel:"否"});
				//Browser.window.open(HttpRequestUtil.httpUrl + HttpRequestUtil.chargeRequest + "amount=0&orderid=" + param.orderid,"_blank"); 
			}
			else
			{
				if(Userdata.instance.accountType == Constast.ACCOUNT_EMPLOYEE && Userdata.instance.privilege[Constast.PRIVILEGE_PAYORDER_BY_AMOUNT] == "0")
				{
					ViewManager.showAlert("您没有余额支付的权限,请联系管理者开放权限");
					return;
				}
				
				if(uiSkin.paytype.selectedIndex == 1 && Userdata.instance.money < param.amount)
				{
					ViewManager.showAlert("账户余额不足");
					return;
				}
				
				if(uiSkin.paytype.selectedIndex == 2 && Userdata.instance.actMoney < param.amount)
				{
					ViewManager.showAlert("活动余额不足");
					return;
				}
				var paykind:int = uiSkin.paytype.selectedIndex - 1;
				
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.payOrderByMoney,this,payMoneyBack,"orderid=" + ordrid + "&kind=" + paykind ,"post");

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
		
		public override function  onDestroy():void
		{
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			Laya.timer.clearAll(this);
		}
	}
}