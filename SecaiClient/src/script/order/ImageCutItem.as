package script.order
{
	import laya.display.Input;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.TextInput;
	
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
		
		private var curColorIndex:int = 0;
		
		private var hinputlist:Vector.<TextInput>;
		private var vinputlist:Vector.<TextInput>;

		private var inputCount:int = 7;
		public function ImageCutItem()
		{
			linelist = new Vector.<Sprite>();

			
			super();
			
			hinputlist = new Vector.<TextInput>();
			vinputlist = new Vector.<TextInput>();
			for(var i:int=0;i < inputCount;i++)
			{
				hinputlist.push(this["hinput" + i]);
				vinputlist.push(this["vinput" + i]);
				
				hinputlist[i].on(Event.INPUT,this,onHoriInput,[i]);
				vinputlist[i].on(Event.INPUT,this,onVertInput,[i]);
				
				hinputlist[i].type = Input.TYPE_NUMBER;
				vinputlist[i].type = Input.TYPE_NUMBER;

			}
		}
		
		public function setData(data:*):void
		{
			cutdata = data;
						
			cuttyperad.selectedIndex = cutdata.orderitemvo.cuttype;
			
			cuttyperad.on(Event.CHANGE,this,onCutTypeChange);
			cutnumrad.on(Event.CHANGE,this,onCutNumChange);

			cuttype = cutdata.orderitemvo.cuttype;

			initView();
			
			Laya.timer.clearAll(this);
			
			Laya.timer.loop(500,this,onReDrawLine);
		}
		
		private function onReDrawLine():void
		{
			
			drawLines();
			curColorIndex = (curColorIndex+1)%2;
		}
		
		private function onCutTypeChange():void
		{
			
			cuttype = cuttyperad.selectedIndex;

			var finalwidth:Number = cutdata.finalWidth + cutdata.border;
			var finalheight:Number = cutdata.finalHeight + cutdata.border;;
			var product:ProductVo = PaintOrderModel.instance.curSelectMat;
			
			var maxwidth:Number = cutdata.maxwidth;//product.max_width - 3;
			if(cuttype == 1)
			{
				leastCutNum = Math.ceil(finalheight/maxwidth);
				
				if(cutdata.maxwidth < OrderConstant.MAX_CUT_THRESHOLD)		
				{
					cutdata.orderitemvo.cutnum = Math.ceil(finalheight/OrderConstant.CUT_PRIOR_WIDTH);
					if(cutdata.orderitemvo.cutnum < 2)
						cutdata.orderitemvo.cutnum = 2;
				}
				else
					cutdata.orderitemvo.cutnum = leastCutNum;
			}
			else
			{
				leastCutNum = Math.ceil(finalwidth/maxwidth);
				
				if(cutdata.maxwidth < OrderConstant.MAX_CUT_THRESHOLD)		
				{
					cutdata.orderitemvo.cutnum = Math.ceil(finalwidth/OrderConstant.CUT_PRIOR_WIDTH);
					if(cutdata.orderitemvo.cutnum < 2)
						cutdata.orderitemvo.cutnum = 2;
				}
				else
					cutdata.orderitemvo.cutnum = leastCutNum;
				
			}
			//cutdata.orderitemvo.cutnum = leastCutNum;
			
			
			
			cutdata.orderitemvo.cuttype = cuttype;
			//cutdata.orderitemvo.cutnum = leastCutNum;
			initCutNum();

			resetCutlen();
			updateInputText();
		}
		private function initView():void
		{
			
			var finalwidth:Number = cutdata.finalWidth;
			var finalheight:Number = cutdata.finalHeight;
			
			var border:Number = cutdata.border;
			
			this.borderimg.visible = border > 0;
				
			
			if(finalwidth > finalheight)
			{
				this.borderimg.width = 400;
				this.borderimg.height = 400*(finalheight+border)/(finalwidth+border);
				
				paintimg.width = 400*finalwidth/(finalwidth + border);
				
				paintimg.height = paintimg.width * finalheight/finalwidth;
			}
			else
			{
				this.borderimg.height = 400;
				this.borderimg.width = 400*(finalwidth+border)/(finalheight+border);
				
				paintimg.height = 400*finalheight/(finalheight + border);;
				paintimg.width = paintimg.height * finalwidth/finalheight;
			}
			
			this.hbox.width = paintimg.width;
			this.vbox.height = paintimg.height;
			
			this.hbox.x = (400 - this.hbox.width)/2;
			this.vbox.y = 65 + (400 - this.vbox.height)/2;

			paintimg.skin =  HttpRequestUtil.biggerPicUrl + cutdata.fid + ".jpg";
			
			if(cuttype == 0)
			{
				for(var i:int=0;i < cutdata.orderitemvo.cutnum;i++)
				{
					if(hinputlist.length > i)
						hinputlist[i].text = cutdata.orderitemvo.eachCutLength[i] + "";
				}
			}
			else
			{
				for(var i:int=0;i < cutdata.orderitemvo.cutnum;i++)
				{
					if(vinputlist.length > i)
						vinputlist[i].text = cutdata.orderitemvo.eachCutLength[i] + "";
				}
			}
			updateInputText();
			
			initCutNum();
			//cuttyperad.selectedIndex
			//if(matvo.preProc_Code == OrderConstant.HORIZANTAL_CUT_COMBINE)
			//	cuttype = 0;
			
		}
		
		private function onHoriInput(index:int):void
		{
			
			if(index == this.cutdata.orderitemvo.cutnum - 1)
			{
				this.hinputlist[index].text = cutdata.orderitemvo.eachCutLength[index] + "";
				return;
			}
			
			if(this.hinputlist[index].text == "")
				return;
			
			//var product:ProductVo = PaintOrderModel.instance.curSelectMat;
			
			var maxwidth:Number = cutdata.maxwidth;//product.max_width - 3;
			
			
			var hascutlen:Number = 0;
			for(var i:int=0;i < index;i++)
			{
				hascutlen += cutdata.orderitemvo.eachCutLength[i];
			}
			
			var curnum:Number = parseFloat(parseFloat(this.hinputlist[index].text).toFixed(2));
			this.hinputlist[index].text = curnum + "";
			var maxlen:Number = Math.min(maxwidth,cutdata.finalWidth + cutdata.border - hascutlen - this.cutdata.orderitemvo.cutnum + index + 1);
			
			var minlen:Number = Math.max(1,cutdata.finalWidth + cutdata.border - hascutlen - maxwidth*(cutdata.orderitemvo.cutnum - index - 1));
			
			if(curnum <= minlen)
				this.hinputlist[index].text = minlen.toFixed(2) + "";
			if(curnum > maxlen )
				this.hinputlist[index].text = maxlen + "";
			
			hascutlen += parseFloat(this.hinputlist[index].text);
			var leftAvg:Number = (cutdata.finalWidth + cutdata.border - hascutlen)/(this.cutdata.orderitemvo.cutnum - index - 1);
			
			for(var i=index+1;i < this.cutdata.orderitemvo.cutnum;i++)
			{
				if(i < this.vinputlist.length)
					this.hinputlist[i].text = leftAvg.toFixed(2);
			}
			
			for(var i:int=0;i < this.cutdata.orderitemvo.cutnum;i++)
			{
				if(i < this.vinputlist.length)
					cutdata.orderitemvo.eachCutLength[i] = parseFloat(this.hinputlist[i].text);
			}
			
			drawLines();
		}
		
		private function onVertInput(index:int):void
		{
			if(index == this.cutdata.orderitemvo.cutnum - 1)
			{
				this.vinputlist[index].text = cutdata.orderitemvo.eachCutLength[index] + "";
				return;
			}
			
			if(this.vinputlist[index].text == "")
				return;
			
			var maxwidth:Number = cutdata.maxwidth;
			
			var hascutlen:Number = 0;
			for(var i:int=0;i < index;i++)
			{
				hascutlen += cutdata.orderitemvo.eachCutLength[i];
			}
			
			var curnum:Number = parseFloat(parseFloat(this.vinputlist[index].text).toFixed(2));
			this.vinputlist[index].text = curnum + "";

			var maxlen:Number = Math.min(maxwidth,cutdata.finalHeight + cutdata.border - hascutlen - this.cutdata.orderitemvo.cutnum + index + 1);

			var minlen:Number = Math.max(1,cutdata.finalHeight + cutdata.border - hascutlen - maxwidth*(cutdata.orderitemvo.cutnum - index - 1));

			
			if(curnum <= minlen)
				this.vinputlist[index].text = minlen + "";
			if(curnum > maxlen)
				this.vinputlist[index].text = maxlen + "";
			
			hascutlen += parseFloat(this.vinputlist[index].text);
			var leftAvg:Number = (cutdata.finalHeight + cutdata.border - hascutlen)/(this.cutdata.orderitemvo.cutnum - index - 1);
			
			for(var i=index+1;i < this.cutdata.orderitemvo.cutnum;i++)
			{
				if(i < this.vinputlist.length)
					this.vinputlist[i].text = leftAvg.toFixed(2);
			}
			
			for(var i:int=0;i < this.cutdata.orderitemvo.cutnum;i++)
			{
				if(i < this.vinputlist.length)
					cutdata.orderitemvo.eachCutLength[i] = parseFloat(this.vinputlist[i].text);
			}
			
			drawLines();
		}
		
		private function resetCutlen():void
		{
			var cutlen:Number = 0;
			if(cuttype == 0)
			 	cutlen = (cutdata.finalWidth + cutdata.border)/cutdata.orderitemvo.cutnum;
			else
				cutlen = (cutdata.finalHeight + cutdata.border)/cutdata.orderitemvo.cutnum;

			cutlen = parseFloat(cutlen.toFixed(2));
			cutdata.orderitemvo.eachCutLength = [];
			for(var j:int=0;j < cutdata.orderitemvo.cutnum;j++)
				cutdata.orderitemvo.eachCutLength.push(cutlen);
			
			if(cuttype == 0)
			{
				for(var i:int=0;i < cutdata.orderitemvo.cutnum;i++)
				{
					if(hinputlist.length > i)
						hinputlist[i].text = cutdata.orderitemvo.eachCutLength[i] + "";
				}
			}
			else
			{
				for(var i:int=0;i < cutdata.orderitemvo.cutnum;i++)
				{
					if(hinputlist.length > i)
						vinputlist[i].text = cutdata.orderitemvo.eachCutLength[i] + "";
				}
			}
			
		}
		private function updateInputText():void
		{
			this.hbox.visible = cuttype == 0;
			this.vbox.visible = cuttype == 1;
			
			for(var i:int=0;i < hinputlist.length;i++)
			{
				hinputlist[i].visible = i < cutdata.orderitemvo.cutnum;
				vinputlist[i].visible = i < cutdata.orderitemvo.cutnum;

			}
			
			this.hbox.space = (this.hbox.width - this.hinput0.width*cutdata.orderitemvo.cutnum)/(cutdata.orderitemvo.cutnum - 1);
			this.vbox.space = (this.vbox.height  - this.vinput0.height*cutdata.orderitemvo.cutnum)/(cutdata.orderitemvo.cutnum - 1);

		}
		
		private function initCutNum():void
		{
			
			var finalwidth:Number = cutdata.finalWidth+ cutdata.border;
			var finalheight:Number = cutdata.finalHeight+ cutdata.border;
			var product:ProductVo = PaintOrderModel.instance.curSelectMat;

			var maxwidth:Number = cutdata.maxwidth;//product.max_width - 3;
			if(cuttype == 1)
			{
				leastCutNum = Math.ceil(finalheight/maxwidth);
			}
			else
			{
				leastCutNum = Math.ceil(finalwidth/maxwidth);
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
			//onCutNumChange();
			drawLines();
		}
		
		private function onCutNumChange():void
		{
			var lineNum:int = cutnumrad.selectedIndex + leastCutNum;
			cutdata.orderitemvo.cutnum = lineNum;
			
			updateInputText();
			resetCutlen();
			
			drawLines();
		}
		private function drawLines():void
		{
			for(var i:int=0;i < linelist.length;i++)
			{
				
				linelist[i].graphics.clear(true);
				linelist[i].removeSelf();				
				linelist.splice(i,1);
				i--;
				
			}
			
			
			//trace("colroinde:" + curColorIndex);
			if(cutdata.orderitemvo == null)
			{
				trace("null");
			}
			
			var lineNum:int = cutnumrad.selectedIndex + leastCutNum;

			var stepdist:Number = 0;
			if(cuttype == 0)
			{
				stepdist = borderimg.width/lineNum;
				
				//this.widthnum.text = (cutdata.finalWidth/lineNum).toFixed(2);
				for(var i:int=0;i < 2;i++)
				{
					var sp:Sprite = new Sprite();
					this.paintimg.addChild(sp);									
					
					sp.x = (this.paintimg.width - this.borderimg.width)/2;
					sp.y = (this.paintimg.height - this.borderimg.height)/2;

					var linelen:Number = this.borderimg.width/linenum;
					for(var j:int=0;j < linenum;j++)
					{
						
						if(j % 2 == 0)
							sp.graphics.drawLine(j  * linelen,i * this.borderimg.height, (j + 1) * linelen,i * this.borderimg.height,curColorIndex == 0? color1:color2, linethick);
						else
							sp.graphics.drawLine(j * linelen,i * this.borderimg.height, (j + 1) * linelen,i * this.borderimg.height,curColorIndex == 1? color1:color2, linethick);
						
					}											
					linelist.push(sp);
				}
			}
			else
			{
				stepdist = borderimg.height/lineNum;
				//this.widthnum.text = (cutdata.finalHeight/lineNum).toFixed(2);

				for(var i:int=0;i < 2;i++)
				{
					var sp:Sprite = new Sprite();
					this.paintimg.addChild(sp);									
					
					sp.x = (this.paintimg.width - this.borderimg.width)/2;
					sp.y = (this.paintimg.height - this.borderimg.height)/2;

					var linelen:Number = this.borderimg.height/linenum;
					for(var j:int=0;j < linenum;j++)
					{
						if(j % 2 == 0)
							sp.graphics.drawLine(i * this.borderimg.width,j * linelen, i * this.borderimg.width,(j +1)* linelen,curColorIndex == 0? color1:color2, linethick);
						else
							sp.graphics.drawLine(i * this.borderimg.width,j * linelen, i * this.borderimg.width,(j +1)* linelen,curColorIndex == 1? color1:color2, linethick);
						
					}											
					linelist.push(sp);

				}
				
			}
			for(var i:int=0;i < lineNum + 1;i++)
			{
				var sp:Sprite = new Sprite();
				this.paintimg.addChild(sp);
				
				sp.x = (this.paintimg.width - this.borderimg.width)/2;
				sp.y = (this.paintimg.height - this.borderimg.height)/2;

				if(cuttype == 0)
				{
					
					//sp.graphics.drawLine((i+1) * stepdist,0, (i+1) * stepdist,this.paintimg.height,"#ff4400", 1);
					
					var linelen:Number = this.borderimg.height/linenum;
					
					var beforewidth:Number = 0;
					for(var k:int=0;k < i;k++)
						beforewidth += cutdata.orderitemvo.eachCutLength[k];
					var startpos:Number = (beforewidth/cutdata.finalWidth)*this.paintimg.width;
					
					for(var j:int=0;j < linenum;j++)
					{
						//if(j == linenum - 1)
						//	sp.graphics.drawLine((i+1) * stepdist,j * 2 * linelen, (i+1) * stepdist,this.paintimg.height,color2, 1);
										
						
						if(j % 2 == 0)
							sp.graphics.drawLine(startpos,j * linelen, startpos,(j +1)* linelen,curColorIndex == 0? color1:color2, linethick);
						else
							sp.graphics.drawLine(startpos,j * linelen, startpos,(j +1)* linelen,curColorIndex == 1? color1:color2, linethick);
						
					}
					
					
				}
				else
				{
					var linelen:Number = this.borderimg.width/linenum;
					
					var beforewidth:Number = 0;
					for(var k:int=0;k < i;k++)
						beforewidth += cutdata.orderitemvo.eachCutLength[k];
					var startpos:Number = (beforewidth/(cutdata.finalHeight+cutdata.border))*this.borderimg.height;
					
					for(var j:int=0;j < linenum;j++)
					{
						//if(j == linenum - 1)
						//	sp.graphics.drawLine(j * 2 * linelen,(i+1) * stepdist, this.paintimg.width,(i+1) * stepdist,color2, 1);
						if(j % 2 == 0)
							sp.graphics.drawLine(j  * linelen,startpos, (j + 1) * linelen,startpos,curColorIndex == 0? color1:color2, linethick);
						else
							sp.graphics.drawLine(j * linelen,startpos, (j + 1) * linelen,startpos,curColorIndex == 1? color1:color2, linethick);
						
					}
				}
				
				
				
				linelist.push(sp);
			}
		}
	}
}