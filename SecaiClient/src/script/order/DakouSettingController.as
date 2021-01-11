package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.orderModel.PaintOrderModel;
	
	import script.ViewManager;
	
	import ui.order.DakouPanelUI;
	
	public class DakouSettingController extends Script
	{
		private var uiSkin:DakouPanelUI;
		public function DakouSettingController()
		{
			super();
		}
		override public function onStart():void
		{
			
			uiSkin = this.owner as DakouPanelUI; 
			
			uiSkin.mainpanel.vScrollBarSkin = "";
			uiSkin.mainpanel.hScrollBarSkin = "";
			
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;
			
			
			uiSkin.btnok.on(Event.CLICK,this,closeView);
			
			uiSkin.productlist.itemRender = DakouCell;
			
			uiSkin.productlist.vScrollBarSkin = "";
			uiSkin.productlist.repeatX = 3;
			uiSkin.productlist.spaceY = 10;
			uiSkin.productlist.spaceX = 10;
			
			
			uiSkin.productlist.renderHandler = new Handler(this, updateProductList);
			uiSkin.productlist.selectEnable = false;
			
			uiSkin.dakouradio.selectedIndex = 0;
			
			uiSkin.dakouradio.on(Event.CHANGE,this,onChangeDakNum);
			var arr:Array = [];
			//var curmat:ProductVo = PaintOrderModel.instance.curSelectMat;
			
			if(PaintOrderModel.instance.curSelectOrderItem != null)
			{
				var cutdata:Object = {};
				cutdata.finalWidth = PaintOrderModel.instance.curSelectOrderItem.finalWidth;
				cutdata.finalHeight = PaintOrderModel.instance.curSelectOrderItem.finalHeight;
				cutdata.fid = PaintOrderModel.instance.curSelectOrderItem.ordervo.picinfo.fid;
				
				cutdata.orderitemvo = PaintOrderModel.instance.curSelectOrderItem.ordervo;
				cutdata.orderitemvo.dakouNum = 1;
				cutdata.orderitemvo.dkleftpos= cutdata.finalWidth/2;
				cutdata.orderitemvo.dkrightpos= cutdata.finalWidth - 5;
				
				arr.push(cutdata);
			}
			else
			{
				var batchlist:Vector.<PicOrderItem> = PaintOrderModel.instance.batchChangeMatItems;
				for(var i:int=0;i < batchlist.length;i++)
				{
					
					var cutdata:Object = {};
					cutdata.finalWidth = batchlist[i].finalWidth;
					cutdata.finalHeight = batchlist[i].finalHeight;
					cutdata.fid = batchlist[i].ordervo.picinfo.fid;
					
					cutdata.orderitemvo = batchlist[i].ordervo;
					cutdata.orderitemvo.dakouNum = 1;
					cutdata.orderitemvo.dkleftpos= cutdata.finalWidth/2;
					cutdata.orderitemvo.dkrightpos= cutdata.finalWidth - 5;
					
					arr.push(cutdata);
					
				}
			}
			
			uiSkin.productlist.array = arr;
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			
			uiSkin.productlist.on(Event.MOUSE_OVER,this,pauseParentScroll);
			uiSkin.productlist.on(Event.MOUSE_OUT,this,resumeParentScroll);
			
			//initView();
			//uiSkin.inputnum.on(Event.INPUT,this,onCutNumChange);
			
		}
		
		private function onResizeBrower():void
		{
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;
			
		}
		
		private function pauseParentScroll():void
		{
			
			uiSkin.mainpanel.vScrollBar.target = null;
		}
		private function resumeParentScroll():void
		{
			
			uiSkin.mainpanel.vScrollBar.target = uiSkin.mainpanel;
			
		}
		private function updateProductList(cell:DakouCell,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		
		private function onChangeDakNum():void
		{
			var arr:Array = uiSkin.productlist.array;
			for(var i:int=0;i < arr.length;i++)
			{
				arr[i].orderitemvo.dakouNum = uiSkin.dakouradio.selectedIndex + 1;
				if(arr[i].orderitemvo.dakouNum == 1)
					arr[i].orderitemvo.dkleftpos= arr[i].finalWidth/2;
				else
					arr[i].orderitemvo.dkleftpos= 5;

				arr[i].orderitemvo.dkrightpos= arr[i].finalWidth - 5;
			}
			
			uiSkin.productlist.array = arr;
			uiSkin.productlist.refresh();
			
		}
		private function closeView():void
		{
			
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			
			ViewManager.instance.closeView(ViewManager.VIEW_DAKOU_PANEL);
			
		}
	}
}