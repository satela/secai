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
	import model.orderModel.MaterialItemVo;
	import model.users.AddressVo;
	import model.users.FactoryInfoVo;
	
	import script.ViewManager;
	
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

			(uiSkin.panel_main).height = Browser.clientHeight;// - 20;
			uiSkin.downbox.height = 710;
			uiSkin.myaddresstxt.on(Event.CLICK,this,onShowSelectAddress);

			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			EventCenter.instance.on(EventCenter.SELECT_ORDER_ADDRESS,this,onSelectedSelfAddress);

			uiSkin.productlist.itemRender = AdvertiseProItem;
			
			uiSkin.productlist.vScrollBarSkin = "";
			uiSkin.productlist.repeatX = 1;
			//uiSkin.productlist.spaceY = 2;
			
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
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOuputAddr + "addr_id=" + Userdata.instance.getDefaultAddress().searchZoneid + "&manufacturer_type=商品输出中心",this,onGetOutPutAddress,null,null);
				uiSkin.myaddresstxt.text = Userdata.instance.getDefaultAddress().addressDetail;
				selectAddress = Userdata.instance.getDefaultAddress();
			}
			
			for(var i:int=0;i < 3;i++)
			{
				var mat:MaterialItemVo = new MaterialItemVo({});
				mat.preProc_Name = "商品" + i;
				mat.is_endProc = i==2?1:0;
				mat.preProc_Code = i.toString();
				treedic[mat.preProc_Code] = mat;
				list.push(mat);
			}
			
			var treeData:String = "<data>";
			
			for(var i:int=0;i < list.length;i++)
			{
				
				treeData += getTreeData(list[i]);

				
			}

			treeData += "</data>";
			// 解析tree的数据
			var xml:* = Utils.parseXMLFromString(treeData);
						uiSkin.producttree.itemRender = TreeClipUI;
			uiSkin.producttree.xml = xml;
			uiSkin.producttree.on(Event.OPEN,this,onOpenList);
			uiSkin.producttree.on(Event.CHANGE,this,onOpenList);

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

				}
				else
					uiSkin.downbox.y = 295 ;

			}
			
			uiSkin.panel_main.refresh();
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
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOuputAddr + "addr_id=" + selectAddress.searchZoneid + "&manufacturer_type=商品输出中心",this,onGetOutPutAddress,null,null);
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
			(uiSkin.panel_main).height = Browser.clientHeight;// - 50;
		}
		private function getTreeData(matvo:MaterialItemVo):String
		{
			if(matvo.is_endProc == 1)
				return "<leaf label='File " + matvo.preProc_Name + "' id='" + matvo.preProc_Code + "'/>";
			else
			{
				var treeData:String = "";
				if(curselectItemId != matvo.preProc_Code)
				 	treeData = "<item label='Directory " +matvo.preProc_Name + "' id='" + matvo.preProc_Code + "' isOpen='false'>";
				else
					treeData = "<item label='Directory " +matvo.preProc_Name + "' id='" + matvo.preProc_Code + "' isOpen='true'>";

				if(matvo.nextMatList != null)
				{
					for(var i:int=0;i < matvo.nextMatList.length;i++)
						treeData += getTreeData(matvo.nextMatList[i]);
				}
				treeData += "</item>";
				return treeData;
			}
		}
		private function onOpenList(e:Event):void
		{
			if(uiSkin.producttree.selectedItem != null)
			{
				var matid:String = uiSkin.producttree.selectedItem.id;
				if(treedic.hasOwnProperty(matid))
				{
					var matvo:MaterialItemVo = treedic[matid];
					if(matvo.is_endProc == 0 && matvo.nextMatList.length == 0)
					{
						for(var j:int=0;j < 2;j++)
						{
							var matsub:MaterialItemVo = new MaterialItemVo({});
							matsub.preProc_Name = "商品" + matid +"_" + j;
							matsub.preProc_Code = matid +"_" + j;
							matsub.is_endProc = Math.random() > 0.5 ? 1:0;
							matvo.nextMatList.push(matsub);
							treedic[matsub.preProc_Code] = matsub;

						}
					}
				}
				
				curselectItemId = uiSkin.producttree.selectedItem.id;

				var treeData:String = "<data>";
				
				for(var i:int=0;i < list.length;i++)
				{
					
					treeData += getTreeData(list[i]);					
					
				}
				treeData += "</data>";

				// 解析tree的数据
				var xml:* = Utils.parseXMLFromString(treeData);
				uiSkin.producttree.xml = xml;

				trace("uiskin.tree:" + uiSkin.producttree.selectedItem.toString());
			}
		}
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

		}
	}
	
	
}