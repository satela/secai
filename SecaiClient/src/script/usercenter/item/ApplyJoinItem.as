package script.usercenter.item
{
	import eventUtil.EventCenter;
	
	import laya.events.Event;
	
	import model.HttpRequestUtil;
	
	import ui.usercenter.ApplyJoinItemUI;
	
	public class ApplyJoinItem extends ApplyJoinItemUI
	{
		private var joindata:Object;
		public function ApplyJoinItem()
		{
			super();
		}
		
		public function setData(data:*):void
		{
			joindata = data;
			this.account.text = data.ur_phonenumber;
			
			this.msg.text = data.jp_msg;
			this.reqdate.text = data.jp_date;
			
			this.agreebtn.on(Event.CLICK,this,onAgreeJoin);
			this.refusebtn.on(Event.CLICK,this,onRefuseJoin);

		}
		
		private function onAgreeJoin():void
		{
			EventCenter.instance.event(EventCenter.AGREE_JOIN_REQUEST,joindata);
		}
		
		private function onRefuseJoin():void
		{
			var param:String = "id=" + joindata.jp_id + "&opt=0";
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getMyOrganize,this,onhandleBack,param,"post");
		}
		
		private function onhandleBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				EventCenter.instance.event(EventCenter.REFRESH_JOIN_REQUEST);
			}
		}
	}
}