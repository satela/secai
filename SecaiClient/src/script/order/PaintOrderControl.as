package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PartItemVo;
	import model.orderModel.PicOrderItemVo;
	import model.picmanagerModel.DirectoryFileModel;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	
	import ui.PaintOrderPanelUI;
	
	public class PaintOrderControl extends Script
	{
		private var uiSkin:PaintOrderPanelUI;
		public var param:Object;
		public function PaintOrderControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as PaintOrderPanelUI;
			uiSkin.firstpage.on(Event.CLICK,this,onClosePanel);
			uiSkin.panel_main.vScrollBarSkin = "";
			uiSkin.mainvbox.autoSize = true;
			uiSkin.btn_addattach.on(Event.CLICK,this,onAddPart);
			uiSkin.btnaddpic.on(Event.CLICK,this,onShowSelectPic);
			var i:int= 1;
			for each(var fvo in DirectoryFileModel.instance.haselectPic)
			{
				var ovo:PicOrderItemVo = new PicOrderItemVo(fvo);
				ovo.indexNum = i++;
				uiSkin.ordervbox.addChild(new PicOrderItem(ovo));
			}
			
			uiSkin.changemyadd.underline = true;
			uiSkin.changemyadd.underlineColor = "#222222";
			
			uiSkin.changefactory.underline = true;
			uiSkin.changefactory.underlineColor = "#222222";
			
			uiSkin.changemyadd.on(Event.CLICK,this,onShowSelectAddress);
			uiSkin.changefactory.on(Event.CLICK,this,onShowSelectFactory);

			EventCenter.instance.on(EventCenter.SELECT_ORDER_ADDRESS,this,onSelectedAddress);

		}
		
		private function onShowSelectPic():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_PIC_TO_ORDER);
		}
		
		private function onShowSelectFactory():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_FACTORY);

		}
		
		private function onSelectedAddress():void
		{
			this.uiSkin.myaddresstxt.text = PaintOrderModel.instance.selectAddress.addressDetail;
		}
		private function onShowSelectAddress():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.openView(ViewManager.VIEW_SELECT_ADDRESS);
		}
		
		private function onAddPart():void
		{
			uiSkin.partvbox.addChild(new PartItem(new PartItemVo()));
			
		}
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.SELECT_ORDER_ADDRESS,this,onSelectedAddress);

		}
		private function onClosePanel():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_PAINT_ORDER);

		}
	}
}