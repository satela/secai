package script.order
{
	import laya.events.Event;
	
	import model.orderModel.MaterialItemVo;
	import model.orderModel.PaintOrderModel;
	
	import script.ViewManager;
	
	import ui.order.MaterialNameItemUI;
	
	public class MaterialItem extends MaterialNameItemUI
	{
		public var matvo:MaterialItemVo;
		public function MaterialItem()
		{
			super();
		}
		
		public function setData(matName:Object):void
		{
			matvo = matName as MaterialItemVo;
			this.matname.text = matvo.matName;
			
			this.on(Event.CLICK,this,onClickMat);
			//this.blackrect.visible = false;
			//this.redrect.visible = false;
		}
		
		private function onClickMat():void
		{
			// TODO Auto Generated method stub
			PaintOrderModel.instance.curSelectMat = matvo;
			
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_MATERIAL);

			ViewManager.instance.openView(ViewManager.VIEW_SELECT_TECHNORLOGY,false);
		}
		
		public function set ShowSelected(value:Boolean):void
		{
			//this.blackrect.visible = !value;
			//this.redrect.visible = value;
			
		}
		
	}
}