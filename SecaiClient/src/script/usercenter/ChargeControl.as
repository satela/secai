package script.usercenter
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Browser;
	
	import model.HttpRequestUtil;
	import model.Userdata;
	
	import script.ViewManager;
	
	import ui.usercenter.ChargePanelUI;
	
	public class ChargeControl extends Script
	{
		private var uiSkin:ChargePanelUI;

		public function ChargeControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ChargePanelUI;
			uiSkin.accout.text = Userdata.instance.userAccount;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo,this,getCompanyInfoBack,null,"post");

			uiSkin.moneytxt.text = "0";
			//uiSkin.moneytxt.text = Userdata.instance.money.toString();
			
			uiSkin.chargeinput.restrict = "0-9" + ".";
			uiSkin.chargeinput.maxChars = 8;
			uiSkin.tyepgrp.selectedIndex = 0;
			
			uiSkin.confirmcharge.on(Event.CLICK,this,onChargeNow);
		}
		
		private function onChargeNow():void
		{
			if(uiSkin.chargeinput.text == "")
			{
				ViewManager.showAlert("请输入充值金额");
			}
			
			if(uiSkin.chargeinput.text == "0")
			{
				ViewManager.showAlert("充值金额不能为0");
			}
			
			var num:Number = Number(uiSkin.chargeinput.text);
			
			Browser.window.open(HttpRequestUtil.httpUrl + HttpRequestUtil.chargeRequest + "amount=" + num + "&orderid=0",null,null,true);
			
			ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG,false,{msg:"是否支付成功？",caller:this,callback:confirmSucess,ok:"是",cancel:"否"});
			//HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.chargeRequest ,this,onChargeBack,"amount=" + num,"post");

		}
		
		private function confirmSucess(result:Boolean):void
		{
			if(result)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo,this,getCompanyInfoBack,null,"post");
			}

		}
		private function getCompanyInfoBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				Userdata.instance.money = Number(result.balance);
				
				uiSkin.moneytxt.text = Userdata.instance.money.toString();

			}
		}
	}
}