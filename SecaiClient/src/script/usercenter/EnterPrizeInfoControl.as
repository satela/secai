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
	import model.ErrorCode;
	import model.HttpRequestUtil;
	import model.Userdata;
	import model.users.CityAreaVo;
	
	import script.ViewManager;
	import script.login.CityAreaItem;
	
	import ui.usercenter.EnterPrizeInfoPaneUI;
	
	import utils.UtilTool;
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
		
		private var proid:String = "";
		private var cityid:String = "";
		private var areaid:String = "";
		private var townid:String = "";
		private var hasInit:Boolean = false;
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
			uiSkin.account.text = Userdata.instance.userAccount;
			uiSkin.servicetxt.text = Userdata.instance.userAccount;
			
			uiSkin.shortname.maxChars = 6;
			
			uiSkin.changenamePanel.visible = false;
			uiSkin.changeNameBtn.visible = false;
			uiSkin.applybtn.visible = false;
			uiSkin.applyJoinPanel.visible = false;
			
			uiSkin.changeokbtn.on(Event.CLICK,this,onChangeNameOk);
			uiSkin.changeNameBtn.on(Event.CLICK,this,onShowChangeNamePanel);
			uiSkin.closebtn.on(Event.CLICK,this,onCloseChangeNamePanel);

			uiSkin.applybtn.on(Event.CLICK,this,onshowApplyPanel);
			uiSkin.closeapplybtn.on(Event.CLICK,this,onhideApplyPanel);

			uiSkin.btn_uplicense.on(Event.CLICK,this,onUploadlicense);
			Browser.window.uploadApp = this;
			initFileOpen();
			
			uiSkin.chargebtn.on(Event.CLICK,this,onCharge);
			//uiSkin.chongzhi1.on(Event.CLICK,this,onCharge);

//			if(!ChinaAreaModel.hasInit)
//			{
//				WaitingRespond.instance.showWaitingView(500000);
//				Laya.loader.load([{url:"res/xml/addr.xml",type:Loader.XML}], Handler.create(this, initView), null, Loader.ATLAS);
//			}
//			else
//				initView();

			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAuditInfo ,this,getCompanyInfo,null,"post");
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo,this,getCompanyInfoBack,null,"post");
			
			
		}
		
		private function onChangeNameOk():void
		{
			if(uiSkin.newcompanyName.text == "")
			{
				ViewManager.showAlert("请填写企业名称");
				return;
			}
			if(uiSkin.newShortName.text == "")
			{
				ViewManager.showAlert("请填写企业简称");
				return;
			}
			var params:String = "name=" + uiSkin.newcompanyName.text + "&shortname=" + uiSkin.newShortName.text;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.changeCompanyName,this,changeCompanyInfoBack,params,"post");

			uiSkin.changenamePanel.visible = false;
		}
		
		private function changeCompanyInfoBack(datastr:*):void
		{
			if(this.destroyed)
				return;
			
			var result:Object = JSON.parse(datastr as String);
			if(result.status == 0)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCompanyInfo,this,getCompanyInfoBack,null,"post");

			}
		}
		private function onShowChangeNamePanel():void
		{
			uiSkin.newcompanyName.text = Userdata.instance.company;
			uiSkin.newShortName.text = Userdata.instance.companyShort;

			uiSkin.changenamePanel.visible = true;
		}
		
		private function onCloseChangeNamePanel():void
		{
			uiSkin.changenamePanel.visible = false;
		}
		
		private function onshowApplyPanel():void
		{
			uiSkin.applyJoinPanel.visible = true;
		}
		
		private function onhideApplyPanel():void
		{
			uiSkin.applyJoinPanel.visible = false;

		}
		private function getCompanyInfoBack(data:Object):void
		{
			if(this.destroyed)
				return;
			
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				Userdata.instance.money = Number(result.balance);
				uiSkin.moneytxt.text = Userdata.instance.money.toString() + "元";
				
				uiSkin.input_companyname.text = result.name;
				uiSkin.detail_addr.text = result.addr;
				uiSkin.reditcode.text = result.license
				uiSkin.txt_license.text = "";
				uiSkin.shortname.text = result.shortname;
				
				Userdata.instance.company = result.name;
				Userdata.instance.companyShort = result.shortname;
				//var nums = Number(cominfo.gp_zone);
				proid = (result.zone as String).slice(0,2) + "0000";
				cityid = (result.zone as String).slice(0,4) + "00";
				areaid = (result.zone as String).slice(0,6);
				townid = result.zone;
				uiSkin.btnsave.disabled = true;
				uiSkin.btnsave.label = "已审核";
			}
			else if(result.status == 205)
			{
				uiSkin.applybtn.visible = true;
			}
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAddressFromServer ,this,initView,"parentid=0","post");

		}	
		
		private function onCharge():void
		{
			EventCenter.instance.event(EventCenter.SHOW_CHARGE_VIEW);
		}
		private function getCompanyInfo(data:Object):void
		{
			if(this.destroyed)
				return;
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				if(result[0] != null)
				{
					if(parseInt(result[0].result) == 1)
					{
						uiSkin.btnsave.disabled = true;
						uiSkin.btnsave.label = "已审核";
						uiSkin.changeNameBtn.visible = true;
					}
					else if(parseInt(result[0].result) == 0)
					{
						uiSkin.btnsave.disabled = true;
						uiSkin.btnsave.label = "审核中";
						
						var cominfo:Object = JSON.parse(result[0].info);
						uiSkin.input_companyname.text = cominfo.gp_name;
						uiSkin.detail_addr.text = cominfo.gp_addr;
						uiSkin.reditcode.text = cominfo.gp_orgcode;
						uiSkin.txt_license.text = cominfo.gp_license;
						uiSkin.shortname.text = cominfo.gp_shortname;
						
						proid = (cominfo.gp_zone as String).slice(0,2) + "0000";
						cityid = (cominfo.gp_zone as String).slice(0,4) + "00";
						areaid = (cominfo.gp_zone as String).slice(0,6);
						townid = cominfo.gp_zone.zone;
						
						HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAddressFromServer ,this,initView,"parentid=0","post");

					}
					else
					{
						uiSkin.btnsave.disabled = false;
						uiSkin.btnsave.label = "审核失败,请重新提交";
					}
					if(result[0].info != null && result[0].info != "")
					{
						
						
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
			
			var selpro:int = 0;
			if(hasInit == false)
			{
				//var auditproid:String = UtilTool.getLocalVar("proid","0");
				
				if(proid  != "")
				{
					for(var i:int=0;i < uiSkin.provList.array.length;i++)
					{
						if(uiSkin.provList.array[i].id == proid)
						{
							selpro = i;
							break;
						}
					}
				}
			}
			
			selectProvince(selpro);
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
			if(curYyzzFile.size >= 6*1024*1024)
			{
				ViewManager.showAlert("营业执照尺寸不能超过6M");
				return;
			}
			if(curYyzzFile.type != "image/jpg" && curYyzzFile.type != "image/jpeg")
			{
				ViewManager.showAlert("营业执照图片必须为JPG格式");
				return;
			}
			if(uiSkin.shortname.text == "")
			{
				ViewManager.showAlert("请填写企业简称");
				return;
			}
			
			if(uiSkin.reditcode.text == "")
			{
				ViewManager.showAlert("请填写统一社会征信代码");
				return;
			}
			Browser.window.createGroup({urlpath:HttpRequestUtil.httpUrl + HttpRequestUtil.createGroup, cname:uiSkin.input_companyname.text,cshortname:uiSkin.shortname.text,czoneid:companyareaId,caddr:uiSkin.detail_addr.text,reditcode:uiSkin.reditcode.text,file:curYyzzFile});

			//HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.addCompanyInfo,this,onSaveCompnayBack,"name=" + uiSkin.input_companyname.text + "&addr=" + Userdata.instance.defaultAddrid,"post");
		}
		
		private function onSaveCompnayBack(data:Object):void
		{
			if(this.destroyed)
				return;
			
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
			if(uiSkin == null || uiSkin.destroyed)
				return;
			
			province = uiSkin.provList.array[index];
			uiSkin.provbox.visible = false;
			uiSkin.province.text = province.areaname;

			proid = province.id;
			
			
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAddressFromServer ,this,function(data:String)
			{
				if(uiSkin == null || uiSkin.citytxt == null || uiSkin.destroyed)
					return;
				var result:Object = JSON.parse(data as String);
				
				uiSkin.cityList.array = result.status as Array;//ChinaAreaModel.instance.getAllCity(province.id);
				uiSkin.cityList.refresh();
				
				var selpro:int = 0;
				if(hasInit == false)
				{
					
					if(cityid  != "")
					{
						for(var i:int=0;i < uiSkin.cityList.array.length;i++)
						{
							if(uiSkin.cityList.array[i].id == cityid)
							{
								selpro = i;
								break;
							}
						}
					}
				}
				
				uiSkin.citytxt.text = uiSkin.cityList.array[selpro].areaname;
				//uiSkin.cityList.selectedIndex = selpro;
				selectCity(selpro);
				
			},"parentid=" + proid,"post");
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
			if(uiSkin == null || uiSkin.destroyed)
				return;
			
			uiSkin.citybox.visible = false;
			
			cityid = uiSkin.cityList.array[index].id;

			var tempid = cityid;
			
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAddressFromServer ,this,function(data:String)
			{
				if(uiSkin == null || uiSkin.areatxt == null || uiSkin.destroyed)
					return;
				
				var result:Object = JSON.parse(data as String);
				
				uiSkin.areaList.array = result.status as Array;//ChinaAreaModel.instance.getAllCity(province.id);
				uiSkin.areaList.refresh();
				
				var selpro:int = 0;
				if(hasInit == false)
				{
									
					if(areaid != "")
					{
						for(var i:int=0;i < uiSkin.areaList.array.length;i++)
						{
							if(uiSkin.areaList.array[i].id == areaid)
							{
								selpro = i;
								break;
							}
						}
					}
				}
				
				uiSkin.areatxt.text = uiSkin.areaList.array[selpro].areaname;
				//uiSkin.areaList.selectedIndex = selpro;
				selectArea(selpro);

				
			},"parentid=" + tempid,"post");
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
			if(uiSkin == null || uiSkin.destroyed)
				return;
			
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);

			if( index == -1 )
				return;
			areaid = uiSkin.areaList.array[index].id;

			var tempid = areaid;
			
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getAddressFromServer ,this,function(data:String)
			{
				if(uiSkin == null || uiSkin.towntxt == null || uiSkin.destroyed)
					return;
				
				var result:Object = JSON.parse(data as String);
				
				uiSkin.townList.array = result.status as Array;//ChinaAreaModel.instance.getAllCity(province.id);
				uiSkin.townList.refresh();
				
				var selpro:int = 0;
				if(hasInit == false)
				{
					
					if(townid != "")
					{
						for(var i:int=0;i < uiSkin.townList.array.length;i++)
						{
							if(uiSkin.townList.array[i].id == townid)
							{
								selpro = i;
								break;
							}
						}
					}
				}
				
				uiSkin.towntxt.text = uiSkin.townList.array[selpro].areaname;
				//uiSkin.townList.selectedIndex =selpro;
				companyareaId = uiSkin.townList.array[selpro].id;

				
			},"parentid=" + tempid,"post");
			
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
			hasInit = true;

			if( index == -1 )
				return;
			uiSkin.townbox.visible = false;
			uiSkin.towntxt.text = uiSkin.townList.array[index].areaname;
			companyareaId = uiSkin.townList.array[index].id;
			townid = companyareaId;
		}
	}
}