/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;
	import script.prefabScript.TopBannerControl;
	import laya.html.dom.HTMLDivElement;
	import script.picUpload.PicManagerControl;

	public class PicManagePanelUI extends View {
		public var main_panel:Panel;
		public var firstPage:Text;
		public var myorder:Text;
		public var userName:Text;
		public var logout:Text;
		public var btnUploadPic:Button;
		public var btnNewFolder:Button;
		public var flder0:Label;
		public var htmltext:HTMLDivElement;
		public var radiosel:CheckBox;
		public var searchInput:TextInput;
		public var filetypeRadio:RadioGroup;
		public var prgcap:ProgressBar;
		public var leftcapacity:Label;
		public var btnorder:Button;
		public var picList:List;
		public var btnroot:Label;
		public var flder1:Label;
		public var flder2:Label;
		public var boxNewFolder:Box;
		public var input_folename:TextInput;
		public var btnSureCreate:Button;
		public var btnCloseInput:Button;
		public var btnprevfolder:Text;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("PicManagePanel");

		}

	}
}