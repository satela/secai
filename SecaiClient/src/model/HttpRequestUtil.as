package model
{
	import laya.events.Event;
	import laya.net.HttpRequest;

	public class HttpRequestUtil
	{
		private static var _instance:HttpRequestUtil;
		
		public static const httpUrl:String = "http://47.101.178.87/"; //"http://100.94.150.222:80/" ;//	"http://dhs3iy.natappfree.cc/";//
		
		public static const registerUrl:String = "account/create?";
		
		public static const loginInUrl:String = "account/login?";//phone= code= 或pwd= mode(0 密码登陆 1 验证码登陆);
		
		public static const loginOutUrl:String = "account/logout?";//登出

		
		public static const getVerifyCode:String = "api/getcode?";
		

		public static const createDirectory:String = "dir/create?";
		public static const deleteDirectory:String = "dir/remove?";
		public static const getDirectoryList:String = "dir/list?";
		public static const uploadPic:String = "file/add?";
		public static const deletePic:String = "file/remove?";

		public static const biggerPicUrl:String = "http://m-scfy-763.oss-cn-shanghai.aliyuncs.com/";
		public static const smallerrPicUrl:String = "http://s-scfy-763.oss-cn-shanghai.aliyuncs.com/";
		
		
		public static const addCompanyInfo:String = "group/create?"; //name=,addr=

		public static const getOuputAddr:String = "business/manufacturers?client_code=og001&";//addr_id=120106";获取输出工厂地址
		public static const getProdCategory:String = "business/prodcategory?client_code=og001&";//addr_id=120106";获取工厂材料列表

		public static const getProdList:String = "business/prodlist?client_code=og001&addr_id=120106&";//prodCat_name=纸&;获取工厂材料列表

		public static const getProcessCatList:String = "business/processcatlist?prod_code=";//

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
			Laya.timer.clearAll(request);
			// TODO Auto Generated method stub
			if(caller&&complete)complete.call(caller,data);
			request.offAll();
		}
		
		public  function Request(url:String,caller:Object=null,complete:Function=null,param:Object=null,type:String="get",onProgressFun:Function = null):void{
			newRequest(url,caller,complete,param,type);
		}
		// --- Static Functions ------------------------------------------------------------------------------------------------------------------------------------ //
		public  function RequestBin(url:String,caller:Object=null,complete:Function=null,param:Object=null):void{
			newRequest(url,caller,complete,param,"arraybuffer");
		}
		
	}
}