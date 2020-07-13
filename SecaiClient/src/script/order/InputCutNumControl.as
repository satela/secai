package script.order
{
	import eventUtil.EventCenter;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	import laya.components.Script;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.orderModel.MaterialItemVo;
	import model.orderModel.OrderConstant;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.ProductVo;
	
	import script.ViewManager;
	
	import ui.order.InputCutNumPanelUI;
	
	public class InputCutNumControl extends Script
	{
		private var uiSkin:InputCutNumPanelUI;
		private var matvo:MaterialItemVo;
		private var param:Object;
		private var leastCutNum:int;

		private var cuttype:int;
		
		private var linelist:Vector.<Sprite>;

		public function InputCutNumControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as InputCutNumPanelUI; 
			
			uiSkin.mainpanel.vScrollBarSkin = "";
			uiSkin.mainpanel.hScrollBarSkin = "";
			
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;
			
			matvo = param as MaterialItemVo;
			linelist = new Vector.<Sprite>();
			uiSkin.okbtn.on(Event.CLICK,this,closeView);
			
			uiSkin.productlist.itemRender = ImageCutItem;
			
			uiSkin.productlist.vScrollBarSkin = "";
			uiSkin.productlist.repeatX = 2;
			uiSkin.productlist.spaceY = 20;
			uiSkin.productlist.spaceX = 340;
			
			
			uiSkin.productlist.renderHandler = new Handler(this, updateProductList);
			uiSkin.productlist.selectEnable = false;
			
			var arr:Array = [];
			var curmat:ProductVo = PaintOrderModel.instance.curSelectMat;

			uiSkin.maxtips.text = "（单份最大裁切宽度：" + (curmat.max_width-3) + "cm）";
			if(PaintOrderModel.instance.curSelectOrderItem != null)
			{
				var cutdata:Object = {};
				cutdata.finalWidth = PaintOrderModel.instance.curSelectOrderItem.finalWidth;
				cutdata.finalHeight = PaintOrderModel.instance.curSelectOrderItem.finalHeight;
				cutdata.fid = PaintOrderModel.instance.curSelectOrderItem.ordervo.picinfo.fid;
				
				cutdata.orderitemvo = PaintOrderModel.instance.curSelectOrderItem.ordervo;
				cutdata.orderitemvo.cuttype = 0;
				cutdata.orderitemvo.cutnum = Math.ceil(PaintOrderModel.instance.curSelectOrderItem.finalWidth/(curmat.max_width-3));
				
				var cutlen:Number = PaintOrderModel.instance.curSelectOrderItem.finalWidth/cutdata.orderitemvo.cutnum;
				cutlen = parseFloat(cutlen.toFixed(2));
				cutdata.orderitemvo.eachCutLength = [];
				for(var j:int=0;j < cutdata.orderitemvo.cutnum;j++)
					cutdata.orderitemvo.eachCutLength.push(cutlen);
				arr.push(cutdata);
			}
			else
			{
				var batchlist:Vector.<PicOrderItem> = PaintOrderModel.instance.batchChangeMatItems;
				for(var i:int=0;i < batchlist.length;i++)
				{
					if(batchlist[i].finalWidth > curmat.max_width && batchlist[i].finalHeight > curmat.max_width)
					{
						var cutdata:Object = {};
						cutdata.finalWidth = batchlist[i].finalWidth;
						cutdata.finalHeight = batchlist[i].finalHeight;
						cutdata.fid = batchlist[i].ordervo.picinfo.fid;
						
						cutdata.orderitemvo = batchlist[i].ordervo;
						cutdata.orderitemvo.cuttype = 0;
						cutdata.orderitemvo.cutnum = Math.ceil(batchlist[i].finalWidth/(curmat.max_width-3));
						
						var cutlen:Number = batchlist[i].finalWidth/cutdata.orderitemvo.cutnum;
						cutlen = parseFloat(cutlen.toFixed(2));
						cutdata.orderitemvo.eachCutLength = [];
						for(var j:int=0;j < cutdata.orderitemvo.cutnum;j++)
							cutdata.orderitemvo.eachCutLength.push(cutlen);
						arr.push(cutdata);
					}
				}
			}
			
			uiSkin.productlist.array = arr;
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

			uiSkin.productlist.on(Event.MOUSE_OVER,this,pauseParentScroll);
			uiSkin.productlist.on(Event.MOUSE_OUT,this,resumeParentScroll);
			
			//initView();
			//uiSkin.inputnum.on(Event.INPUT,this,onCutNumChange);

		}
		
		private function onResizeBrower():void
		{
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;
			
		}
		
		private function pauseParentScroll():void
		{

			uiSkin.mainpanel.vScrollBar.target = null;
		}
		private function resumeParentScroll():void
		{
			
			uiSkin.mainpanel.vScrollBar.target = uiSkin.mainpanel;
			
		}
		private function updateProductList(cell:ImageCutItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		
		
		private function closeView():void
		{
			
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

			ViewManager.instance.closeView(ViewManager.INPUT_CUT_NUM);
			
		}
	}
}