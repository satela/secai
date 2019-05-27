package script.usercenter
{
	import laya.components.Script;
	import laya.events.Event;
	
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
			
			var allproduct:Array = JSON.parse(param.or_text).orderItemList as Array;

			for(var i:int=0;i < allproduct.length;i++)
			{
				var product:QuestOrderItem = new QuestOrderItem();
				uiSkin.orderbox.addChild(product);
				
				product.setData(allproduct[i]);
				product.adjustHeight = refrshVbox;
				product.caller = this;
								
			}
			
			uiSkin.closebtn.on(Event.CLICK,this,onCloseView);
		}
		private function refrshVbox():void
		{
			uiSkin.orderbox.refresh();
		}
		private function onCloseView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_ORDER_DETAIL_PANEL);
		}
	}
}