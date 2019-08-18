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
		public static const SELECT_OUT_ADDRESS:String = "SELECT_OUT_ADDRESS";//选择输出工厂

		public static const SELECT_DELIVERY_TYPE:String = "SELECT_DELIVERY_TYPE";//选择配送方式


		public static const ADD_PIC_FOR_ORDER:String = "ADD_PIC_FOR_ORDER";//新增图片下单
		public static const DELETE_PIC_ORDER:String = "DELETE_PIC_ORDER";//删除订单图片

		public static const SHOW_SELECT_TECH:String = "SHOW_SELECT_TECH";//打开选择工艺界面
		public static const UPDATE_ORDER_ITEM_TECH:String = "UPDATE_ORDER_ITEM_TECH";//选择工艺结束

		public static const ADJUST_PIC_ORDER_TECH:String = "ADJUST_PIC_ORDER_TECH";//自适应下单工艺修改

		
		public static const UPDATE_LOADING_PROGRESS:String = "UPDATE_LOADING_PROGRESS";//刷新加载进度
		
		public static const UPDATE_MYADDRESS_LIST:String = "UPDATE_MYADDRESS_LIST";//刷新我的地址列表

		public static const CANCAEL_UPLOAD_ITEM:String = "CANCAEL_UPLOAD_ITEM";//删除一个上传文件
		public static const RE_UPLOAD_FILE:String = "RE_UPLOAD_FILE";//重新上传文件

		public static const ADD_TECH_ATTACH:String = "ADD_TECH_ATTACH";//增加配件

		public static const BROWER_WINDOW_RESIZE:String = "BROWER_WINDOW_RESIZE";//浏览器窗口大小改变

		public static const BATCH_CHANGE_PRODUCT_NUM:String = "BATCH_CHANGE_PRODUCT_NUM";//批量修改数量
		
		public static const PAUSE_SCROLL_VIEW:String = "PAUSE_SCROLL_VIEW";//暂停滚动


		public static const CLOSE_PANEL_VIEW:String = "CLOSE_PANEL_VIEW";//关闭界面消息
		public static const SHOW_CHARGE_VIEW:String = "SHOW_CHARGE_VIEW";//充值
		
		public static const PAY_ORDER_SUCESS:String = "PAY_ORDER_SUCESS";//支付成功

		public static const CANCEL_PAY_ORDER:String = "CANCEL_PAY_ORDER";//取消支付


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
