/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.usercenter {
	import laya.ui.*;
	import laya.display.*;
	import script.usercenter.ApplyJoinMgrControl;

	public class ApplyJoinMgrPanelUI extends View {
		public var applylist:List;
		public var distributePanel:Box;
		public var deptbox:ComboBox;
		public var confirmJoin:Button;
		public var closedistribute:Button;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("usercenter/ApplyJoinMgrPanel");

		}

	}
}