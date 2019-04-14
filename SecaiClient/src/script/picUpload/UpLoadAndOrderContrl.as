package script.picUpload
{	
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.picmanagerModel.DirectoryFileModel;
	
	import script.ViewManager;
	
	import ui.uploadpic.UpLoadPanelUI;
	
	public class UpLoadAndOrderContrl extends Script
	{
		private var uiSkin:UpLoadPanelUI;
		private var fileListData:Array;

		private var allFileData:Array;
		private var curUploadIndex:int = 0;
		private var file:Object; 
		public var param:Object;

		public var isUploading:Boolean = false;
		
		private var clientParam:Object;
		private var checkpoint:Object = 0;
		private var callbackparam:Object; //服务器回调参数
		private var ossFileName:String;//服务器指定的文件名
		public function UpLoadAndOrderContrl()
		{
			super();
		}
		
		override public function onStart():void
		{
			
			uiSkin = this.owner as UpLoadPanelUI; 
			uiSkin.btnClose.on(Event.CLICK,this,onCloseScene);
			//uiSkin.btnBegin.on(Event.CLICK,this,onClickBegin);
			uiSkin.btnOpenFile.on(Event.CLICK,this,onClickOpenFile);

			//uiSkin.bgimg.alpha = 0.7;
			uiSkin.fileList.itemRender = FileUpLoadItem;
			uiSkin.fileList.vScrollBarSkin = "";
			uiSkin.fileList.selectEnable = false;
			uiSkin.fileList.spaceY = 4;
			uiSkin.fileList.renderHandler = new Handler(this, updateFileItem);
			initFileOpen();
			uiSkin.uploadinfo.visible = false;
			uiSkin.errortxt.visible = false;
			
			Browser.window.uploadApp = this;
			if(param != null && (param as Array) != null)
			{
				uiSkin.fileList.array = param as Array;
				fileListData = param as Array;
				onClickBegin();
			}
			else
				uiSkin.fileList.array = [];

			
			EventCenter.instance.on(EventCenter.CANCAEL_UPLOAD_ITEM,this,onDeleteItem);
			EventCenter.instance.on(EventCenter.RE_UPLOAD_FILE,this,reUploadFile);

		}
		
		private function reUploadFile():void
		{
			uiSkin.errortxt.visible = false;
			onClickBegin();
		}
		private function onClickOpenFile():void
		{
			Laya.timer.clearAll(this);
			file.click();
			file.value ;
		}
		private function initFileOpen():void
		{
			 file = Browser.document.createElement("input");
			
			file.style="filter:alpha(opacity=0);opacity:0;width: 100;height:34px;left:395px;top:-248";
			
//			if(param && param.type == "License")
//				file.multiple="";
//			else
				file.multiple="multiple";

			file.accept = ".jpg,.jpeg,.png,.tif";
			file.type ="file";
			file.style.position ="absolute";
			file.style.zIndex = 999;
			Browser.document.body.appendChild(file);//添加到舞台
			file.onchange = function(e):void
			{
				uiSkin.uploadinfo.visible = false;
				
				if(isUploading)
					return;
				if(file.files.length <= 0)
					return;
				curUploadIndex = 0;
				//allFileData = [];
				//fileReader.readAsBinaryString(file.files[0]);
				
				fileListData = [];
				for(var i:int=0;i < file.files.length;i++)
				{
					file.files[i].progress = 0;
					fileListData.push(file.files[i]);
				}
				
				uiSkin.fileList.array = fileListData;
				onClickBegin();
			};
//			var fileReader:Object = new  Browser.window.FileReader();
//			fileReader.onload = function(evt):void
//			{  
//				if(Browser.window.FileReader.DONE==fileReader.readyState)
//				{
//					allFileData.push(fileReader.result);
//					//var bytearr:ByteArray = new ByteArray();
//					//bytearr.readBytes(fileReader.result);
//				}
//			}
		}
		
		private function getSendRequest():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.authorUploadUrl,this,onGetAuthor,null,"get");
		}
		private function onGetAuthor(data:Object):void
		{
			var authordata:Object = JSON.parse(data as String);
			clientParam = {};
			clientParam.accessKeyId = authordata.Credentials.AccessKeyId;
			clientParam.accessKeySecret = authordata.Credentials.AccessKeySecret;
			clientParam.stsToken = authordata.Credentials.SecurityToken;
			clientParam.endpoint = "oss-cn-shanghai.aliyuncs.com";			
			clientParam.bucket = "n-scfy-763";
			onClickBegin();
		}
		
		private function onClickBegin():void
		{
			if(isUploading)
				return;
			if(clientParam == null)
			{
				getSendRequest();
				return;
			}
			isUploading = true;
			onBeginUpload();
			if(fileListData.length > 0)
			{
				uiSkin.uploadinfo.visible = true;
				uiSkin.uploadinfo.text = "正在上传" + "(" + curUploadIndex + "/" + fileListData.length + ")";
			}
		}
		private function onBeginUpload():void
		{
			if(callbackparam == null && fileListData && fileListData.length > curUploadIndex)
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.noticeServerPreUpload,this,onReadyToUpload,"path=" + DirectoryFileModel.instance.curSelectDir.dpath + "&fname=" + fileListData[curUploadIndex].name ,"get");
			else
				uploadFileImmediate();
			
		}
		
		private function uploadFileImmediate():void
		{
			if(fileListData && fileListData.length > curUploadIndex)
			{
				Browser.window.ossUpload({clientpm:clientParam,file:fileListData[curUploadIndex]},checkpoint,callbackparam,ossFileName);
				
				//Browser.window.uploadPic({urlpath:HttpRequestUtil.httpUrl + HttpRequestUtil.uploadPic, path:DirectoryFileModel.instance.curSelectDir.dpath,file:fileListData[curUploadIndex]});
				//HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.uploadPic,this,onCompleteUpload,{path:"0|11|",file:file.files[0]},"post",onProgressHandler);
			}
			else
			{
				isUploading = false;
				uiSkin.uploadinfo.text = "上传完成，共上传文件" + fileListData.length;
				
				Laya.timer.once(5000,this,onCloseScene);
			}
		}
		private function onReadyToUpload(data:Object):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				callbackparam = {};
				
				callbackparam.url = result.CallbackUrl;
				callbackparam.body = result.CallbackBody;
				callbackparam.contentType = 'application/x-www-form-urlencoded';
				
				var arr:Array = (fileListData[curUploadIndex].name as String).split(".");
				
				ossFileName = result.ObjectName + "." + (arr[1] == null ?"jpg":arr[1]);
				uploadFileImmediate();
			}
		}
		private function onCompleteUpload(e:Object):void
		{
			if(fileListData[curUploadIndex])
			fileListData[curUploadIndex].progress = 100;
			updateProgress();
			curUploadIndex++;
			uiSkin.uploadinfo.text = "正在上传" + "(" + curUploadIndex + "/" + fileListData.length + ")";
			checkpoint = 0;
			callbackparam = null;
			ossFileName = "";
			onBeginUpload();

		}
		
		private function onProgressHandler(e:Object,pro:Object):void
		{
			checkpoint = e;
			if(Number(pro) >= 100)
				pro = "99";
			if(fileListData[curUploadIndex])
			fileListData[curUploadIndex].progress = Number(pro);
			updateProgress();
			//(this.uiSkin.fileList.cells[curUploadIndex] as FileUpLoadItem).updateProgress(e.toString());
			//trace("up progress" + JSON.stringify(e));
		}
		
		private function onUploadError(err:Object):void
		{
			uiSkin.errortxt.visible = true;
			uiSkin.errortxt.text = getErrorMsg(err);
			
			isUploading = false;
			clientParam = null;
			//callbackparam = null;
			//ossFileName = "";
			
			var cells:Vector.<Box> = uiSkin.fileList.cells;
			for(var i:int=0;i < cells.length;i++)
			{
				if(cells[i] as FileUpLoadItem != null && (cells[i] as FileUpLoadItem).fileobj == fileListData[curUploadIndex])
				{
					(cells[i] as FileUpLoadItem).showReUploadbtn();
					break;
				}
			}
			
		}
		private function updateProgress():void
		{
			var cells:Vector.<Box> = uiSkin.fileList.cells;
			for(var i:int=0;i < cells.length;i++)
			{
				if(cells[i] as FileUpLoadItem != null && (cells[i] as FileUpLoadItem).fileobj == fileListData[curUploadIndex])
				{
					(cells[i] as FileUpLoadItem).updateProgress();
					break;
				}
			}
		}
		private function updateFileItem(cell:FileUpLoadItem):void 
		{
			cell.setData(cell.dataSource);
		}
		
		private function onDeleteItem(delitem:FileUpLoadItem):void
		{
			if(delitem.fileobj.progress >= 99)
				return;
			
			var index:int = fileListData.indexOf(delitem.fileobj);
			if(index == curUploadIndex)
			{
				Browser.window.cancelUpload();
				if(isUploading)
					onBeginUpload();
			}
			uiSkin.fileList.deleteItem(index);
			
			
		}
		private function getErrorMsg(err:Object):String
		{
			switch (err.status) {
				case 0:
					if (err.name == "cancel") { //手动点击暂停上传
						return "主动删除";
					}
					break;
				case -1: //请求错误，自动重新上传
					return "自动重新上传";
					return;
				case 203: //回调失败
					return "前端自己给后台回调";
					return;
				case 400:
					switch (err.code) {
						case 'FilePartInterity': //文件Part已改变
						case 'FilePartNotExist': //文件Part不存在
						case 'FilePartState': //文件Part过时
						case 'InvalidPart': //无效的Part
						case 'InvalidPartOrder': //无效的part顺序
						case 'InvalidArgument': //参数格式错误
							return "清空断点,重新上传;";
							
						case 'InvalidBucketName': //无效的Bucket名字
						case 'InvalidDigest': //无效的摘要
						case 'InvalidEncryptionAlgorithmError': //指定的熵编码加密算法错误
						case 'InvalidObjectName': //无效的Object名字
						case 'InvalidPolicyDocument': //无效的Policy文档
						case 'InvalidTargetBucketForLogging': //Logging操作中有无效的目标bucket
						case 'MalformedXML': //XML格式非法
						case 'RequestIsNotMultiPartContent': //Post请求content-type非法
							return "重新授权;继续上传;"
							
						case 'RequestTimeout'://请求超时
							return "请求超时，请重新上传";
					}
					break;
				case 403: 
					return "授权无效，重新授权";
				case 411: return "缺少参数"
				case 404: //Bucket/Object/Multipart Upload ID 不存在
					return "重新授权;继续上传;"
					
				case 500: //OSS内部发生错误
					return "OSS内部发生错误,重新上传;"
					return;
				default:return "未知错误，请重新上传";
					break;
			}
			return "";
		}
		private function onCloseScene():void
		{
			// TODO Auto Generated method stub
			Browser.window.uploadApp = null;

			EventCenter.instance.event(EventCenter.UPDATE_FILE_LIST);
			EventCenter.instance.off(EventCenter.CANCAEL_UPLOAD_ITEM,this,onDeleteItem);
			EventCenter.instance.off(EventCenter.RE_UPLOAD_FILE,this,reUploadFile);

			ViewManager.instance.closeView(ViewManager.VIEW_MYPICPANEL);
			
			Browser.document.body.removeChild(file);//添加到舞台

		}		
		
		
	}
}