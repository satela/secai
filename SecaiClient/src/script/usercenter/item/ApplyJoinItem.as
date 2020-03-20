package script.usercenter.item
{
	import ui.usercenter.ApplyJoinItemUI;
	
	public class ApplyJoinItem extends ApplyJoinItemUI
	{
		public function ApplyJoinItem()
		{
			super();
		}
		
		public function setData(data:*):void
		{
			this.nickname.text = data.account;
		}
	}
}