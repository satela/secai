package script.order
{
	import laya.display.Sprite;
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	import model.orderModel.MaterialItemVo;
	import model.orderModel.OrderConstant;
	import model.orderModel.PaintOrderModel;
	import model.orderModel.PicOrderItemVo;
	import model.orderModel.ProductVo;
	
	import ui.order.CutImageItemUI;
	
	public class ImageCutItem extends CutImageItemUI
	{
		private var cutdata:Object;
		
		//private var matvo:MaterialItemVo;
		//private var param:Object;
		private var leastCutNum:int;
		
		private var cuttype:int;
		
		private var linelist:Vector.<Sprite>;
		private var linenum:int = 19;
		
		private var color1:String = "#000000";
		
		private var color2:String = "#ffffff";
		
		private var linethick:int = 2;
		
		public function ImageCutItem()
		{
			linelist = new Vector.<Sprite>();

			super();
		}
		
		public function setData(data:*):void
		{
			cutdata = data;
			
			
			cuttyperad.selectedIndex = cutdata.orderitemvo.cuttype;
			
			cuttyperad.on(Event.CHANGE,this,onCutTypeChange);
			cutnumrad.on(Event.CHANGE,this,onCutNumChange);

			cuttype = cutdata.orderitemvo.cuttype;

			initView();
		}
		
		private function onCutTypeChange():void
		{
			
			cuttype = cuttyperad.selectedIndex;

			var finalwidth:Number = cutdata.finalWidth;
			var finalheight:Number = cutdata.finalHeight;
			var product:ProductVo = PaintOrderModel.instance.curSelectMat;
			
			var maxwidth:Number = product.max_width - 3;
			if(cuttype == 1)
			{
				leastCutNum = Math.ceil(finalheight/maxwidth) - 1;
			}
			else
			{
				leastCutNum = Math.ceil(finalwidth/maxwidth) - 1;
			}
			cutdata.orderitemvo.cutnum = leastCutNum;
			
			initCutNum();
			
			cutdata.orderitemvo.cuttype = cuttype;
			cutdata.orderitemvo.cutnum = leastCutNum;
		}
		private function initView():void
		{
			
			var finalwidth:Number = cutdata.finalWidth;
			var finalheight:Number = cutdata.finalHeight;
			if(finalwidth > finalheight)
			{
				paintimg.width = 400;
				paintimg.height = 400 * finalheight/finalwidth;
			}
			else
			{
				paintimg.height = 400;
				paintimg.width = 400 * finalwidth/finalheight;
			}
			
			paintimg.skin =  HttpRequestUtil.biggerPicUrl + cutdata.fid + ".jpg";
			
			initCutNum();
			//cuttyperad.selectedIndex
			//if(matvo.preProc_Code == OrderConstant.HORIZANTAL_CUT_COMBINE)
			//	cuttype = 0;
			
		}
		
		private function initCutNum():void
		{
			
			var finalwidth:Number = cutdata.finalWidth;
			var finalheight:Number = cutdata.finalHeight;
			var product:ProductVo = PaintOrderModel.instance.curSelectMat;

			var maxwidth:Number = product.max_width - 3;
			if(cuttype == 1)
			{
				leastCutNum = Math.ceil(finalheight/maxwidth) - 1;
			}
			else
			{
				leastCutNum = Math.ceil(finalwidth/maxwidth) - 1;
			}
			var labes:String = "";
			for(var i:int=0;i < 5;i++)
			{
				labes += (leastCutNum + i) + " ,";
			}
			labes = labes.substr(0,labes.length - 1);
			this.cutnumrad.labels = labes;
			this.cutnumrad.selectedIndex = cutdata.orderitemvo.cutnum - leastCutNum;
			//this.uiSkin.inputnum.text = leastCutNum + "";
			onCutNumChange();
		}
		private function onCutNumChange():void
		{
			for(var i:int=0;i < linelist.length;i++)
			{
				
				linelist[i].graphics.clear(true);
				linelist[i].removeSelf();				
				linelist.splice(i,1);
				i--;
				
			}
			
			var lineNum:int = cutnumrad.selectedIndex + leastCutNum;
			
			if(cutdata.orderitemvo == null)
			{
				trace("null");
			}
			cutdata.orderitemvo.cutnum = lineNum;

			var stepdist:Number = 0;
			if(cuttype == 0)
			{
				stepdist = paintimg.width/(lineNum+1);
				
				this.widthnum.text = (cutdata.finalWidth/(lineNum+1)).toFixed(2);
				for(var i:int=0;i < 2;i++)
				{
					var sp:Sprite = new Sprite();
					this.paintimg.addChild(sp);									
					
					var linelen:Number = this.paintimg.width/linenum;
					for(var j:int=0;j < linenum;j++)
					{
						
						if(j % 2 == 0)
							sp.graphics.drawLine(j  * linelen,i * this.paintimg.height, (j + 1) * linelen,i * this.paintimg.height,color1, linethick);
						else
							sp.graphics.drawLine(j * linelen,i * this.paintimg.height, (j + 1) * linelen,i * this.paintimg.height,color2, linethick);
						
					}											
					linelist.push(sp);
				}
			}
			else
			{
				stepdist = paintimg.height/(lineNum+1);
				this.widthnum.text = (cutdata.finalHeight/(lineNum+1)).toFixed(2);

				for(var i:int=0;i < 2;i++)
				{
					var sp:Sprite = new Sprite();
					this.paintimg.addChild(sp);									
					
					var linelen:Number = this.paintimg.height/linenum;
					for(var j:int=0;j < linenum;j++)
					{
						if(j % 2 == 0)
							sp.graphics.drawLine(i * this.paintimg.width,j * linelen, i * this.paintimg.width,(j +1)* linelen,color1, linethick);
						else
							sp.graphics.drawLine(i * this.paintimg.width,j * linelen, i * this.paintimg.width,(j +1)* linelen,color2, linethick);
						
					}											
					linelist.push(sp);

				}
				
			}
			for(var i:int=0;i < lineNum + 2;i++)
			{
				var sp:Sprite = new Sprite();
				this.paintimg.addChild(sp);
				
				
				if(cuttype == 0)
				{
					
					//sp.graphics.drawLine((i+1) * stepdist,0, (i+1) * stepdist,this.paintimg.height,"#ff4400", 1);
					
					var linelen:Number = this.paintimg.height/linenum;
					for(var j:int=0;j < linenum;j++)
					{
						//if(j == linenum - 1)
						//	sp.graphics.drawLine((i+1) * stepdist,j * 2 * linelen, (i+1) * stepdist,this.paintimg.height,color2, 1);
						if(j % 2 == 0)
							sp.graphics.drawLine(i * stepdist,j * linelen, i * stepdist,(j +1)* linelen,color1, linethick);
						else
							sp.graphics.drawLine(i * stepdist,j * linelen, i * stepdist,(j +1)* linelen,color2, linethick);
						
					}
					
					
				}
				else
				{
					var linelen:Number = this.paintimg.width/linenum;
					for(var j:int=0;j < linenum;j++)
					{
						//if(j == linenum - 1)
						//	sp.graphics.drawLine(j * 2 * linelen,(i+1) * stepdist, this.paintimg.width,(i+1) * stepdist,color2, 1);
						if(j % 2 == 0)
							sp.graphics.drawLine(j  * linelen,i * stepdist, (j + 1) * linelen,i * stepdist,color1, linethick);
						else
							sp.graphics.drawLine(j * linelen,i * stepdist, (j + 1) * linelen,i * stepdist,color2, linethick);
						
					}
				}
				
				
				
				linelist.push(sp);
			}
		}
	}
}