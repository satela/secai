//
//全局消息注册与发送，用事件机制完成
//
package eventUtil
{
	
	import laya.events.EventDispatcher;
	
	/**客户端内部事件的派发和接受用这个*/
	public class EventCenter extends EventDispatcher 
	{
		public static const LOGIN_SUCESS:String = "LOGIN_SUCESS";
		
		public static const SELECT_FOLDER:String = "SELECT_FOLDER";

		public static const UPDATE_FILE_LIST:String = "UPDATE_FILE_LIST";

		public static const SELECT_PIC_ORDER:String = "SELECT_PIC_ORDER";

		public static const SELECT_ORDER_ADDRESS:String = "SELECT_ORDER_ADDRESS";

		public static const ADD_PIC_FOR_ORDER:String = "ADD_PIC_FOR_ORDER";//新增图片下单
		public static const DELETE_PIC_ORDER:String = "DELETE_PIC_ORDER";//删除订单图片

		public static const ADJUST_PIC_ORDER_TECH:String = "ADJUST_PIC_ORDER_TECH";//自适应下单工艺修改

		private static var _eventCenter:EventCenter;
		
	

		public static function get instance():EventCenter
		{
			if(_eventCenter == null)
			{
				_eventCenter = new EventCenter(new SingleForcer());
			}
			
			return _eventCenter;
		}
		
		public function EventCenter(force:SingleForcer)
		{
			
		}
		
	}
}

class SingleForcer{}
