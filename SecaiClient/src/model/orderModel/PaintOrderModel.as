package model.orderModel
{
	import laya.maths.MathUtil;
	
	import model.picmanagerModel.PicInfoVo;
	import model.users.AddressVo;
	import model.users.CityAreaVo;
	import model.users.FactoryInfoVo;
	
	import script.ViewManager;
	import script.order.MaterialItem;
	import script.order.PicOrderItem;
	
	import utils.TimeManager;
	import utils.UtilTool;

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
		
		public var packageList:Vector.<PackageVo>;
		//public var orderPackageData:Object;
		
		public var finalOrderData:Array;//最终下单数据

		public var allManuFacutreMatProcPrice:Object = {};
		
		public var availableDeliveryDates:Object = {};
		
		public var orderType:int;//当前下单类型 
		
		public var curTimePrefer:int = 0;//当前选择的交付策略
		
		public var curCommmonDeliveryType:String = "";//当前选择的普通配送方式
		public var curUrgentDeliveryType:String = "";//当前选择的加急配送方式
		
		public var currentDayStr:String = "";

		public var batchOrders:Object = {};
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
			packageList = new Vector.<PackageVo>();
			finalOrderData = [];
			availableDeliveryDates = {};
			curCommmonDeliveryType = "";
			curUrgentDeliveryType = "";
			batchOrders = {};
			
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
				//var arr:Array = allManuFacutreMatProcPrice[orgcode];
//				for(var i:int=0;i < arr.length;i++)
//				{
//					var matlist:Array = arr[i].mat_list;
//					arr[i].matlist = {};
//					for(var j:int=0;j < matlist.length;j++)
//					{
//						arr[i].matlist[matlist[j].mat_code] = matlist[j];
//					}
//				}
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
						//if(list[i].matlist[matcode] != null)
						//	return [list[i].measure_unit,list[i].matlist[matcode].baseprice,list[i].matlist[matcode].unit_procprice];
						//else
						//	return [list[i].measure_unit,list[i].baseprice,list[i].unit_procprice];
						if(list[i].mat_code == matcode)
							return [list[i].measure_unit,list[i].baseprice,list[i].unit_procprice];
					}
				}
				
				for(var i:int=0;i < list.length;i++)
				{
					if(list[i].proc_code == procCode && list[i].mat_code == "")
					{						
						return [list[i].measure_unit,list[i].baseprice,list[i].unit_procprice];
					}
				}
				
				return [];
			}
		}
		
		
		
		public function getCapacityData(orgcode:String,procCode:String,matcode:String):Array
		{
			if(allManuFacutreMatProcPrice == null || allManuFacutreMatProcPrice[orgcode] == null)
				return [];
			else
			{
				var list:Array = allManuFacutreMatProcPrice[orgcode];
				if(list == null)
					return [0,0,0];
							
				
				for(var i:int=0;i < list.length;i++)
				{
					if(list[i].proc_code == procCode && list[i].mat_code == matcode)
					{
//						if(list[i].matlist[matcode] != null)
//							return [list[i].cap_unit,list[i].matlist[matcode].unit_capacity,list[i].matlist[matcode].unit_urgentcapacity];
//						else
							return [list[i].cap_unit,list[i].unit_capacity,list[i].unit_urgentcapacity];
					}
				}
				for(var i:int=0;i < list.length;i++)
				{
					if(list[i].proc_code == procCode && list[i].mat_code == "")
					{
						//						if(list[i].matlist[matcode] != null)
						//							return [list[i].cap_unit,list[i].matlist[matcode].unit_capacity,list[i].matlist[matcode].unit_urgentcapacity];
						//						else
						return [list[i].cap_unit,list[i].unit_capacity,list[i].unit_urgentcapacity];
					}
				}
				return [0,0,0];
			}
		}
		
		//异形切割的工艺价格寻找加个最高的那个（根据选择的附件材料查找有没有对应的加个，再选择最高的价格)
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
					if(allprice.length == 0)
						allprice = [list[i].measure_unit,list[i].baseprice,list[i].unit_procprice];
					for(var j:int=0;j < hasselectMat.length;j++)
					{
						if(list[i].mat_code == hasselectMat[j]  && list[i].unit_procprice > allprice[2])
							allprice = [list[i].measure_unit,list[i].baseprice,list[i].unit_procprice];
						
					}
					if(list[i].mat_code == "" && list[i].unit_procprice > allprice[2])
					{
						allprice = [list[i].measure_unit,list[i].baseprice,list[i].unit_procprice];
					}
					
				}
			}
			
			return allprice;
			
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
		
		public function checkUnFitFileType(material:ProductVo,showtip:Boolean=true):Boolean
		{
			var picorderitems:Vector.<PicOrderItem> = getCurPicOrderItems();
			
			var limitwidth:Number = 0;
			
			if(material.prod_code == "SPPR60100" || material.prod_code == "SPPR60110")
			{
				if(material.prod_code == "SPPR60100")
					limitwidth = 42.5;
				else
					limitwidth = 52.5;
				
				for(var i:int=0;i < picorderitems.length;i++)
				{
					if(picorderitems[i].ordervo.picinfo.colorspace.toUpperCase() != "GRAY")
					{
						if(showtip)
						{
							ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG_WITH_PICTURE,false,{msg:"图片不符合条幅材料下单要求",picurl:"bigpic/tiaofutp.jpg"});
						}
						return true;
						
					}
					else if(picorderitems[i].ordervo.picinfo.iswhitebg == false)
					{
						if(showtip)
						{
							ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG_WITH_PICTURE,false,{msg:"图片不符合条幅材料下单要求",picurl:"bigpic/tiaofutp.jpg"});
						}
						return true;
					}
					else if(picorderitems[i].ordervo.picinfo.iswhitebg && picorderitems[i].ordervo.picinfo.tiaofuwidth > limitwidth)
					{
						if(showtip)
						{
							ViewManager.instance.openView(ViewManager.VIEW_POPUPDIALOG_WITH_PICTURE,false,{msg:"图片不符合条幅材料下单要求",picurl:"bigpic/tiaofutp.jpg"});
						}
						return true;
					}
				}
			
			}
			return false;
		}
		
		public function getManuFactureIndex(manucode:String):int
		{
			for(var i:int=0;i < outPutAddr.length;i++)
			{
				if(manucode == (outPutAddr[i] as FactoryInfoVo).org_code)
					return i;
			}
			
			return 0;
		}
		
		public function addPackage(packagename:String):void
		{
			if(packageList == null)
				packageList = new Vector.<PackageVo>();
			
			var pack:PackageVo = new PackageVo();
			pack.packageName = packagename;
			packageList.push(pack);
			
			//pack.itemlist = new 
		}
		
		public function setPackageData():void
		{
			if(finalOrderData == null)
				return;
			
			for(var i:int=0;i < finalOrderData.length;i++)
			{
				finalOrderData[i].packageList = [];
				
				for(var j:int=0;j < packageList.length;j++)
				{
					
					var packdata:Object = {};
					packdata.package_name = packageList[j].packageName;
					packdata.consignee = "";
					packdata.tel = "";
					packdata.addr = "";
					
					packdata.itemList = [];
					for(var k:int=0;k < finalOrderData[i].orderItemList.length;k++)
					{
						if(finalOrderData[i].orderItemList[k].numlist[j] > 0)
						{
							var itemdata:Object = {};
							itemdata.orderItem_sn = finalOrderData[i].orderItemList[k].orderItem_sn;
							itemdata.count = finalOrderData[i].orderItemList[k].numlist[j];
							packdata.itemList.push(itemdata);
						}
					}
					
					finalOrderData[i].packageList.push(packdata);
					
				}
				for(var k:int=0;k < finalOrderData[i].orderItemList.length;k++)
				{
					
					delete finalOrderData[i].orderItemList[k].numlist;
				}
				
			}
			
			
		}
		
		public function getOrderCapcaityData(orderdata:Object,deliveryprefer:int):String
		{
			var resultdata:Object = {};
			resultdata.manufacturer_code = orderdata.manufacturer_code;
			resultdata.orderItemList = [];
			resultdata.delivery_prefer = deliveryprefer;
			
			var orderitems:Array = orderdata.orderItemList;
			
			var productProcMap:Object = {};
			for(var i:int=0;i < orderitems.length;i++)
			{
				var itemdata:Object = {};
				itemdata.orderItem_sn = orderitems[i].orderItem_sn;
				
				itemdata.prod_code = orderitems[i].prod_code;
				var tempkey:String = itemdata.prod_code + "-";

				itemdata.processList = [];

				for(var j:int=0;j < orderitems[i].procInfoList.length;j++)
				{
					var procedata:Object = {};
					procedata.proc_code = orderitems[i].procInfoList[j].proc_Code;
					var size:Array = orderitems[i].LWH.split("/");
					
					var picwidth:Number = parseFloat(size[0]);
					var picheight:Number = parseFloat(size[1]);
					tempkey += procedata.proc_code + "-";
					
					procedata.cap_occupy = orderitems[i].item_number * getProcessNeedCapacity(orderdata.manufacturer_code,orderitems[i].material_code,picwidth,picheight,orderitems[i].procInfoList[j].proc_Code);
					
					procedata.proc_seq = j+1;
					
					itemdata.processList.push(procedata);
				}
//				if(productProcMap.hasOwnProperty(tempkey))
//				{
//					var prococcupydata:Array = productProcMap[tempkey].processList;
//					for(var k:int=0;k < prococcupydata.length;k++)
//					{
//						prococcupydata[k].cap_occupy += itemdata.processList[k].cap_occupy;
//					}
//					orderitems[i].batchOrderItem_sn = productProcMap[tempkey].orderItem_sn;
//					
//					batchOrders[productProcMap[tempkey].orderItem_sn]++;
//
//				}
//				else
//				{
					productProcMap[tempkey] = itemdata;
					resultdata.orderItemList.push(itemdata);
					batchOrders[orderitems[i].orderItem_sn] = 1;
					orderitems[i].batchOrderItem_sn = orderitems[i].orderItem_sn;
				//}
				//resultdata.orderItemList.push(itemdata);
				
			}
			
			for(i=0;i < orderitems.length;i++)
			{
				if(batchOrders[orderitems[i].batchOrderItem_sn] == 1)
				{
					orderitems[i].batchOrderItem_sn = "";
				}
				
			}
			return JSON.stringify(resultdata);
			
			
		}
		
		public function getSingleOrderItemCapcaityData(orderItemdata:Object):String
		{
			var resultdata:Object = {};
			resultdata.manufacturer_code = getManufacturerCode(orderItemdata.orderItem_sn);
			resultdata.orderItemList = [];
			
			resultdata.delivery_prefer = 0;
			
			//var orderitems:Array = orderdata.orderItemList;
			
			//for(var i:int=0;i < orderitems.length;i++)
			//{
				var itemdata:Object = {};
				itemdata.orderItem_sn = orderItemdata.orderItem_sn;
				itemdata.prod_code = orderItemdata.prod_code;
				
				itemdata.processList = [];
				
				for(var j:int=0;j < orderItemdata.procInfoList.length;j++)
				{
					var procedata:Object = {};
					procedata.proc_code = orderItemdata.procInfoList[j].proc_Code;
					var size:Array = orderItemdata.LWH.split("/");
					
					var picwidth:Number = parseFloat(size[0]);
					var picheight:Number = parseFloat(size[1]);
					
					procedata.cap_occupy = orderItemdata.item_number * getProcessNeedCapacity(resultdata.manufacturer_code,orderItemdata.material_code,picwidth,picheight,orderItemdata.procInfoList[j].proc_Code);
					
					procedata.proc_seq = j+1;
					
					itemdata.processList.push(procedata);
				}
				resultdata.orderItemList.push(itemdata);
				
		//	}
			
			return JSON.stringify(resultdata);
			
			
		}
		
		//计算工艺占用产能时
		public function getProcessNeedCapacity(manufacturerCode:String,matcode:String,picwidth:Number,picheight:Number,processcode:String):Number
		{
			var capacitydata:Array = getCapacityData(manufacturerCode,processcode,matcode);
			
			if(capacitydata.length < 3)
				return 0;
			
			if(capacitydata[1] == 0 || capacitydata[1] == null)
				return 0;
			
			var amout:Number = UtilTool.getAmoutByUnit(picwidth/100.0,picheight/100.0,capacitydata[0]);
			
			if(capacitydata[1] > 0)
				return parseFloat((amout/capacitydata[1] as Number).toFixed(4));
			else
				return 0;
			
		}
		
		public function getManufacturerCode(orderitemsn:String):String{
			
			var arr:Array = finalOrderData;
			for(var i:int=0;i < arr.length;i++)
			{
				var orderitems:Array = arr[i].orderItemList;
				for(var j:int=0;j < orderitems.length;j++)
				{
					if(orderitems[j].orderItem_sn == orderitemsn)
						return arr[i].manufacturer_code;
				}
			}
			
			return "";
		}
		
		public function getManufacturerNameBySn(orderitemsn:String):String{
			
			var arr:Array = finalOrderData;
			for(var i:int=0;i < arr.length;i++)
			{
				var orderitems:Array = arr[i].orderItemList;
				for(var j:int=0;j < orderitems.length;j++)
				{
					if(orderitems[j].orderItem_sn == orderitemsn)
						return arr[i].manufacturer_name;
				}
			}
			
			return "";
		}
		
		public function getSingleProductOrderData(orderitemsn:String):Object{
			
			var arr:Array = finalOrderData;
			for(var i:int=0;i < arr.length;i++)
			{
				var orderitems:Array = arr[i].orderItemList;
				for(var j:int=0;j < orderitems.length;j++)
				{
					if(orderitems[j].orderItem_sn == orderitemsn)
						return orderitems[j];
				}
			}
			
			return null;
		}	
		
		public function getProductOrderDataList(orderitemsn:String):Array{
			
			var arr:Array = finalOrderData;
			var batchItemDatas:Array = [];
			for(var i:int=0;i < arr.length;i++)
			{
				var orderitems:Array = arr[i].orderItemList;
				for(var j:int=0;j < orderitems.length;j++)
				{
					if(orderitems[j].batchOrderItem_sn == orderitemsn || orderitems[j].orderItem_sn == orderitemsn)
					{
						batchItemDatas.push(orderitems[j]);
					}
				}
			}
			
			return batchItemDatas;
		}	
		
		public function getDeliveryTypeStr(needurgetn:Boolean):String
		{
			if(deliveryList == null || deliveryList.length <= 0)
				return "";
			
			var typestr:String = "";
			var servertime:Date = new Date(TimeManager.instance.serverDate*1000);
			
			for(var i:int=0;i < deliveryList.length;i++)
			{
				var deliveryVO:DeliveryTypeVo = deliveryList[i] as DeliveryTypeVo;
				if(!needurgetn  || deliveryVO.canbeslected(servertime))
				{
					if(i < deliveryList.length - 1)
						typestr += deliveryVO.delivery_name + "(" + deliveryVO.firstweight_price + "元)" + ",";
					else
						typestr += deliveryVO.delivery_name + "(" + deliveryVO.firstweight_price + "元)";

				}
			}
			
			return typestr;
		}
		
		public function isValidDeliveryType(deliveryname:String):Boolean
		{
			if(deliveryname.indexOf(OrderConstant.DELIVERY_TYPE_BY_MANUFACTURER) < 0)
				return true;
			
			var servertime:Date = new Date(TimeManager.instance.serverDate*1000);
			for(var i:int=0;i < deliveryList.length;i++)
			{
				var deliveryVO:DeliveryTypeVo = deliveryList[i] as DeliveryTypeVo;
				if(deliveryVO.delivery_name == deliveryname && deliveryVO.canbeslected(servertime))
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function getDeliveryPrice(deliveryname:String):Number
		{
			
			//var servertime:Date = new Date(TimeManager.instance.serverDate);
			if(deliveryname == "")
				return 0;
			
			for(var i:int=0;i < deliveryList.length;i++)
			{
				var deliveryVO:DeliveryTypeVo = deliveryList[i] as DeliveryTypeVo;
				if(deliveryVO.delivery_name == deliveryname)
				{
					return deliveryVO.firstweight_price;
				}
			}
			
			return 0;
		}
		
		public function getDeliveryOrgCode():String
		{
			if(deliveryList.length > 0)
			{
				return (deliveryList[0] as DeliveryTypeVo).deliverynet_code;
			}
			return "";
		}
	}
}