package model
{
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	import model.users.CityAreaVo;
	
	import utils.WaitingRespond;
	
	
	public class ChinaAreaModel
	{
		private static var areadict:Object;
		
		private static var allAreaDict:Object;
		private static var _instance:ChinaAreaModel;
		public static var hasInit:Boolean = false;
		
		public function ChinaAreaModel()
		{
			
		}
		
		public  static function get instance():ChinaAreaModel
		{
			if(_instance == null)
			{
				_instance = new ChinaAreaModel();
				initData();
			}
			
			return _instance;
		}
		
		private static function initData():void
		{
			//WaitingRespond.instance.showWaitingView(500000);
			//Laya.loader.load("res/xml/addr.xml",new Handler(ChinaAreaModel,onCompelteHandler),null,Loader.XML);
		//}
		
		//private static function onCompelteHandler(e:Event):void
		//{
			//var times:Number = (new Date()).getTime();
			//console.log("地址 配置 解析开始");
			hasInit = true;
			var xmlstr:* = Laya.loader.getRes("res/xml/addr.xml");
			//var xml:XmlDom = Utils.parseXMLFromString(xmlstr);
			var rootNode:XmlDom = xmlstr.firstChild as XmlDom;
			
			var nodes:Array = rootNode.childNodes;
			 areadict = {};
			 allAreaDict = {};
			for(var i:int=0;i < nodes.length;i++)
			{
				var node:Object = nodes[i];
				var arrtibute:Array = node.attributes as Array;
				
				var cityvo:CityAreaVo = new CityAreaVo();
				cityvo.areaName = node.@name;
				cityvo.id = node.@id;
				cityvo.parentid = node.@parentid;
				
				allAreaDict[cityvo.id] = cityvo;
				
				if(areadict.hasOwnProperty(cityvo.parentid))
					areadict[cityvo.parentid].push(cityvo);
				else
				{
					areadict[cityvo.parentid] = [];
					areadict[cityvo.parentid].push(cityvo);
				}
			}
			WaitingRespond.instance.hideWaitingView();
			//var times1:Number = (new Date()).getTime();

			//console.log("地址 配置 解析完毕" + (times1 - times));
		}
		public function getAllProvince():Array
		{			
			
			return areadict["0"];
		}
		
		public function getAllCity(proid:String):Array
		{
					
			return areadict[proid];
		}
		
		public function getAllArea(cityid:String):Array
		{
			return areadict[cityid];
					
		}
		
		public function getAreaName(cityid:String):String
		{
			if(allAreaDict.hasOwnProperty(cityid))
				return allAreaDict[cityid].areaName;
			return "";
		}
		public function getParentId(cityid:String):String
		{
			return allAreaDict[cityid].parentid;
			
		}
		public function getFullAddressByid(cityid:String):String
		{
			if(allAreaDict.hasOwnProperty(cityid))
			{
				var address:String = getFullAddressByid(allAreaDict[cityid].parentid) + " " + allAreaDict[cityid].areaName;
				return address;
			}
			return "";
		}
	}
}