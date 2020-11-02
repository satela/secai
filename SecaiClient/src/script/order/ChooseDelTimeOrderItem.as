package script.order
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	import laya.ui.CheckBox;
	
	import model.HttpRequestUtil;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PicOrderItemVo;
	
	import ui.order.SimpleOrderItemUI;
	
	import utils.UtilTool;
	
	public class ChooseDelTimeOrderItem extends SimpleOrderItemUI
	{
		public var orderdata:Object;
		
		private var curselectIndex:int = -1;
		public function ChooseDelTimeOrderItem()
		{
			super();
			
			for(var i:int=0;i < 5;i++)
			{
				this["deltime" + i].on(Event.CLICK,this,onSelectTime,[i]);
			}
			
			this.urgentcheck.on(Event.CLICK,this,onClickUrgent);
			Laya.timer.loop(1000,this,countDownPayTime);

		}
		
		private function onSelectTime(index:int):void
		{
			//selectTime = index;
			
			//discount = PaintOrderModel.instance.getDiscountByDate(selectTime);
			
			//updatePrice();
			

			var manucode:String = PaintOrderModel.instance.getManufacturerCode(orderdata.orderItem_sn);
			
			curselectIndex = index;
			
			var deliverydate:String = PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList[index].availableDate;

			var params:String = "orderItem_sn=" + orderdata.orderItem_sn + "&manufacturer_code=" + manucode + "&prod_code=" + orderdata.prod_code + "&is_urgent=0&delivery_date=" + deliverydate;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.preOccupyCapacity + params,this,onOccupyCapacityBack,null,null);

			
		}
		
		private function onOccupyCapacityBack(data:*):void
		{
			var result:Object = JSON.parse(data);
			if(!result.hasOwnProperty("status"))
			{
				if(result.feedBack == 1)
				{
					for(var i:int=0;i < 5;i++)
					{
						this["deltime"+i].selected = i == curselectIndex;
					}
					
					this.urgentcheck.selected = false;
					this.urgentcheck.disabled = false;

					orderdata.outtime = false;
					orderdata.lefttime = 180;
					
					orderdata.is_urgent = 0;
					orderdata.delivery_date = PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList[curselectIndex].availableDate;
					orderdata.discount = PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList[curselectIndex].discount;
					
				}
				else if(result.newDateList != null && result.newDateList != "")
				{
					PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList = result.newDateList;
					
					PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn] = {};
					//PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].canUrgent = false;
					PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList = [];
					
					for(var j:int=0;j < result.newDateList.length;j++)
					{
						if(result.newDateList[j].urgent == false)
						{
							PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList.push(result.newDateList[j]);
						}
						else
						{
							PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].urgentDate = result.newDateList[j];
						}
					}	
					orderdata.is_urgent = 0;
					orderdata.delivery_date = null;
					orderdata.discount = 1;

					resetDeliveryDates();
				}
				updatePrice();
				EventCenter.instance.event(EventCenter.UPDATE_PRICE_BY_DELIVERYDATE);

			}
		}
		private function onClickUrgent():void
		{
			var manucode:String = PaintOrderModel.instance.getManufacturerCode(orderdata.orderItem_sn);
			
			//curselectIndex = index;
			
			var deliverydate:String = PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].urgentDate.availableDate;
			
			var params:String = "orderItem_sn=" + orderdata.orderItem_sn + "&manufacturer_code=" + manucode + "&prod_code=" + orderdata.prod_code + "&is_urgent=1&delivery_date=" + deliverydate;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.preOccupyCapacity + params,this,onOccupyUrgentCapacityBack,null,null);
			
//			if(this.urgentcheck.selected)
//			{
//				for(var i:int=0;i < 5;i++)
//				{
//					this["deltime"+i].selected = false;
//				}
//			}
		}
		
		private function onOccupyUrgentCapacityBack(data:*):void
		{
			var result:Object = JSON.parse(data);
			if(!result.hasOwnProperty("status"))
			{
				if(result.feedBack == 1)
				{
					for(var i:int=0;i < 5;i++)
					{
						this["deltime"+i].selected = false;
					}
					
					this.urgentcheck.selected = true;
					this.urgentcheck.disabled = true;
					
					orderdata.outtime = false;
					orderdata.lefttime = 180;
					
					orderdata.is_urgent = 1;
					orderdata.delivery_date = PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].urgentDate.availableDate;
					orderdata.discount = PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].urgentDate.discount;
					
				}
				else if(result.newDateList != null && result.newDateList != "")
				{
					PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList = result.newDateList;
					
					PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn] = {};
					//PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].canUrgent = false;
					PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList = [];
					
					for(var j:int=0;j < result.newDateList.length;j++)
					{
						if(result.newDateList[j].urgent == false)
						{
							if(result.newDateList[j].discount == 0)
								result.newDateList[j].discount = 1;
							
							PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList.push(result.newDateList[j]);
						}
						else
						{
							if(result.newDateList[j].discount == 0)
								result.newDateList[j].discount = 1;
							
							PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].urgentDate = result.newDateList[j];
						}
					}	
					orderdata.is_urgent = 0;
					orderdata.delivery_date = null;
					orderdata.discount = 1;
					
					resetDeliveryDates();
				}
				updatePrice();
				EventCenter.instance.event(EventCenter.UPDATE_PRICE_BY_DELIVERYDATE);
				
			}
		}
		
		public function setData(data:*):void
		{
			orderdata = data;
			this.numindex.text = data.item_seq.toString();
			
			this.fileimg.skin = data.previewImage_path;
			
			//data.orderItem_sn = data.item_seq.toString();
			//data.is_urgent = 0;
			//data.delivery_date = "2020-10-7";
			
			var size:Array = data.LWH.split("/");

			var picwidth:Number = parseFloat(size[0]);
			var picheight:Number = parseFloat(size[1]);

			if(picwidth > picheight)
			{
				this.fileimg.width = 80;					
				this.fileimg.height = 80/picwidth * picheight;
				
			}
			else
			{
				this.fileimg.height = 80;
				this.fileimg.width = 80/picheight * picwidth;
				
			}
			
			this.filename.text = data.filename;
			
			this.mattext.text = data.prod_name;
			
			
			this.picwidth.text = size[0];
			this.picheight.text = size[1];
			
			//this.proctext.text = data.techStr;
			
			//this.pricetext.text = data.item_number * parseFloat(data.item_priceSt) + "";
			
			var techstr:String =  "";
			if(data.procInfoList != null)
			{
				for(var i:int=0;i < data.procInfoList.length;i++)
					techstr += data.procInfoList[i].proc_description + "-";
			}
			
			this.proctext.text = techstr.substr(0,techstr.length - 1);
			
			//this.pricetext.text = (Number(data.item_priceStr) * Number(data.item_number)).toFixed(2);
			
			
			this.numtxt.text = data.item_number + "";
			
			resetDeliveryDates();
			
			updatePrice();
		}
		
		private function updatePrice():void
		{
			var rawprice:Number = Number(orderdata.item_priceStr) * Number(orderdata.item_number);
			
			if(orderdata.is_urgent == 1 || orderdata.delivery_date != null)
			{
				this.pricetext.text = (rawprice*orderdata.discount as Number).toFixed(1);

			}
			
			else
				this.pricetext.text = rawprice.toFixed(1);
			
		}
		
		public function resetDeliveryDates():void
		{
			for(var i:int=0;i < 5;i++)
			{
				this["deltime" + i].visible = false;
				this["deltime" + i].selected = false;
			}
			
			var deliverydatas:Array = PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].deliveryDateList;
			for(var i:int=0;i < deliverydatas.length;i++)
			{
				if(i < 5)
				{
					this["deltime" + i].label = UtilTool.getNextDayStr((deliverydatas[i].availableDate as String) + " 00:00:00");
					this["deltime" + i].visible = true;
					this["discount" + i].text = getPayDicountStr(deliverydatas[i].discount);
					if(orderdata.delivery_date == deliverydatas[i].availableDate)
						this["deltime" + i].selected = true;
					
				}
			}
			this.urgentcheck.visible = PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].urgentDate != null;
			if(this.urgentcheck.visible)
				this.urgentdiscount.text = getPayDicountStr(PaintOrderModel.instance.availableDeliveryDates[orderdata.orderItem_sn].urgentDate.discount);
			
			this.urgentcheck.selected = orderdata.is_urgent == 1;
			if(this.urgentcheck.selected)
				this.urgentcheck.disabled = true;

		}
		private function countDownPayTime():void
		{
			if(orderdata != null)
			{
				if(orderdata.is_urgent == 1  ||  orderdata.delivery_date != null)
				{
					this.paycountdown.text = UtilTool.getCountDownString(orderdata.lefttime);
				}
				else if(orderdata.outtime)
					this.paycountdown.text = "支付超时";
				else
					this.paycountdown.text = "00:00";

			}
		}
		
		private function getPayDicountStr(discount:Number):String
		{
			if(discount < 1)
			{
				return discount*100 + "折";
			}
			else if(discount == 1)
			{
				return discount + "";
			}
			else
			{
				return discount + "倍";
			}
		}
	}
}