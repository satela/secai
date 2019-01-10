package model.orderModel
{
	import model.picmanagerModel.PicInfoVo;
	import model.users.AddressVo;

	public class PaintOrderModel
	{
		private static var _instance:PaintOrderModel;
		public static function get instance():PaintOrderModel
		{
			if(_instance == null)
				_instance = new PaintOrderModel();
			return _instance;
		}
		
		public var selectAddress:AddressVo;
		
		public var curSelectPic:PicInfoVo;
		
		public var curSelectMat:MaterialItemVo;
		
		public function PaintOrderModel()
		{
		}
	}
}