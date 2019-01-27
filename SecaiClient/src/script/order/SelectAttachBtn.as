package script.order
{
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
			this.selbtn.label = attachCatVo.accessoryCat_Name;
		}
		
		public function set ShowSelected(value:Boolean):void
		{
			this.selbtn.selected = value;
			
		}
	}
}