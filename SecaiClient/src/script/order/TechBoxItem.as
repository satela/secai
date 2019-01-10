package script.order
{
	import laya.events.Event;
	
	import model.orderModel.MaterialItemVo;
	import model.orderModel.TechMainVo;
	
	import ui.order.TechBoxItemUI;
	import ui.order.TechorItemUI;
	
	public class TechBoxItem extends TechorItemUI
	{
		public var techmainvo:MaterialItemVo;
		
		public var originPos:int = 110;
		
		private var allItems:Array = [];
		
		private var lastSelectIndex:int = -1;
		public function TechBoxItem()
		{
			super();			
		}
		
		public function setData(tvo:MaterialItemVo):void
		{
			techmainvo = tvo;
			initView();
		}
		private function initView():void
		{
			this.txt.text = techmainvo.matName;
		}
		
		
		private function onClickTech(index:int):void
		{
//			if(lastSelectIndex >= 0 && lastSelectIndex != index)
//			{
//				allItems[index].txt.borderColor = "#FF0000";
//				allItems[lastSelectIndex].txt.borderColor = "#445544";
//				lastSelectIndex = index;
//			}
//			else if(lastSelectIndex < 0)
//			{
//				allItems[index].txt.borderColor = "#FF0000";
//				lastSelectIndex = index;
//			}
//			else if(lastSelectIndex == index)
//			{
//				allItems[lastSelectIndex].txt.borderColor = "#445544";
//				lastSelectIndex = -1;
//			}
		}
	}
}