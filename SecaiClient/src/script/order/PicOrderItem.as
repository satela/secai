package script.order
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PicOrderItemVo;
	import model.orderModel.ProductVo;
	
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
			
			this.subtn.on(Event.CLICK,this,onSubItemNum);
			this.addbtn.on(Event.CLICK,this,onAddItemNum);
			this.hascomment.visible = false;
			if(ordervo.picinfo.picWidth > ordervo.picinfo.picHeight)
			{
				this.fileimg.width = 100;					
				this.fileimg.height = 100/ordervo.picinfo.picWidth * ordervo.picinfo.picHeight;
				
			}
			else
			{
				this.fileimg.height = 100;
				this.fileimg.width = 100/ordervo.picinfo.picHeight * ordervo.picinfo.picWidth;
				
			}
			this.fileimg.on(Event.DOUBLE_CLICK,this,onShowBigImg);
			this.editwidth.text = ordervo.picinfo.picPhysicWidth.toString();
			this.editheight.text = ordervo.picinfo.picPhysicHeight.toString();
			this.filename.text = ordervo.picinfo.directName;
			this.architype.text = ordervo.techStr;
			this.total.text = "0";
			this.deleteorder.underline = true;
			this.deleteorder.underlineColor = "#222222";
			this.inputnum.text = "1";
			this.inputnum.restrict = "0-9";
			this.deleteorder.on(Event.CLICK,this,onDeleteOrder);
			
			this.addmsg.underline = true;
			this.addmsg.underlineColor = "#222222";
			this.price.text = "0";
			this.addmsg.on(Event.CLICK,this,onAddComment);
			
			this.mattxt.text = "";
			this.changemat.underline = true;
			this.changemat.underlineColor = "#222222";
			this.changemat.on(Event.CLICK,this,onShowMaterialView);
			//this.changearchitxt.on(Event.CLICK,this,onchangeTech);
			this.inputnum.on(Event.INPUT,this,onNumChange);

			if(this.architype.textField.textHeight > 80)
				this.architype.height = this.architype.textField.textHeight;
			else
				this.architype.height = 80;
			
			//this.changearchitxt.y = this.architype.y + this.architype.height - 15;
			
			if(this.architype.height > 80)
				this.height = this.architype.height + 35;
			else
				this.height = 113;
			this.bgimg.height = this.height;
			alighComponet();
		}
		
		private function onSubItemNum():void
		{
			var num:int = parseInt(this.inputnum.text);
			if(num > 1)
				num--;
			this.inputnum.text = num.toString();
			onNumChange();
		}
		private function onAddItemNum():void
		{
			var num:int = parseInt(this.inputnum.text);
			num++;
			this.inputnum.text = num.toString();
			onNumChange();
		}
		
		private function onShowBigImg():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_PICTURE_CHECK,false,this.ordervo.picinfo);

		}
		private function onAddComment():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_ADD_MESSAGE,false,{msg:this.ordervo.comment,caller:this,callback:onAddMsgBack});
		}
		
		private function onAddMsgBack(msg:String):void
		{
			this.ordervo.comment = msg;
			this.hascomment.visible = this.ordervo.comment != "";

			if(this.ordervo.orderData)
			{
				this.ordervo.orderData.comments = this.ordervo.comment;
			}
		}
		
		private function alighComponet():void
		{
			this.checkSel.y = (this.height - 26)/2;
			
			this.numindex.y = (this.height - this.numindex.height)/2;
			
			this.fileimg.y = this.height/2;
			
			this.filename.y = (this.height - this.filename.height)/2;
			this.matbox.y = (this.height - 42)/2;
			this.editbox.y = (this.height - this.editbox.height)/2;
			//this.viprice.y = (this.height - this.viprice.height)/2;
			this.numbox.y = (this.height)/2 - 12;
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
		
		private function onNumChange():void
		{
			
			this.total.text = (parseInt(this.inputnum.text) * this.ordervo.orderPrice).toFixed(2).toString();
			if(this.ordervo.orderData)
			this.ordervo.orderData.item_number = parseInt(this.inputnum.text);
			EventCenter.instance.event(EventCenter.UPDATE_ORDER_ITEM_TECH);

		}
		private function onShowMaterialView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_MATERIAL);
			PaintOrderModel.instance.curSelectOrderItem = this;
			PaintOrderModel.instance.batchChangeMatItems = new Vector.<PicOrderItem>();
		}
		
		public function changeProduct(provo:ProductVo):void
		{
			//this.ordervo.orderData = provo;
			updateOrderData(provo);
			var area:Number = (ordervo.picinfo.picPhysicHeight * ordervo.picinfo.picPhysicWidth)/10000;
			var perimeter:Number = (ordervo.picinfo.picPhysicHeight + ordervo.picinfo.picPhysicWidth)*2/100;
			
			this.price.text = provo.getTotalPrice(area,perimeter).toString();
			
			this.total.text = parseInt(this.inputnum.text) *provo.getTotalPrice(area,perimeter) + "";
			
			this.mattxt.text = provo.prod_name;
			var lastheight:int = this.height;

			this.architype.text = provo.getTechDes();
			
			if(this.architype.textField.textHeight > 80)
				this.architype.height = this.architype.textField.textHeight;
			else
				this.architype.height = 80;
			
			//this.changearchitxt.y = this.architype.y + this.architype.height - 15;
			
			if(this.architype.height > 80)
				this.height = this.architype.height + 35;
			else
				this.height = 113;
			this.bgimg.height = this.height;
			alighComponet();
			
			EventCenter.instance.event(EventCenter.ADJUST_PIC_ORDER_TECH,this.height - lastheight);
		}
		
		public function getPrice():Number
		{			
			return parseInt(this.inputnum.text) * this.ordervo.orderPrice;
		}
		public function updateOrderData(productVo:ProductVo)
		{
			
			var area:Number = (ordervo.picinfo.picPhysicHeight * ordervo.picinfo.picPhysicWidth)/10000;
			var perimeter:Number = (ordervo.picinfo.picPhysicHeight + ordervo.picinfo.picPhysicWidth)*2/100;

			this.ordervo.orderPrice = productVo.getTotalPrice(area,perimeter);
			ordervo.manufacturer_code = productVo.manufacturer_code;
			ordervo.manufacturer_name = productVo.manufacturer_name;
			
			var orderitemdata:Object = {};
			
			orderitemdata.prod_name = productVo.prod_name;
			orderitemdata.prod_code = productVo.prod_code;
			
			orderitemdata.prod_description = "";
			orderitemdata.LWH = ordervo.picinfo.picPhysicWidth + "/" + ordervo.picinfo.picPhysicHeight + "/1";
			orderitemdata.weightStr = 1;
			orderitemdata.item_number = parseInt(this.inputnum.text);
			orderitemdata.item_priceStr = this.ordervo.orderPrice.toString();
			orderitemdata.item_status = "1";
			orderitemdata.comments = this.ordervo.comment;
			orderitemdata.imagefile_path = HttpRequestUtil.originPicPicUrl + this.ordervo.picinfo.fid + "." + this.ordervo.picinfo.picClass;
			orderitemdata.previewImage_path = HttpRequestUtil.biggerPicUrl + this.ordervo.picinfo.fid + ".jpg";
			orderitemdata.thumbnails_path = HttpRequestUtil.smallerrPicUrl + this.ordervo.picinfo.fid + ".jpg";

			
			orderitemdata.procInfoList = productVo.getProInfoList();
			

			this.ordervo.orderData =  orderitemdata;
		}
	}
}