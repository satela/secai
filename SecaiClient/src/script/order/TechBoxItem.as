package script.order
{
	import model.orderModel.TechMainVo;
	
	import ui.order.TechBoxItemUI;
	import ui.order.TechorItemUI;
	
	public class TechBoxItem extends TechBoxItemUI
	{
		public var techmainvo:TechMainVo;
		
		public var originPos:int = 110;
		
		private var allItems:Array = [];
		public function TechBoxItem(tvo:TechMainVo)
		{
			super();
			techmainvo = tvo;
			initView();
		}
		
		private function initView():void
		{
			this.techname.text = techmainvo.totalName;
			
			var startposx:int = originPos;
			var startposy:int = 0;
			var xspace:int = 10;
			var yspace:int = 10;
			
			for(var i:int=0;i < techmainvo.techlist.length;i++)
			{
				var item:TechorItemUI = new TechorItemUI();
				item.txt.text = techmainvo.techlist[i].techName;
				item.txt.borderColor = "#445544";
				item.txt.width = item.txt.textField.textWidth + 20;
				
				this.addChild(item);
				
				if(startposx + xspace + item.txt.width > this.width)
				{
					startposx = originPos;
					startposy += item.txt.height + yspace;
				}
				
				item.x = startposx + xspace;
				item.y = startposy;
				
				startposx += item.txt.width + xspace;
				allItems.push(item);
			}
			if(startposy > 0)
				this.height = startposy + 30;
			else
				this.height = 30;
		}
	}
}