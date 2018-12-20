package model.orderModel
{
	import model.picmanagerModel.PicInfoVo;

	public class PicOrderItemVo
	{
		public var indexNum:int;
		public var picinfo:PicInfoVo;
		
		public var materialID:int;//材料id
		
		public var materialName:String;//材料名称
		
		public var editWidth:Number;
		
		public var editHeight:Number;

		public var technolegs:Array;
		
		public var techStr:String = "";
		
		public var vipPrice:Number;
		
		public var price:Number;
		
		public var paitNum:int = 1;//下单数量
		
		public var totalPrice:Number;
		
		public function PicOrderItemVo(picvo:PicInfoVo)
		{
			picinfo = picvo;
			var num:int = Math.random()*8;
			for(var i:int=0;i < 2;i++)
			{
				techStr += "工艺" + i + "\n";
			}
		}
	}
}