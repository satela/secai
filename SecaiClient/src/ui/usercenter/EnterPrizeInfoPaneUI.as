/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import script.usercenter.EnterPrizeInfoControl;

	public class EnterPrizeInfoPaneUI extends View {
		public var chargebtn:Button;
		public var moneytxt:Label;
		public var actMoney:Label;
		public var frezeMoney:Label;
		public var servicetxt:Label;
		public var account:Label;
		public var reditcode:TextInput;
		public var shortname:TextInput;
		public var input_companyname:TextInput;
		public var changeNameBtn:Button;
		public var applybtn:Button;
		public var btnSelProv:Button;
		public var province:Label;
		public var btnSelCity:Button;
		public var citytxt:Label;
		public var btnSelArea:Button;
		public var areatxt:Label;
		public var detail_addr:TextInput;
		public var txt_license:TextInput;
		public var btn_uplicense:Button;
		public var provbox:Image;
		public var provList:List;
		public var citybox:Image;
		public var cityList:List;
		public var areabox:Image;
		public var areaList:List;
		public var btnsave:Button;
		public var btnSelTown:Button;
		public var towntxt:Label;
		public var townbox:Image;
		public var townList:List;
		public var changenamePanel:Box;
		public var newcompanyName:TextInput;
		public var newShortName:TextInput;
		public var changeokbtn:Button;
		public var closebtn:Button;
		public var applyJoinPanel:Box;
		public var createAccountInput:TextInput;
		public var applyokbtn:Button;
		public var closeapplybtn:Button;
		public var commentInput:TextInput;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("usercenter/EnterPrizeInfoPane");

		}

	}
}