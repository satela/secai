package model.orderModel
{
	import laya.maths.MathUtil;
	
	import model.picmanagerModel.PicInfoVo;
	import model.users.AddressVo;
	import model.users.CityAreaVo;
	import model.users.FactoryInfoVo;
	
	import script.order.PicOrderItem;

	public class PaintOrderModel
	{
		private static var _instance:PaintOrderModel;
		public static function get instance():PaintOrderModel
		{
			if(_instance == null)
				_instance = new PaintOrderModel();
			return _instance;
		}
		
		public var curSelectOrderItem:PicOrderItem;

		public var selectAddress:AddressVo;//当前选择的收获地址
		
		public var selectFactoryAddress:Array; //当前选中的输出中心 可 多个
		
		public var selectFactoryInMat:FactoryInfoVo; //选中工艺的时候 当前选中的输出中心 

		public var curSelectPic:PicInfoVo;
		
		public var curSelectMat:ProductVo;
		
		public var outPutAddr:Array;
		
		public var productList:Array;//产品材料 列表
		
		public var deliveryList:Array;//配送方式列表
		
		public var selectDelivery:DeliveryTypeVo;//选择的配送方式

		public var curSelectProcList:Array;
		
		public var batchChangeMatItems:Vector.<PicOrderItem>;

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
		
		public function getProcDataByProcName(procName:String):Object
		{
			if(curSelectProcList == null)
				return null;
			for(var i:int=0;i < curSelectProcList.length;i++)
			{
				if(curSelectProcList[i].preProc_Name == procName)
					return curSelectProcList[i];
			}
			
			return null;
		}
		
		public static var VOCABURARY:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		public static function getOrderSn():String
		{
			var sn:String = "";
			
			for(var i:int=0;i<20;i++)
			{
				var rnd:int = Math.round(Math.random() * VOCABURARY.length);
				sn += VOCABURARY.charAt(rnd);
			}
			return sn;
		}
	}
}