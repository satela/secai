package script.login
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.display.Input;
	import laya.events.Event;
	import laya.maths.Point;
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
		
		private var coutdown:int = 60;
		
		
		private var serviceTxt:String = "尊敬的用户：\n" +
     									"   色彩飞扬是专业的为广告及相关产品委托生产、买卖、交付等提供服务的网站（下称“本网站”），为广告相关产品及其他产品的委托生产、买卖、交付等的双方用户提供居间服务及其他相关服务，在此特别提醒用户认真阅读本《服务协议》(下称“本协议”)中各个条款，并确认是否同意本协议条款。用户的使用行为将视为对本协议的接受，并同意接受本协议各项条款的约束。\n\n" + 

										"一、本协议条款的确认\n" + 
										"   1、本网站的各项服务的所有权归上海红印科技有限公司。本协议内容包括协议正文及所有本网站已经发布或将来可能发布的各类规则。所有规则为协议不可分割的一部分，与本协议正文具有同等法律效力。以任何方式进入本网站即表示用户已充分阅读、理解并同意接受本协议的条款。\n" + 
    									"   2、本网站有权根据业务需要酌情修订本协议，并以网站公告或直接更新的形式进行更新，不再单独通知。经修订的协议条款一经公布，即产生效力。如用户不同意相关修订，可以选择停止使用。如用户继续使用本网站，则将视为用户已接受经修订的协议条款。\n\n" + 
										"二、服务要求及保密\n" + 
										"1、用户必须符合下列要求：\n" + 
		" （1）应当是具备完全民事权利能力和与所从事的民事行为相适应的行为能力的自然人、法人或其他组织；\n" + 
		" （2）自行配备上网的所需设备，并自行负担上网及其他与此服务有关的电话、网络等费用；\n" + 
		" （3）按本网站要求完成注册，保证向本网站提供的任何资料、注册信息的真实性、正确性及完整性，保证本网站可以通过上述联系方式与用户进行联系；当上述资料发生变更时，及时更新用户资料；\n" + 
		" （4）账号使用权仅属于初始注册人，禁止赠与、借用、租用、转让或售卖，否则，本网站有权收回账号；\n" + 
		" （5）用户保证各项行为符合各项法律、法规、政策规定，以及本网站各项协议等的要求；\n" + 
		" （6）用户为委托方或买方的，保证遵守印刷、出版等行业的法律、法规、政策规定，且保证要求制作的产品不会侵犯他人的知识产权；\n" + 
		" （7）用户为广告经营者的，应当在注册时验证广告经营资格；若后续资格有变动的，应及时变更登记信息。\n" + 
		"2、本网站对用户的隐私资料进行保护，承诺不会在未获得用户许可的情况下擅自将用户的个人资料信息出租或出售给任何第三方，但以下情况除外：\n" + 
		" （1）为完成用户与第三方交易； \n" + 
		" （2）用户同意让第三方共享资料；\n" + 
		" （3）用户同意公开其个人资料，享受为其提供的商品和服务；\n" + 
		" （4）根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；\n" + 
		" （5）本网站发现用户违反了本网站服务条款或其它规定。\n" + 
		"   若本网站有合理理由怀疑用户资料信息为错误、不实、失效或不完整，本网站有权暂停或终止用户的帐号，并拒绝现在或将来使用本站网络服务的全部或部分，同时保留追索用户不当得利返还的权利。\n\n" + 
		"三、平台服务和地位 \n" + 
		"   本网站仅作为用户物色交易对象，就货物和服务的交易进行协商，以及获取各类与交易相关的居间服务的场所，不涉及用户间因交易而产生的法律关系及法律纠纷。本网站不能控制或保证交易信息的真实性、合法性、准确性，亦不能控制或保证交易所涉及的物品及服务的质量、安全或合法性，以及相关交易各方履行在贸易协议项下的各项义务的能力。但本网站会尽力协助各方履行各自义务。用户注册并选择本网站提供的服务，即视为认可由本网站为其提供居间服务及有关服务的内容，同时认可通过本网站指定的账号或支付平台由本网站监管、代付有关款项。\n\n" + 
		"四、结束服务\n" + 
		"   用户或本网站可随时根据实际情况中断一项或多项网络服务。本网站不需对任何个人或第三方负责而随时中断服务。结束用户服务后，用户使用网络服务的权利马上中止。从那时起，用户没有权利要求本网站，本网站也没有义务传送任何未处理的信息或提供未完成的服务给用户或第三方。用户在使用服务期间因使用服务与其他用户之间发生的关系，不因本协议的终止而终止。\n\n" + 
		
		"五、服务费用。 \n" + 
		"   本网站保留在征得用户同意后，收取服务费用的权利。用户因进行交易、获取有偿服务等发生的所有应纳税赋，由用户自行承担。\n\n" + 
		
		"六、广告展示\n" + 
		"   用户在本网站发表宣传资料或参与广告策划，展示商品或服务，都只是在相应的用户之间发生，本网站不承担任何责任。\n\n" + 
		
		"七、服务内容的所有权\n" + 
		"   本网站有关文字、软件、声音、图片、录象、图表、广告及其他文件的全部内容受版权、商标、和其它财产所有权属于本网站所有，受法律的保护。\n\n" + 
		
		"八、责任限制\n" + 
		"   如因不可抗力或其他本网站无法控制的原因使本网站无法正常运营的，本网站不承担责任。\n\n" + 
		
		"九、争议解决和管辖\n" + 
		"   本协议的订立、执行和解释及争议的解决均应适用中国法律。\n" + 
		"如用户与本网站发生任何争议，双方应尽力友好协商解决；协商不成时，任何一方均应向本网站所属公司住所地人民法院提起诉讼。\n";


		


		public function RegisterCntrol()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as RegisterPanelUI; 
						
			uiSkin.mainpanel.vScrollBarSkin = "";
			uiSkin.mainpanel.hScrollBarSkin = "";
			uiSkin.contractpanel.hScrollBarSkin = "";

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
			
			uiSkin.sevicepro.leading = 5;
			uiSkin.sevicepro.text = serviceTxt;
			
			uiSkin.txtpanel.vScrollBarSkin = "";
			uiSkin.txtpanel.hScrollBarSkin = "";

			if(Browser.height > Laya.stage.height)
				uiSkin.contractpanel.height = Laya.stage.height;
			else
				uiSkin.contractpanel.height = Browser.height;

			
			uiSkin.contractpanel.width = Browser.width;

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
			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;

			
			EventCenter.instance.on(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);
			
			Laya.timer.frameLoop(1,this,updateVerifyPos);
			
			
			uiSkin.okbtn.disabled = true;
			uiSkin.agreebox.on(Event.CLICK,this,onAgreeService);
			uiSkin.okbtn.on(Event.CLICK,this,onReadService);
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
		
		private function onReadService():void
		{
			uiSkin.contractpanel.visible = false;
			
			verifycode = Browser.document.createElement("div");
			verifycode.id = "v_container";
			verifycode.style="width: 200px;height: 50px;left:950px;top:548";
			verifycode.style.width = 200/Browser.pixelRatio + "px";
			verifycode.style.height = 50/Browser.pixelRatio + "px";
			
			verifycode.style.left = (950 - (1920 - Browser.width)/2) + "px";
			
			verifycode.style.position ="absolute";
			verifycode.style.zIndex = 999;
			Browser.document.body.appendChild(verifycode);//添加到舞台
			
			//uiSkin.on(Event.CLICK,this,hideAddressPanel);
			Browser.window.loadVerifyCode();
			
		}
		private function onAgreeService():void
		{
			uiSkin.okbtn.disabled = !uiSkin.agreebox.selected;
		}
		private function onResizeBrower():void
		{
			if(verifycode != null)
			{
				//verifycode.style.left = 950 - (1920 - Browser.width)/2 + "px";
				//verifycode.style.top = 548 - (1920 - Browser.width)/2 + "px";
				//verifycode.style.top = 548 - uiSkin.mainpanel.vScrollBar.value + "px";

			}
			
			//uiSkin.contractpanel.height = Browser.height;
			if(Browser.height > Laya.stage.height)
				uiSkin.contractpanel.height = Laya.stage.height;
			else
				uiSkin.contractpanel.height = Browser.height;
			uiSkin.contractpanel.width = Browser.width;

			uiSkin.mainpanel.height = Browser.height;
			uiSkin.mainpanel.width = Browser.width;

		}
		
		private function updateVerifyPos():void
		{
			if(verifycode != null)
			{
				//verifycode.style.top = 548 - uiSkin.mainpanel.vScrollBar.value + "px";
				var pt:Point = uiSkin.inputCode.localToGlobal(new Point(uiSkin.inputCode.x,uiSkin.inputCode.y),true);
				var offset:Number = 0;
				if(Browser.width > Laya.stage.width)
					offset = (Browser.width - Laya.stage.width)/2;
				
				verifycode.style.top = pt.y/Browser.pixelRatio + "px";
				verifycode.style.left = (pt.x +  80 + offset)/Browser.pixelRatio +  "px";
				
				verifycode.style.width = 200/Browser.pixelRatio + "px";
				verifycode.style.height = 50/Browser.pixelRatio + "px";

				//trace("pos:" + pt.x + "," + pt.y);
				//verifycode.style.left = 950 -  uiSkin.mainpanel.hScrollBar.value + "px";

			}
			
		}
		private function onGetPhoneCode():void
		{
			// TODO Auto Generated method stub
			if(uiSkin.input_phone.text.length < 11)
			{
				Browser.window.alert("请填写正确的手机号");
				return;
			}
			uiSkin.btnGetCode.disabled = true;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getVerifyCode ,this,onGetPhoneCodeBack,"phone=" + uiSkin.input_phone.text,"post");
		}
		
		private function onGetPhoneCodeBack(data:String):void
		{
			var result:Object = JSON.parse(data);
			if(result.status == 0)
			{
				phonecode = result.code;
				uiSkin.btnGetCode.label = "60秒后重试";
				Laya.timer.loop(1000,this,countdownCode);
			}
			else
				uiSkin.btnGetCode.disabled = false;

			trace("pho code:" + data);
		}
		
		private function countdownCode():void
		{
			coutdown--;
			if(coutdown > 0)
			{
				uiSkin.btnGetCode.label = coutdown + "秒后重试";
			}
			else
			{
				uiSkin.btnGetCode.disabled = false;
				uiSkin.btnGetCode.label = "获取验证码";
				Laya.timer.clear(this,countdownCode);
			}
		}
		private function onRefreshVerify(e:Event):void
		{
			Browser.window.loadVerifyCode();

		}
		private function onCloseScene():void
		{
			Browser.document.body.removeChild(verifycode);//添加到舞台
			Laya.timer.clear(this,countdownCode);

			ViewManager.instance.closeView(ViewManager.VIEW_REGPANEL);
			ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
			EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

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
				
				var param:String = "phone=" + uiSkin.input_phone.text + "&pwd=" + uiSkin.input_pwd.text + "&code=" + uiSkin.input_phonecode.text;
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
			if(result.status == 0)
			{
				Browser.window.alert("注册成功！");
				Browser.document.body.removeChild(verifycode);//添加到舞台
				EventCenter.instance.off(EventCenter.BROWER_WINDOW_RESIZE,this,onResizeBrower);

				ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);

				ViewManager.instance.openView(ViewManager.VIEW_lOGPANEL,false);

			}
		}		
		public override function onDestroy():void
		{
			
			Laya.timer.clearAll(this);

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