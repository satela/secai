package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	
	import script.ViewManager;
	
	import ui.usercenter.MyOrdersPanelUI;
	
	import utils.UtilTool;
	
	public class MyOrderControl extends Script
	{
		private var uiSkin:MyOrdersPanelUI;
		
		private var curpage:int = 1;
		
		private var totalPage:int = 1;
		private var dateInput:Object; 
		private var dateInput2:Object; 

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
			
			Laya.timer.frameLoop(1,this,updateDateInputPos);

			//var curyear:int = (new Date()).getFullYear();
			//var curmonth:int = (new Date()).getMonth();
			
			
			//uiSkin.yearCombox.selectedIndex = curyear - 2019;
			//uiSkin.monthCombox.selectedIndex = curmonth;
			
			var param:String = "begindate=" + UtilTool.formatFullDateTime(new Date(),false) + "&enddate=" + UtilTool.formatFullDateTime(new Date(),false) + "&type=2&curpage=1";
			//if(curmonth + 1 < 10 )
			//	param = "begindate=" + curyear + "0" + (curmonth + 1) + "enddate=" + curyear + "0" + (curmonth + 1) + "&type=2&curpage=1";
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOrderRecordList,this,onGetOrderListBack,param,"post");

			uiSkin.lastyearbtn.on(Event.CLICK,this,onLastYear);
			uiSkin.nextyearbtn.on(Event.CLICK,this,onNextYear);
			
			uiSkin.lastmonthbtn.on(Event.CLICK,this,onLastMonth);
			uiSkin.nextmonthbtn.on(Event.CLICK,this,onNextMonth);
			
			
			uiSkin.lastpage.on(Event.CLICK,this,onLastPage);
			uiSkin.nexttpage.on(Event.CLICK,this,onNextPage);
			
			
			uiSkin.ordertotalNum.text = "0";
			uiSkin.ordertotalMoney.text = "0元";

			uiSkin.paytype.selectedIndex = 2;
			
			uiSkin.orderList.on(Event.MOUSE_DOWN,this,onMouseDwons);
			
			uiSkin.orderList.on(Event.MOUSE_UP,this,onMouseUpHandler);
			
			uiSkin.yearCombox.on(Event.CHANGE,this,getOrderListAgain);
			uiSkin.monthCombox.on(Event.CHANGE,this,getOrderListAgain);
			uiSkin.btnsearch.on(Event.CLICK,this,queryOrderList);

			EventCenter.instance.on(EventCenter.COMMON_CLOSE_PANEL_VIEW,this,onshowInputDate);
			EventCenter.instance.on(EventCenter.OPEN_PANEL_VIEW,this,onHideInputDate);

			Laya.stage.on(Event.MOUSE_UP,this,onMouseUpHandler);
			
			EventCenter.instance.on(EventCenter.DELETE_ORDER_BACK,this,getOrderListAgain);

			this.initDateSelector();
		}
		
		private function onshowInputDate():void
		{
			if(dateInput != null)
			{
				dateInput.hidden = false;
				dateInput2.hidden = false;

			}
		}
		
		private function onHideInputDate():void
		{
			if(dateInput != null)
			{
				dateInput.hidden = true;
				dateInput2.hidden = true;
				
			}
		}
		
		private function initDateSelector():void
		{
			var curdate:Date = new Date();
			
			var nextmonth:Date = new Date(curdate.getTime() + 31 * 24 * 3600 * 1000);
			
			//trace(UtilTool.formatFullDateTime(curdate,false));
			//trace(UtilTool.formatFullDateTime(nextmonth,false));

			//var curyear:int = (new Date()).getFullYear();
			//var curmonth:int = (new Date()).getMonth();
			
			
			dateInput = Browser.document.createElement("input");
			
			dateInput.style="filter:alpha(opacity=100);opacity:100;left:795px;top:240";
			
			//			if(param && param.type == "License")
			//				file.multiple="";
			//			else			
			
			dateInput.type ="date";
			dateInput.style.position ="absolute";
			dateInput.style.zIndex = 999;
			dateInput.value = UtilTool.formatFullDateTime(curdate,false);
			Browser.document.body.appendChild(dateInput);//添加到舞台
			
			dateInput.onchange = function(datestr):void
			{
				if(dateInput.value == "")
					return;
				var curdata:Date = new Date(dateInput.value);
				var nextdate:Date = new Date(dateInput2.value);
				
				if(nextdate.getTime() - curdata.getTime() > 31 * 24 * 3600 * 1000)
				{
					nextdate =  new Date(curdata.getTime() + 31 * 24 * 3600 * 1000);
					
					dateInput2.value = UtilTool.formatFullDateTime(nextdate,false);
				}
				else if(nextdate.getTime() - curdata.getTime() < 0 )
				{
					dateInput2.value = UtilTool.formatFullDateTime(curdata,false);

				}
				//trace(UtilTool.formatFullDateTime(curdata,false));
			}
				
			dateInput2 = Browser.document.createElement("input");
			
			dateInput2.style="filter:alpha(opacity=100);opacity:100;left:980px;top:240";
			
			//			if(param && param.type == "License")
			//				file.multiple="";
			//			else			
			
			dateInput2.type ="date";
			dateInput2.style.position ="absolute";
			dateInput2.style.zIndex = 999;
			Browser.document.body.appendChild(dateInput2);//添加到舞台
			dateInput2.value = UtilTool.formatFullDateTime(nextmonth,false);

			dateInput2.onchange = function(datestr):void
			{
				if(dateInput2.value == "")
					return;
				//trace("选择的日期：" + datestr);
				var curdata:Date = new Date(dateInput2.value);
				var lastdate:Date = new Date(dateInput.value);
				
				if(curdata.getTime() - lastdate.getTime() > 31 * 24 * 3600 * 1000)
				{
					lastdate =  new Date(curdata.getTime() - 31 * 24 * 3600 * 1000);
					
					dateInput.value = UtilTool.formatFullDateTime(lastdate,false);
				}
				else if(curdata.getTime() - lastdate.getTime() < 0 )
				{
					dateInput.value = UtilTool.formatFullDateTime(curdata,false);
					
				}
				
			}
		}
		
		private function updateDateInputPos():void
		{
			if(dateInput != null)
			{
				//verifycode.style.top = 548 - uiSkin.mainpanel.vScrollBar.value + "px";
				var pt:Point = uiSkin.ordertime.localToGlobal(new Point(uiSkin.ordertime.x,uiSkin.ordertime.y),true);
				
				dateInput.style.top = (pt.y - 15) + "px";
				dateInput.style.left = (pt.x + 15) +  "px";
				
				dateInput2.style.top = (pt.y - 15) + "px";
				dateInput2.style.left = (pt.x + 205) +  "px";
				
				//trace("pos:" + pt.x + "," + pt.y);
				//verifycode.style.left = 950 -  uiSkin.mainpanel.hScrollBar.value + "px";
				
			}
			
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
		
		private function queryOrderList():void
		{
			curpage = 1;
			getOrderListAgain();
		}
		private function getOrderListAgain()
		{
			var curdata:Date = new Date(dateInput2.value);
			var lastdate:Date = new Date(dateInput.value);
			
			var param:String = "begindate=" + dateInput.value + "enddate=" + dateInput2.value + "&type=" + uiSkin.paytype.selectedIndex + "&curpage=" + curpage;
			//if(curmonth + 1 < 10 )
			//	param = "begindate=" + curyear + "0" + (curmonth + 1) + "enddate=" + curyear + "0" + (curmonth + 1) + "&type=2&curpage=1";
			
			//if(uiSkin.monthCombox.selectedIndex + 1 >= 10)
			//	var param:String = "date=" + (2019 + uiSkin.yearCombox.selectedIndex) + (uiSkin.monthCombox.selectedIndex + 1) + "&curpage=" + curpage;
			//else
			//	 param = "date=" + (2019 + uiSkin.yearCombox.selectedIndex) +  "0" + (uiSkin.monthCombox.selectedIndex + 1) + "&curpage=" + curpage;

			
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
			else
				ViewManager.showAlert("获取订单失败");
		}
		public function updateOrderList(cell:OrderCheckListItem):void
		{
			cell.setData(cell.dataSource);
		}
		
		public override function onDestroy():void
		{
			Laya.stage.off(Event.MOUSE_UP,this,onMouseUpHandler);
			Laya.timer.clearAll(this);
			if(dateInput != null)
			{
				Browser.document.body.removeChild(dateInput);//添加到舞台
				Browser.document.body.removeChild(dateInput2);//添加到舞台
			}
			EventCenter.instance.off(EventCenter.DELETE_ORDER_BACK,this,getOrderListAgain);

			EventCenter.instance.off(EventCenter.PAY_ORDER_SUCESS,this,onRefreshOrder);
			EventCenter.instance.off(EventCenter.COMMON_CLOSE_PANEL_VIEW,this,onshowInputDate);
			EventCenter.instance.off(EventCenter.OPEN_PANEL_VIEW,this,onHideInputDate);
		}
	}
}