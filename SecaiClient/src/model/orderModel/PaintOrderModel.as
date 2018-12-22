package model.orderModel
{
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
		
		public function PaintOrderModel()
		{
		}
	}
}