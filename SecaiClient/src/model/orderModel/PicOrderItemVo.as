package model.orderModel
{
	import model.picmanagerModel.PicInfoVo;

	public class PicOrderItemVo
	{
		public var indexNum:int;
		public var picinfo:PicInfoVo;
		
		public var materialID:int;//材料id
		
		public var materialName:String;//材料名称
		
		public var orderData:Object; //最早下单的数据
		
		public var orderPrice:Number = 0;//该单的单价
		
		public var manufacturer_code:String;//输出中心编码
		public var manufacturer_name:String;//输出中心编码

		
		public var editWidth:Number;
		
		public var editHeight:Number;

		public var technolegs:Array;
		
		public var techStr:String = "";
		
		public var vipPrice:Number;
		
		public var price:Number;
		
		public var paitNum:int = 1;//下单数量
		
		public var totalPrice:Number;
		
		public var comment:String = "";
		
		public var cuttype:int = 0;//裁切类型
		public var cutnum:int = 0;//裁切数
		
		public var eachCutLength:Array;
		
		public var horiCutNum:int = 1;
		public var verCutNum:int = 1;
		
		public var dakouNum:int = 1;
		public var dkleftpos:int = 5;//左边打扣位置
		
		public var dkrightpos:int = 50;//右边打扣位置
		
		public function PicOrderItemVo(picvo:PicInfoVo)
		{
			picinfo = picvo;
			
		}
	}
}