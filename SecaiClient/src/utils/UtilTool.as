package utils
{
	import laya.net.LocalStorage;

	public class UtilTool
	{
		public static function oneCutNineAdd(fnum:Number):Number
		{
			var numstr:String = fnum.toFixed(1);
			var dotnum:int = parseInt(numstr.split(".")[1]);
			
			if(dotnum == 1)
				return parseInt(numstr.split(".")[0]);
			else if(dotnum == 9)
				return parseInt(numstr.split(".")[0]) + 1;
			else
				return parseFloat(numstr);

		}
		
		/**
		 *获取本地记录的内容 
		 * @param key
		 * @param defaultValue 默认值，会根据默认值int,float,string自动格式化返回值
		 * @return 
		 * 
		 */		
		public static function getLocalVar(key:String,defaultValue:*= null):*{
			var v:String=laya.net.LocalStorage.getItem(key);
			if(v===null){
				if(defaultValue==null)return null;
				v=defaultValue;
				laya.net.LocalStorage.setItem(key,v+"");
				return v;
			}
			
			if(defaultValue!=null)if(Math.floor(defaultValue)==defaultValue){
				return parseInt(v); 
			}else if (parseFloat(defaultValue+"")==defaultValue){
				
				return parseFloat(v);
			}
			return v;
		}
		public static function setLocalVar(key:String,value:*):void{
			//清除
			if(value==null){
				removeLocalVar(key);
				return;
			}
			LocalStorage.setItem(key,value+"");
		}
		public static function removeLocalVar(key:String):void{
			LocalStorage.removeItem(key);
		}
		
		public function UtilTool()
		{
		}
	}
}