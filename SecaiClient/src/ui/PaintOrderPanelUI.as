/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;
	import script.prefabScript.LinkTextControl;
	import script.prefabScript.TopBannerControl;
	import script.order.PaintOrderControl;
	import laya.html.dom.HTMLDivElement;

	public class PaintOrderPanelUI extends View {
		public var panelout:Panel;
		public var firstPage:Text;
		public var myorder:Text;
		public var userName:Text;
		public var logout:Text;
		public var myaddresstxt:Text;
		public var outputbox:VBox;
		public var fengeimg:Image;
		public var floatpt:Box;
		public var floatdocker:Box;
		public var selectAll:CheckBox;
		public var productNum:Label;
		public var btnaddpic:Button;
		public var batchChange:Button;
		public var mainvbox:VBox;
		public var ordervbox:VBox;
		public var deliversp:Sprite;
		public var deliverbox:VBox;
		public var batchcomment:Box;
		public var commentall:TextInput;
		public var panelbottom:Panel;
		public var textTotalPrice:HTMLDivElement;
		public var textDeliveryType:HTMLDivElement;
		public var textPayPrice:HTMLDivElement;
		public var copynum:TextInput;
		public var btnsaveorder:Button;
		public var btnordernow:Button;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("PaintOrderPanel");

		}

	}
}