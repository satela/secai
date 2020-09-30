package script.order
{
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.orderModel.PicOrderItemVo;
	
	import ui.order.SimpleOrderItemUI;
	
	public class ChooseDelTimeOrderItem extends SimpleOrderItemUI
	{
		public function ChooseDelTimeOrderItem()
		{
			super();
			
			for(var i:int=0;i < 5;i++)
			{
				this["deltime" + i].on(Event.CLICK,this,onSelectTime,[i]);
			}
			
			this.urgentcheck.on(Event.CLICK,this,onClickUrgent);
		}
		
		private function onSelectTime(index:int):void
		{
			//selectTime = index;
			
			//discount = PaintOrderModel.instance.getDiscountByDate(selectTime);
			
			//updatePrice();
			for(var i:int=0;i < 5;i++)
			{
				this["deltime"+i].selected = i == index;
			}
			
			this.urgentcheck.selected = false;
		}
		
		private function onClickUrgent():void
		{
			if(this.urgentcheck.selected)
			{
				for(var i:int=0;i < 5;i++)
				{
					this["deltime"+i].selected = false;
				}
			}
		}
		public function setData(data:*):void
		{
			this.numindex.text = data.item_seq.toString();
			
			this.fileimg.skin = data.previewImage_path;
			
			
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
			
			this.pricetext.text = (Number(data.item_priceStr) * Number(data.item_number)).toFixed(2);
			
			
			this.numtxt.text = data.item_number + "";
			
				
				
		}
	}
}