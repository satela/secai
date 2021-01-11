package script.order
{
	import laya.events.Event;
	import laya.utils.Ease;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	import model.orderModel.AttchCatVo;
	import model.orderModel.MaterialItemVo;
	import model.orderModel.OrderConstant;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.ProcessCatVo;
	
	import script.ViewManager;
	
	import ui.order.TechorItemUI;
	
	import utils.UtilTool;
	
	public class TechBoxItem extends TechorItemUI
	{
		public var techmainvo:MaterialItemVo;		
		
		
		public var isSelected:Boolean = false;
		
		public var processCatVo:ProcessCatVo;
		
		public var attachVo:AttchCatVo;
		public function TechBoxItem()
		{
			super();			
		}
		
		public function setData(tvo:MaterialItemVo):void
		{
			processCatVo = null;
			techmainvo = tvo;
			initView();
			
			if(tvo.selected)
				setSelected(true);
			else
				setSelected(false);
			
			if(techmainvo.preProc_attachmentTypeList.toUpperCase() == OrderConstant.AVERAGE_CUTOFF)
			{
				if(UtilTool.hasChaofuProcess(PaintOrderModel.instance.curSelectMat.getAllSelectedTech() as Vector.<MaterialItemVo>) || PaintOrderModel.instance.checkIslongerForDfcq())
				{
					this.techBtn.disabled = true;
					this.mouseEnabled = !this.techBtn.disabled;
					this.grayimg.visible = !this.mouseEnabled;
					return;
				}				
				
			}
			
			this.techBtn.disabled = false;
			this.mouseEnabled = true;
			this.grayimg.visible = false;

			this.shineimg.visible = false;
			
					
		}
		
		public function startshine():void
		{
			this.shineimg.visible = true;
			startTween();
		}
		
		private function startTween():void
		{
			Tween.to(this.shineimg,{alpha:0},300,Ease.elasticIn,new Handler(this,onCompleteShine));

		}
		public function onCompleteShine():void
		{
			Tween.to(this.shineimg,{alpha:1},300,Ease.elasticIn,new Handler(this,startshine));

		}
		
		public function stopshine():void
		{
			this.shineimg.visible = false;
			Tween.clearAll(this.shineimg);
		}
		public function setAttachVo(attachvo:AttchCatVo):void
		{
			processCatVo = null;
			techmainvo = null;
			
			attachVo = attachvo;
			this.techBtn.label = attachVo.accessory_name;
			setSelected(false);
		}
		
		public function setProcessData(pvo:ProcessCatVo):void
		{
			techmainvo = null;
			processCatVo = pvo;
			this.techBtn.label = pvo.procCat_Name.split("-")[0];
//			if(pvo.isMandatory)
//			{
//				setSelected(true);
//			}
//			else
//				setSelected(false);
		}
		
		private function initView():void
		{
			this.techBtn.label = techmainvo.preProc_Name;
		}
		
		public function setSelected(sel:Boolean):void
		{
			this.techBtn.selected = sel;;
			isSelected = sel;
			
		}
		
		public function setTechSelected(sel:Boolean):void
		{
			if(techmainvo != null)
			{
				techmainvo.selected = sel;
//				if(sel && techmainvo.preProc_attachmentTypeList != null && techmainvo.preProc_attachmentTypeList != "" && techmainvo.preProc_attachmentTypeList.toLocaleUpperCase() != OrderConstant.ATTACH_NO && techmainvo.preProc_attachmentTypeList.toLocaleUpperCase() != OrderConstant.ATTACH_PEIJIAN)
//				{
//					ViewManager.instance.openView(ViewManager.VIEW_SELECT_PIC_TO_ORDER,false,techmainvo);
//				}
//				else
//				{
					techmainvo.attchMentFileId = "";
					techmainvo.attchFileId = "";
					techmainvo.selectAttachVoList = null;
				//}
			}
			else
				processCatVo.selected = sel;
			
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