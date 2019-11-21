package script.order
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.orderModel.OrderConstant;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PicOrderItemVo;
	import model.orderModel.ProductVo;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	
	import ui.order.OrderItemUI;
	
	public class PicOrderItem extends OrderItemUI
	{
		public var ordervo:PicOrderItemVo;
		public var locked:Boolean = true;
		
		public var finalWidth:Number;
		public var finalHeight:Number;
		
		private var curproductvo:ProductVo;
		
		private var fanmianFid:String;
		
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
			this.addmsg.visible = false;
			if(ordervo.picinfo.picWidth > ordervo.picinfo.picHeight)
			{
				this.fileimg.width = 80;					
				this.fileimg.height = 80/ordervo.picinfo.picWidth * ordervo.picinfo.picHeight;
				
			}
			else
			{
				this.fileimg.height = 80;
				this.fileimg.width = 80/ordervo.picinfo.picHeight * ordervo.picinfo.picWidth;
				
			}
			
			this.yixingimg.width = this.fileimg.width;
			this.yixingimg.height = this.fileimg.height;
			
			this.backimg.width = this.fileimg.width;
			this.backimg.height = this.fileimg.height;
			
			this.yixingimg.visible = false;
			this.backimg.visible = false;
			
			
			this.fileimg.on(Event.CLICK,this,onShowBigImg);
			this.backimg.on(Event.CLICK,this,onShowBackImg);

			finalWidth = ordervo.picinfo.picPhysicWidth;
			finalHeight = ordervo.picinfo.picPhysicHeight;
			
			this.editwidth.text = ordervo.picinfo.picPhysicWidth.toString();
			this.editheight.text = ordervo.picinfo.picPhysicHeight.toString();
			this.editwidth.restrict = "0-9" + ".";
			this.editheight.restrict = "0-9" + ".";
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

			this.editwidth.on(Event.INPUT,this,onWidthSizeChange);
			this.editheight.on(Event.INPUT,this,onHeightSizeChange);
			this.lockratio.on(Event.CLICK,this,onLockChange);

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
		
		private function onLockChange():void
		{
			if(locked)
			{
				this.lockratio.skin = "commers/unlock.png";
				locked = false;
			}
			else
			{
				this.lockratio.skin = "commers/lock.png";
				locked = true;
			}
		}
		private function onWidthSizeChange():void
		{
			var curwidth:Number = Number(this.editwidth.text);
			
			finalWidth = curwidth;
			if(locked)
			{
				var heightration:Number = curwidth/ordervo.picinfo.picPhysicWidth*ordervo.picinfo.picPhysicHeight;
				finalHeight = heightration;
				
				this.editheight.text = heightration.toFixed(2);
			}
			updatePrice();
		}
		private function onHeightSizeChange():void
		{
			var curheight:Number = Number(this.editheight.text);
			finalHeight = curheight;

			if(locked)
			{
				var widthration:Number = curheight/ordervo.picinfo.picPhysicHeight*ordervo.picinfo.picPhysicWidth;
				finalWidth = widthration;

				this.editwidth.text = widthration.toFixed(2);
			}
			updatePrice();
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
			if(this.yixingimg.visible)
			{
				var obj:Array = [];
				obj.push(this.ordervo.picinfo);
				obj.push(this.yixingimg.skin);
				ViewManager.instance.openView(ViewManager.VIEW_PICTURE_CHECK,false,obj);

			}
			else
				ViewManager.instance.openView(ViewManager.VIEW_PICTURE_CHECK,false,this.ordervo.picinfo);


		}
		
		private function onShowBackImg():void
		{
			var obj:PicInfoVo = new PicInfoVo({},1);  
			obj.fid = fanmianFid;
			obj.picWidth = this.ordervo.picinfo.picWidth;
			obj.picHeight = this.ordervo.picinfo.picHeight;
			
			ViewManager.instance.openView(ViewManager.VIEW_PICTURE_CHECK,false,obj);

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
			
			this.backimg.y =  this.height/2;
			
			this.yixingimg.y = this.height/2;
			
			this.filename.y = (this.height - this.filename.height)/2;
			this.matbox.y = (this.height - 42)/2;
			this.editbox.y = (this.height - this.editbox.height)/2;
			//this.viprice.y = (this.height - this.viprice.height)/2;
			this.numbox.y = (this.height)/2 - 12;
			this.price.y = (this.height - this.price.height)/2;
			this.total.y = (this.height - this.total.height)/2;
			this.operatebox.y = (this.height - this.operatebox.height)/2 - 10;

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
		
		private function updatePrice():void
		{
			if(curproductvo != null)
			{
				updateOrderData(curproductvo);
				var area:Number = (finalHeight * finalWidth)/10000;
				var perimeter:Number = (finalHeight + finalWidth)*2/100;
//				if(area < 0.1)
//					area = 0.1;
//				
				if(curproductvo.measure_unit == OrderConstant.MEASURE_UNIT_AREA)
					this.price.text = (curproductvo.getTotalPrice(area,perimeter,true)/area).toFixed(1);
				else
					this.price.text = (curproductvo.getTotalPrice(area,perimeter,true)/perimeter).toFixed(1);
				
				
				this.total.text = (parseInt(this.inputnum.text) *curproductvo.getTotalPrice(area,perimeter)).toFixed(1) + "";
				EventCenter.instance.event(EventCenter.UPDATE_ORDER_ITEM_TECH);

			}
		}
		private function onNumChange():void
		{
			
			this.total.text = (parseInt(this.inputnum.text) * this.ordervo.orderPrice).toFixed(1).toString();
			if(this.ordervo.orderData)
			this.ordervo.orderData.item_number = parseInt(this.inputnum.text);
			EventCenter.instance.event(EventCenter.UPDATE_ORDER_ITEM_TECH);

		}
		private function onShowMaterialView():void
		{
			// TODO Auto Generated method stub
			if(PaintOrderModel.instance.selectAddress == null)
			{
				ViewManager.showAlert("请先选择收货地址");
				return;
			}
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_MATERIAL,false,ordervo.picinfo);
			PaintOrderModel.instance.curSelectOrderItem = this;
			PaintOrderModel.instance.batchChangeMatItems = new Vector.<PicOrderItem>();
		}
		
		public function changeProduct(provo:ProductVo):void
		{
			//this.ordervo.orderData = provo;
			curproductvo = provo;
			fanmianFid = "";
			updateOrderData(provo);
			var area:Number = (finalHeight * finalWidth)/10000;
			var perimeter:Number = (finalHeight + finalWidth)*2/100;
			
			
			var hasSelectedTech:Array = provo.getAllSelectedTech();
			var doublesideImg:String = "";
			var yixingqiegeImg:String = "";
			var doublesame:Boolean = false;
			for(var i:int=0;i < hasSelectedTech.length;i++)
			{
				if(hasSelectedTech[i].preProc_Code == OrderConstant.DOUBLE_SIDE_SAME_TECHNO )
				{
					doublesame = true;
				}
				else if(hasSelectedTech[i].preProc_Code == OrderConstant.DOUBLE_SIDE_UNSAME_TECHNO)
				{
					doublesideImg = hasSelectedTech[i].attchFileId;
					fanmianFid = doublesideImg;
					
				}
				else if(hasSelectedTech[i].preProc_Code == OrderConstant.UNNORMAL_CUT_TECHNO)
				{
					yixingqiegeImg = hasSelectedTech[i].attchFileId;
				}
			}
			
			this.backimg.visible = doublesideImg != "" || doublesame;
			//uiSkin.backimg.visible = doublesideImg != "" || doublesame;
			
			if(doublesideImg != "")
			{
				//uiSkin.originimg.skin = HttpRequestUtil.biggerPicUrl + param.fid + ".jpg";				
				this.backimg.skin = HttpRequestUtil.biggerPicUrl +doublesideImg + ".jpg";	
			}
			if(doublesame)
			{
				//uiSkin.originimg.skin = HttpRequestUtil.biggerPicUrl + param.fid + ".jpg";				
				this.backimg.skin = HttpRequestUtil.biggerPicUrl + ordervo.picinfo.fid + ".jpg";	
			}
			
			this.yixingimg.visible = yixingqiegeImg != "";
			
			if(yixingqiegeImg != "")
			{
				this.yixingimg.skin = HttpRequestUtil.biggerPicUrl +yixingqiegeImg + ".jpg";	
			}
			
			
//			if(area < 0.1)
//				area = 0.1;
			
			if(provo.measure_unit == OrderConstant.MEASURE_UNIT_AREA)
				this.price.text = (provo.getTotalPrice(area,perimeter,true)/area).toFixed(1);
			else
				this.price.text = (provo.getTotalPrice(area,perimeter,true)/perimeter).toFixed(1);

			
			this.total.text = (parseInt(this.inputnum.text) *provo.getTotalPrice(area,perimeter)).toFixed(1) + "";
			
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
			
			var area:Number = (finalHeight * finalWidth)/10000;
			var perimeter:Number = (finalHeight + finalWidth)*2/100;

//			if(area < 0.1)
//				area = 0.1;
			
			this.ordervo.orderPrice = productVo.getTotalPrice(area,perimeter);
			if(this.ordervo.orderPrice < 0.1)
				this.ordervo.orderPrice = 0.1;
			
			ordervo.manufacturer_code = productVo.manufacturer_code;
			ordervo.manufacturer_name = productVo.manufacturer_name;
			
			var orderitemdata:Object = {};
			
			orderitemdata.prod_name = productVo.prod_name;
			orderitemdata.prod_code = productVo.prod_code;
			
			orderitemdata.prod_description = "";
			orderitemdata.LWH = finalWidth.toFixed(2) + "/" + finalHeight.toFixed(2) + "/1";
			orderitemdata.weightStr = 1;
			orderitemdata.item_number = parseInt(this.inputnum.text);
			orderitemdata.item_priceStr = this.ordervo.orderPrice.toString();
			orderitemdata.item_status = "1";
			orderitemdata.comments = this.ordervo.comment;
			orderitemdata.imagefile_path = HttpRequestUtil.originPicPicUrl + this.ordervo.picinfo.fid + "." + this.ordervo.picinfo.picClass;
			orderitemdata.previewImage_path = HttpRequestUtil.biggerPicUrl + this.ordervo.picinfo.fid + ".jpg";
			orderitemdata.thumbnails_path = HttpRequestUtil.smallerrPicUrl + this.ordervo.picinfo.fid + ".jpg";
			orderitemdata.filename = this.ordervo.picinfo.directName;
			
			orderitemdata.procInfoList = productVo.getProInfoList();
			

			this.ordervo.orderData =  orderitemdata;
		}
		
		public function checkCanOrder():Boolean
		{
//			var pixel:Array = this.fileimg._bitmap.source.getPixels(0,0,this.fileimg.width,this.fileimg.height);
//			for(var i:int=0;i < pixel.length;i+=4)
//			{
//				var r:int = pixel[i];
//				var g:int = pixel[i+1];
//				var b:int = pixel[i+2];
//				if(r== g && r == b)
//				{
//					trace("rgb=" + r);
//				}
//				
//			}
			if(ordervo.orderData == null)
			{
				ViewManager.showAlert("未选择材料工艺");
				return false;
			}
			
			if(curproductvo != null)
				return curproductvo.checkCurTechValid();
			else
				return false;
			
		}
	}
}