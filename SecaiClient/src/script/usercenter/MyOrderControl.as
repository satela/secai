package script.usercenter
{
	import laya.components.Script;
	
	import ui.usercenter.MyOrdersPanelUI;
	
	public class MyOrderControl extends Script
	{
		private var uiSkin:MyOrdersPanelUI;
		public function MyOrderControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as MyOrdersPanelUI;
			
			for(var i:int=18965898;i < 18965905;i++)
			{
				var ordetata:Object = {};
				ordetata.orderId = i.toString();
				
				var orderitem:QuestOrderItem = new QuestOrderItem();
				orderitem.setData(ordetata);
				orderitem.adjustHeight = updateVbox;
				orderitem.caller = this;
				uiSkin.orderbox.addChild(orderitem);
			}
			
		}
		
		public function updateVbox():void
		{
			uiSkin.orderbox.refresh();
		}
	}
}