package script.login
{
	import laya.components.Script;
	import laya.display.Input;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.ui.List;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.ChinaAreaModel;
	import model.HttpRequestUtil;
	import model.users.CityAreaVo;
	
	import script.ViewManager;
	import script.login.CityAreaItem;
	
	import ui.login.RegisterPanelUI;
	
	import utils.WaitingRespond;
	
	public class RegisterCntrol extends Script
	{
		private var uiSkin:RegisterPanelUI;
		
		private var province:CityAreaVo;
		
		private var verifycode:Object;
		public var param:Object;

		private var phonecode:String = "";
		public function RegisterCntrol()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as RegisterPanelUI; 
			
//			uiSkin.input_adress.maxChars = 200;
//			uiSkin.input_company.maxChars = 50;
			uiSkin.input_conpwd.maxChars = 20;
			uiSkin.input_conpwd.type = Input.TYPE_PASSWORD;
			uiSkin.input_phone.maxChars = 11;
			uiSkin.input_phone.restrict = "0-9";
			uiSkin.input_phonecode.maxChars = 6;
			
			uiSkin.input_pwd.maxChars = 20;
			uiSkin.input_pwd.type = Input.TYPE_PASSWORD;
			
//			uiSkin.input_receiver.maxChars = 10;
//			uiSkin.input_receiverphone.maxChars = 11;
//			uiSkin.input_receiverphone.restrict = "0-9";
			uiSkin.inputCode.maxChars = 8;
			
//			uiSkin.radio_default.selectedIndex = 0;
//			
//			uiSkin.provList.itemRender = CityAreaItem;
//			uiSkin.provList.vScrollBarSkin = "";
//			uiSkin.provList.repeatX = 1;
//			uiSkin.provList.spaceY = 2;
//			
//			uiSkin.provList.renderHandler = new Handler(this, updateCityList);
//			uiSkin.provList.selectEnable = true;
//			uiSkin.provList.selectHandler = new Handler(this, selectProvince);
//			
//			uiSkin.cityList.itemRender = CityAreaItem;
//			uiSkin.cityList.vScrollBarSkin = "";
//			uiSkin.cityList.repeatX = 1;
//			uiSkin.cityList.spaceY = 2;
//			
//			uiSkin.cityList.selectEnable = true;
//			
//			uiSkin.cityList.renderHandler = new Handler(this, updateCityList);
//			uiSkin.cityList.selectHandler = new Handler(this, selectCity);
//			
//			
//			uiSkin.areaList.itemRender = CityAreaItem;
//			uiSkin.areaList.vScrollBarSkin = "";
//			uiSkin.areaList.selectEnable = true;
//			uiSkin.areaList.repeatX = 1;
//			uiSkin.areaList.spaceY = 2;
//			
//			uiSkin.areaList.renderHandler = new Handler(this, updateCityList);
//			uiSkin.areaList.selectHandler = new Handler(this, selectArea);
//			
//			uiSkin.townList.itemRender = CityAreaItem;
//			uiSkin.townList.vScrollBarSkin = "";
//			uiSkin.townList.selectEnable = true;
//			uiSkin.townList.repeatX = 1;
//			uiSkin.townList.spaceY = 2;
//			
//			uiSkin.townList.renderHandler = new Handler(this, updateCityList);
//			uiSkin.townList.selectHandler = new Handler(this, selectTown);
//			
//			
//			uiSkin.btnSelProv.on(Event.CLICK,this,onShowProvince);
//			uiSkin.btnSelCity.on(Event.CLICK,this,onShowCity);
//			uiSkin.btnSelArea.on(Event.CLICK,this,onShowArea);
//			uiSkin.btnSelTown.on(Event.CLICK,this,onShowTown);

			uiSkin.btnGetCode.on(Event.CLICK,this,onGetPhoneCode);

			uiSkin.btnClose.on(Event.CLICK,this,onCloseScene);
			//uiSkin.bgimg.alpha = 0.9;
//			uiSkin.areabox.visible = false;
//			uiSkin.provbox.visible = false;
//			uiSkin.citybox.visible = false;
//			uiSkin.townbox.visible = false;
			
			//uiSkin.txtRefresh.underline = true;
			//uiSkin.txtRefresh.underlineColor = "#121212";
			uiSkin.txtRefresh.on(Event.CLICK,this,onRefreshVerify);

			uiSkin.btnReg.on(Event.CLICK,this,onRegister);

			verifycode = Browser.document.createElement("div");
			verifycode.id = "v_container";
			verifycode.style="width: 200px;height: 50px;left:950px;top:521";
							
			
			verifycode.style.position ="absolute";
			verifycode.style.zIndex = 999;
			Browser.document.body.appendChild(verifycode);//添加到舞台
			
			//uiSkin.on(Event.CLICK,this,hideAddressPanel);
			Browser.window.loadVerifyCode();
			
//			if(!ChinaAreaModel.hasInit)
//			{
//				WaitingRespond.instance.showWaitingView(500000);
//				Laya.loader.load([{url:"res/xml/addr.xml",type:Loader.XML}], Handler.create(this, initView), null, Loader.ATLAS);
//			}
//			else
//				initView();
		}
		
//		private function initView():void
//		{
//			uiSkin.provList.array = ChinaAreaModel.instance.getAllProvince();
//			selectProvince(0);
//			uiSkin.provList.refresh();
//		}
		private function onGetPhoneCode():void
		{
			// TODO Auto Generated method stub
			if(uiSkin.input_phone.text.length < 11)
			{
				Browser.window.alert("请填写正确的手机号");
				return;
			}
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getVerifyCode ,this,onGetPhoneCodeBack,"phone=" + uiSkin.input_phone.text,"post");
		}
		
		private function onGetPhoneCodeBack(data:String):void
		{
			var result:Object = JSON.parse(data);
			if(result.status == 0)
			{
				phonecode = result.code;
			}
			trace("pho code:" + data);
		}
		private function onRefreshVerify(e:Event):void
		{
			Browser.window.loadVerifyCode();

		}
		private function onCloseScene():void
		{
			Browser.document.body.removeChild(verifycode);//添加到舞台
			
			ViewManager.instance.closeView(ViewManager.VIEW_REGPANEL);
			//this.owner.removeSelf();
		}		
		
		private function onRegister():void
		{
			//if(uiSkin.
			var res:Boolean = Browser.window.checkCode(uiSkin.inputCode.text);
			if(res)
			{
				if(uiSkin.input_phone.text.length < 11)
				{
					Browser.window.alert("请填写正确的手机号");
					return;
				}
				if(uiSkin.input_pwd.text.length < 6)
				{
					Browser.window.alert("密码长度至少6位");
					return;
				}
				if(uiSkin.input_pwd.text != uiSkin.input_conpwd.text)
				{
					Browser.window.alert("密码确认不对");
					return;
				}
				
//				if(uiSkin.input_company.text.length < 6)
//				{
//					Browser.window.alert("请填写正确的公司名称");
//					return;
//				}
//				if(uiSkin.input_receiver.text == "")
//				{
//					Browser.window.alert("请填写收货人");
//					return;
//				}
//				if(uiSkin.input_receiverphone.text == "")
//				{
//					Browser.window.alert("请填写收货人电话");
//					return;
//				}
//				if(uiSkin.input_receiverphone.text == "")
//				{
//					Browser.window.alert("请填写收货人电话");
//					return;
//				}
//				
//				if(uiSkin.province.text == "")
//				{
//					Browser.window.alert("请选择省份");
//					return;
//				}
//				
//				if(uiSkin.citytxt.text == "")
//				{
//					Browser.window.alert("请选择城市");
//					return;
//				}
//				if(uiSkin.citytxt.text == "")
//				{
//					Browser.window.alert("请选择城市");
//					return;
//				}
//				
//				if(uiSkin.input_adress.text.length < 10)
//				{
//					Browser.window.alert("请填写详细收货地址");
//					return;
//				}
//				
//				if(uiSkin.input_phonecode.text == "")
//				{
//					Browser.window.alert("请填写手机验证码");
//					return;
//				}
				
				var param:String = "phone=" + uiSkin.input_phone.text + "&pwd=" + uiSkin.input_pwd.text + "&code=" + phonecode;
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.registerUrl,this,onRegisterBack,param,"post");

			}
			else
			{
				Browser.window.alert("验证码错误");
				//Browser.window.loadVerifyCode();

			}

		}
		
		private function onRegisterBack(data:String):void
		{
			// TODO Auto Generated method stub
			var result:Object = JSON.parse(data);
			//if(result.status == 0)
			{
				Browser.window.alert("注册成功！");
				Browser.document.body.removeChild(verifycode);//添加到舞台

				ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);

				ViewManager.instance.openView(ViewManager.VIEW_lOGPANEL,false);

			}
		}		
		
//		private function hideAddressPanel(e:Event):void
//		{
//			if(e.target is List)
//				return;
//			uiSkin.provbox.visible = false;
//			uiSkin.citybox.visible = false;
//			uiSkin.areabox.visible = false;
//			uiSkin.townbox.visible = false;
//
//		}
//		private function onShowProvince(e:Event):void
//		{
//			uiSkin.provbox.visible = true;
//			uiSkin.citybox.visible = false;
//			uiSkin.areabox.visible = false;
//			uiSkin.townbox.visible = false;
//
//			e.stopPropagation();
//		}
//		private function onShowCity(e:Event):void
//		{
//			uiSkin.provbox.visible = false;
//			uiSkin.citybox.visible = true;
//			uiSkin.areabox.visible = false;
//			uiSkin.townbox.visible = false;
//
//			e.stopPropagation();
//		}
//		private function onShowArea(e:Event):void
//		{
//			uiSkin.provbox.visible = false;
//			uiSkin.citybox.visible = false;
//			uiSkin.areabox.visible = true;
//			uiSkin.townbox.visible = false;
//			e.stopPropagation();
//		}
//		
//		private function onShowTown(e:Event):void
//		{
//			uiSkin.provbox.visible = false;
//			uiSkin.citybox.visible = false;
//			uiSkin.areabox.visible = false;
//			uiSkin.townbox.visible = true;
//			e.stopPropagation();
//		}
//		
//		private function updateCityList(cell:CityAreaItem,index:int):void
//		{
//			cell.setData(cell.dataSource);
//		}
//		private function selectProvince(index:int):void
//		{
//			province = uiSkin.provList.array[index];
//			trace(province);
//			uiSkin.provbox.visible = false;
//			//province = uiSkin.provList.cells[index].cityname;
//			uiSkin.cityList.array = ChinaAreaModel.instance.getAllCity(province.id);
//			uiSkin.cityList.refresh();
//			uiSkin.province.text = province.areaName;
//			
//			uiSkin.citytxt.text = uiSkin.cityList.array[0].areaName;
//			uiSkin.cityList.selectedIndex = 0;
//			
//			uiSkin.areaList.array = ChinaAreaModel.instance.getAllArea(uiSkin.cityList.array[0].id);
//			uiSkin.areaList.refresh();
//			
//			uiSkin.areatxt.text = uiSkin.areaList.array[0].areaName;
//			uiSkin.areaList.selectedIndex = -1;
//			
//			uiSkin.townList.array = ChinaAreaModel.instance.getAllArea(uiSkin.areaList.array[0].id);
//			
//			uiSkin.towntxt.text = uiSkin.townList.array[0].areaName;
//			uiSkin.townList.selectedIndex = -1;
//			
//		}
//		
//		private function selectCity(index:int):void
//		{
//			uiSkin.citybox.visible = false;
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
//		}
//		
//		private function selectArea(index:int):void
//		{
//			if( index == -1 )
//				return;
//			uiSkin.areabox.visible = false;
//			uiSkin.areatxt.text = uiSkin.areaList.array[index].areaName;
//			
//			uiSkin.townList.array = ChinaAreaModel.instance.getAllArea(uiSkin.areaList.array[index].id);
//			uiSkin.townList.refresh();
//			uiSkin.towntxt.text = uiSkin.townList.array[0].areaName;
//			uiSkin.townList.selectedIndex = -1;
//			
//		
//		}
//		
//		private function selectTown(index:int):void
//		{
//			if( index == -1 )
//				return;
//			uiSkin.townbox.visible = false;
//			uiSkin.towntxt.text = uiSkin.townList.array[index].areaName;
//			
//		}
		
	}
}