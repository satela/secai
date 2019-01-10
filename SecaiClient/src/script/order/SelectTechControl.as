package script.order
{
	import laya.components.Script;
	import laya.display.Sprite;
	import laya.events.Event;
	
	import model.orderModel.MaterialItemVo;
	import model.orderModel.MatetialClassVo;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.TechMainVo;
	
	import script.ViewManager;
	
	import ui.order.SelectTechPanelUI;
	import ui.order.TechorItemUI;
	
	public class SelectTechControl extends Script
	{
		private var uiSKin:SelectTechPanelUI;
		
		private var firsttech:Vector.<TechorItemUI>;
		
		private var startposx:int = 10;
		
		public var param:MaterialItemVo;
		
		private var itemheight:int = 30;
		
		private var itemspaceH:int = 50;
		private var itemspaceV:int = 20;

		private var allitemlist:Array;
		
		private var hasShowItemList:Array;
		
		private var linelist:Vector.<Sprite>;
		public function SelectTechControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSKin = this.owner as SelectTechPanelUI;
			
			var list:Array = [];
			hasShowItemList = [];
			linelist = new Vector.<Sprite>();
			//var num:int = Math.random()*18;
			this.uiSKin.techcontent.vScrollBarSkin = "";
			var arr:Vector.<MaterialItemVo> = PaintOrderModel.instance.curSelectMat.nextMatList;
			var startpos:int = (this.uiSKin.techcontent.height - arr.length*itemheight -  itemspaceV * (arr.length - 1))/2;

			for(var i:int=0;i < arr.length;i++)
			{
				//var tcvo:TechMainVo = new TechMainVo();
				var itembox:TechBoxItem = new TechBoxItem();
				itembox.setData(arr[i]);
				itembox.on(Event.CLICK,this,onClickMat,[itembox,arr[i]]);		

				itembox.x = startposx;
				
				itembox.y = startpos;
				startpos += itembox.height + itemspaceV;
				this.uiSKin.techcontent.addChild(itembox);
			}
			this.uiSKin.btnok.on(Event.CLICK,this,onCloseView);
			this.uiSKin.btncancel.on(Event.CLICK,this,onCloseView);
			allitemlist = [];

		}
		
		private function drawCurves(a:TechBoxItem,b:TechBoxItem):void
		{
			var sp:Sprite = new Sprite();
			this.uiSKin.techcontent.addChild(sp);
			
			var endy = b.y - a.y;
			
			sp.graphics.drawCurves(0, a.y + 0.5 * itemheight, [0, 0, 0.4*itemspaceH, 0.8 * endy,itemspaceH,endy], "#ff0000", 1);
			sp.x =a.x + a.width;
			
			linelist.push(sp);
		}
		private function onClickMat(parentitem:TechBoxItem,matvo:MaterialItemVo):void
		{
			hideItems(parentitem.x);

			if(matvo.nextMatList && matvo.nextMatList.length > 0)
			{
				var arr:Vector.<MaterialItemVo> = matvo.nextMatList;
				var startpos:int = parentitem.y + 0.5 * itemheight - (arr.length*itemheight +  itemspaceV * (arr.length - 1))/2;
				var starpox:int = parentitem.x + parentitem.width + itemspaceH;
				for(var i:int=0;i < arr.length;i++)
				{
					//var tcvo:TechMainVo = new TechMainVo();
					var itembox:TechBoxItem = getItembox();
					itembox.setData(arr[i]);
					hasShowItemList.push(itembox);
					itembox.on(Event.CLICK,this,onClickMat,[itembox,arr[i]]);		
					
					itembox.x = starpox;
					
					itembox.y = startpos;
					
					drawCurves(parentitem,itembox);

					startpos += itembox.height + itemspaceV;
					this.uiSKin.techcontent.addChild(itembox);
				}
			}
		}
		
		private function hideItems(curposx:Number):void
		{
			for(var i:int=0;i < hasShowItemList.length;i++)
			{
				if(hasShowItemList[i].x > curposx)
				{
					hasShowItemList[i].removeSelf();
					allitemlist.push(hasShowItemList[i]);
					hasShowItemList.splice(i,1);
					i--;
				}
			}
		}
		private function getItembox():TechBoxItem
		{
			if(allitemlist.length > 0)
			{
				return allitemlist.splice(0,1)[0];
			}
				
			else
			{
				var itembox:TechBoxItem = new TechBoxItem();
				return itembox;
			}
		}
		private function onCloseView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_TECHNORLOGY);
		}
	}
}