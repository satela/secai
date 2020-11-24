package script.order
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.TextInput;
	import laya.utils.Handler;
	
	import model.Constast;
	import model.HttpRequestUtil;
	import model.orderModel.OrderConstant;
	import model.orderModel.PackageItem;
	import model.orderModel.PackageVo;
	import model.orderModel.PaintOrderModel;
	
	import script.ViewManager;
	
	import ui.order.PackageItemUI;
	import ui.order.PackagePanelUI;
	
	import utils.UtilTool;
	
	public class PackageOrderControl extends Script
	{
		public function PackageOrderControl()
		{
			super();
		}
		
		private var uiSkin:PackagePanelUI;
		
		private var param:Object;
		
		private var orderDatas:Array;
		
		private var requestnum:int = 0;
		
		override public function onStart():void
		{
			uiSkin = this.owner as PackagePanelUI;
			
			uiSkin.productlist.itemRender = OrderPackItem;
			uiSkin.productlist.selectEnable = false;
			uiSkin.productlist.spaceY = 2;
			uiSkin.productlist.renderHandler = new Handler(this, updateOrderItem);
			
			uiSkin.cancelbtn.on(Event.CLICK,this,onCloseView);
			uiSkin.okbtn.on(Event.CLICK,this,onConfirmPackage);

			orderDatas = param as Array;
			for(var i:int=0;i < orderDatas.length;i++)
			{
				var numlist:Array = [];
				
				numlist.push(orderDatas[i].item_number);
				for(var j:int=1;j < OrderConstant.packagemaxCout;j++)
				{
					numlist.push(0);
				}
				orderDatas[i].numlist = numlist;
				
			}
			uiSkin.addpackbtn.on(Event.CLICK,this,addnewPack);
			
			var defaultPrefer:String = UtilTool.getLocalVar("timePrefer","0");

			uiSkin.timepreferRdo.selectedIndex = parseInt(defaultPrefer);
			
			
			addnewPack();
			
			uiSkin.productlist.array = orderDatas;
			
			
		}
		
		private function addnewPack():void
		{
			
			if(uiSkin.packagebox.numChildren >= OrderConstant.packagemaxCout)
				return;
			
			var packitem:PackageItemUI = new PackageItemUI();
			
			packitem.packname.maxChars = 6;
			
			packitem.packname.focus = true;
		
			packitem.packname.select();
			
			uiSkin.packagebox.addChild(packitem);

			packitem.packname.on(Event.INPUT,this,onchangePackName,[packitem.packname,uiSkin.packagebox.numChildren - 1]);
			
			packitem.delbtn.on(Event.CLICK,this,ondeletepack,[packitem,uiSkin.packagebox.numChildren - 1]);

			packitem.x = (uiSkin.packagebox.numChildren - 1)*55;
			
			uiSkin.addpackbtn.x = 110 + uiSkin.packagebox.numChildren*55;
			
			
			packitem.packname.text = "包裹" + uiSkin.packagebox.numChildren;
			
			
			PaintOrderModel.instance.addPackage("包裹" + uiSkin.packagebox.numChildren);
			
			if(PaintOrderModel.instance.packageList.length > 1)
			{
				for(var i:int=0;i < uiSkin.productlist.cells.length;i++)
				{
					(uiSkin.productlist.cells[i] as OrderPackItem).addpacakge();
				}
			}
			if(uiSkin.packagebox.numChildren >= OrderConstant.packagemaxCout)
				uiSkin.addpackbtn.visible = false;
			
		}
		
		private function onchangePackName(nametext:TextInput,index:int):void
		{
			if(PaintOrderModel.instance.packageList[index] != null)
				PaintOrderModel.instance.packageList[index].packageName = nametext.text;
		}
		
		private function ondeletepack(packitem:PackageItemUI,index:int):void
		{
			index = uiSkin.packagebox.getChildIndex(packitem);

			if(index == 0)
			return;
			
			packitem.removeSelf();
			
			uiSkin.addpackbtn.visible = true;

			for(var i:int=index;i < uiSkin.packagebox.numChildren;i++)
			{
				(uiSkin.packagebox.getChildAt(i) as PackageItemUI).x -= 55;
			}
			uiSkin.addpackbtn.x -= 55;
			
			
			var arr:Array = orderDatas;
			
			for(var i:int=0;i < arr.length;i++)
			{
				arr[i].numlist[0] += arr[i].numlist[index];
				for(var j:int=index;j < OrderConstant.packagemaxCout - 1;j++)
				{
					arr[i].numlist[j] = arr[i].numlist[j +1 ];
				}
				arr[i].numlist[OrderConstant.packagemaxCout - 1] = 0;
			}
			PaintOrderModel.instance.packageList.splice(index,1);

			//if(PaintOrderModel.instance.packageList.length > 1)
			//{				
				for(var i:int=0;i < uiSkin.productlist.cells.length;i++)
				{
					(uiSkin.productlist.cells[i] as OrderPackItem).deletepack(index);
				}
			//}

		}
		private function onCloseView():void
		{
			PaintOrderModel.instance.packageList = new Vector.<PackageVo>();
			ViewManager.instance.closeView(ViewManager.VIEW_PACKAGE_ORDER_PANEL);
		}
		
		private function onConfirmPackage():void
		{

			PaintOrderModel.instance.setPackageData();
			

			var arr:Array = PaintOrderModel.instance.finalOrderData;
			
			requestnum = 0;
			for(var i:int=0;i < arr.length;i++)
			{
				
				PaintOrderModel.instance.curTimePrefer = uiSkin.timepreferRdo.selectedIndex + 1;
				
				var datas:String = PaintOrderModel.instance.getOrderCapcaityData(arr[i],uiSkin.timepreferRdo.selectedIndex + 1);
				
				
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDeliveryTimeList,this,ongetAvailableDateBack,{data:datas},"post");

				
			}
			//ViewManager.instance.openView(ViewManager.VIEW_CHOOSE_DELIVERY_TIME_PANEL,false,orderDatas);
			//PaintOrderModel.instance.packageList = new Vector.<PackageVo>();

		}
		
		private function ongetAvailableDateBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				var alldates:Array = result as Array;
				for(var i:int=0;i < alldates.length;i++)
				{
					
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn] = {};
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].canUrgent = false;
					PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList = [];
					
					var orderdata:Object = PaintOrderModel.instance.getSingleProductOrderData(alldates[i].orderItem_sn);
					
					var currentdate:String = alldates[i].current_date;

					if(orderdata != null && alldates[i].default_deliveryDate != null && alldates[i].default_deliveryDate != "")
					{
						orderdata.delivery_date = alldates[i].default_deliveryDate;
					
						orderdata.is_urgent = (orderdata.delivery_date == currentdate && PaintOrderModel.instance.curTimePrefer == Constast.ORDER_TIME_PREFER_URGENT);
						orderdata.lefttime = 180;
					}

					for(var j:int=0;j < alldates[i].deliveryDateList.length;j++)
					{
						if(alldates[i].deliveryDateList[j].urgent == false)
						{
							if(alldates[i].deliveryDateList[j].discount == 0)
								alldates[i].deliveryDateList[j].discount = 1;
							
							PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].deliveryDateList.push(alldates[i].deliveryDateList[j]);
							
							if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent == false)
							{
								orderdata.discount = alldates[i].deliveryDateList[j].discount;
							}
						}
						else if(currentdate == alldates[i].deliveryDateList[j].availableDate)
						{
							if(alldates[i].deliveryDateList[j].discount == 0)
								alldates[i].deliveryDateList[j].discount = 1;
							
							if(orderdata.delivery_date == alldates[i].deliveryDateList[j].availableDate && orderdata.is_urgent)
							{
								orderdata.discount = alldates[i].deliveryDateList[j].discount;
							}
							
							PaintOrderModel.instance.availableDeliveryDates[alldates[i].orderItem_sn].urgentDate = alldates[i].deliveryDateList[j];
						}
						
						
					}										
					
				}
				requestnum++;
				if(requestnum == PaintOrderModel.instance.finalOrderData.length)
				{
					ViewManager.instance.closeView(ViewManager.VIEW_PACKAGE_ORDER_PANEL);

					ViewManager.instance.openView(ViewManager.VIEW_CHOOSE_DELIVERY_TIME_PANEL,false,{orders:orderDatas,delaypay:false});
					PaintOrderModel.instance.packageList = new Vector.<PackageVo>();
				}
			}
		}
		private function updateOrderItem(cell:OrderPackItem):void
		{
			cell.setData(cell.dataSource);
		}
	}
}