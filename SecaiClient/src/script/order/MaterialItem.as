package script.order
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.orderModel.MaterialItemVo;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.ProcessCatVo;
	import model.orderModel.ProductVo;
	
	import script.ViewManager;
	
	import ui.order.MaterialNameItemUI;
	
	import utils.UtilTool;
	
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
			this.matbtn.label = matvo.prod_name;
			this.on(Event.CLICK,this,onClickMat);
			
			this.grayimg.visible = PaintOrderModel.instance.checkExceedMaterialSize(matvo);
			
			this.mouseEnabled = !PaintOrderModel.instance.checkExceedMaterialSize(matvo);
			
			//this.blackrect.visible = false;
			//this.redrect.visible = false;
		}
		
		private function onClickMat():void
		{
			
			if(PaintOrderModel.instance.checkExceedMaterialSize(matvo))
			{
				ViewManager.showAlert("有图片超出材料的最大尺寸");
				return;
			}
			
			if(PaintOrderModel.instance.checkUnFitFileType(matvo))
			{
				//ViewManager.showAlert("图片格式不符合产品要求");
				return;
			}
			
			// TODO Auto Generated method stub
			if(matvo.prcessCatList != null && matvo.prcessCatList.length > 0)
			{
				matvo.resetData();
				PaintOrderModel.instance.curSelectMat = matvo;
				EventCenter.instance.event(EventCenter.SHOW_SELECT_TECH);

				//ViewManager.instance.closeView(ViewManager.VIEW_SELECT_MATERIAL);
				
				//ViewManager.instance.openView(ViewManager.VIEW_SELECT_TECHNORLOGY,false);
			}
			else
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProcessCatList + matvo.prod_code,this,onGetProcessListBack,null,null);
				
			}
			
			
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
				EventCenter.instance.event(EventCenter.SHOW_SELECT_TECH);
				//ViewManager.instance.closeView(ViewManager.VIEW_SELECT_MATERIAL);
				
				//ViewManager.instance.openView(ViewManager.VIEW_SELECT_TECHNORLOGY,false);
			}
		}
		public function set ShowSelected(value:Boolean):void
		{
			//this.blackrect.visible = !value;
			//this.redrect.visible = value;
			
		}
		
	}
}