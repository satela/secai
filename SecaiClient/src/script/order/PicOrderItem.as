package script.order
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.orderModel.PicOrderItemVo;
	
	import script.ViewManager;
	
	import ui.order.OrderItemUI;
	
	public class PicOrderItem extends OrderItemUI
	{
		public var ordervo:PicOrderItemVo;
		public function PicOrderItem(vo:PicOrderItemVo)
		{
			super();
			ordervo = vo;
			initItem();
		}
		
		private function initItem():void
		{
			this.numindex.text = ordervo.indexNum.toString();
			
			this.fileimg.skin = HttpRequestUtil.smallerrPicUrl + ordervo.picinfo.fid + ".jpg";
			
			this.filename.text = ordervo.picinfo.directName;
			this.architype.text = ordervo.techStr;
			
			this.deleteorder.underline = true;
			this.deleteorder.underlineColor = "#222222";
			
			this.deleteorder.on(Event.CLICK,this,onDeleteOrder);
			this.changemat.underline = true;
			this.changemat.underlineColor = "#222222";
			this.changemat.on(Event.CLICK,this,onShowMaterialView);
			this.changearchitxt.on(Event.CLICK,this,onchangeTech);

			if(this.architype.textField.textHeight > 30)
				this.architype.height = this.architype.textField.textHeight;
			else
				this.architype.height = 30;
			
			//this.changearchitxt.y = this.architype.y + this.architype.height - 15;
			
			if(this.architype.height > 30)
				this.height = this.architype.height + 35;
			else
				this.height = 60;
			this.bgimg.height = this.height;
			alighComponet();
		}
		
		private function onchangeTech():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_TECHNORLOGY);
			return;
			var num:int = Math.random()*8;
			var techStr:String = "";
			for(var i:int=0;i < num;i++)
			{
				techStr += "工艺" + i + "\n";
			}
			var lastheight:int = this.height;
			this.architype.text = techStr;
			if(this.architype.textField.textHeight > 30)
				this.architype.height = this.architype.textField.textHeight;
			else
				this.architype.height = 30;
			
			//this.changearchitxt.y = this.architype.y + this.architype.height - 15;
			
			if(this.architype.height > 30)
				this.height = this.architype.height + 35;
			else
				this.height = 60;
			this.bgimg.height = this.height;
			alighComponet();
			
			EventCenter.instance.event(EventCenter.ADJUST_PIC_ORDER_TECH,this.height - lastheight);
		}
		private function alighComponet():void
		{
			this.numindex.y = (this.height - this.numindex.height)/2;
			
			this.fileimg.y = (this.height - this.fileimg.height)/2;
			
			this.filename.y = (this.height - this.filename.height)/2;
			this.matbox.y = (this.height - 42)/2;
			this.editbox.y = (this.height - this.editbox.height)/2;
			this.viprice.y = (this.height - this.viprice.height)/2;
			this.inputnum.y = (this.height - this.inputnum.height)/2;
			this.price.y = (this.height - this.price.height)/2;
			this.total.y = (this.height - this.total.height)/2;
			this.operatebox.y = (this.height - this.operatebox.height)/2;

		}
		public function updateIndex():void
		{
			this.numindex.text = ordervo.indexNum.toString();
		}
		private function onDeleteOrder():void
		{
			// TODO Auto Generated method stub
			EventCenter.instance.event(EventCenter.DELETE_PIC_ORDER,this);
		}
		
		private function onShowMaterialView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_MATERIAL);
		}
	}
}