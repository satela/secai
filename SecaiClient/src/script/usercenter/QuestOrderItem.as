package script.usercenter
{
	import laya.events.Event;
	
	import script.ViewManager;
	
	import ui.usercenter.OrderQuestItemUI;
	
	public class QuestOrderItem extends OrderQuestItemUI
	{
		public var adjustHeight:Function;
		public var caller:Object;

		public var ordata:Object;
		public function QuestOrderItem()
		{
			super();
		}
		
		public function setData(orderdata:Object):void
		{
			this.itemseq.text = orderdata.item_seq;
			this.picimg.skin = orderdata.thumbnails_path;
			
			ordata = orderdata;
			//this.fileimg.skin = 
			//this.txtMaterial.text = ;
			this.matname.text = orderdata.prod_name;
			var sizearr:Array = (orderdata.LWH as String).split("/");
			
			this.widthtxt.text = sizearr[0];
			this.heighttxt.text = sizearr[1];
			
			this.pronum.text = orderdata.item_number + "";
			var techstr:String =  "";
			for(var i:int=0;i < orderdata.procInfoList.length;i++)
				techstr += orderdata.procInfoList[i].proc_description + "-";
			
			this.tech.text = techstr.substr(0,techstr.length - 1);
			
			this.money.text = (Number(orderdata.item_priceStr) * Number(orderdata.item_number)).toFixed(2);
			
			if(orderdata.filename != null)
				this.filename.text = orderdata.filename;
			else
				this.filename.text = "";
			//this.txtDetailInfo.text = "收货地址：" + orderdata.address;
			
			this.commentmark.visible = orderdata.comments != "";
			this.comment.on(Event.CLICK,this,onShowComment);
			
			this.detailbox.visible = false;
			this.bgimg.height = 90;
			this.detailbtn.on(Event.CLICK,this,onClickShowDetail);
		}
		
		private function onShowComment():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_ADD_MESSAGE,false,{msg:ordata.comments});

		}
		private function onClickShowDetail():void
		{
			this.detailbox.visible = !this.detailbox.visible;
			if(this.detailbox.visible)
				this.bgimg.height = 165;
			else
				this.bgimg.height = 90;
			adjustHeight.call(caller);
		}
		
		private function hideDetail():void
		{
			this.detailbox.visible = false;
			this.bgimg.height = 90;
		}
	}
}