package utils
{
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
		public function UtilTool()
		{
		}
	}
}