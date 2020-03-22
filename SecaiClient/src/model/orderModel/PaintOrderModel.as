package model.orderModel
{
	import laya.maths.MathUtil;
	
	import model.picmanagerModel.PicInfoVo;
	import model.users.AddressVo;
	import model.users.CityAreaVo;
	import model.users.FactoryInfoVo;
	
	import script.ViewManager;
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

		public var allManuFacutreMatProcPrice:Object = {};
		
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
			allManuFacutreMatProcPrice = {};
			
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
		
		public function getContactPhone(manuFactoryCode:String):String
		{
			for(var i:int=0;i < outPutAddr.length;i++)
			{
				if(outPutAddr[i].org_code == manuFactoryCode)
					return outPutAddr[i].contact_phone;
					
			}
			
			return "";
			
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
		
		public function initManuFacuturePrice(orgcode:String,dataStr:*):void
		{
			try
			{
				allManuFacutreMatProcPrice[orgcode] = JSON.parse(dataStr);
				var arr:Array = allManuFacutreMatProcPrice[orgcode];
				for(var i:int=0;i < arr.length;i++)
				{
					var matlist:Array = arr[i].mat_list;
					arr[i].matlist = {};
					for(var j:int=0;j < matlist.length;j++)
					{
						arr[i].matlist[matlist[j].mat_code] = matlist[j];
					}
				}
			}
			catch(err:Error)
			{
				ViewManager.showAlert("获取生产商材料工艺价格失败");
			}
			
		}
		
		public function getProcePriceUnit(orgcode:String,procCode:String,matcode:String):Array
		{
			if(allManuFacutreMatProcPrice == null || allManuFacutreMatProcPrice[orgcode] == null)
				return [];
			else
			{
				var list:Array = allManuFacutreMatProcPrice[orgcode];
				if(list == null)
					return [];
				for(var i:int=0;i < list.length;i++)
				{
					if(list[i].proc_code == procCode)
					{
						if(list[i].matlist[matcode] != null)
							return [list[i].measure_unit,list[i].matlist[matcode].baseprice,list[i].matlist[matcode].unit_procprice];
						else
							return [list[i].measure_unit,list[i].baseprice,list[i].unit_procprice];
					}
				}
				return [];
			}
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