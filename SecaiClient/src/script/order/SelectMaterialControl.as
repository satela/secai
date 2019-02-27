package script.order
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.orderModel.MatetialClassVo;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.ProductVo;
	
	import script.ViewManager;
	
	import ui.order.SelectMaterialPanelUI;
	
	public class SelectMaterialControl extends Script
	{
		private var uiSkin:SelectMaterialPanelUI;
		public function SelectMaterialControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as SelectMaterialPanelUI; 
			
			uiSkin.tablist.itemRender = MaterialClassBtn;
			uiSkin.tablist.vScrollBarSkin = "";
			uiSkin.tablist.selectEnable = true;
			uiSkin.tablist.spaceY = 2;
			uiSkin.tablist.renderHandler = new Handler(this, updateMatClassItem);
			
			uiSkin.tablist.selectHandler = new Handler(this,onSlecteMatClass);
			
			uiSkin.matlist.itemRender = MaterialItem;
			uiSkin.matlist.vScrollBarSkin = "";
			uiSkin.matlist.selectEnable = true;
			uiSkin.matlist.spaceY = 10;
			uiSkin.matlist.renderHandler = new Handler(this, updateMatNameItem);
			
			//uiSkin.matlist.selectHandler = new Handler(this,onSlecteMat);
			
			uiSkin.matlist.array = [];
			
			uiSkin.tablist.array = PaintOrderModel.instance.productList;
			
			if(PaintOrderModel.instance.productList && PaintOrderModel.instance.productList.length > 0)
			{
				uiSkin.tablist.selectedIndex = 0;
				onSlecteMatClass(0);
				(uiSkin.tablist.cells[0] as MaterialClassBtn).ShowSelected = true;
			}
			
			uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
			uiSkin.btnok.on(Event.CLICK,this,onConfirmSelectAddress);
		}
		
		private function updateMatClassItem(cell:MaterialClassBtn):void
		{
			cell.setData(cell.dataSource);
		}
		private function onSlecteMatClass(index:int):void
		{
			for each(var item:MaterialClassBtn in uiSkin.tablist.cells)
			{
				item.ShowSelected = item.matclassvo == uiSkin.tablist.array[index];
			}
			
			var matvo:MatetialClassVo = uiSkin.tablist.array[index] as MatetialClassVo;
			if(matvo.childMatList != null)
				uiSkin.matlist.array = (uiSkin.tablist.array[index] as MatetialClassVo).childMatList;
			else
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProdList + PaintOrderModel.instance.selectAddress.searchZoneid + "&prodCat_name=" + matvo.matclassname,this,onGetProductListBack,null,null);

		}
		
		private function onGetProductListBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				var matvo:MatetialClassVo = uiSkin.tablist.array[uiSkin.tablist.selectedIndex] as MatetialClassVo;
				matvo.childMatList = [];
				for(var i:int=0;i < result.length;i++)
				{
					matvo.childMatList.push(new ProductVo(result[i]));
					
				}
				uiSkin.matlist.array = matvo.childMatList;
			}
		}
		private function updateMatNameItem(cell:MaterialItem):void
		{
			cell.setData(cell.dataSource);
		}
		private function onSlecteMat(index:int):void
		{
			for each(var item:MaterialItem in uiSkin.matlist.cells)
			{
				item.ShowSelected = item.matvo == uiSkin.matlist.array[index];
			}
		}
		
		private function onConfirmSelectAddress(index:int):void
		{
			// TODO Auto Generated method stub
			onCloseView();
		}
		
		private function onCloseView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_MATERIAL);
		}
	}
}