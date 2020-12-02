package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.net.HttpRequest;
	import laya.ui.Panel;
	import laya.utils.Browser;
	import laya.utils.Utils;
	
	import model.ChinaAreaModel;
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.orderModel.DeliveryTypeVo;
	import model.orderModel.MatetialClassVo;
	import model.orderModel.OrderConstant;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PartItemVo;
	import model.orderModel.PicOrderItemVo;
	import model.picmanagerModel.DirectoryFileModel;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	import script.usercenter.UserMainControl;
	
	import ui.PaintOrderPanelUI;
	import ui.order.OrderAddressItemUI;
	import ui.order.OutPutCenterUI;
	
	import utils.UtilTool;
	
	public class PaintOrderControl extends Script
	{
		private var uiSkin:PaintOrderPanelUI;
		public var param:Object;
		
		private var orderlist:Vector.<PicOrderItem>;
		
		private var fengeoriginy:Number = 0;
		
		private var floatpyy:Number = 0;
		
		private var mianvbox:Number = 0;
		
		public function PaintOrderControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			PaintOrderModel.instance.resetData();
			uiSkin = this.owner as PaintOrderPanelUI;
			//uiSkin.firstpage.on(Event.CLICK,this,onClosePanel);
			//uiSkin.panel_main.vScrollBarSkin = "";
			uiSkin.mainvbox.autoSize = true;
			//uiSkin.btn_addattach.on(Event.CLICK,this,onAddPart);
			uiSkin.btnaddpic.on(Event.CLICK,this,onShowSelectPic);
			var i:int= 1;
			//uiSkin.ordervbox.autoSize = true;
			var num:int = 0;
			var totalheight:int= 0;
			
			//uiSkin.commentall.visible = false;
			//uiSkin.batchcomment.visible = false;
			uiSkin.commentall.maxChars = 10;
			
			uiSkin.copynum.text = "1";
			uiSkin.copynum.restrict = "0-9";
			uiSkin.copynum.maxChars = 3;
			uiSkin.copynum.on(Event.INPUT,this,onNumChange);

			
			fengeoriginy = uiSkin.fengeimg.y;
			floatpyy = uiSkin.floatpt.y;
			mianvbox = uiSkin.mainvbox.y;
			
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
			
			uiSkin.productNum.text = orderlist.length.toString();
			
			uiSkin.textTotalPrice.style.fontSize = 22;
			uiSkin.textTotalPrice.style.font = "SimHei";
			
			uiSkin.textDeliveryType.style.fontSize = 22;
			uiSkin.textDeliveryType.style.font = "SimHei";
			
			uiSkin.textPayPrice.style.fontSize = 22;
			uiSkin.textPayPrice.style.font = "SimHei";
			
			//if(uiSkin.ordervbox.height > 10)
			//	uiSkin.ordervbox.height -= uiSkin.ordervbox.space;
			
			uiSkin.ordervbox.size(uiSkin.ordervbox.width,totalheight - uiSkin.ordervbox.space);
			//(uiSkin.panel_main).height = uiSkin.mainvbox.height;

			DirectoryFileModel.instance.haselectPic = {};
			//uiSkin.myaddresstxt.underline = true;
			//uiSkin.myaddresstxt.underlineColor = "#222222";
			
			//uiSkin.factorytxt.underline = true;
			//uiSkin.factorytxt.underlineColor = "#222222";
		//	uiSkin.qqContact.on(Event.CLICK,this,onClickOpenQQ);
			uiSkin.myaddresstxt.on(Event.CLICK,this,onShowSelectAddress);
		//	uiSkin.factorytxt.on(Event.CLICK,this,onShowSelectFactory);
			//uiSkin.deliverytxt.on(Event.CLICK,this,onShowSelectDelivery);
			
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
			EventCenter.instance.on(EventCenter.BATCH_CHANGE_PRODUCT_NUM,this,changeProductNum);
			EventCenter.instance.on(EventCenter.PAY_ORDER_SUCESS,this,onPaySucess);
			EventCenter.instance.on(EventCenter.CANCEL_PAY_ORDER,this,onCancelPay);

			uiSkin.panelout.vScrollBarSkin = "";
			uiSkin.panelout.hScrollBarSkin = "";
			
			uiSkin.panelbottom.hScrollBarSkin = "";
			uiSkin.panelout.hScrollBar.mouseWheelEnable = false;
			

			uiSkin.panelout.width = Browser.width;
			uiSkin.panelbottom.width = Browser.width;

			uiSkin.deliversp.autoSize = true;
			//(uiSkin.panel_main).bottom = 298 + (Browser.height - 1080);
			//(uiSkin.panelout).height = (Browser.height - 80);

			if(Browser.height > Laya.stage.height)
				this.uiSkin.height = 1080;
			else
				this.uiSkin.height = Browser.height;
			this.uiSkin.btnordernow.on(Event.CLICK,this,onOrderPaint);
			this.uiSkin.btnsaveorder.on(Event.CLICK,this,onSaveOrder);

			this.uiSkin.panelout.on(Event.DRAG_MOVE,this,onDragMove);
			
			if(Userdata.instance.company == null || Userdata.instance.company == "")
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo ,this,getCompanyInfo,null,"post");

//			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProcessFlow,this,function(data:Object):void{
//				
//				var result:Object = JSON.parse(data as String);
//				if(result.hasOwnProperty("status"))
//				{
//					
//				}
//				trace(data);
//			});
			
			uiSkin.textTotalPrice.visible = !Userdata.instance.isHidePrice();
			uiSkin.textDeliveryType.visible = !Userdata.instance.isHidePrice();
			uiSkin.textPayPrice.visible = !Userdata.instance.isHidePrice();

			
			PaintOrderModel.instance.selectAddress = null;

			resetOrderInfo();
			if(Userdata.instance.getDefaultAddress() != null)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOuputAddr + "addr_id=" + Userdata.instance.getDefaultAddress().searchZoneid + "&manufacturer_type=喷印输出中心",this,onGetOutPutAddress,null,null);
				uiSkin.myaddresstxt.text = Userdata.instance.getDefaultAddress().addressDetail;
				PaintOrderModel.instance.selectAddress = Userdata.instance.getDefaultAddress();
			}
			Laya.timer.frameLoop(5,this,onDragMove);
		}
		
		private function getCompanyInfo(data:Object):void
		{
			if(this.destroyed)
				return;
			var result:Object = JSON.parse(data as String);
			
			if(result.status == 0)
			{
				Userdata.instance.company = result.name;
				Userdata.instance.companyShort = result.shortname;
			}
			
		}
		
		private function onNumChange():void
		{
			if(uiSkin.copynum.text == "")
				uiSkin.copynum.text = "1";
			var num:int = parseInt(uiSkin.copynum.text);
			if(num < 1)
			{
				uiSkin.copynum.text = "1";
			}
			if(num > 100)
			{
				uiSkin.copynum.text = "100";
			}
			this.resetOrderInfo();
		}
		private function onDragMove():void
		{
			//if(uiSkin.panelout.hScrollBar)
			//trace("panel out:" + uiSkin.panelout.y + "," + uiSkin.panelout.hScrollBar.value);  
			if(uiSkin.floatpt.localToGlobal(new Point(uiSkin.floatpt.x,uiSkin.floatpt.y),false).y - 294 <= 0)
			{
				if(uiSkin.floatdocker.parent != uiSkin)
				{
					uiSkin.addChild(uiSkin.floatdocker);
					uiSkin.floatdocker.y = 0;
					uiSkin.floatdocker.x = 320;
				}
			}
			else if(uiSkin.floatdocker.parent != uiSkin.floatpt)
			{
				uiSkin.floatpt.addChild(uiSkin.floatdocker);
				uiSkin.floatdocker.y = 0;
				uiSkin.floatdocker.x = 0;

			}
		}
		private function resetOrderInfo():void
		{
			var total:Number = 0;
//			for(var i:int=0;i < orderlist.length;i++)
//			{
//				total += Number(orderlist[i].total.text);
//			}
			//var arr:Array = [];
			if(orderlist.length > 0)
			{
				
				var orderFactory:Object = {};
				
				for(var i:int=0; i < orderlist.length;i++)
				{
					var orderitem:PicOrderItem = orderlist[i];
					//				if(!orderitem.checkCanOrder())
					//				{
					//					//ViewManager.showAlert("未选择材料工艺");
					//					return null;
					//				}
					
					var orderdata:Object;
					if(orderitem.ordervo.orderData != null && !orderFactory.hasOwnProperty(orderitem.ordervo.manufacturer_code))
					{
						orderdata = {};
						orderdata.order_sn = PaintOrderModel.getOrderSn();
						orderdata.client_code = "CL10200";
						orderdata.consignee = Userdata.instance.companyShort + "#" + PaintOrderModel.instance.selectAddress.receiverName;
						orderdata.tel = PaintOrderModel.instance.selectAddress.phone;
						orderdata.address = PaintOrderModel.instance.selectAddress.proCityArea;
						orderdata.order_amountStr = 0;
						orderdata.shipping_feeStr = "0";
						orderdata.money_paidStr = "0";
						orderdata.discountStr = "0";
						orderdata.pay_timeStr = UtilTool.formatFullDateTime(new Date());
						orderdata.delivery_dateStr = UtilTool.formatFullDateTime(new Date(),false);
						
						orderdata.manufacturer_code = orderitem.ordervo.manufacturer_code;
						orderdata.manufacturer_name = orderitem.ordervo.manufacturer_name;
						orderdata.contact_phone = PaintOrderModel.instance.getContactPhone(orderitem.ordervo.manufacturer_code);
						
						var totalMoney:Number = 0;
						if(PaintOrderModel.instance.selectDelivery)
						{
							orderdata.logistic_code = PaintOrderModel.instance.selectDelivery.deliverynet_code + "#" +  PaintOrderModel.instance.selectDelivery.delivery_name;
							//orderdata.logistic_name = PaintOrderModel.instance.selectDelivery.delivery_name;
						}
						
						orderdata.orderItemList = [];
						orderFactory[orderitem.ordervo.manufacturer_code] = orderdata;
					}
					else
						orderdata = orderFactory[orderitem.ordervo.manufacturer_code];
					
					
					if(orderlist[i].ordervo.orderData != null)
					{
						orderdata.order_amountStr += orderlist[i].getPrice();
						//totalMoney += orderlist[i].getPrice();
						
						if(orderlist[i].ordervo.orderData.comments == "")
							orderlist[i].ordervo.orderData.comments = uiSkin.commentall.text;
						orderlist[i].ordervo.orderData.item_seq = i+1;
						orderdata.orderItemList.push(orderlist[i].ordervo.orderData);
					}
					else
					{
						//ViewManager.showAlert("有图片未选择材料工艺");
						//return null;
					}
					
				}
				//orderdata.order_amountStr = totalMoney.toString();
				//orderdata.money_paidStr =  "0.01";//totalMoney.toString();
				for each(var odata in orderFactory)
				{
					if( (odata.order_amountStr as Number) < 2)
						odata.order_amountStr = 2.00;
					
					total += (Number)((odata.order_amountStr as Number).toFixed(2));
						
					//odata.order_amountStr = (odata.order_amountStr as Number).toFixed(2);
					
					//arr.push(odata);
				}				
				
			}
			
			var copy:int = parseInt(uiSkin.copynum.text);
			total = parseFloat(total.toFixed(1));
			total = total * copy;
			
			uiSkin.textTotalPrice.innerHTML = "<span color='#262B2E' size='20'>折后总额：</span>" + "<span color='#FF4400' size='20'>" + total.toFixed(1) + "</span>" + "<span color='#262B2E' size='20'>元</span>";
			uiSkin.textDeliveryType.innerHTML = "<span color='#262B2E' size='20'>运费总额：</span>" + "<span color='#FF4400' size='20'>" + "0" + "</span>" + "<span color='#262B2E' size='20'>元</span>";

			uiSkin.textPayPrice.innerHTML = "<span color='#262B2E' size='20'>应付总额：</span>" + "<span color='#FF4400' size='20'>" + total.toFixed(1) + "</span>" + "<span color='#262B2E' size='20'>元</span>";
			
		}
		private function onGetOutPutAddress(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				PaintOrderModel.instance.initOutputAddr(result as Array);
				
				PaintOrderModel.instance.selectFactoryAddress = PaintOrderModel.instance.outPutAddr.concat();
				while(uiSkin.outputbox.numChildren > 0)
					uiSkin.outputbox.removeChildAt(0);
				if(PaintOrderModel.instance.outPutAddr.length > 0)
				{
					//PaintOrderModel.instance.selectFactoryAddress = PaintOrderModel.instance.outPutAddr[0];
					//this.uiSkin.factorytxt.text = PaintOrderModel.instance.selectFactoryAddress[0].name + " " + PaintOrderModel.instance.selectFactoryAddress[0].addr;
					for(var i:int=0;i < PaintOrderModel.instance.outPutAddr.length;i++)
					{
						var outputitem:OutPutCenterUI = new OutPutCenterUI();
						uiSkin.outputbox.addChild(outputitem);
						outputitem.checkselect.selected = true;
						outputitem.qqContact.on(Event.CLICK,this,onClickOpenQQ);
						outputitem.factorytxt.text = PaintOrderModel.instance.selectFactoryAddress[i].name;
						outputitem.holaday.text = "";
						outputitem.outicon.skin = "commers/" + OrderConstant.OUTPUT_ICON[i];
						
					}

						
//						if(PaintOrderModel.instance.selectFactoryAddress[i].name.indexOf("义乌物与") >= 0)
//							outputitem.holaday.text = "2020年春节放假时间1月17日22时截稿，2月4日正式上班";
//						else if(PaintOrderModel.instance.selectFactoryAddress[i].name.indexOf("无锡点") >= 0)
//							outputitem.holaday.text = "2020年春节放假时间1月19日22时截稿，2月1日正式上班";
						// + " " + PaintOrderModel.instance.selectFactoryAddress[i].addr;
					
					uiSkin.fengeimg.y = fengeoriginy + (PaintOrderModel.instance.outPutAddr.length - 1)*40 + (PaintOrderModel.instance.outPutAddr.length - 2)*uiSkin.outputbox.space;
					uiSkin.floatpt.y = floatpyy + (PaintOrderModel.instance.outPutAddr.length - 1)*40 + (PaintOrderModel.instance.outPutAddr.length - 2)*uiSkin.outputbox.space;
					uiSkin.mainvbox.y = mianvbox + (PaintOrderModel.instance.outPutAddr.length - 1)*40 + (PaintOrderModel.instance.outPutAddr.length - 2)*uiSkin.outputbox.space;

					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProdCategory + "addr_id=" + PaintOrderModel.instance.selectAddress.searchZoneid ,this,onGetProductBack,null,null);
					
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDeliveryList + PaintOrderModel.instance.outPutAddr[0].org_code + "&addr_id=" + PaintOrderModel.instance.selectAddress.searchZoneid,this,onGetDeliveryBack,null,null);

				}
				else
				{
					PaintOrderModel.instance.selectFactoryAddress = null;
					PaintOrderModel.instance.productList = [];
					//this.uiSkin.factorytxt.text = "你选择的地址暂无生产商";
				}
			}
			
			for(var i:int=0; i < orderlist.length;i++)
			{
				var orderitem:PicOrderItem = orderlist[i];
				orderitem.reset();
			}
			
			this.resetOrderInfo();
		}
		
		private function onGetDeliveryBack(data:Object):void
		{
			if(this.destroyed)
				return;
			var result:Object = JSON.parse(data as String);
			while(uiSkin.deliverbox.numChildren > 0)
				uiSkin.deliverbox.removeChildAt(0);
			if(!result.hasOwnProperty("status"))
			{
				PaintOrderModel.instance.deliveryList = [];
				for(var i:int=0;i < result.length;i++)
				{
					var tempdevo:DeliveryTypeVo = new DeliveryTypeVo(result[i]);
					var deliveritem:OrderAddressItemUI = new OrderAddressItemUI();
					deliveritem.addresstxt.text = tempdevo.deliveryDesc;
					if(tempdevo.delivery_name == "送货上门")
					{
						deliveritem.btnsel.selected = true;
						deliveritem.selCheck.selected = true;
						PaintOrderModel.instance.selectDelivery = tempdevo;
					}
					
					deliveritem.on(Event.CLICK,this,onSelectDeliverAdd,[deliveritem,tempdevo]);
					uiSkin.deliverbox.addChild(deliveritem);
					//PaintOrderModel.instance.deliveryList.push(tempdevo);
				}
			}
			Laya.timer.frameOnce(2,this,function(){
				uiSkin.deliversp.size(1280,uiSkin.deliverbox.height);
				uiSkin.mainvbox.refresh();
			});
		}
		private function onSelectDeliverAdd(deliitem:OrderAddressItemUI,delivervo:DeliveryTypeVo):void
		{
			for(var i:int=0;i < uiSkin.deliverbox.numChildren;i++)
			{
				var deitem:OrderAddressItemUI = uiSkin.deliverbox.getChildAt(i) as OrderAddressItemUI;
				if(deitem)
				{
					deitem.btnsel.selected = false;
					deitem.selCheck.selected = false;
				}
			}
			
			deliitem.btnsel.selected = true;
			deliitem.selCheck.selected = true;
			PaintOrderModel.instance.selectDelivery = delivervo;

			
		}
		private function onResizeBrower():void
		{
			// TODO Auto Generated method stub
			//if(Browser.height - 350 > 0)
			//	(uiSkin.panel_main).height = (Browser.height - 350);
			//(uiSkin.panel_main).bottom = 298 + (Browser.height - 1080);

			//(uiSkin.panelout).height = (Browser.height - 80);
			if(Browser.height > Laya.stage.height)
				this.uiSkin.height = 1080;
			else
				this.uiSkin.height = Browser.height;
			uiSkin.panelout.width = Browser.width;
			uiSkin.panelbottom.width = Browser.width;

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
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOuputAddr + "addr_id=" + PaintOrderModel.instance.selectAddress.searchZoneid + "&manufacturer_type=喷印输出中心",this,onGetOutPutAddress,null,null);
			}
		}
		private function onSelectedAddress():void
		{
			if(PaintOrderModel.instance.selectFactoryAddress)
			//this.uiSkin.factorytxt.text = PaintOrderModel.instance.selectFactoryAddress.name +  " " +  PaintOrderModel.instance.selectFactoryAddress.addr;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProdCategory + "addr_id=" + PaintOrderModel.instance.selectAddress.searchZoneid,this,onGetProductBack,null,null);

			
		}
		private function onGetProductBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				var product:Array = result as Array;
				PaintOrderModel.instance.productList = [];

				var hasMatName:Array = [];
				for(var i:int=0;i < product.length;i++)
				{
					if(product[i].prodCat_name.indexOf("雕刻") < 0 && hasMatName.indexOf(product[i].prodCat_name) < 0)
					{
						var matvo:MatetialClassVo = new MatetialClassVo(product[i].prodCat_name);
						PaintOrderModel.instance.productList.push(matvo);
						hasMatName.push(product[i].prodCat_name);
					}
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
			if(PaintOrderModel.instance.selectAddress == null)
			{
				ViewManager.showAlert("请先选择收货地址");
				return;
			}
			
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
			PaintOrderModel.instance.curSelectMat = null;
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_MATERIAL);
			PaintOrderModel.instance.curSelectOrderItem = null;
		}
		private function changeProductNum(numstr:String):void
		{
			for(var i:int=0;i < orderlist.length;i++)
			{
				if(orderlist[i].checkSel.selected)
				{
					orderlist[i].inputnum.text = numstr;
					
					orderlist[i].onNumChange();
				}
			}
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
			//(uiSkin.panel_main).height = uiSkin.mainvbox.height;
			uiSkin.productNum.text = orderlist.length.toString();

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
			//(uiSkin.panel_main).height = uiSkin.mainvbox.height;
			uiSkin.productNum.text = orderlist.length.toString();

		}
		
		private function updateDeliveryType():void
		{
			//if(PaintOrderModel.instance.selectDelivery != null)
			//	uiSkin.deliverytxt.text = PaintOrderModel.instance.selectDelivery.deliveryDesc;
			resetOrderInfo();
		}
		private function onAdjustHeight(changeht:int):void
		{
			this.uiSkin.ordervbox.height += changeht;
			//(uiSkin.panel_main).height = uiSkin.mainvbox.height;
		}
		
		private function onOrderPaint():void
		{
//			var obj:Object = {client_code:"SCFY001",order_sn:"123456",refund_amount:"9.12"};
//			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.cancelOrder,this,onPlaceOrderBack,{data:JSON.stringify(obj)},"post");
//			return;
			
			if(Userdata.instance.companyShort == null)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo ,this,function(data:Object){
					
					if(this.destroyed)
						return;
					var result:Object = JSON.parse(data as String);
					
					if(result.status == 0)
					{
						Userdata.instance.company = result.name;
						Userdata.instance.companyShort = result.shortname;
					}
					
					onOrderPaint();		
				}
				,null,"post");	
				
				return;
			}
			var arr:Array = getOrderData();
			if(arr == null)
				return;
			
	
			var itemlist:Array = [];
			
			for(var i:int=0;i < arr.length;i++)
			{
				itemlist = itemlist.concat(arr[i].orderItemList);
			}
			
			PaintOrderModel.instance.finalOrderData = arr;
			
			
//			for(var i:int=0;i < arr.length;i++)
//			{
//				var datas:String = PaintOrderModel.instance.getOrderCapcaityData(arr[i]);
//				//trace("orderdeldata:" + datas);
//			}
			
			var params:String = "count=" + itemlist.length;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProductUids,this,ongetUidsBack,params,"post");
			
			
		//	HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.placeOrder,this,onPlaceOrderBack,{data:JSON.stringify(arr)},"post");

		}
		
		private function ongetUidsBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				var ids:Array = result.id;
				
				var itemlist:Array = [];
				
				for(var i:int=0;i < PaintOrderModel.instance.finalOrderData.length;i++)
				{
					itemlist = itemlist.concat(PaintOrderModel.instance.finalOrderData[i].orderItemList);
				}
				
				
				for(var i:int=0;i < ids.length;i++)
				{
					itemlist[i].orderItem_sn = ids[i];
				}
				
				ViewManager.instance.openView(ViewManager.VIEW_PACKAGE_ORDER_PANEL,false,itemlist);

			}
		}
		private function onSaveOrder():void
		{
			if(Userdata.instance.companyShort == null)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo ,this,function(data:Object){
					
					if(this.destroyed)
						return;
					var result:Object = JSON.parse(data as String);
					
					if(result.status == 0)
					{
						Userdata.instance.company = result.name;
						Userdata.instance.companyShort = result.shortname;
					}
					
					onSaveOrder();		
				}
					,null,"post");	
				
				return;
			}
			
			var arr:Array = getOrderData();
			if(arr == null)
				return;
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.placeOrder,this,onSaveOrderBack,{data:JSON.stringify(arr)},"post");
		}
		
		private function onSaveOrderBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				ViewManager.showAlert("保存订单成功，您可以到我的订单继续支付");
				ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
				
			}
		}
		private function onPaySucess():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);

		}
		
		private function onCancelPay():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
			
		}
		private function onPlaceOrderBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				//ViewManager.showAlert("下单成功");
				var totalmoney:Number = 0;
				var allorders:Array = [];
				for(var i:int=0;i < result.orders.length;i++)
				{
					var orderdata:Object = JSON.parse(result.orders[i]);
					totalmoney += Number(orderdata.money_paidStr);
					allorders.push(orderdata.order_sn);
				}
				ViewManager.instance.openView(ViewManager.VIEW_SELECT_PAYTYPE_PANEL,false,{amount:Number(totalmoney.toFixed(2)),orderid:allorders});
				
			}
		}
		
		private function getOrderData():Array
		{
			
			if(orderlist.length <= 0)
			{
				ViewManager.showAlert("未选择下单图片");
				return null;
			}
			
			if(PaintOrderModel.instance.selectDelivery == null)
			{
				ViewManager.showAlert("请选择配送方式");
				return null;
			}
			var orderFactory:Object = {};
			
			for(var i:int=0; i < orderlist.length;i++)
			{
				var orderitem:PicOrderItem = orderlist[i];
				if(!orderitem.checkCanOrder())
				{
					//ViewManager.showAlert("未选择材料工艺");
					return null;
				}
				
				var orderdata:Object;
				if(!orderFactory.hasOwnProperty(orderitem.ordervo.manufacturer_code))
				{
					orderdata = {};
					orderdata.order_sn = PaintOrderModel.getOrderSn();
					orderdata.client_code = "CL10200";
					orderdata.consignee = Userdata.instance.companyShort + "#" + PaintOrderModel.instance.selectAddress.receiverName;
					orderdata.tel = PaintOrderModel.instance.selectAddress.phone;
					orderdata.address = PaintOrderModel.instance.selectAddress.proCityArea;
					orderdata.order_amountStr = 0;
					orderdata.shipping_feeStr = "0";
					orderdata.money_paidStr = "0";
					orderdata.discountStr = "0";
					orderdata.pay_timeStr = UtilTool.formatFullDateTime(new Date());
					orderdata.delivery_dateStr = UtilTool.formatFullDateTime(new Date(),false);
					
					orderdata.manufacturer_code = orderitem.ordervo.manufacturer_code;
					orderdata.manufacturer_name = orderitem.ordervo.manufacturer_name;
					orderdata.contact_phone = PaintOrderModel.instance.getContactPhone(orderitem.ordervo.manufacturer_code);
						
					var totalMoney:Number = 0;
					if(PaintOrderModel.instance.selectDelivery)
					{
						orderdata.logistic_code = PaintOrderModel.instance.selectDelivery.deliverynet_code + "#" +  PaintOrderModel.instance.selectDelivery.delivery_name;
						//orderdata.logistic_name = PaintOrderModel.instance.selectDelivery.delivery_name;
					}
					
					orderdata.orderItemList = [];
					orderFactory[orderitem.ordervo.manufacturer_code] = orderdata;
				}
				else
					orderdata = orderFactory[orderitem.ordervo.manufacturer_code];
				
				
				if(orderlist[i].ordervo.orderData != null)
				{
					orderdata.order_amountStr += orderlist[i].getPrice();
					//totalMoney += orderlist[i].getPrice();
					
					if(orderlist[i].ordervo.orderData.comments == "")
						orderlist[i].ordervo.orderData.comments = uiSkin.commentall.text;
					orderlist[i].ordervo.orderData.item_seq = i+1;
					orderdata.orderItemList.push(orderlist[i].ordervo.orderData);
				}
				else
				{
					ViewManager.showAlert("有图片未选择材料工艺");
					return null;
				}
				
				
				//orderdata.order_amountStr = totalMoney.toString();
				//orderdata.money_paidStr =  "0.01";//totalMoney.toString();
				
			}
			var arr:Array = [];
			for each(var odata in orderFactory)
			{
				if( (odata.order_amountStr as Number) < 2)
				{
					odata.order_amountStr = 2.00;
					var itemarr:Array = odata.orderItemList;
					if(itemarr.length > 0)
					{
						var eachprice:Number = Number((2/itemarr.length).toFixed(2));
						
						var overflow:Number = 2 - eachprice*itemarr.length;
						for(var j:int=0;j < itemarr.length;j++)
						{
							if(j==0)
								itemarr[j].item_priceStr = (((eachprice + overflow)/itemarr[j].item_number) as Number).toFixed(2);
							else
								itemarr[j].item_priceStr =  ((eachprice/itemarr[j].item_number) as Number).toFixed(2);
						}
					}
				}
				
				odata.money_paidStr = (odata.order_amountStr as Number).toFixed(1);
				odata.order_amountStr = (odata.order_amountStr as Number).toFixed(1);
				//odata.order_amountStr = "0.01";
				//odata.money_paidStr = "0.01";
				arr.push(odata);
			}
			
			var copy:int = parseInt(uiSkin.copynum.text);
			var copyarr:Array = [];
			for(i=1;i < copy;i++)
			{
				for(var j:int=0;j < arr.length;j++)
				{
					var copydata:Object =  JSON.parse(JSON.stringify(arr[j]));
					copyarr.push(copydata);
				}
			}
			if(copyarr.length > 0)
				arr = arr.concat(copyarr);
			return arr;
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
			EventCenter.instance.off(EventCenter.BATCH_CHANGE_PRODUCT_NUM,this,changeProductNum);
			EventCenter.instance.off(EventCenter.PAY_ORDER_SUCESS,this,onPaySucess);
			EventCenter.instance.off(EventCenter.CANCEL_PAY_ORDER,this,onCancelPay);

			PaintOrderModel.instance.resetData();

			Laya.timer.clear(this,onDragMove);

		}
		private function onClosePanel():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);

		}
	}
}