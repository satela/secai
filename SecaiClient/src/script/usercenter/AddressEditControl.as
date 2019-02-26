package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.List;
	import laya.utils.Handler;
	
	import model.ChinaAreaModel;
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.users.AddressVo;
	import model.users.CityAreaVo;
	
	import script.ViewManager;
	import script.login.CityAreaItem;
	
	import ui.order.AddCommentPanelUI;
	import ui.usercenter.NewAddressPanelUI;
	
	public class AddressEditControl extends Script
	{
		private var uiSkin:NewAddressPanelUI;
		
		private var province:CityAreaVo;
		
		private var zoneid:String;
		
		private var param:Object;
		private var isAddOrEdit:Boolean = true;//true add false edit
		public function AddressEditControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as NewAddressPanelUI;
			
			if(param != null && param is AddressVo)
				isAddOrEdit = false;
			
			uiSkin.input_username.maxChars = 10;
			uiSkin.input_phone.maxChars = 11;
			uiSkin.input_phone.restrict = "0-9";
			uiSkin.input_address.maxChars = 50;
			
			uiSkin.provList.itemRender = CityAreaItem;
			uiSkin.provList.vScrollBarSkin = "";
			uiSkin.provList.repeatX = 1;
			uiSkin.provList.spaceY = 2;
			
			uiSkin.provList.renderHandler = new Handler(this, updateCityList);
			uiSkin.provList.selectEnable = true;
			uiSkin.provList.selectHandler = new Handler(this, selectProvince);
			uiSkin.provList.array = ChinaAreaModel.instance.getAllProvince();
			uiSkin.provList.refresh();
			uiSkin.cityList.itemRender = CityAreaItem;
			uiSkin.cityList.vScrollBarSkin = "";
			uiSkin.cityList.repeatX = 1;
			uiSkin.cityList.spaceY = 2;
			
			uiSkin.cityList.selectEnable = true;
			
			uiSkin.cityList.renderHandler = new Handler(this, updateCityList);
			uiSkin.cityList.selectHandler = new Handler(this, selectCity);
			
			
			uiSkin.areaList.itemRender = CityAreaItem;
			uiSkin.areaList.vScrollBarSkin = "";
			uiSkin.areaList.selectEnable = true;
			uiSkin.areaList.repeatX = 1;
			uiSkin.areaList.spaceY = 2;
			
			uiSkin.areaList.renderHandler = new Handler(this, updateCityList);
			uiSkin.areaList.selectHandler = new Handler(this, selectArea);
			
			uiSkin.townList.itemRender = CityAreaItem;
			uiSkin.townList.vScrollBarSkin = "";
			uiSkin.townList.selectEnable = true;
			uiSkin.townList.repeatX = 1;
			uiSkin.townList.spaceY = 2;
			
			uiSkin.townList.renderHandler = new Handler(this, updateCityList);
			uiSkin.townList.selectHandler = new Handler(this, selectTown);
			
			uiSkin.btnSelProv.on(Event.CLICK,this,onShowProvince);
			uiSkin.btnSelCity.on(Event.CLICK,this,onShowCity);
			uiSkin.btnSelArea.on(Event.CLICK,this,onShowArea);
			uiSkin.btnSelTown.on(Event.CLICK,this,onShowTown);

			//uiSkin.bgimg.alpha = 0.9;
			uiSkin.areabox.visible = false;
			uiSkin.provbox.visible = false;
			uiSkin.citybox.visible = false;
			uiSkin.townbox.visible = false;

			if(isAddOrEdit == false)
			{
				initAddr();
			}
			else
				selectProvince(0);

			uiSkin.on(Event.CLICK,this,hideAddressPanel);

			this.uiSkin.btnok.on(Event.CLICK,this,onSubmitAdd);
			this.uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
		}
		
		private function hideAddressPanel(e:Event):void
		{
			if(e.target is List)
				return;
			uiSkin.provbox.visible = false;
			uiSkin.citybox.visible = false;
			uiSkin.areabox.visible = false;
			uiSkin.townbox.visible = false;
			
		}
		private function onShowProvince(e:Event):void
		{
			uiSkin.provbox.visible = true;
			uiSkin.citybox.visible = false;
			uiSkin.areabox.visible = false;
			uiSkin.townbox.visible = false;
			
			e.stopPropagation();
		}
		private function onShowCity(e:Event):void
		{
			uiSkin.provbox.visible = false;
			uiSkin.citybox.visible = true;
			uiSkin.areabox.visible = false;
			uiSkin.townbox.visible = false;
			
			e.stopPropagation();
		}
		private function onShowArea(e:Event):void
		{
			uiSkin.provbox.visible = false;
			uiSkin.citybox.visible = false;
			uiSkin.areabox.visible = true;
			uiSkin.townbox.visible = false;
			e.stopPropagation();
		}
		
		private function onShowTown(e:Event):void
		{
			uiSkin.provbox.visible = false;
			uiSkin.citybox.visible = false;
			uiSkin.areabox.visible = false;
			uiSkin.townbox.visible = true;
			e.stopPropagation();
		}
		
		private function updateCityList(cell:CityAreaItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		private function initAddr():void
		{
			var addvo:AddressVo = param as AddressVo;
			
			uiSkin.townList.array = ChinaAreaModel.instance.getAllArea(addvo.searchZoneid);
			
			uiSkin.towntxt.text =  ChinaAreaModel.instance.getAreaName(addvo.zoneid);
			
			var cityid:String = ChinaAreaModel.instance.getParentId(addvo.searchZoneid);
			uiSkin.areaList.array = ChinaAreaModel.instance.getAllArea(cityid);
			
			uiSkin.areatxt.text =  ChinaAreaModel.instance.getAreaName(addvo.searchZoneid);
			
			uiSkin.citytxt.text =  ChinaAreaModel.instance.getAreaName(cityid);

			 cityid = ChinaAreaModel.instance.getParentId(cityid);
			uiSkin.cityList.array = ChinaAreaModel.instance.getAllArea(cityid);			
			
			uiSkin.province.text = ChinaAreaModel.instance.getAreaName(cityid);
			uiSkin.input_username.text = addvo.receiverName;
			uiSkin.input_phone.text = addvo.phone;
			uiSkin.input_address.text = addvo.address;
			zoneid = addvo.zoneid;
			
		}
		private function selectProvince(index:int):void
		{
			province = uiSkin.provList.array[index];
			trace(province);
			uiSkin.provbox.visible = false;
			//province = uiSkin.provList.cells[index].cityname;
			uiSkin.cityList.array = ChinaAreaModel.instance.getAllCity(province.id);
			uiSkin.cityList.refresh();
			uiSkin.province.text = province.areaName;
			
			uiSkin.citytxt.text = uiSkin.cityList.array[0].areaName;
			uiSkin.cityList.selectedIndex = 0;
			
			uiSkin.areaList.array = ChinaAreaModel.instance.getAllArea(uiSkin.cityList.array[0].id);
			uiSkin.areaList.refresh();
			
			uiSkin.areatxt.text = uiSkin.areaList.array[0].areaName;
			uiSkin.areaList.selectedIndex = -1;
			
			uiSkin.townList.array = ChinaAreaModel.instance.getAllArea(uiSkin.areaList.array[0].id);
			
			uiSkin.towntxt.text = uiSkin.townList.array[0].areaName;
			zoneid =  uiSkin.townList.array[0].id;
			uiSkin.townList.selectedIndex = -1;
			
		}
		
		private function selectCity(index:int):void
		{
			uiSkin.citybox.visible = false;
			uiSkin.areaList.array = ChinaAreaModel.instance.getAllArea(uiSkin.cityList.array[index].id);
			uiSkin.areaList.refresh();
			uiSkin.citytxt.text = uiSkin.cityList.array[index].areaName;
			uiSkin.areatxt.text = "";
			uiSkin.areatxt.text = uiSkin.areaList.array[0].areaName;
			uiSkin.areaList.selectedIndex = -1;
			
			uiSkin.townList.array = ChinaAreaModel.instance.getAllArea(uiSkin.areaList.array[0].id);
			
			uiSkin.towntxt.text = uiSkin.townList.array[0].areaName;
			zoneid =  uiSkin.townList.array[0].id;

			uiSkin.townList.selectedIndex = -1;
			
		}
		
		private function selectArea(index:int):void
		{
			if( index == -1 )
				return;
			uiSkin.areabox.visible = false;
			uiSkin.areatxt.text = uiSkin.areaList.array[index].areaName;
			
			uiSkin.townList.array = ChinaAreaModel.instance.getAllArea(uiSkin.areaList.array[index].id);
			uiSkin.townList.refresh();
			uiSkin.towntxt.text = uiSkin.townList.array[0].areaName;
			zoneid =  uiSkin.townList.array[0].id;

			uiSkin.townList.selectedIndex = -1;
			
			
		}
		
		private function selectTown(index:int):void
		{
			if( index == -1 )
				return;
			uiSkin.townbox.visible = false;
			uiSkin.towntxt.text = uiSkin.townList.array[index].areaName;
			zoneid =  uiSkin.townList.array[index].id;

		}
		
		private function onSubmitAdd():void
		{
			// TODO Auto Generated method stub
			if(uiSkin.input_username.text == "")
			{
				ViewManager.showAlert("请填写收货人姓名");
				return;
			}
			if(uiSkin.input_phone.text == "" || uiSkin.input_phone.text.length < 11)
			{
				ViewManager.showAlert("请填写正确的收货人电话");
				return;
			}
			if(uiSkin.input_address.text == "")
			{
				ViewManager.showAlert("请填写具体的地址");
				return;
			}
			var requestStr:String = "opt=" + (isAddOrEdit?AddressVo.ADDRESS_INSERT:AddressVo.ADDRESS_UPDATE) + "&cnee=" + uiSkin.input_username.text + "&pn=" + uiSkin.input_phone.text + "&zone=" + zoneid +
				"&addr=" + uiSkin.input_address.text;
			if(isAddOrEdit == false)
				requestStr += "&id=" + param.id;
			
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.addressManageUrl,this,addAddressback,requestStr,"post");
		

			//ViewManager.instance.closeView(ViewManager.VIEW_ADD_NEW_ADDRESS);
		}
		private function addAddressback(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				if(isAddOrEdit)
					Userdata.instance.addNewAddress(result);
				else
					Userdata.instance.updateAddress(result);
				EventCenter.instance.event(EventCenter.UPDATE_MYADDRESS_LIST);
				ViewManager.showAlert("添加地址成功");
			}
		}
		
		private function onCloseView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_ADD_NEW_ADDRESS);
		}
		
	}
}