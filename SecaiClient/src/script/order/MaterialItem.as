package script.order
{
	import model.orderModel.MaterialItemVo;
	
	import ui.order.MaterialNameItemUI;
	
	public class MaterialItem extends MaterialNameItemUI
	{
		public var matvo:MaterialItemVo;
		public function MaterialItem()
		{
			super();
		}
		
		public function setData(matName:Object):void
		{
			matvo = matName as MaterialItemVo;
			this.matname.text = matvo.matName;
			
			this.blackrect.visible = false;
			this.redrect.visible = false;
		}
		
		public function set ShowSelected(value:Boolean):void
		{
			this.blackrect.visible = !value;
			this.redrect.visible = value;

		}
		
	}
}