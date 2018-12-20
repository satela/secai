package script.order
{
	import model.HttpRequestUtil;
	import model.orderModel.PicOrderItemVo;
	
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
			
			if(this.architype.textField.textHeight > 40)
				this.architype.height = this.architype.textField.textHeight;
			else
				this.architype.height = 40;
			
			this.changearchitxt.y = this.architype.y + this.architype.height - 15;
			
			if(this.architype.height > 60)
				this.height = this.architype.height + 20;
			else
				this.height = 60;
		}
	}
}