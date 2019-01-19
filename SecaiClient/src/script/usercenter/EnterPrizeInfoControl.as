package script.usercenter
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.List;
	import laya.utils.Handler;
	
	import model.ChinaAreaModel;
	import model.users.CityAreaVo;
	
	import script.login.CityAreaItem;
	
	import ui.usercenter.EnterPrizeInfoPaneUI;
	
	public class EnterPrizeInfoControl extends Script
	{
		private var uiSkin:EnterPrizeInfoPaneUI;
		private var province:CityAreaVo;
		private var cityname:CityAreaVo;
		private var areaname:CityAreaVo;
		
		public function EnterPrizeInfoControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as EnterPrizeInfoPaneUI;
			uiSkin.provList.itemRender = CityAreaItem;
			uiSkin.provList.vScrollBarSkin = "";
			uiSkin.provList.repeatX = 1;
			uiSkin.provList.spaceY = 2;
			
			uiSkin.provList.renderHandler = new Handler(this, updateCityList);
			uiSkin.provList.selectEnable = true;
			uiSkin.provList.selectHandler = new Handler(this, selectProvince);
			uiSkin.provList.array = ChinaAreaModel.instance.getAllProvince();
			selectProvince(0);
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
			uiSkin.on(Event.CLICK,this,hideAddressPanel);

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
			uiSkin.townList.selectedIndex = -1;
			
			
		}
		
		private function selectTown(index:int):void
		{
			if( index == -1 )
				return;
			uiSkin.townbox.visible = false;
			uiSkin.towntxt.text = uiSkin.townList.array[index].areaName;
			
		}
	}
}