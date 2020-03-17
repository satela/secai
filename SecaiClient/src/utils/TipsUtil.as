package utils
{
	import laya.display.Node;
	import laya.events.Event;
	
	import ui.common.TipPanelUI;

	public class TipsUtil
	{
		public static var _instance:TipsUtil;
		public var tipspanel:TipPanelUI;
		private var tipsMsg:String = "";
		public static function getInstance():TipsUtil
		{
			if(_instance == null)
				_instance = new TipsUtil();
			return _instance;
		}
		public function TipsUtil()
		{
			tipspanel = new TipPanelUI();
		}
		
		public function addTips(container:Node,tips:String)
		{
			container.on(Event.MOUSE_OVER,this,showTips);
			container.on(Event.MOUSE_MOVE,this,showTips);
			container.on(Event.MOUSE_OUT,this,removeTips);
			tipspanel.tips.text = tips;
			
			tipspanel.backimg.width = tipspanel.tips.textField.textWidth + 15;
			tipspanel.backimg.height = tipspanel.tips.textField.textHeight + 15;

		}
		
		public function showTips(e:Event):void
		{
			if(tipspanel.parent == null)
			{
				Laya.stage.addChild(tipspanel);				
			}
			tipspanel.x = e.stageX + 10;
			tipspanel.y = e.stageY + 10;
		}
		public function removeTips(e:Event):void
		{
			if(tipspanel.parent != null)
			{
				tipspanel.removeSelf();				
			}
		}
	}
}