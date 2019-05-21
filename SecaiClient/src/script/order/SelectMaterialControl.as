package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.orderModel.AttchCatVo;
	import model.orderModel.MaterialItemVo;
	import model.orderModel.MatetialClassVo;
	import model.orderModel.OrderConstant;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.ProcessCatVo;
	import model.orderModel.ProductVo;
	
	import script.ViewManager;
	
	import ui.order.SelectMaterialPanelUI;
	import ui.order.TechorItemUI;
	
	public class SelectMaterialControl extends Script
	{
		private var uiSkin:SelectMaterialPanelUI;
		
		
		private var startposx:int = 10;
		
		public var param:MaterialItemVo;
		
		private var itemheight:int = 40;
		
		private var itemspaceH:int = 30;
		private var itemspaceV:int = 20;
		
		private var allitemlist:Array;
		
		private var hasShowItemList:Array;
		
		private var firstTechlist:Vector.<TechBoxItem>;
		
		private var linelist:Vector.<Sprite>;
		
		private var hasFinishAllFlow:Boolean = false;
		
		
		public function SelectMaterialControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			hasFinishAllFlow = false;
			uiSkin = this.owner as SelectMaterialPanelUI; 
			uiSkin.main_panel.vScrollBarSkin = "";
			uiSkin.tablist.itemRender = MaterialClassBtn;
			uiSkin.tablist.vScrollBarSkin = "";
			uiSkin.tablist.selectEnable = true;
			uiSkin.tablist.spaceY = 2;
			uiSkin.tablist.renderHandler = new Handler(this, updateMatClassItem);
			
			uiSkin.tablist.selectHandler = new Handler(this,onSlecteMatClass);
			
			uiSkin.matlist.itemRender = MaterialItem;
			uiSkin.matlist.vScrollBarSkin = "";
			uiSkin.matlist.selectEnable = true;
			uiSkin.matlist.spaceY = 10;
			uiSkin.matlist.renderHandler = new Handler(this, updateMatNameItem);
			this.uiSkin.selecttech.text = "无";
			//uiSkin.matlist.selectHandler = new Handler(this,onSlecteMat);
			uiSkin.hasSelMat.text = "无";
			uiSkin.matlist.array = [];
			
			uiSkin.tablist.array = PaintOrderModel.instance.productList;
			
			this.uiSkin.techcontent.vScrollBar.hide = true;
			this.uiSkin.techcontent.hScrollBar.hide = true;
			
			this.uiSkin.main_panel.vScrollBarSkin = "";
			uiSkin.subtn.on(Event.CLICK,this,onSubItemNum);
			uiSkin.addbtn.on(Event.CLICK,this,onAddItemNum);
			uiSkin.numinput.on(Event.INPUT,this,onNumChange);
			uiSkin.numinput.text = "1";
			uiSkin.numinput.restrict = "0-9";

			if(PaintOrderModel.instance.productList && PaintOrderModel.instance.productList.length > 0)
			{
				uiSkin.tablist.selectedIndex = 0;
				//onSlecteMatClass(0);
				(uiSkin.tablist.cells[0] as MaterialClassBtn).ShowSelected = true;
			}
			
			uiSkin.box_tech.visible = false;
			uiSkin.backBtn.label = "工艺";
			
			uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
			uiSkin.btnok.on(Event.CLICK,this,onConfirmTech);
			uiSkin.backBtn.on(Event.CLICK,this,onSwitchPanel);
			
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			EventCenter.instance.on(EventCenter.SHOW_SELECT_TECH,this,initTechView);
			EventCenter.instance.on(EventCenter.CLOSE_PANEL_VIEW,this,onUpdateTechDes);

			uiSkin.main_panel.height = Browser.clientHeight;
		}
		
		private function onSubItemNum():void
		{
			var num:int = parseInt(uiSkin.numinput.text);
			if(num > 1)
				num--;
			uiSkin.numinput.text = num.toString();
			onNumChange();
		}
		private function onAddItemNum():void
		{
			var num:int = parseInt(uiSkin.numinput.text);
			num++;
			uiSkin.numinput.text = num.toString();
			onNumChange();
		}
		private function onNumChange():void
		{
			EventCenter.instance.event(EventCenter.BATCH_CHANGE_PRODUCT_NUM,uiSkin.numinput.text);
		}

		private function onResizeBrower():void
		{
			// TODO Auto Generated method stub
			 uiSkin.main_panel.height = Browser.clientHeight;
		}
		
		private function updateMatClassItem(cell:MaterialClassBtn):void
		{
			cell.setData(cell.dataSource);
		}
		private function onSlecteMatClass(index:int):void
		{
			for each(var item:MaterialClassBtn in uiSkin.tablist.cells)
			{
				item.ShowSelected = item.matclassvo == uiSkin.tablist.array[index];
			}
			
			var matvo:MatetialClassVo = uiSkin.tablist.array[index] as MatetialClassVo;
			if(matvo.childMatList != null)
				uiSkin.matlist.array = (uiSkin.tablist.array[index] as MatetialClassVo).childMatList;
			else
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProdList + PaintOrderModel.instance.selectAddress.searchZoneid + "&prodCat_name=" + matvo.matclassname,this,onGetProductListBack,null,null);

		}
		
		private function onGetProductListBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(!result.hasOwnProperty("status"))
			{
				var matvo:MatetialClassVo = uiSkin.tablist.array[uiSkin.tablist.selectedIndex] as MatetialClassVo;
				matvo.childMatList = [];
				for(var i:int=0;i < result.length;i++)
				{
					matvo.childMatList.push(new ProductVo(result[i]));
					
				}
				uiSkin.matlist.array = matvo.childMatList;
			}
		}
		private function updateMatNameItem(cell:MaterialItem):void
		{
			cell.setData(cell.dataSource);
		}
		private function onSlecteMat(index:int):void
		{
			for each(var item:MaterialItem in uiSkin.matlist.cells)
			{
				item.ShowSelected = item.matvo == uiSkin.matlist.array[index];
			}
		}
		
		private function onSwitchPanel():void
		{
			if(uiSkin.box_mat.visible)
			{
				if(PaintOrderModel.instance.curSelectMat == null)
				{
					ViewManager.showAlert("请先选择一种材料");
					return;
				}
				else
					showTechView();
					
			}
			else
			{
				uiSkin.box_mat.visible = true;
				uiSkin.box_tech.visible = false;
				uiSkin.backBtn.label = "工艺";
			}
		}
		//选择工艺---------------------------------------------
		
		private function showTechView():void
		{
			uiSkin.box_mat.visible = false;
			uiSkin.box_tech.visible = true;
			uiSkin.backBtn.label = "材料";
		}
		private function initTechView():void
		{
			uiSkin.hasSelMat.text =  PaintOrderModel.instance.curSelectMat.prod_name;
			
			showTechView();
			
			var list:Array = [];
			hasShowItemList = [];
			linelist = new Vector.<Sprite>();
			firstTechlist = new Vector.<TechBoxItem>();
			//var num:int = Math.random()*18;
			//this.uiSkin.techcontent.vScrollBarSkin = "";
			//this.uiSkin.main_panel.vScrollBarSkin = "";
			var arr:Vector.<ProcessCatVo> = PaintOrderModel.instance.curSelectMat.prcessCatList;
			var startpos:int = (this.uiSkin.techcontent.height - arr.length*itemheight -  itemspaceV * (arr.length - 1))/2;
			
			while(uiSkin.techcontent.numChildren > 0)
				uiSkin.techcontent.removeChildAt(0);
			
			if(arr.length > 0)
			{
				var manufacturecode = PaintOrderModel.instance.curSelectMat.manufacturer_code;
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProcessFlow + manufacturecode + "&procCat_name=" + arr[0].procCat_Name,this,function(data:Object):void{
					
					var result:Object = JSON.parse(data as String);
					if(!result.hasOwnProperty("status"))
					{
						PaintOrderModel.instance.curSelectProcList = result as Array;
						arr[0].selected = true;
						arr[0].initProcFlow(result);
						//onClickMat(parentitem,processCatvo);
						var materials:Vector.<MaterialItemVo> = arr[0].nextMatList;
						for(var i:int=0;i < materials.length;i++)
						{
							//var tcvo:TechMainVo = new TechMainVo();
							var itembox:TechBoxItem = new TechBoxItem();
							itembox.setData(materials[i]);
							itembox.on(Event.CLICK,this,onClickMat,[itembox,materials[i]]);		
							
							itembox.x = startposx;
							
							itembox.y = startpos;
							startpos += itembox.height + itemspaceV;
							this.uiSkin.techcontent.addChild(itembox);
							firstTechlist.push(itembox);
							hasShowItemList.push(itembox);
						}
						
					}
					
				},null,null);
			}
			
			
			
			//this.uiSkin.btnok.on(Event.CLICK,this,onConfirmTech);
			//this.uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
			allitemlist = [];
			
			//(uiSkin.main_panel).height = Browser.clientHeight;
			
		}
		
		private function drawCurves(a:TechBoxItem,b:TechBoxItem):void
		{
			var sp:Sprite = new Sprite();
			this.uiSkin.techcontent.addChild(sp);
			
			var endy = b.y - a.y;
			
			sp.graphics.drawLine(0, a.y + 0.5 * itemheight, itemspaceH*0.5, a.y + 0.5 * itemheight,"#ff4400", 1);
			
			sp.graphics.drawLine( itemspaceH*0.5, a.y + 0.5 * itemheight, itemspaceH*0.5, b.y + 0.5 * itemheight,"#ff4400", 1);
			
			sp.graphics.drawLine( itemspaceH*0.5, b.y + 0.5 * itemheight,itemspaceH, b.y + 0.5 * itemheight,"#ff4400", 1);


			//sp.graphics.drawCurves(0, a.y + 0.5 * itemheight, [0, 0, 0.4*itemspaceH, 0.8 * endy,itemspaceH,endy], "#ff4400", 1);
			sp.x =a.x + a.width;
			
			linelist.push(sp);
		}
		
		private function onGetProFlowt(parentitem:TechBoxItem,processCatvo:ProcessCatVo):void
		{
			var manufacturecode = PaintOrderModel.instance.curSelectMat.manufacturer_code;
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getProcessFlow + manufacturecode + "&procCat_name=" + processCatvo.procCat_Name,this,function(data:Object):void{
				
				var result:Object = JSON.parse(data as String);
				if(!result.hasOwnProperty("status"))
				{
					PaintOrderModel.instance.curSelectProcList = result as Array;
					processCatvo.initProcFlow(result);
					onClickMat(parentitem,processCatvo);
				}
				
			},null,null);
		}
		private function onClickMat(parentitem:TechBoxItem,matvo:Object):void
		{
			
			if(matvo.nextMatList == null && matvo is ProcessCatVo)
			{
				onGetProFlowt(parentitem, matvo as ProcessCatVo);
				
				return;
			}
			hasFinishAllFlow = false;

			if(parentitem.isSelected)
			{
				//hideItems(parentitem.x,true);
				refreshHashowItem(parentitem.x);
				updateSelectedTech();
				//if(matvo is MaterialItemVo)
				//return;
			}
//			else if(firstTechlist.indexOf(parentitem) >= 0)
//				hideItems(parentitem.x,false);
//			else
			//	hideItems(parentitem.x,true);
			
			
//			if(parentitem.isSelected)
//			{
//				parentitem.setSelected(false);
//				parentitem.setTechSelected(false);
//				if(firstTechlist.indexOf(parentitem) >= 0)
//					cancelTech(parentitem.processCatVo.nextMatList);
//				updateSelectedTech();
//				
//				return;
//				
//			}
			
			
			if(!hasShowNextMaterial(matvo as MaterialItemVo))
			{
				hideItems(parentitem.x,true);
			}
			
			parentitem.setSelected(true);
			parentitem.setTechSelected(true);
			
			
			if(matvo.nextMatList && matvo.nextMatList.length > 0 && !hasShowNextMaterial(matvo as MaterialItemVo))
			{
				var arr:Vector.<MaterialItemVo> = matvo.nextMatList;
				var startpos:int = parentitem.y + 0.5 * itemheight - (arr.length*itemheight +  itemspaceV * (arr.length - 1))/2;
				if(startpos < 0)
					startpos = 0;
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
					this.uiSkin.techcontent.addChild(itembox);
				}
				
				if(itembox != null && (itembox.x + itembox.width) > uiSkin.techcontent.width)
				{
					this.uiSkin.techcontent.hScrollBar.hide = false;
					Laya.timer.frameOnce(2,this,function(){
						this.uiSkin.techcontent.scrollTo(itembox.x + itembox.width,0);
					});
				}
				else
					this.uiSkin.techcontent.hScrollBar.visible = false;

				
			}
//			else if(matvo.attachList != null && matvo.attachList.length > 0)
//			{
//				var arrAttach:Array = matvo.attachList;
//				var startpos:int = parentitem.y + 0.5 * itemheight - (arrAttach.length*itemheight +  itemspaceV * (arrAttach.length - 1))/2;
//				var starpox:int = parentitem.x + parentitem.width + itemspaceH;
//				for(var i:int=0;i < arrAttach.length;i++)
//				{
//					//var tcvo:TechMainVo = new TechMainVo();
//					var itembox:TechBoxItem = getItembox();
//					itembox.setAttachVo(arrAttach[i]);
//					hasShowItemList.push(itembox);
//					itembox.on(Event.CLICK,this,onClickAttach,[itembox,arrAttach[i]]);		
//					
//					itembox.x = starpox;
//					
//					itembox.y = startpos;
//					
//					drawCurves(parentitem,itembox);
//					
//					startpos += itembox.height + itemspaceV;
//					this.uiSkin.techcontent.addChild(itembox);
//				}
//			}
			else
			{
				//hideItems(firstTechlist[0].x,false,true);
				hasFinishAllFlow = true;
			}
			

			if(matvo.preProc_attachmentTypeList.toLocaleUpperCase() == OrderConstant.ATTACH_PEIJIAN)
				ViewManager.instance.openView(ViewManager.VIEW_SELECT_ATTACH,false,matvo);
			updateSelectedTech();
		}
		
		private function hasShowNextMaterial(matvo:MaterialItemVo):Boolean
		{
			var nextmat:Vector.<MaterialItemVo> = matvo.nextMatList;
			if(nextmat != null)
			{
				for(var i:int=0;i < hasShowItemList.length;i++)
				{
					if((hasShowItemList[i] as TechBoxItem).techmainvo == nextmat[0])
						return true;
				}
			}
			
			return false;
		}
		
		private function onClickAttach(parentitem:TechBoxItem,attachvo:AttchCatVo):void
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
				parentitem.setTechSelected(false);
				if(firstTechlist.indexOf(parentitem) >= 0)
					cancelTech(parentitem.processCatVo.nextMatList);
				updateSelectedTech();
				
				return;
				
			}
			parentitem.setSelected(true);
			//attachvo.materialItemVo.selectAttachVo = attachvo;
			updateSelectedTech();

			hideItems(firstTechlist[0].x,false,true);
		}
		private function hideItems(curposx:Number,changedata:Boolean,finishselectTech:Boolean = false):void
		{
			for(var i:int=0;i < hasShowItemList.length;i++)
			{
				if(hasShowItemList[i].x > curposx)
				{
					hasShowItemList[i].removeSelf();
					hasShowItemList[i].setSelected(false);
					if(changedata && hasShowItemList[i].techmainvo != null)
						hasShowItemList[i].techmainvo.selected = false;
					allitemlist.push(hasShowItemList[i]);
					(hasShowItemList[i] as TechBoxItem).offAll();
					hasShowItemList.splice(i,1);
					i--;
				}
				else if(hasShowItemList[i].x == curposx)
				{
					if(!finishselectTech)
					hasShowItemList[i].setSelected(false);
					if(changedata && hasShowItemList[i].techmainvo != null)
						hasShowItemList[i].techmainvo.selected = false;

				}
			}
			
			for(var i:int=0;i < linelist.length;i++)
			{
				if(linelist[i].x > curposx)
				{
					linelist[i].graphics.clear(true);
					linelist[i].removeSelf();				
					linelist.splice(i,1);
					i--;
				}
			}
			
		}
		
		private function refreshHashowItem(curposx:Number):void
		{
			for(var i:int=0;i < hasShowItemList.length;i++)
			{
				if(hasShowItemList[i].x > curposx)
				{
					hasShowItemList[i].setSelected(false);
					if(hasShowItemList[i].techmainvo != null)
						hasShowItemList[i].techmainvo.selected = false;					
				}
				
			}
		}
		private function updateSelectedTech():void
		{
			
			this.uiSkin.selecttech.text = PaintOrderModel.instance.curSelectMat.getTechDes();
		}
		
		private function cancelTech(arr:Vector.<MaterialItemVo>):void
		{
			//var arr:Vector.<MaterialItemVo> = matvo.nextMatList;
			if(arr)
			{
				for(var i:int=0;i < arr.length;i++)
				{
					arr[i].selected = false;
					cancelTech(arr[i].nextMatList);
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
		private function onConfirmTech():void
		{
			if(!hasFinishAllFlow)
			{
				ViewManager.showAlert("未选择完整工艺");
				return;
			}
			if(PaintOrderModel.instance.curSelectOrderItem)
				PaintOrderModel.instance.curSelectOrderItem.changeProduct(PaintOrderModel.instance.curSelectMat);
			else if(PaintOrderModel.instance.batchChangeMatItems && PaintOrderModel.instance.batchChangeMatItems.length > 0)
			{
				for(var i:int=0;i < PaintOrderModel.instance.batchChangeMatItems.length;i++)
					PaintOrderModel.instance.batchChangeMatItems[i].changeProduct(PaintOrderModel.instance.curSelectMat);
			}
			EventCenter.instance.event(EventCenter.UPDATE_ORDER_ITEM_TECH);

			onCloseView();
		}
		
		private function onUpdateTechDes(viewname:String):void
		{
			if(viewname == ViewManager.VIEW_SELECT_ATTACH)
				updateSelectedTech();
		}
		private function onCloseView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_MATERIAL);
		}
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			EventCenter.instance.off(EventCenter.SHOW_SELECT_TECH,this,initTechView);
			EventCenter.instance.off(EventCenter.CLOSE_PANEL_VIEW,this,onUpdateTechDes);

		}
	}
}