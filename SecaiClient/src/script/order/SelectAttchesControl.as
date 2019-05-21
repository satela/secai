package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.orderModel.AttchCatVo;
	import model.orderModel.MaterialItemVo;
	import model.orderModel.OrderConstant;
	import model.orderModel.PaintOrderModel;
	
	import script.ViewManager;
	
	import ui.order.SelectAttchPanelUI;
	
	
	public class SelectAttchesControl extends Script
	{
		private var uiSkin:SelectAttchPanelUI;
		private var matvo:MaterialItemVo;
		private var param:Object;
		
		private var selectAttach:Vector.<AttchCatVo>;
		public function SelectAttchesControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as SelectAttchPanelUI; 
			
			uiSkin.attachList.itemRender = SelectAttachBtn;
			uiSkin.attachList.vScrollBarSkin = "";
			uiSkin.attachList.selectEnable = true;
			uiSkin.attachList.spaceY = 2;
			uiSkin.attachList.renderHandler = new Handler(this, updateAttachClassItem);
			
			uiSkin.attachList.selectHandler = new Handler(this,onSlecteAttachCat);
			uiSkin.attachList.array = [];
			matvo = param as MaterialItemVo;
			if(matvo.attachList != null && matvo.attachList.length > 0)
				uiSkin.attachList.array = matvo.attachList;
			else
			{
				
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.GetAccCatlist + "prod_code=" +PaintOrderModel.instance.curSelectMat.prod_code + "&proc_name=" + matvo.preProc_Name,this,onAccCatlistBack,null,null);
									
			}
				
			//uiSkin.attachList.itemRender = MaterialItem;
			//uiSkin.attchesList.vScrollBarSkin = "";
			//uiSkin.attchesList.selectEnable = true;
			//uiSkin.attchesList.spaceY = 10;
			//uiSkin.attchesList.renderHandler = new Handler(this, updateMatNameItem);
			
			//uiSkin.matlist.selectHandler = new Handler(this,onSlecteMat);
			
			selectAttach = new Vector.<AttchCatVo>();
			uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
			uiSkin.btnok.on(Event.CLICK,this,onSureClose);
			EventCenter.instance.on(EventCenter.ADD_TECH_ATTACH,this,onAddAttach);

		}
		
		private function onAccCatlistBack(data:String):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				if(result[0] != null)
					HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.GetAccessorylist + "manufacturer_code=" + PaintOrderModel.instance.curSelectMat.manufacturer_code + "&accessoryCat_name=" + result[0].accessoryCat_Name,this,onGetAccessorylistBack,null,null);
				
			}
		}
		
		private function onGetAccessorylistBack(data:String):void
		{
			var result:Array = JSON.parse(data as String) as Array;
			if(result)
			{
				matvo.attachList = [];
				for(var i:int=0;i < result.length;i++)
				{
					var attachVo:AttchCatVo = new AttchCatVo(result[i]);
					attachVo.materialItemVo = matvo;
					matvo.attachList.push(attachVo);

				}
				uiSkin.attachList.array = matvo.attachList;

			}
			
		}
		
		private function updateAttachClassItem(cell:SelectAttachBtn):void
		{
			cell.setData(cell.dataSource);
		}
		
		private function onAddAttach(attchvo:AttchCatVo):void
		{
//			if(selectAttach.indexOf(attchvo) < 0)
//				selectAttach.push(attchvo);
//			else
//			{
//				selectAttach.splice(selectAttach.indexOf(attchvo),1);
//			}
			matvo.selectAttachVoList = new Vector.<AttchCatVo>();
			matvo.selectAttachVoList.push(attchvo);
			onCloseView();
			EventCenter.instance.event(EventCenter.CLOSE_PANEL_VIEW,ViewManager.VIEW_SELECT_ATTACH);
		}
		private function onSureClose(index:int):void
		{
			matvo.selectAttachVoList = selectAttach;
			onCloseView();
			EventCenter.instance.event(EventCenter.CLOSE_PANEL_VIEW,ViewManager.VIEW_SELECT_ATTACH);
		}
		
		private function onSlecteAttachCat(index:int):void
		{
			for(var i:int=0;i < uiSkin.attachList.cells.length;i++)
			{
				(uiSkin.attachList.cells[i] as SelectAttachBtn).ShowSelected(i==index);
			}
			selectAttach = new Vector.<AttchCatVo>();
			selectAttach.push(uiSkin.attachList.array[index]);
		}
		
		private function onCloseView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_ATTACH);
			EventCenter.instance.off(EventCenter.ADD_TECH_ATTACH,this,onAddAttach);

		}
	}
}