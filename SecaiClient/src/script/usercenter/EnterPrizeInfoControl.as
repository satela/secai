package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.ui.List;
	import laya.ui.Panel;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.ChinaAreaModel;
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.users.CityAreaVo;
	
	import script.ViewManager;
	import script.login.CityAreaItem;
	
	import ui.usercenter.EnterPrizeInfoPaneUI;
	
	import utils.WaitingRespond;
	
	public class EnterPrizeInfoControl extends Script
	{
		private var uiSkin:EnterPrizeInfoPaneUI;
		private var province:Object;
		//private var cityname:CityAreaVo;
		//private var areaname:CityAreaVo;
		
		private var file:Object; 
		
		private var companyareaId:String;

		private var curYyzzFile:Object;
		public function EnterPrizeInfoControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as EnterPrizeInfoPaneUI;
			uiSkin.provList.itemRender = CityAreaItem;
			//uiSkin.provList.vScrollBarSkin = "";
			uiSkin.provList.repeatX = 1;
			uiSkin.provList.spaceY = 2;
			
			uiSkin.provList.renderHandler = new Handler(this, updateCityList);
			uiSkin.provList.selectEnable = true;
			uiSkin.provList.selectHandler = new Handler(this, selectProvince);
			uiSkin.provList.refresh();
			uiSkin.cityList.itemRender = CityAreaItem;
			//uiSkin.cityList.vScrollBarSkin = "";
			uiSkin.cityList.repeatX = 1;
			uiSkin.cityList.spaceY = 2;
			
			uiSkin.cityList.selectEnable = true;
			
			uiSkin.cityList.renderHandler = new Handler(this, updateCityList);
			uiSkin.cityList.selectHandler = new Handler(this, selectCity);
			
			
			uiSkin.areaList.itemRender = CityAreaItem;
			//uiSkin.areaList.vScrollBarSkin = "";
			uiSkin.areaList.selectEnable = true;
			uiSkin.areaList.repeatX = 1;
			uiSkin.areaList.spaceY = 2;
			
			uiSkin.areaList.renderHandler = new Handler(this, updateCityList);
			uiSkin.areaList.selectHandler = new Handler(this, selectArea);
			
			uiSkin.townList.itemRender = CityAreaItem;
			//uiSkin.townList.vScrollBarSkin = "";
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
			uiSkin.btnsave.on(Event.CLICK,this,onSaveCompanyInfo);
			
			uiSkin.txt_license.text = "";
			
			uiSkin.btn_uplicense.on(Event.CLICK,this,onUploadlicense);
			Browser.window.uploadApp = this;
			initFileOpen();
			
			
//			if(!ChinaAreaModel.hasInit)
//			{
//				WaitingRespond.instance.showWaitingView(500000);
//				Laya.loader.load([{url:"res/xml/addr.xml",type:Loader.XML}], Handler.create(this, initView), null, Loader.ATLAS);
//			}
//			else
//				initView();
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAddressFromServer ,this,initView,"parentid=0","post");

			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo ,this,getCompanyInfo,null,"post");


		}
		
		private function getCompanyInfo(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				if(result[0] != null)
				{
					if(parseInt(result[0].result) == 1)
					{
						uiSkin.btnsave.disabled = true;
						uiSkin.btnsave.label = "已审核";
					}
					else if(parseInt(result[0].result) == 0)
					{
						uiSkin.btnsave.disabled = true;
						uiSkin.btnsave.label = "审核中";
					}
					else
					{
						uiSkin.btnsave.disabled = false;
						uiSkin.btnsave.label = "审核失败,请重新提交";
					}
					if(result[0].info != null && result[0].info != "")
					{
						var cominfo:Object = JSON.parse(result[0].info);
						uiSkin.input_companyname.text = cominfo.gp_name;
						uiSkin.detail_addr.text = cominfo.gp_addr;
						uiSkin.reditcode.text = cominfo.gp_orgcode;
						uiSkin.txt_license.text = cominfo.gp_license;
					}
				}
				trace(result);
			}
		}
		private function initView(data:Object):void
		{
			//WaitingRespond.instance.hideWaitingView();
			var result:Object = JSON.parse(data as String);
			
			uiSkin.provList.array = result.status as Array;//ChinaAreaModel.instance.getAllProvince();
			selectProvince(0);
		}
		
		private function initFileOpen():void
		{
			file = Browser.document.createElement("input");
			
			file.style="filter:alpha(opacity=0);opacity:0;width: 100;height:34px;left:1080px;top:-210";		
			
			file.accept = ".jpg,.jpeg,.png,.tif";
			file.type ="file";
			file.style.position ="absolute";
			file.style.zIndex = 999;
			Browser.document.body.appendChild(file);//添加到舞台
			file.onchange = function(e):void
			{
				
				
				curYyzzFile = file.files[0];
				if(curYyzzFile != null)
					uiSkin.txt_license.text = curYyzzFile.name;
				
			};
		
		}
		
		public override function onDestroy():void
		{
			Browser.document.body.removeChild(file);//添加到舞台

		}
		private function onUploadlicense():void
		{
			file.click();
			file.value ;
		}
		private function onSaveCompanyInfo():void
		{
			// TODO Auto Generated method stub
			if(curYyzzFile == null)
			{
				ViewManager.showAlert("请选择营业执照");
				return;
			}
			if(uiSkin.reditcode.text == "")
			{
				ViewManager.showAlert("请填写统一社会征信代码");
				return;
			}
			Browser.window.createGroup({urlpath:HttpRequestUtil.httpUrl + HttpRequestUtil.createGroup, cname:uiSkin.input_companyname.text,cshortname:"色彩飞扬",czoneid:companyareaId,caddr:uiSkin.detail_addr.text,reditcode:uiSkin.reditcode.text,file:curYyzzFile});

			//HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.addCompanyInfo,this,onSaveCompnayBack,"name=" + uiSkin.input_companyname.text + "&addr=" + Userdata.instance.defaultAddrid,"post");
		}
		
		private function onSaveCompnayBack(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				ViewManager.showAlert("提交成功，请等待审核");
				uiSkin.btnsave.disabled = true;
				uiSkin.btnsave.label = "审核中";
			}
			else
			{
				ViewManager.showAlert("保存失败");

			}
		}
		private function hideAddressPanel(e:Event):void
		{
			if(e.target is List)
				return;
			uiSkin.provbox.visible = false;
			uiSkin.citybox.visible = false;
			uiSkin.areabox.visible = false;
			uiSkin.townbox.visible = false;
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);

		}
		private function onShowProvince(e:Event):void
		{
			uiSkin.provbox.visible = true;
			uiSkin.citybox.visible = false;
			uiSkin.areabox.visible = false;
			uiSkin.townbox.visible = false;
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,false);
			e.stopPropagation();
		}
		private function onShowCity(e:Event):void
		{
			uiSkin.provbox.visible = false;
			uiSkin.citybox.visible = true;
			uiSkin.areabox.visible = false;
			uiSkin.townbox.visible = false;
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,false);

			e.stopPropagation();
		}
		private function onShowArea(e:Event):void
		{
			uiSkin.provbox.visible = false;
			uiSkin.citybox.visible = false;
			uiSkin.areabox.visible = true;
			uiSkin.townbox.visible = false;
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,false);

			e.stopPropagation();
		}
		
		private function onShowTown(e:Event):void
		{
			uiSkin.provbox.visible = false;
			uiSkin.citybox.visible = false;
			uiSkin.areabox.visible = false;
			uiSkin.townbox.visible = true;
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,false);

			e.stopPropagation();
		}
		
		private function updateCityList(cell:CityAreaItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		private function selectProvince(index:int):void
		{
			if(uiSkin.provList.array[index] == null)
				return;
			province = uiSkin.provList.array[index];
			uiSkin.provbox.visible = false;
			uiSkin.province.text = province.areaname;

			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAddressFromServer ,this,function(data:String)
			{
				var result:Object = JSON.parse(data as String);
				
				uiSkin.cityList.array = result.status as Array;//ChinaAreaModel.instance.getAllCity(province.id);
				uiSkin.cityList.refresh();
				
				uiSkin.citytxt.text = uiSkin.cityList.array[0].areaname;
				uiSkin.cityList.selectedIndex = 0;
				selectCity(0);
				
			},"parentid=" + province.id,"post");
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);

			//trace(province);
			//province = uiSkin.provList.cells[index].cityname;
			
			
//			uiSkin.areaList.array = ChinaAreaModel.instance.getAllArea(uiSkin.cityList.array[0].id);
//			uiSkin.areaList.refresh();
//			
//			uiSkin.areatxt.text = uiSkin.areaList.array[0].areaName;
//			uiSkin.areaList.selectedIndex = -1;
//			
//			uiSkin.townList.array = ChinaAreaModel.instance.getAllArea(uiSkin.areaList.array[0].id);
//			
//			
//			uiSkin.towntxt.text = uiSkin.townList.array[0].areaName;
//			uiSkin.townList.selectedIndex = -1;
//			companyareaId = uiSkin.townList.array[0].id;

		}
		
		private function selectCity(index:int):void
		{
			uiSkin.citybox.visible = false;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAddressFromServer ,this,function(data:String)
			{
				var result:Object = JSON.parse(data as String);
				
				uiSkin.areaList.array = result.status as Array;//ChinaAreaModel.instance.getAllCity(province.id);
				uiSkin.areaList.refresh();
				
				uiSkin.areatxt.text = uiSkin.areaList.array[0].areaname;
				uiSkin.areaList.selectedIndex = 0;
				selectArea(0);

				
			},"parentid=" + uiSkin.cityList.array[index].id,"post");
			uiSkin.citytxt.text = uiSkin.cityList.array[index].areaname;
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);

//			uiSkin.areaList.array = ChinaAreaModel.instance.getAllArea(uiSkin.cityList.array[index].id);
//			uiSkin.areaList.refresh();
//			uiSkin.citytxt.text = uiSkin.cityList.array[index].areaName;
//			uiSkin.areatxt.text = "";
//			uiSkin.areatxt.text = uiSkin.areaList.array[0].areaName;
//			uiSkin.areaList.selectedIndex = -1;
//			
//			uiSkin.townList.array = ChinaAreaModel.instance.getAllArea(uiSkin.areaList.array[0].id);
//			
//			uiSkin.towntxt.text = uiSkin.townList.array[0].areaName;
//			uiSkin.townList.selectedIndex = -1;
//			
//			companyareaId = uiSkin.townList.array[0].id;

			
		}
		
		private function selectArea(index:int):void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);

			if( index == -1 )
				return;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAddressFromServer ,this,function(data:String)
			{
				var result:Object = JSON.parse(data as String);
				
				uiSkin.townList.array = result.status as Array;//ChinaAreaModel.instance.getAllCity(province.id);
				uiSkin.townList.refresh();
				
				uiSkin.towntxt.text = uiSkin.townList.array[0].areaname;
				uiSkin.townList.selectedIndex = 0;
				companyareaId = uiSkin.townList.array[0].id;
				
			},"parentid=" + uiSkin.areaList.array[index].id,"post");
			uiSkin.areatxt.text = uiSkin.areaList.array[index].areaname;

			uiSkin.areabox.visible = false;

//			uiSkin.areatxt.text = uiSkin.areaList.array[index].areaName;
//			
//			uiSkin.townList.array = ChinaAreaModel.instance.getAllArea(uiSkin.areaList.array[index].id);
//			uiSkin.townList.refresh();
//			uiSkin.towntxt.text = uiSkin.townList.array[0].areaName;
//			uiSkin.townList.selectedIndex = -1;
//			companyareaId = uiSkin.townList.array[0].id;

			
		}
		
		private function selectTown(index:int):void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);

			if( index == -1 )
				return;
			uiSkin.townbox.visible = false;
			uiSkin.towntxt.text = uiSkin.townList.array[index].areaname;
			companyareaId = uiSkin.townList.array[index].id;

		}
	}
}