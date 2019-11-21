package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	
	import ui.usercenter.MyOrdersPanelUI;
	
	public class MyOrderControl extends Script
	{
		private var uiSkin:MyOrdersPanelUI;
		
		private var curpage:int = 1;
		
		private var totalPage:int = 1;
		
		public function MyOrderControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as MyOrdersPanelUI;
			
			uiSkin.orderList.itemRender = OrderCheckListItem;
			
			//uiSkin.orderList.vScrollBarSkin = "";
			uiSkin.orderList.repeatX = 1;
			uiSkin.orderList.spaceY = 2;
			
			uiSkin.orderList.renderHandler = new Handler(this, updateOrderList);
			uiSkin.orderList.selectEnable = false;
			uiSkin.orderList.array = [];
			EventCenter.instance.on(EventCenter.PAY_ORDER_SUCESS,this,onRefreshOrder);
			
			uiSkin.yearCombox.labels = "2019年,2020年,2021年,2022年,2023年,2024年,2025年";
			uiSkin.monthCombox.labels = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"].join(",");
			
			//uiSkin.yearCombox.scrollBarSkin = "";
			
			
			var curyear:int = (new Date()).getFullYear();
			var curmonth:int = (new Date()).getMonth();
			
			uiSkin.yearCombox.selectedIndex = curyear - 2019;
			uiSkin.monthCombox.selectedIndex = curmonth;
			
			var param:String = "date=" + curyear + (curmonth + 1) + "&curpage=1";
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOrderRecordList,this,onGetOrderListBack,param,"post");

			uiSkin.lastyearbtn.on(Event.CLICK,this,onLastYear);
			uiSkin.nextyearbtn.on(Event.CLICK,this,onNextYear);
			
			uiSkin.lastmonthbtn.on(Event.CLICK,this,onLastMonth);
			uiSkin.nextmonthbtn.on(Event.CLICK,this,onNextMonth);
			
			
			uiSkin.lastpage.on(Event.CLICK,this,onLastPage);
			uiSkin.nexttpage.on(Event.CLICK,this,onNextPage);
			
			
			uiSkin.ordertotalNum.text = "0";
			uiSkin.ordertotalMoney.text = "0元";

			uiSkin.orderList.on(Event.MOUSE_DOWN,this,onMouseDwons);
			
			uiSkin.orderList.on(Event.MOUSE_UP,this,onMouseUpHandler);
			
			Laya.stage.on(Event.MOUSE_UP,this,onMouseUpHandler);

		}
		
		private function onLastYear():void
		{
			if(uiSkin.yearCombox.selectedIndex > 0 )
			{
				uiSkin.yearCombox.selectedIndex = uiSkin.yearCombox.selectedIndex - 1;
				curpage = 1;
				this.getOrderListAgain();
			}
			
		}
		
		private function onNextYear():void
		{
			if(uiSkin.yearCombox.selectedIndex < 6 )
			{
				uiSkin.yearCombox.selectedIndex = uiSkin.yearCombox.selectedIndex + 1;
				curpage = 1;
				this.getOrderListAgain();
			}
		}
		
		private function onLastMonth():void
		{
			if(uiSkin.monthCombox.selectedIndex > 0 )
			{
				uiSkin.monthCombox.selectedIndex = uiSkin.monthCombox.selectedIndex - 1;
				curpage = 1;
				this.getOrderListAgain();
			}
			
		}
		
		private function onNextMonth():void
		{
			if(uiSkin.monthCombox.selectedIndex < 11 )
			{
				uiSkin.monthCombox.selectedIndex = uiSkin.monthCombox.selectedIndex + 1;
				curpage = 1;
				this.getOrderListAgain();
			}
		}
		private function onLastPage():void
		{
			if(curpage > 1 )
			{
				curpage--;
				getOrderListAgain();
			}
		}
		private function onNextPage():void
		{
			if(curpage < totalPage )
			{
				curpage++;
				getOrderListAgain();
			}
		}
		private function getOrderListAgain()
		{
			var param:String = "date=" + (2019 + uiSkin.yearCombox.selectedIndex) + (uiSkin.monthCombox.selectedIndex + 1) + "&curpage=" + curpage;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOrderRecordList,this,onGetOrderListBack,param,"post");
		}
		private function onMouseDwons(e:Event):void{
			
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,false);

		}
		private function onMouseUpHandler(e:Event):void{
			
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);
			
		}
		
		private function onRefreshOrder():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.checkOrderList,this,onGetOrderListBack,null,"post");
		}
		private function onGetOrderListBack(data:Object):void
		{
			if (data == null || data == "")
				return;
			
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				var totalNum:int = result.total;
				totalPage = Math.ceil(totalNum/30);
				if(totalPage < 1)
					totalPage = 1;
				
				uiSkin.ordertotalNum.text = totalNum + "";
				if(result.amount != null)
					uiSkin.ordertotalMoney.text = result.amount + "元";
				else
					uiSkin.ordertotalMoney.text = "0元";

				uiSkin.pagenum.text = curpage + "/" + totalPage;
				uiSkin.orderList.array = (result.data as Array).reverse();
			}
		}
		public function updateOrderList(cell:OrderCheckListItem):void
		{
			cell.setData(cell.dataSource);
		}
		
		public override function onDestroy():void
		{
			Laya.stage.off(Event.MOUSE_UP,this,onMouseUpHandler);

			EventCenter.instance.off(EventCenter.PAY_ORDER_SUCESS,this,onRefreshOrder);

		}
	}
}