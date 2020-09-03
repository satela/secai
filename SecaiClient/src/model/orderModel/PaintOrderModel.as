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
		
		public var orderType:int;//当前下单类型 
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
				if(allManuFacutreMatProcPrice[orgcode].code != null)
				{
					ViewManager.showAlert("获取生产商工艺价格出错！");
					ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
					return;
				}
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
		
		public function getProcePriceUnit(orgcode:String,procCode:String,matcode:String,processList:Array):Array
		{
			if(allManuFacutreMatProcPrice == null || allManuFacutreMatProcPrice[orgcode] == null)
				return [];
			else
			{
				var list:Array = allManuFacutreMatProcPrice[orgcode];
				if(list == null)
					return [];
				
				if(procCode == OrderConstant.UNNORMAL_CUT_TECHNO)
					return getYixingProcPrice(orgcode,procCode,matcode,processList);
				
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
		
		public function getYixingProcPrice(orgcode:String,procCode:String,matcode:String,processList:Array):Array
		{
			var allprice:Array = [];
			var hasselectMat:Array = [];
			hasselectMat.push(matcode);
			for(var i:int=0;i < processList.length;i++)
			{
				var attchvo:Vector.<AttchCatVo> = processList[i].selectAttachVoList;
				if(attchvo != null && attchvo.length > 0)
				{
					hasselectMat.push(attchvo[0].accessory_code);
				}
			}
			
			var list:Array = allManuFacutreMatProcPrice[orgcode];
			if(list == null)
				return [];
			for(var i:int=0;i < list.length;i++)
			{
				if(list[i].proc_code == procCode)
				{
					allprice = [list[i].measure_unit,list[i].baseprice,list[i].unit_procprice];
					for(var j:int=0;j < hasselectMat.length;j++)
					{
						if(list[i].matlist[hasselectMat[j]] != null && list[i].matlist[hasselectMat[j]].unit_procprice > allprice[2])
							allprice = [list[i].measure_unit,list[i].matlist[hasselectMat[j]].baseprice,list[i].matlist[hasselectMat[j]].unit_procprice];
						
					}
					
					return allprice;
				}
			}
			return [];
			
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
		
		public function getManuFacturePriority(manufacCode:String):int
		{
			var manuFacList:Array = outPutAddr;
			if(manuFacList != null)
			{
				for(var i:int=0;i < manuFacList.length;i++)
				{
					if(manuFacList[i].org_code == manufacCode)
						return manuFacList[i].manu_priority;
				}
			}
			
			return 0;
		}
		
		public function checkCanSelYixing():Boolean
		{
			var picitems:Vector.<PicOrderItem> = this.batchChangeMatItems;
			if(picitems != null && picitems.length > 0)
			{
				for(var i:int=0;i < picitems.length;i++)
				{
					var picinfo:PicInfoVo = picitems[i].ordervo.picinfo;
					if(picinfo.relatedRoadNum <= 0 || picinfo.yixingFid == "0")
						return false;
				}
				return true;
			}
			else if(curSelectOrderItem != null && curSelectOrderItem.ordervo.picinfo.relatedRoadNum > 0 && curSelectOrderItem.ordervo.picinfo.yixingFid != "0")
				return true;
			
			return false;
		}
		
		public function checkCanDoubleSide():Boolean
		{
			var picitems:Vector.<PicOrderItem> = this.batchChangeMatItems;
			if(picitems != null && picitems.length > 0)
			{
				for(var i:int=0;i < picitems.length;i++)
				{
					var picinfo:PicInfoVo = picitems[i].ordervo.picinfo;
					if(picinfo.backFid == "0")
						return false;
				}
				return true;
			}
			else if(curSelectOrderItem != null && curSelectOrderItem.ordervo.picinfo.backFid != "0")
				return true;
			
			return false;
		}
		
		//判断图片是否不符合等份裁切的尺寸要求
		public function checkIslongerForDfcq():Boolean
		{
			var vect:Vector.<PicOrderItem> = new Vector.<PicOrderItem>();
			if(this.curSelectOrderItem != null)
				vect.push(this.curSelectOrderItem);
			else
				vect = this.batchChangeMatItems;
			
			for(var i:int=0;i < vect.length;i++)
			{
				var minside:Number = Math.min(vect[i].finalWidth,vect[i].finalHeight);
				var longside:Number = Math.max(vect[i].finalWidth,vect[i].finalHeight);
				if(minside > OrderConstant.DFCQ_MAX_HEIGHT || longside > OrderConstant.DFCQ_MAX_WIDTH)
					return true;

			}
			
			return false;
		}
		
		//判断是否需要重新选择超幅拼接参数
		public function checkNeedReChooseCfpj():Boolean
		{
			var curprocesslst:Vector.<MaterialItemVo> = PaintOrderModel.instance.curSelectMat.getAllSelectedTech() as Vector.<MaterialItemVo>;
			var picorderitems:Vector.<PicOrderItem> = new Vector.<PicOrderItem>();
			if(PaintOrderModel._instance.curSelectOrderItem != null)
				picorderitems.push(PaintOrderModel._instance.curSelectOrderItem);
			else
				picorderitems = PaintOrderModel._instance.batchChangeMatItems;
			
			var hascfpj:Boolean = false;
			for(var i:int=0;i < curprocesslst.length;i++)
			{
				if(curprocesslst[i].preProc_attachmentTypeList.toUpperCase() == OrderConstant.CUTOFF_H_V)
				{
					hascfpj = true;
					break;
				}
			}
			
			if(hascfpj)
			{
				for(var i:int=0;i < picorderitems.length;i++)
				{
					var cutlengths:Array = picorderitems[i].ordervo.eachCutLength;
					if(cutlengths != null)
					{
						for(var j:int=0;j < cutlengths.length;j++)
						{
							if(cutlengths[j] > OrderConstant.FUBAI_WOOD_MAX_WIDTH)
							{
								return true;
							}
						}
					}
				}
			}
			
			return false;

		}
		
		public function getCurPicOrderItems():Vector.<PicOrderItem>
		{
			var picorderitems:Vector.<PicOrderItem> = new Vector.<PicOrderItem>();
			if(PaintOrderModel._instance.curSelectOrderItem != null)
				picorderitems.push(PaintOrderModel._instance.curSelectOrderItem);
			else
				picorderitems = PaintOrderModel._instance.batchChangeMatItems;
			
			return picorderitems;
			
		}
		
		public function checkExceedMaterialSize(material:ProductVo):Boolean
		{
			var picorderitems:Vector.<PicOrderItem> = getCurPicOrderItems();
			
			for(var i:int=0;i < picorderitems.length;i++)
			{
				var minside:Number = Math.min(picorderitems[i].finalWidth,picorderitems[i].finalHeight);
				var longside:Number = Math.max(picorderitems[i].finalWidth,picorderitems[i].finalHeight);
				
				if(minside > material.max_width || longside > material.max_length)
					return true;
				
				if(minside < material.min_width || longside < material.min_length)
					return true;
			}
			
			return false;
		}
	}
}