package laya.system {
	import laya.renders.Render;
	
	/**
	 * @private
	 */
	public class System {
		/**
		 * 替换指定名称的定义。用来动态更改类的定义。
		 * @param	name 属性名。
		 * @param	classObj 属性值。
		 */
		//TODO:coverage
		public static function changeDefinition(name:String, classObj:*):void {
			Laya[name] = classObj;
			var str:String = name + "=classObj";
			Laya._runScript(str);
		}
		
		/**
		 * @private
		 * 初始化。
		 */
		public static function __init__():void {
		}
	}
}