package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Browser;
	
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
			//uiSkin.ordervbox.autoSize = true;
			var num:int = 0;
			var totalheight:int= 0;
			for each(var fvo in DirectoryFileModel.instance.haselectPic)
			{
				var ovo:PicOrderItemVo = new PicOrderItemVo(fvo);
				ovo.indexNum = i++;
				var item:PicOrderItem = new PicOrderItem(ovo);
				uiSkin.ordervbox.addChild(item);
				//if(num > 0)
				//	uiSkin.ordervbox.height += item.height + uiSkin.ordervbox.space;
				totalheight += item.height + uiSkin.ordervbox.space;
				num++;
			}
			
			//if(uiSkin.ordervbox.height > 10)
			//	uiSkin.ordervbox.height -= uiSkin.ordervbox.space;
			
			uiSkin.ordervbox.size(uiSkin.ordervbox.width,totalheight - uiSkin.ordervbox.space);
			
			DirectoryFileModel.instance.haselectPic = {};
			uiSkin.changemyadd.underline = true;
			uiSkin.changemyadd.underlineColor = "#222222";
			
			uiSkin.changefactory.underline = true;
			uiSkin.changefactory.underlineColor = "#222222";
			
			uiSkin.changemyadd.on(Event.CLICK,this,onShowSelectAddress);
			uiSkin.changefactory.on(Event.CLICK,this,onShowSelectFactory);

			EventCenter.instance.on(EventCenter.SELECT_ORDER_ADDRESS,this,onSelectedAddress);
			EventCenter.instance.on(EventCenter.ADD_PIC_FOR_ORDER,this,onUpdateOrderPic);
			
			EventCenter.instance.on(EventCenter.DELETE_PIC_ORDER,this,onDeletePicOrder);
			EventCenter.instance.on(EventCenter.ADJUST_PIC_ORDER_TECH,this,onAdjustHeight);
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			(uiSkin.panel_main).height = (Browser.clientHeight - 160);


		}
		private function onResizeBrower():void
		{
			// TODO Auto Generated method stub
			if(Browser.clientHeight - 160 > 0)
				(uiSkin.panel_main).height = (Browser.clientHeight - 160);
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
		
		private function onUpdateOrderPic():void
		{
			var curindex:int = uiSkin.ordervbox.numChildren;
			curindex++;
			
			var childarr:Array = [];
//			while(uiSkin.ordervbox.numChildren > 1)
//			{
//				childarr.push(uiSkin.ordervbox.getChildAt(1));
//				uiSkin.ordervbox.removeChildAt(1);	
//			}
			for each(var fvo in DirectoryFileModel.instance.haselectPic)
			{
				if(uiSkin.ordervbox.numChildren > 0)
					uiSkin.ordervbox.height += uiSkin.ordervbox.space;
				var ovo:PicOrderItemVo = new PicOrderItemVo(fvo);
				ovo.indexNum = curindex++ ;
				var item:PicOrderItem = new PicOrderItem(ovo);

				uiSkin.ordervbox.height += item.height;
				uiSkin.ordervbox.addChild(item);

			}
			
			for(var i:int=0;i < uiSkin.ordervbox.numChildren;i++)
			{
				if(i == 0)
					(uiSkin.ordervbox.getChildAt(0) as PicOrderItem).y = 0;
				else
					(uiSkin.ordervbox.getChildAt(i) as PicOrderItem).y = (uiSkin.ordervbox.getChildAt(i-1) as PicOrderItem).y + (uiSkin.ordervbox.getChildAt(i-1) as PicOrderItem).height + uiSkin.ordervbox.space;
			}
			uiSkin.ordervbox.refresh();
			DirectoryFileModel.instance.haselectPic = {};
		}
		
		private function onDeletePicOrder(orderitem:PicOrderItem):void
		{
			var ordervo:PicOrderItemVo = orderitem.ordervo;
			for(var i:int=0;i < uiSkin.ordervbox.numChildren;i++)
			{
				var pvo:PicOrderItemVo = (uiSkin.ordervbox.getChildAt(i) as PicOrderItem).ordervo;
				if(pvo.indexNum > ordervo.indexNum)
					pvo.indexNum--;
				(uiSkin.ordervbox.getChildAt(i) as PicOrderItem).updateIndex();
			}
			uiSkin.ordervbox.removeChild(orderitem);
			if(uiSkin.ordervbox.height - orderitem.height - uiSkin.ordervbox.space < 0)			
				uiSkin.ordervbox.height = 0;
			else
				uiSkin.ordervbox.height -= orderitem.height + uiSkin.ordervbox.space;
			if(uiSkin.ordervbox.numChildren == 0)
				uiSkin.ordervbox.height = 0;
			uiSkin.ordervbox.size(uiSkin.ordervbox.width,0);
			uiSkin.ordervbox.refresh();

		}
		
		private function onAdjustHeight(changeht:int):void
		{
			this.uiSkin.ordervbox.height += changeht;
		}
		private function onAddPart():void
		{
			uiSkin.partvbox.addChild(new PartItem(new PartItemVo()));
			
		}
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.SELECT_ORDER_ADDRESS,this,onSelectedAddress);
			EventCenter.instance.off(EventCenter.ADD_PIC_FOR_ORDER,this,onUpdateOrderPic);
			EventCenter.instance.off(EventCenter.DELETE_PIC_ORDER,this,onDeletePicOrder);
			EventCenter.instance.off(EventCenter.ADJUST_PIC_ORDER_TECH,this,onAdjustHeight);
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

		}
		private function onClosePanel():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_PAINT_ORDER);

		}
	}
}