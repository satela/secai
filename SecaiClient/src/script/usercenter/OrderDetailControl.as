package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Browser;
	
	import script.ViewManager;
	
	import ui.usercenter.OrderDetailPanelUI;
	
	public class OrderDetailControl extends Script
	{
		private var uiSkin:OrderDetailPanelUI;
		
		public var param:Object;
		
		public function OrderDetailControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as OrderDetailPanelUI;
			
			uiSkin.orderoanel.vScrollBarSkin = "";

			uiSkin.mainpanel.vScrollBarSkin = "";
			uiSkin.mainpanel.hScrollBarSkin = "";
			
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;

			var orderdata:Object = JSON.parse(param.or_text);
			var allproduct:Array = orderdata.orderItemList as Array;
			
			allproduct.sort(sortProduct);
			uiSkin.outputtxt.text = orderdata.manufacturer_name;

			uiSkin.orderbox.autoSize = true;
			for(var i:int=0;i < allproduct.length;i++)
			{
				var product:QuestOrderItem = new QuestOrderItem();
				uiSkin.orderbox.addChild(product);
				product.y = product.height*i ;
				product.setData(allproduct[i]);
				product.adjustHeight = refrshVbox;
				product.caller = this;
								
			}
			
			uiSkin.orderbox.size(uiSkin.orderbox.width,uiSkin.orderbox.getBounds().height);
			uiSkin.closebtn.on(Event.CLICK,this,onCloseView);
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

		}
		private function onResizeBrower():void
		{
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;
			
		}
		private function sortProduct(a:Object,b:Object):int
		{
			if(parseInt(a.item_seq) > parseInt(b.item_seq))
				return 1;
			else
				return -1;
		}
		private function refrshVbox():void
		{
			uiSkin.orderbox.refresh();

			uiSkin.orderbox.size(uiSkin.orderbox.width,uiSkin.orderbox.getBounds().height);
			//uiSkin.orderbox.height = uiSkin.orderbox.getBounds().height;
		}
		private function onCloseView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_ORDER_DETAIL_PANEL);
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

		}
	}
}