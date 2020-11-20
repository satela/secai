package model
{
	public class Constast
	{
		public static const ACCOUNT_CREATER:int = 1;//公司创建者
		public static const ACCOUNT_EMPLOYEE:int = 0;//公司职员
		
		public static const PRIVILEGE_PAYORDER_BY_SCAN = 1;//扫码支付权限
		public static const PRIVILEGE_PAYORDER_BY_AMOUNT = 2;//余额支付权限
		public static const PRIVILEGE_HIDE_PRICE = 3;//隐藏价格

		public static const PRIVILEGE_CHECK_ORDERS = 4;//查看订单
		
		public static const PRIVILEGE_CHECK_TRANSACTION = 5;//查看账单


		public static const TYPE_NAME:Array = ["","充值","余额支付订单","退款","","取消异常订单","直接支付订单","撤单退款"];


	}
}