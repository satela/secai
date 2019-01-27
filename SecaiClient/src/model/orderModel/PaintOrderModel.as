package model.orderModel
{
	import model.picmanagerModel.PicInfoVo;
	import model.users.AddressVo;
	import model.users.CityAreaVo;
	import model.users.FactoryInfoVo;

	public class PaintOrderModel
	{
		private static var _instance:PaintOrderModel;
		public static function get instance():PaintOrderModel
		{
			if(_instance == null)
				_instance = new PaintOrderModel();
			return _instance;
		}
		
		public var selectAddress:AddressVo;//当前选择的收获地址
		
		public var selectFactoryAddress:FactoryInfoVo;
		
		
		public var curSelectPic:PicInfoVo;
		
		public var curSelectMat:ProductVo;
		
		public var outPutAddr:Array;
		
		public var productList:Array;//产品材料 列表
		
		public var deliveryList:Array;//配送方式列表
		
		public var selectDelivery:DeliveryTypeVo;//选择的配送方式

		public function PaintOrderModel()
		{
		}
		
		public function resetData():void
		{
			selectAddress = null;
			selectFactoryAddress = null;
			curSelectMat = null;
			outPutAddr = null;
			productList = null;
			deliveryList = null;
			selectDelivery = null;			
			
		}
		public function initOutputAddr(addrobj:Array):void
		{
			outPutAddr = [];
			for(var i:int=0;i < addrobj.length;i++)
			{
				var addvo:FactoryInfoVo = new FactoryInfoVo(addrobj[i]);
				outPutAddr.push(addvo);
			}
		}
	}
}