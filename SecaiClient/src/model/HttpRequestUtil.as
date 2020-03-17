package model
{
	import laya.events.Event;
	import laya.net.HttpRequest;
	import laya.ui.View;
	import laya.utils.Browser;
	
	import script.ViewManager;
	
	import utils.UtilTool;
	import utils.WaitingRespond;

	public class HttpRequestUtil
	{
		private static var _instance:HttpRequestUtil;
		
		public static var httpUrl:String =  "http://seiuf7.natappfree.cc/";//"../scfy/";//http://www.cmyk.com.cn/scfy/" ;//	"http://47.98.218.56/scfy/"; //"http://dhs3iy.natappfree.cc/";//
		
		public static const registerUrl:String = "account/create?";
		
		public static const loginInUrl:String = "account/login?";//phone= code= 或pwd= mode(0 密码登陆 1 验证码登陆);
		
		public static const loginOutUrl:String = "account/logout?";//登出

		
		public static const getVerifyCode:String = "api/getcode?";
			
		

		public static const createDirectory:String = "dir/create?";
		public static const deleteDirectory:String = "dir/remove?";
		public static const getDirectoryList:String = "dir/list?";
		public static const uploadPic:String = "file/add";
		public static const deletePic:String = "file/remove?";
		
		public static const getCapacity:String = "get-info?";
		
		public static const getChangePwdCode:String = "account/getcode?";
		public static const changePwdReqUrl:String = "account/modify?";

		public static const createGroup:String = "group/create-group?";//cname,cshortname,czoneid,caddr,cyyzz


		public static const addressManageUrl:String = "group/opt-group-express?";//1 delete 2 update 3 insert 4 list 5 default

		public static const biggerPicUrl:String = "http://large-thumbnail-image.oss-cn-hangzhou.aliyuncs.com/";
		public static const smallerrPicUrl:String = "http://small-thumbnail-image.oss-cn-hangzhou.aliyuncs.com/";
		
		public static const originPicPicUrl:String = "http://original-image.oss-cn-hangzhou.aliyuncs.com/";

		public static const addCompanyInfo:String = "group/create?"; //name=,addr=
		
		public static const getAuditInfo:String = "group/get-request?";//获取企业信息

		public static const getOuputAddr:String = "business/manufacturers?client_code=CL10200&";//addr_id=120106";获取输出工厂地址
		public static const getProdCategory:String = "business/prodcategory?client_code=CL10200&";//addr_id=120106";获取工厂材料列表 SCFY001

		public static const getProdList:String = "business/prodlist?client_code=CL10200&addr_id=";//addr_id,prodCat_name=纸&;获取工厂材料列表

		public static const getProcessCatList:String = "business/processcatlist?prod_code=";//

		public static const getProcessFlow:String = "business/procflowlist?manufacturer_code=";//procCat_name= //获取工艺流
		
		public static const GetAccCatlist:String = "business/acccatlist?";//prod_code=，proc_name= //获取附件类名称

		public static const GetAccessorylist:String = "business/accessorylist?";//manufacturer_code=，accessoryCat_name= //获取附件类列表

		public static const getDeliveryList:String = "business/deliverylist?manufacturer_code=";//=SPSC00100&addr_id=330700";//获取配送列表

		public static const placeOrder:String = "business/placeorder?";//下单接口

		public static const cancelOrder:String = "business/cancelorder?";//取消订单
		
		public static const authorUploadUrl:String = "file/authinfo";//上传请求凭证
		public static const noticeServerPreUpload:String = "file/preupload?";//上传前通知服务器 path,fname 
		
		public static const getAddressFromServer:String = "group/get-addr-list?";//查询地址 parentid
		
		public static const abortUpload:String = "file/abortadd?";//主动终止上传
		
		public static const getMerchandiseList:String = "business/merchandiselist?client_code=CL10200&";

		public static const getManuFactureMatProcPrice:String = "business/getmatprocprice?manufacturer_code=";
		
		//充值
		public static const getCompanyInfo:String = "group/get-info?";//账户信息

		
		public static const chargeRequest:String = "group/recharge?";//账户充值
		
		public static const orderOnlinePay:String = "group/recharge?";//订单在线支付  orderid 在线支付 

		public static const payOrderByMoney:String = "group/pay-order?";//余额支付orderid

		public static const checkOrderList:String = "business/list-order?";//查询订单

		public static const getOrderRecordList:String = "account/listorder?";//查询订单 date = 201910 curpage=1

		public static const changeCompanyName:String = "group/update_group?";//修改公司名

		public static function get instance():HttpRequestUtil
		{
			if(_instance == null)
				_instance = new HttpRequestUtil();
			return _instance;
		}
		
		public function HttpRequestUtil()
		{
			
		}
		
		private function newRequest(url:String,caller:Object=null,complete:Function=null,param:Object=null,requestType:String="text",onProgressFun:Function = null):void{
			
			var request:HttpRequest=new HttpRequest();
			request.on(Event.PROGRESS, this, function(e:Object)
			{
				if(onProgressFun != null)
					onProgressFun(e);
			});
			request.on(Event.COMPLETE, this,onRequestCompete,[caller, complete,request]);
			
			//var self:HttpModel=this;
			function checkOver(url:String,caller:Object,complete:Function,param:Object,requestType:String,request:HttpRequest){
				onHttpRequestError(url,caller,complete,param,requestType,request);
			}
			Laya.timer.once(5000,request,checkOver,[url,caller,complete,param,requestType,request]);
			
			
			
			request.on(Event.ERROR, this, onHttpRequestError,[url,caller,complete,param,requestType,request]);
			if(param!=null){
				if(param is String){
					
				}else if(param is ArrayBuffer){
					
				}else{
					var query:Array=[];
					for(var k in param){
						
						query.push(k+"="+encodeURIComponent(param[k]));
					}
					param=query.join("&");
				}
			}
			console.log(url+param);
			request["retrytime"]=0;
			request.send(url, param, requestType?'post':'get', "text");
		}
		
		private function onHttpRequestError(url:String,caller:Object,complete:Function,param:Object,requestType:String,request:HttpRequest,e:Object=null):void
		{
			//ViewManager.showAlert("您的网络出了个小差，请重试！");
		}
		
		private function onHttpRequestProgress(e:Object=null):void
		{
			trace(e)
		}
		
		private function onRequestCompete(caller:Object,complete:Function,request:HttpRequest,data:Object):void
		{
			WaitingRespond.instance.hideWaitingView();

			try
			{
				var result:Object = JSON.parse(data as String);
				if(result && result.hasOwnProperty("status"))
				{
					if(result.status != 0)
					{
						if(ErrorCode.ErrorTips.hasOwnProperty(result.status))
						{
							ViewManager.showAlert(ErrorCode.ErrorTips[result.status]);
						}
						if(result.status == 203)
						{
							ViewManager.instance.openView(ViewManager.VIEW_lOGPANEL,true);
						}
					}
				}
			}
			catch(err:Error)
			{
				ViewManager.instance.openView(ViewManager.VIEW_lOGPANEL,true);
				return;
			}
			Laya.timer.clearAll(request);
			// TODO Auto Generated method stub
			if(caller&&complete)complete.call(caller,data);
			request.offAll();
		}
		
		public  function Request(url:String,caller:Object=null,complete:Function=null,param:Object=null,type:String="get",onProgressFun:Function = null,showwaiting:Boolean=true):void{
			
			var logtime:String = UtilTool.getLocalVar("loginTime","");
			if(Userdata.instance.loginTime != 0 && logtime != Userdata.instance.loginTime.toString())
			{
				ViewManager.showAlert("不能同时登陆两个账号，请重新登录");
				Userdata.instance.isLogin = false;
				
				UtilTool.setLocalVar("useraccount","");
				UtilTool.setLocalVar("userpwd","");
				
				Browser.window.location.reload();
				//ViewManager.instance.openView(ViewManager.VIEW_FIRST_PAGE,true);
				
				return;
			}
			
			if(showwaiting)
			{
				WaitingRespond.instance.showWaitingView();
			}
			newRequest(url,caller,complete,param,type);
		}
		// --- Static Functions ------------------------------------------------------------------------------------------------------------------------------------ //
		public  function RequestBin(url:String,caller:Object=null,complete:Function=null,param:Object=null):void{
			newRequest(url,caller,complete,param,"arraybuffer");
		}
		
	}
}