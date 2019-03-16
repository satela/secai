package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.net.HttpRequest;
	import laya.utils.Browser;
	import laya.utils.Utils;
	
	import model.ChinaAreaModel;
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.orderModel.MatetialClassVo;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PartItemVo;
	import model.orderModel.PicOrderItemVo;
	import model.picmanagerModel.DirectoryFileModel;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	
	import ui.PaintOrderPanelUI;
	
	import utils.UtilTool;
	
	public class PaintOrderControl extends Script
	{
		private var uiSkin:PaintOrderPanelUI;
		public var param:Object;
		
		private var orderlist:Vector.<PicOrderItem>;
		public function PaintOrderControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as PaintOrderPanelUI;
			//uiSkin.firstpage.on(Event.CLICK,this,onClosePanel);
			uiSkin.panel_main.vScrollBarSkin = "";
			uiSkin.mainvbox.autoSize = true;
			//uiSkin.btn_addattach.on(Event.CLICK,this,onAddPart);
			uiSkin.btnaddpic.on(Event.CLICK,this,onShowSelectPic);
			var i:int= 1;
			//uiSkin.ordervbox.autoSize = true;
			var num:int = 0;
			var totalheight:int= 0;
			
			orderlist = new Vector.<PicOrderItem>();
			for each(var fvo in DirectoryFileModel.instance.haselectPic)
			{
				var ovo:PicOrderItemVo = new PicOrderItemVo(fvo);
				ovo.indexNum = i++;
				var item:PicOrderItem = new PicOrderItem(ovo);
				uiSkin.ordervbox.addChild(item);
				orderlist.push(item);
				//if(num > 0)
				//	uiSkin.ordervbox.height += item.height + uiSkin.ordervbox.space;
				totalheight += item.height + uiSkin.ordervbox.space;
				num++;
			}
			
			//if(uiSkin.ordervbox.height > 10)
			//	uiSkin.ordervbox.height -= uiSkin.ordervbox.space;
			
			uiSkin.ordervbox.size(uiSkin.ordervbox.width,totalheight - uiSkin.ordervbox.space);
			
			DirectoryFileModel.instance.haselectPic = {};
			uiSkin.myaddresstxt.underline = true;
			uiSkin.myaddresstxt.underlineColor = "#222222";
			
			uiSkin.factorytxt.underline = true;
			uiSkin.factorytxt.underlineColor = "#222222";
			uiSkin.qqContact.on(Event.CLICK,this,onClickOpenQQ);
			uiSkin.myaddresstxt.on(Event.CLICK,this,onShowSelectAddress);
			uiSkin.factorytxt.on(Event.CLICK,this,onShowSelectFactory);
			uiSkin.deliverybtn.on(Event.CLICK,this,onShowSelectDelivery);
			uiSkin.batchChange.on(Event.CLICK,this,onBatchChangeMaterial);
			uiSkin.selectAll.on(Event.CLICK,this,onSelectAll);
			EventCenter.instance.on(EventCenter.SELECT_OUT_ADDRESS,this,onSelectedAddress);
			EventCenter.instance.on(EventCenter.SELECT_ORDER_ADDRESS,this,onSelectedSelfAddress);

			EventCenter.instance.on(EventCenter.ADD_PIC_FOR_ORDER,this,onUpdateOrderPic);
			
			EventCenter.instance.on(EventCenter.DELETE_PIC_ORDER,this,onDeletePicOrder);
			
			EventCenter.instance.on(EventCenter.SELECT_DELIVERY_TYPE,this,updateDeliveryType);

			EventCenter.instance.on(EventCenter.ADJUST_PIC_ORDER_TECH,this,onAdjustHeight);
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			EventCenter.instance.on(EventCenter.UPDATE_ORDER_ITEM_TECH,this,resetOrderInfo);

			(uiSkin.panel_main).height = (Browser.clientHeight - 292);

			this.uiSkin.btnordernow.on(Event.CLICK,this,onOrderPaint);
//			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProcessFlow,this,function(data:Object):void{
//				
//				var result:Object = JSON.parse(data as String);
//				if(result.hasOwnProperty("status"))
//				{
//					
//				}
//				trace(data);
//			});
			resetOrderInfo();
			if(Userdata.instance.getDefaultAddress() != null)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOuputAddr + "addr_id=" + Userdata.instance.getDefaultAddress().searchZoneid,this,onGetOutPutAddress,null,null);
				uiSkin.myaddresstxt.text = Userdata.instance.getDefaultAddress().addressDetail;
				PaintOrderModel.instance.selectAddress = Userdata.instance.getDefaultAddress();
			}
		}
		
		private function resetOrderInfo():void
		{
			if(PaintOrderModel.instance.selectDelivery == null)
				uiSkin.textDeliveryType.text = "送货方式：无";
			else
				uiSkin.textDeliveryType.text = "送货方式：" + PaintOrderModel.instance.selectDelivery.delivery_name;
			
			uiSkin.textProductNum.text = "商品总数：" + orderlist.length + "";
			var total:Number = 0;
			for(var i:int=0;i < orderlist.length;i++)
			{
				total += Number(orderlist[i].total.text);
			}
			
			uiSkin.textTotalPrice.text = "订单总额：" + total.toFixed(2);
			
			uiSkin.textDiscountPrice.text = "折后总额：" + total.toFixed(2);
			uiSkin.textPayPrice.text = "应付金额：" + total.toFixed(2);
			
		}
		private function onGetOutPutAddress(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				PaintOrderModel.instance.initOutputAddr(result as Array);
				if(PaintOrderModel.instance.outPutAddr.length > 0)
				{
					PaintOrderModel.instance.selectFactoryAddress = PaintOrderModel.instance.outPutAddr[0];
					this.uiSkin.factorytxt.text = PaintOrderModel.instance.selectFactoryAddress.name + " " + PaintOrderModel.instance.selectFactoryAddress.addr;
					
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProdCategory + "addr_id=" + PaintOrderModel.instance.selectAddress.searchZoneid ,this,onGetProductBack,null,null);
				}
				else
				{
					PaintOrderModel.instance.selectFactoryAddress = null;
					PaintOrderModel.instance.productList = [];
					this.uiSkin.factorytxt.text = "你选择的地址暂无生产商";
				}
			}
		}
		private function onResizeBrower():void
		{
			// TODO Auto Generated method stub
			if(Browser.clientHeight - 292 > 0)
				(uiSkin.panel_main).height = (Browser.clientHeight - 292);
		}
		private function onShowSelectPic():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_PIC_TO_ORDER);
		}
		
		private function onShowSelectFactory():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_FACTORY);

		}
		
		private function onSelectedSelfAddress():void
		{
			if(PaintOrderModel.instance.selectAddress)
			{
			uiSkin.myaddresstxt.text = PaintOrderModel.instance.selectAddress.addressDetail;
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOuputAddr + "addr_id=" + PaintOrderModel.instance.selectAddress.searchZoneid,this,onGetOutPutAddress,null,null);
			}
		}
		private function onSelectedAddress():void
		{
			if(PaintOrderModel.instance.selectFactoryAddress)
			this.uiSkin.factorytxt.text = PaintOrderModel.instance.selectFactoryAddress.name +  " " +  PaintOrderModel.instance.selectFactoryAddress.addr;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProdCategory + "addr_id=" + PaintOrderModel.instance.selectAddress.searchZoneid,this,onGetProductBack,null,null);

			
		}
		private function onGetProductBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				var product:Array = result as Array;
				PaintOrderModel.instance.productList = [];

				for(var i:int=0;i < product.length;i++)
				{
					var matvo:MatetialClassVo = new MatetialClassVo(product[i].prodCat_name);
					PaintOrderModel.instance.productList.push(matvo);
				}
			}
		}
		private function onShowSelectAddress():void
		{
			// TODO Auto Generated method stub
			
			
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_ADDRESS);
		}
		
		private function onShowSelectDelivery():void
		{
			if(orderlist.length <= 0)
			{
				ViewManager.showAlert("请先选择图片和工艺");
				return;
			}
			
			var orderitem:PicOrderItem = orderlist[0];
			if(orderitem.ordervo.orderData == null)
			{
				ViewManager.showAlert("未选择材料工艺");
				return;
			}
			
			
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_DELIVERY_TYPE,false,orderitem.ordervo.manufacturer_code);
		}
		
		private function onSelectAll():void
		{
			for(var i:int=0;i < orderlist.length;i++)
			{
				orderlist[i].checkSel.selected = uiSkin.selectAll.selected;				
			}
		}
		private function onBatchChangeMaterial():void
		{			
			PaintOrderModel.instance.batchChangeMatItems = new Vector.<PicOrderItem>();
			for(var i:int=0;i < orderlist.length;i++)
			{
				if(orderlist[i].checkSel.selected)
				{
					PaintOrderModel.instance.batchChangeMatItems.push(orderlist[i]);
				}
			}
			if(PaintOrderModel.instance.batchChangeMatItems.length <= 0)
			{
				ViewManager.showAlert("请至少选择一个需要更换的产品");
				return;
			}
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_MATERIAL);
			PaintOrderModel.instance.curSelectOrderItem = null;
		}
		private function onUpdateOrderPic():void
		{
			var curindex:int = uiSkin.ordervbox.numChildren;
			curindex++;
			
			var childarr:Array = [];
//			while(uiSkin.ordervbox.numChildren > 1)
//			{
//				childarr.push(uiSkin.ordervbox.getChildAt(1));
//				uiSkin.ordervbox.removeChildAt(1);	
//			}
			for each(var fvo in DirectoryFileModel.instance.haselectPic)
			{
				if(uiSkin.ordervbox.numChildren > 0)
					uiSkin.ordervbox.height += uiSkin.ordervbox.space;
				var ovo:PicOrderItemVo = new PicOrderItemVo(fvo);
				ovo.indexNum = curindex++ ;
				var item:PicOrderItem = new PicOrderItem(ovo);

				uiSkin.ordervbox.height += item.height;
				uiSkin.ordervbox.addChild(item);
				orderlist.push(item);
			}
			
			for(var i:int=0;i < uiSkin.ordervbox.numChildren;i++)
			{
				if(i == 0)
					(uiSkin.ordervbox.getChildAt(0) as PicOrderItem).y = 0;
				else
					(uiSkin.ordervbox.getChildAt(i) as PicOrderItem).y = (uiSkin.ordervbox.getChildAt(i-1) as PicOrderItem).y + (uiSkin.ordervbox.getChildAt(i-1) as PicOrderItem).height + uiSkin.ordervbox.space;
			}
			uiSkin.ordervbox.refresh();
			DirectoryFileModel.instance.haselectPic = {};
			resetOrderInfo();

		}
		
		private function onDeletePicOrder(orderitem:PicOrderItem):void
		{
			var ordervo:PicOrderItemVo = orderitem.ordervo;
			
			if(orderlist.indexOf(orderitem) >=0 )
				orderlist.splice(orderlist.indexOf(orderitem),1);

			for(var i:int=0;i < uiSkin.ordervbox.numChildren;i++)
			{
				var pvo:PicOrderItemVo = (uiSkin.ordervbox.getChildAt(i) as PicOrderItem).ordervo;
				if(pvo.indexNum > ordervo.indexNum)
					pvo.indexNum--;
				(uiSkin.ordervbox.getChildAt(i) as PicOrderItem).updateIndex();
			}
			uiSkin.ordervbox.removeChild(orderitem);
			if(uiSkin.ordervbox.height - orderitem.height - uiSkin.ordervbox.space < 0)			
				uiSkin.ordervbox.height = 0;
			else
				uiSkin.ordervbox.height -= orderitem.height + uiSkin.ordervbox.space;
			if(uiSkin.ordervbox.numChildren == 0)
				uiSkin.ordervbox.height = 0;
			uiSkin.ordervbox.size(uiSkin.ordervbox.width,0);
			uiSkin.ordervbox.refresh();
			resetOrderInfo();
		}
		
		private function updateDeliveryType():void
		{
			if(PaintOrderModel.instance.selectDelivery != null)
				uiSkin.deliverytxt.text = PaintOrderModel.instance.selectDelivery.deliveryDesc;
			resetOrderInfo();
		}
		private function onAdjustHeight(changeht:int):void
		{
			this.uiSkin.ordervbox.height += changeht;
		}
		
		private function onOrderPaint():void
		{
//			var obj:Object = {client_code:"SCFY001",order_sn:"123456",refund_amount:"9.12"};
//			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.cancelOrder,this,onPlaceOrderBack,{data:JSON.stringify(obj)},"post");
//			return;
			if(orderlist.length <= 0)
			{
				ViewManager.showAlert("未选择下单图片");
				return;
			}
			
			var orderitem:PicOrderItem = orderlist[0];
			if(orderitem.ordervo.orderData == null)
			{
				ViewManager.showAlert("未选择材料工艺");
				return;
			}
			
			var orderdata:Object = {};
			orderdata.order_sn = PaintOrderModel.getOrderSn();
			orderdata.client_code = "SCFY001";
			orderdata.consignee = PaintOrderModel.instance.selectAddress.receiverName
			orderdata.tel = PaintOrderModel.instance.selectAddress.phone;
			orderdata.address = PaintOrderModel.instance.selectAddress.proCityArea;
			orderdata.order_amountStr = "0";
			orderdata.shipping_feeStr = "0";
			orderdata.money_paidStr = "0";
			orderdata.discountStr = "0";
			orderdata.pay_timeStr = UtilTool.formatFullDateTime(new Date());
			orderdata.manufacturer_code = orderitem.ordervo.manufacturer_code;
			orderdata.manufacturer_name = orderitem.ordervo.manufacturer_name;
			
			var totalMoney:Number = 0;
			if(PaintOrderModel.instance.selectDelivery)
			{
				orderdata.logistic_code = PaintOrderModel.instance.selectDelivery.deliverynet_code;
				orderdata.logistic_name = PaintOrderModel.instance.selectDelivery.deliverynet_name;
			}
			
			orderdata.orderItemList = [];
			for(var i:int=0;i < orderlist.length;i++)
			{
				if(orderlist[i].ordervo.orderData != null)
				{
					totalMoney += orderlist[i].getPrice();
					//totalMoney += orderlist[i].getPrice();

					if(orderlist[i].ordervo.orderData.comments == "")
						orderlist[i].ordervo.orderData.comments = uiSkin.commentall.text;
					orderdata.orderItemList.push(orderlist[i].ordervo.orderData);
				}
				else
				{
					ViewManager.showAlert("有图片未选择材料工艺");
					return;
				}
					
			}
			orderdata.order_amountStr = totalMoney.toString();
			orderdata.money_paidStr =  totalMoney.toString();
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.placeOrder,this,onPlaceOrderBack,{data:JSON.stringify(orderdata)},"post");

		}
		
		private function onPlaceOrderBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("code"))
			{
				ViewManager.showAlert("下单成功");
			}
		}
		
		private function onClickOpenQQ():void
		{
			window.open('tencent://message/?uin=10987654321');
		}
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.SELECT_ORDER_ADDRESS,this,onSelectedAddress);
			EventCenter.instance.off(EventCenter.ADD_PIC_FOR_ORDER,this,onUpdateOrderPic);
			EventCenter.instance.off(EventCenter.DELETE_PIC_ORDER,this,onDeletePicOrder);
			EventCenter.instance.off(EventCenter.ADJUST_PIC_ORDER_TECH,this,onAdjustHeight);
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			EventCenter.instance.off(EventCenter.SELECT_ORDER_ADDRESS,this,onSelectedSelfAddress);

			EventCenter.instance.off(EventCenter.SELECT_OUT_ADDRESS,this,onSelectedAddress);
						
			EventCenter.instance.off(EventCenter.SELECT_DELIVERY_TYPE,this,updateDeliveryType);
			EventCenter.instance.off(EventCenter.UPDATE_ORDER_ITEM_TECH,this,resetOrderInfo);

		}
		private function onClosePanel():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);

		}
	}
}