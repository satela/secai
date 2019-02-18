package script.order
{
	import laya.events.Event;
	
	import model.orderModel.MaterialItemVo;
	import model.orderModel.ProcessCatVo;
	
	import script.ViewManager;
	
	import ui.order.TechBoxItemUI;
	import ui.order.TechorItemUI;
	
	public class TechBoxItem extends TechorItemUI
	{
		public var techmainvo:MaterialItemVo;		
		
		
		public var isSelected:Boolean = false;
		
		public var processCatVo:ProcessCatVo;
		public function TechBoxItem()
		{
			super();			
		}
		
		public function setData(tvo:MaterialItemVo):void
		{
			processCatVo = null;
			techmainvo = tvo;
			initView();
			setSelected(false);
		}
		
		public function setProcessData(pvo:ProcessCatVo):void
		{
			techmainvo = null;
			processCatVo = pvo;
			this.txt.text = pvo.procCat_Name;
			setSelected(false);
		}
		
		private function initView():void
		{
			this.txt.text = techmainvo.preProc_Name;
		}
		
		public function setSelected(sel:Boolean):void
		{
			if(!sel)
				this.txt.borderColor = "#222222";
			else
				this.txt.borderColor = "#FF0000";
			isSelected = sel;
			
		}
		
		public function setTechSelected(sel:Boolean):void
		{
			if(techmainvo != null)
			{
				techmainvo.selected = sel;
				if(sel && techmainvo.preProc_AttachmentType != null && techmainvo.preProc_AttachmentType != "")
				{
					ViewManager.instance.openView(ViewManager.VIEW_SELECT_PIC_TO_ORDER,false,techmainvo);
				}
				else
				{
					techmainvo.attchMentFileId = "";
				}
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