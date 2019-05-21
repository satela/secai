package model
{
	import laya.events.Event;
	import laya.net.HttpRequest;
	
	import script.ViewManager;
	
	import utils.WaitingRespond;

	public class HttpRequestUtil
	{
		private static var _instance:HttpRequestUtil;
		
		public static var httpUrl:String = "../scfy/";//http://www.cmyk.com.cn/scfy/" ;//	"http://47.98.218.56/scfy/"; //"http://dhs3iy.natappfree.cc/";//
		
		public static const registerUrl:String = "account/create?";
		
		public static const loginInUrl:String = "account/login?";//phone= code= 或pwd= mode(0 密码登陆 1 验证码登陆);
		
		public static const loginOutUrl:String = "account/logout?";//登出

		
		public static const getVerifyCode:String = "api/getcode?";
			
		

		public static const createDirectory:String = "dir/create?";
		public static const deleteDirectory:String = "dir/remove?";
		public static const getDirectoryList:String = "dir/list?";
		public static const uploadPic:String = "file/add";
		public static const deletePic:String = "file/remove?";
		
		public static const createGroup:String = "group/create-group?";//cname,cshortname,czoneid,caddr,cyyzz


		public static const addressManageUrl:String = "group/opt-group-express?";//1 delete 2 update 3 insert 4 list 5 default

		public static const biggerPicUrl:String = "http://large-thumbnail-image.oss-cn-hangzhou.aliyuncs.com/";
		public static const smallerrPicUrl:String = "http://small-thumbnail-image.oss-cn-hangzhou.aliyuncs.com/";
		
		public static const originPicPicUrl:String = "http://original-image.oss-cn-hangzhou.aliyuncs.com/";

		public static const addCompanyInfo:String = "group/create?"; //name=,addr=
		
		public static const getCompanyInfo:String = "group/get-request?";//获取企业信息

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
					}
				}
			}
			catch(err:Error)
			{
				
			}
			Laya.timer.clearAll(request);
			// TODO Auto Generated method stub
			if(caller&&complete)complete.call(caller,data);
			request.offAll();
		}
		
		public  function Request(url:String,caller:Object=null,complete:Function=null,param:Object=null,type:String="get",onProgressFun:Function = null,showwaiting:Boolean=true):void{
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