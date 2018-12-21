package script.order
{
	import laya.components.Script;
	import laya.events.Event;
	
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
			var i:int= 1;
			for each(var fvo in DirectoryFileModel.instance.haselectPic)
			{
				var ovo:PicOrderItemVo = new PicOrderItemVo(fvo);
				ovo.indexNum = i++;
				uiSkin.ordervbox.addChild(new PicOrderItem(ovo));
			}
			
		}
		
		private function onAddPart():void
		{
			uiSkin.partvbox.addChild(new PartItem(new PartItemVo()));
			
		}
		private function onClosePanel():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_PAINT_ORDER);

		}
	}
}