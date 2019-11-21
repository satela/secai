package script.product
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.orderModel.DeliveryTypeVo;
	import model.orderModel.MaterialItemVo;
	import model.orderModel.MatetialClassVo;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.ProductVo;
	import model.users.AddressVo;
	import model.users.FactoryInfoVo;
	
	import script.ViewManager;
	
	import ui.order.OrderAddressItemUI;
	import ui.order.OutPutCenterUI;
	import ui.product.ProductMarketPanelUI;
	import ui.product.TreeClipUI;
	
	public class ProductMarketControl extends Script
	{
		private var uiSkin:ProductMarketPanelUI;
		public var param:Object;
		
		private var list:Array = [];
		private var treedic:Object = {};
		private var curselectItemId:String = "";
		
		private var selectAddress:AddressVo;
		private var outPutAddr:Array;
		public function ProductMarketControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ProductMarketPanelUI;
			
			uiSkin.panel_main.vScrollBarSkin = "";
			uiSkin.panel_main.hScrollBarSkin = "";
			
			uiSkin.panel_main.width = Browser.width;
			uiSkin.panel_main.height = Browser.height;// - 20;
			uiSkin.downbox.height = 710;
			
			uiSkin.myaddresstxt.on(Event.CLICK,this,onShowSelectAddress);

			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			EventCenter.instance.on(EventCenter.SELECT_ORDER_ADDRESS,this,onSelectedSelfAddress);

			uiSkin.productCateList.itemRender = ProductCategoryItem;
			
			uiSkin.productCateList.vScrollBarSkin = "";
			uiSkin.productCateList.repeatX = 1;
			uiSkin.productlist.spaceY = 5;
			
			uiSkin.productCateList.renderHandler = new Handler(this, updateProductcateList);
			uiSkin.productCateList.selectEnable = true;
			uiSkin.productCateList.selectHandler = new Handler(this,onSelectCategory);
			//uiSkin.productlist.array = [4,3,2,1];
			
			
			uiSkin.productlist.itemRender = AdvertiseProItem;
			
			uiSkin.productlist.vScrollBarSkin = "";
			uiSkin.productlist.repeatX = 1;
			uiSkin.productlist.spaceY = 2;
			
			uiSkin.productlist.renderHandler = new Handler(this, updateProductList);
			uiSkin.productlist.selectEnable = false;
			uiSkin.productlist.array = [4,3,2,1];
			
			uiSkin.haschooselist.itemRender = AdvertiseProItem;
			
			uiSkin.haschooselist.vScrollBarSkin = "";
			uiSkin.haschooselist.repeatX = 1;
			//uiSkin.productlist.spaceY = 2;
			
			uiSkin.haschooselist.renderHandler = new Handler(this, updateProductList);
			uiSkin.haschooselist.selectEnable = false;
			//uiSkin.haschooselist.array = [];
			uiSkin.haschooselist.array = [4,3,2,1];

			
			if(Userdata.instance.getDefaultAddress() != null)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOuputAddr + "addr_id=" + Userdata.instance.getDefaultAddress().searchZoneid + "&manufacturer_type=喷印输出中心",this,onGetOutPutAddress,null,null);
				uiSkin.myaddresstxt.text = Userdata.instance.getDefaultAddress().addressDetail;
				selectAddress = Userdata.instance.getDefaultAddress();
			}
			
			
		}
		
		private function onGetOutPutAddress(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				this.initOutputAddr(result as Array);
				
				while(uiSkin.outputbox.numChildren > 0)
					uiSkin.outputbox.removeChildAt(0);
				if(outPutAddr.length > 0)
				{
					//PaintOrderModel.instance.selectFactoryAddress = PaintOrderModel.instance.outPutAddr[0];
					//this.uiSkin.factorytxt.text = PaintOrderModel.instance.selectFactoryAddress[0].name + " " + PaintOrderModel.instance.selectFactoryAddress[0].addr;
					for(var i:int=0;i < outPutAddr.length;i++)
					{
						var outputitem:OutPutCenterUI = new OutPutCenterUI();
						uiSkin.outputbox.addChild(outputitem);
						outputitem.checkselect.selected = true;
						outputitem.qqContact.on(Event.CLICK,this,onClickOpenQQ);
						outputitem.factorytxt.text = outPutAddr[i].name;// + " " + PaintOrderModel.instance.selectFactoryAddress[i].addr;
					}
					uiSkin.downbox.y = 295 + (outPutAddr.length - 1)*40 + (outPutAddr.length - 1)*uiSkin.outputbox.space;
					if(outPutAddr.length > 0)
					{
						HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProdCategory + "addr_id=" + selectAddress.searchZoneid ,this,onGetMerchanProductBack,null,null);
						HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getDeliveryList + outPutAddr[0].org_code + "&addr_id=" + selectAddress.searchZoneid,this,onGetDeliveryBack,null,null);
					}

				}
				else
					uiSkin.downbox.y = 295 ;

			}
			
			uiSkin.panel_main.refresh();
		}
		
		private function onGetMerchanProductBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				var product:Array = result as Array;
				PaintOrderModel.instance.productList = [];
				
				var hasMatName:Array = [];
				var tempArr:Array = [];
				for(var i:int=0;i < product.length;i++)
				{
					if(hasMatName.indexOf(product[i].prodCat_name) < 0)
					{
						var proVo:MatetialClassVo = new MatetialClassVo(product[i].prodCat_name);						
						tempArr.push(proVo);
						hasMatName.push(product[i].prodCat_name);
					}
				}
				
				this.uiSkin.productCateList.array = tempArr;
			}
		}
		
		private function onSelectCategory(index:int):void
		{
			for each(var item:ProductCategoryItem in uiSkin.productCateList.cells)
			{
				item.ShowSelected = item.matvo == uiSkin.productCateList.array[index];
			}
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getMerchandiseList + "addr_id=" + selectAddress.searchZoneid + "&prodCat_name=" + uiSkin.productCateList.array[index].matclassname,this,onGetProductListBack,null,null);
			
		}
		private function initMerchanTree(allmatClass:Array):void
		{
			
		}
		private function onClickOpenQQ():void
		{
			window.open('tencent://message/?uin=10987654321');
		}
		private function onShowSelectAddress():void
		{			
			
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_ADDRESS);
		}
		private function onSelectedSelfAddress(add:AddressVo):void
		{
			if(add)
			{
				selectAddress = add;
				uiSkin.myaddresstxt.text = selectAddress.addressDetail;
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOuputAddr + "addr_id=" + selectAddress.searchZoneid + "&manufacturer_type=喷印输出中心",this,onGetOutPutAddress,null,null);
			}
		}
		public function initOutputAddr(addrobj:Array):void
		{
			outPutAddr = [];
			for(var i:int=0;i < addrobj.length;i++)
			{
				var addvo:FactoryInfoVo = new FactoryInfoVo(addrobj[i]);
				outPutAddr.push(addvo);
			}
		}
		
		private function updateProductList(cell:AdvertiseProItem):void
		{
			cell.setData(cell.dataSource);
		}
		private function onResizeBrower():void
		{
			// TODO Auto Generated method stub
			(uiSkin.panel_main).height = Browser.height;// - 50;
			uiSkin.panel_main.width = Browser.width;
		}
		
		private function updateProductcateList(cell:ProductCategoryItem):void
		{
			cell.setData(cell.dataSource);
		}
		
		private function onGetProductListBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
		}
		
		private function onGetDeliveryBack(data:Object):void
		{
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
				//uiSkin.mainvbox.refresh();
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
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

		}
	}
	
	
}