package script.order
{
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.orderModel.MaterialItemVo;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.ProcessCatVo;
	import model.orderModel.ProductVo;
	
	import script.ViewManager;
	
	import ui.order.MaterialNameItemUI;
	
	public class MaterialItem extends MaterialNameItemUI
	{
		public var matvo:ProductVo;
		public function MaterialItem()
		{
			super();
		}
		
		public function setData(product:Object):void
		{
			matvo = product as ProductVo;
			this.matname.text = matvo.prod_name;
			
			this.on(Event.CLICK,this,onClickMat);
			//this.blackrect.visible = false;
			//this.redrect.visible = false;
		}
		
		private function onClickMat():void
		{
			// TODO Auto Generated method stub
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProcessCatList + matvo.prod_code,this,onGetProcessListBack,null,null);

			PaintOrderModel.instance.curSelectMat = matvo;
			
			
		}
		
		private function onGetProcessListBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				PaintOrderModel.instance.curSelectMat = matvo;
				PaintOrderModel.instance.curSelectMat.prcessCatList = new Vector.<ProcessCatVo>();
				for(var i:int=0;i < result.length;i++)
				{
					PaintOrderModel.instance.curSelectMat.prcessCatList.push(new ProcessCatVo(result[i]));
				}
				ViewManager.instance.closeView(ViewManager.VIEW_SELECT_MATERIAL);
				
				ViewManager.instance.openView(ViewManager.VIEW_SELECT_TECHNORLOGY,false);
			}
		}
		public function set ShowSelected(value:Boolean):void
		{
			//this.blackrect.visible = !value;
			//this.redrect.visible = value;
			
		}
		
	}
}