/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui.characterpaint {
	import laya.ui.*;
	import laya.display.*;
	import script.characterpaint.CharacterMainControl;

	public class CharacterPaintUI extends View {
		public var panel_main:Panel;
		public var depth1:TextInput;
		public var mattype1:RadioGroup;
		public var createlayer1:Button;
		public var closebtn:Button;
		public var choosecolor1:Label;
		public var depth2:TextInput;
		public var mattype2:RadioGroup;
		public var createlayer2:Button;
		public var fontsizeinput:TextInput;
		public var backimglist:List;
		public var alphasilder1:HSlider;
		public var alphasilder2:HSlider;
		public var depth3:TextInput;
		public var mattype3:RadioGroup;
		public var createlayer3:Button;
		public var alphasilder3:HSlider;
		public var lightIntensity:HSlider;
		public var changSizeBtn:Button;
		public var choosecolor2:Label;
		public var choosecolor3:Label;
		public var colorpanel:Image;
		public var colorlist:List;
		public var closecolor:Button;

		override protected function createChildren():void {
			super.createChildren();
			loadScene("characterpaint/CharacterPaint");

		}

	}
}