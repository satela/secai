package script.usercenter
{
	import laya.events.Event;
	
	import ui.usercenter.OrderQuestItemUI;
	
	public class QuestOrderItem extends OrderQuestItemUI
	{
		public var adjustHeight:Function;
		public var caller:Object;

		public function QuestOrderItem()
		{
			super();
		}
		
		public function setData(orderdata:Object):void
		{
			this.order_sn.text = orderdata.orderId;
			//this.fileimg.skin = 
			this.txtMaterial.text = "材料：油画布3*6，工艺：喷印方式（户内写真-4pass),外表面装裱（上光油-哑面),异性切割（附件),装裱（有狂装裱-框条（A框条)。" +
				"快递方式（义务物语物流-上门送货";
			this.detailbox.visible = false;
			this.bgimg.height = 65;
			this.detailbtn.on(Event.CLICK,this,onClickShowDetail);
		}
		
		private function onClickShowDetail():void
		{
			this.detailbox.visible = !this.detailbox.visible;
			if(this.detailbox.visible)
				this.bgimg.height = 141;
			else
				this.bgimg.height = 65;
			adjustHeight.call(caller);
		}
		
		private function hideDetail():void
		{
			this.detailbox.visible = false;
			this.bgimg.height = 65;
		}
	}
}