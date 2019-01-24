package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Browser;
	
	import model.orderModel.MaterialItemVo;
	import model.orderModel.MatetialClassVo;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.ProcessCatVo;
	import model.orderModel.TechMainVo;
	
	import script.ViewManager;
	
	import ui.order.SelectTechPanelUI;
	import ui.order.TechorItemUI;
	
	public class SelectTechControl extends Script
	{
		private var uiSKin:SelectTechPanelUI;
		
		
		private var startposx:int = 10;
		
		public var param:MaterialItemVo;
		
		private var itemheight:int = 30;
		
		private var itemspaceH:int = 50;
		private var itemspaceV:int = 20;

		private var allitemlist:Array;
		
		private var hasShowItemList:Array;
		
		private var firstTechlist:Vector.<TechBoxItem>;
		
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
			firstTechlist = new Vector.<TechBoxItem>();
			//var num:int = Math.random()*18;
			this.uiSKin.techcontent.vScrollBarSkin = "";
			//this.uiSKin.main_panel.vScrollBarSkin = "";
			var arr:Vector.<ProcessCatVo> = PaintOrderModel.instance.curSelectMat.prcessCatList;
			var startpos:int = (this.uiSKin.techcontent.height - arr.length*itemheight -  itemspaceV * (arr.length - 1))/2;

			for(var i:int=0;i < arr.length;i++)
			{
				//var tcvo:TechMainVo = new TechMainVo();
				var itembox:TechBoxItem = new TechBoxItem();
				itembox.setProcessData(arr[i]);
				itembox.on(Event.CLICK,this,onClickMat,[itembox,arr[i]]);		

				itembox.x = startposx;
				
				itembox.y = startpos;
				startpos += itembox.height + itemspaceV;
				this.uiSKin.techcontent.addChild(itembox);
				firstTechlist.push(itembox);
			}
			this.uiSKin.btnok.on(Event.CLICK,this,onCloseView);
			this.uiSKin.btncancel.on(Event.CLICK,this,onCloseView);
			allitemlist = [];

			(uiSKin.main_panel).height = Browser.clientHeight;
			
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
		}
		private function onResizeBrower():void
		{
			// TODO Auto Generated method stub
			uiSKin.main_panel.height = Browser.clientHeight;
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
			if(parentitem.isSelected)
				hideItems(parentitem.x,true);
			else if(firstTechlist.indexOf(parentitem) >= 0)
				hideItems(parentitem.x,false);
			else
				hideItems(parentitem.x,true);


			if(parentitem.isSelected)
			{
				parentitem.setSelected(false);
				parentitem.techmainvo.selected = false;
				if(firstTechlist.indexOf(parentitem) >= 0)
					cancelTech(parentitem.techmainvo);
				updateSelectedTech();

				return;
				
			}
			
			parentitem.setSelected(true);
			parentitem.techmainvo.selected = true;
			
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
			else
			{
				hideItems(firstTechlist[0].x,false);
			}
			updateSelectedTech();
		}
		
		private function hideItems(curposx:Number,changedata:Boolean):void
		{
			for(var i:int=0;i < hasShowItemList.length;i++)
			{
				if(hasShowItemList[i].x > curposx)
				{
					hasShowItemList[i].removeSelf();
					hasShowItemList[i].setSelected(false);
					if(changedata)
						hasShowItemList[i].techmainvo.selected = false;
					allitemlist.push(hasShowItemList[i]);
					hasShowItemList.splice(i,1);
					i--;
				}
				else if(hasShowItemList[i].x == curposx)
				{
					hasShowItemList[i].setSelected(false);
					if(changedata)
						hasShowItemList[i].techmainvo.selected = false;
				}
			}
			
			for(var i:int=0;i < linelist.length;i++)
			{
				if(linelist[i].x > curposx)
				{
					linelist[i].removeSelf();				
					linelist.splice(i,1);
					i--;
				}
			}
			
		}
		
		private function updateSelectedTech():void
		{
			var arr:Vector.<ProcessCatVo> = PaintOrderModel.instance.curSelectMat.prcessCatList;
			
			var techstr:String = "";
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					techstr += arr[i].procCat_Name;
					var childtech:String = getTechStr(arr[i].nextMatList);
					if(childtech != "")
						techstr +=  "(" + childtech.substr(0,childtech.length - 1) + ")";
					techstr += ",";
				}
			
				//techstr += ",";
			}
			
			this.uiSKin.selecttech.text = techstr;
		}
		
		private function cancelTech(matvo:MaterialItemVo):void
		{
			var arr:Vector.<MaterialItemVo> = matvo.nextMatList;
			if(arr)
			{
				for(var i:int=0;i < arr.length;i++)
				{
					arr[i].selected = false;
					cancelTech(arr[i]);
				}
			}
		}
		private function getTechStr(arr:Vector.<MaterialItemVo>):String
		{
			//var arr:Vector.<MaterialItemVo> = PaintOrderModel.instance.curSelectMat.nextMatList;
			for(var i:int=0;i < arr.length;i++)
			{
				if(arr[i].selected)
				{
					return arr[i].matName + "-" + getTechStr(arr[i].nextMatList);
				}
			}
			return "";
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
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
		}
	}
}