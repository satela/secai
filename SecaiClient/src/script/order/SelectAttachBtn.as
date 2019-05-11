package script.order
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.orderModel.AttchCatVo;
	
	import ui.order.TabChooseBtnUI;
	
	public class SelectAttachBtn extends TabChooseBtnUI
	{
		public var attachCatVo:AttchCatVo;
		public function SelectAttachBtn()
		{
			super();
		}
		
		public function setData(matName:Object):void
		{
			attachCatVo = matName as AttchCatVo;
			this.selbtn.label = attachCatVo.accessory_name;
			this.selbtn.selected = false;
			this.selbtn.on(Event.CLICK,this,ShowSelected);
		}
		
		public function ShowSelected():void
		{
			this.selbtn.selected = !this.selbtn.selected;
			EventCenter.instance.event(EventCenter.ADD_TECH_ATTACH,attachCatVo);
			
		}
	}
}