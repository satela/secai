package script.order
{
	import laya.display.Input;
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	
	import ui.order.DakouItemUI;
	
	public class DakouCell extends DakouItemUI
	{
		private var cutdata:Object;
		public function DakouCell()
		{
			super();
			
			this.leftposinput.on(Event.INPUT,this,onLeftPosInput);
			this.rightposinput.on(Event.INPUT,this,onRightInput);
			
			this.leftadd.on(Event.CLICK,this,onAddLeftpos);
			this.leftsub.on(Event.CLICK,this,onSubleftpos);
			
			this.rightadd.on(Event.CLICK,this,onAddrightpos);
			this.rightsub.on(Event.CLICK,this,onSubrightpos);
			
			this.leftposinput.type = Input.TYPE_NUMBER;
			this.rightposinput.type = Input.TYPE_NUMBER;

			//this.horiInput.on(Event.FOCUS,this,onSelectHori);
			//this.vertInput.on(Event.FOCUS,this,onSelectVert);
		}
		
		private function onAddLeftpos():void
		{
			var curnum:int = parseFloat(this.leftposinput.text) + 1;
			
			if(curnum > cutdata.finalWidth)
			{
				this.leftposinput.text = cutdata.finalWidth + "";
				
				curnum = cutdata.finalWidth;
			}
			
			
			this.leftposinput.text = curnum + "";
			
			cutdata.orderitemvo.dkleftpos = curnum;
			
			updateKouPos();
			
		}
		
		private function onSubleftpos():void
		{
			var curnum:int = parseFloat(this.leftposinput.text) - 1;
			
			if(curnum < 1)
				return;
			
			this.leftposinput.text = curnum + "";
			
			cutdata.orderitemvo.dkleftpos = curnum;
			
			updateKouPos();
			
		}
		
		private function onAddrightpos():void
		{
			var curnum:int = parseFloat(this.rightposinput.text) + 1;
			
			if(curnum > cutdata.finalWidth)
			{
				this.rightposinput.text = cutdata.finalWidth + "";
			
				curnum = cutdata.finalWidth;
			}
			
			this.rightposinput.text = curnum + "";
			
			cutdata.orderitemvo.dkrightpos = curnum;
			
			updateKouPos();
			
		}
		
		private function onSubrightpos():void
		{
			var curnum:int = parseFloat(this.rightposinput.text) - 1;
			
			if(curnum < 1)
				return;
			
			
			
			this.rightposinput.text = curnum + "";
			
			cutdata.orderitemvo.dkrightpos = curnum;
			
			updateKouPos();
			
		}
		
		private function onLeftPosInput():void
		{
			if(this.leftposinput.text == "")
				return;
			if(parseFloat(this.leftposinput.text) < 1)
				this.leftposinput.text = "1";
			
			if(parseFloat(this.leftposinput.text) > cutdata.finalWidth)
				this.leftposinput.text = cutdata.finalWidth + "";
			
			cutdata.orderitemvo.dkleftpos = parseFloat(this.leftposinput.text);
			updateKouPos();
			
		}
		private function onRightInput():void
		{
			if(this.rightposinput.text == "")
				return;
			if(parseInt(this.rightposinput.text) < 1)
				this.rightposinput.text = "1";
			
			if(parseFloat(this.rightposinput.text) > cutdata.finalWidth)
				this.rightposinput.text = cutdata.finalWidth + "";
			
			cutdata.orderitemvo.dkrightpos = parseFloat(this.rightposinput.text);
			updateKouPos();
			
		}
		
		
		public function setData(data:*):void
		{
			cutdata = data;
			
			//this.horiInput.text = cutdata.orderitemvo.horiCutNum;
			//this.vertInput.text = cutdata.orderitemvo.verCutNum;
			initView();
			changeDakouNum();
		}
		
		public function changeDakouNum():void
		{
			this.rightkou.visible = cutdata.orderitemvo.dakouNum > 1;
			
			this.rightposbox.visible = cutdata.orderitemvo.dakouNum > 1;
			
		}
		
		private function updateKouPos():void
		{
			var startpos:Number = (400 - fileimg.width)/2;
			
			var leftpos:Number = cutdata.orderitemvo.dkleftpos/cutdata.finalWidth * fileimg.width;
			
			this.leftkou.x = startpos + leftpos;
			
			if(cutdata.orderitemvo.dakouNum > 1)
			{
				var rightpos:Number = cutdata.orderitemvo.dkrightpos/cutdata.finalWidth * fileimg.width;
				
				this.rightkou.x = startpos + rightpos;
			}
		}
		private function initView():void
		{
			
			var finalwidth:Number = cutdata.finalWidth;
			var finalheight:Number = cutdata.finalHeight;
			if(finalwidth > finalheight)
			{
				fileimg.width = 400;
				fileimg.height = 400 * finalheight/finalwidth;
			}
			else
			{
				fileimg.height = 400;
				fileimg.width = 400 * finalwidth/finalheight;
			}
			
			this.leftkou.y = (400 - fileimg.height)/2 + 20;
			this.rightkou.y = (400 - fileimg.height)/2 + 20;
			fileimg.skin =  HttpRequestUtil.biggerPicUrl + cutdata.fid + ".jpg";
			
			this.leftposinput.text = cutdata.orderitemvo.dkleftpos;
			this.rightposinput.text = cutdata.orderitemvo.dkrightpos;
			
			this.picwidth.text = cutdata.finalWidth + "(cm)";

			updateKouPos();			
			
		}
	}
}