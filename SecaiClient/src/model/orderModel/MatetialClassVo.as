package model.orderModel
{
	public class MatetialClassVo
	{
		public var matclassname:String = "喷绘材料";
		
		public var childMatList:Array;
		public function MatetialClassVo()
		{
			childMatList = [];
			var arr:Array = ["喷绘材料","布类材料","印刷材料"];
			var ccc:int = Math.floor(Math.random()*arr.length);
			matclassname = arr[ccc];
			
			var maimat:MaterialItemVo = new MaterialItemVo();
			maimat.matName = "油画布";
			maimat.nextMatList = new Vector.<MaterialItemVo>();
			
			
			var mat:MaterialItemVo = new MaterialItemVo();
			mat.matName = "喷印方式";
			mat.nextMatList = new Vector.<MaterialItemVo>();
			
			
			var childmat:MaterialItemVo = new MaterialItemVo();
			childmat.matName = "户内写真";
			childmat.nextMatList = new Vector.<MaterialItemVo>();
			
			var childchildmat:MaterialItemVo = new MaterialItemVo();
			childchildmat.matName = "4pass";
			childchildmat.nextMatList = new Vector.<MaterialItemVo>();
			childmat.nextMatList.push(childchildmat);
			
			 childchildmat = new MaterialItemVo();
			childchildmat.matName = "6pass";
			childchildmat.nextMatList = new Vector.<MaterialItemVo>();
			childmat.nextMatList.push(childchildmat);
					
			mat.nextMatList.push(childmat);

			
			 childmat = new MaterialItemVo();
			childmat.matName = "户外写真";
			childmat.nextMatList = new Vector.<MaterialItemVo>();
			
			 childchildmat = new MaterialItemVo();
			childchildmat.matName = "4pass";
			childchildmat.nextMatList = new Vector.<MaterialItemVo>();
			childmat.nextMatList.push(childchildmat);
			
			childchildmat = new MaterialItemVo();
			childchildmat.matName = "6pass";
			childchildmat.nextMatList = new Vector.<MaterialItemVo>();
			childmat.nextMatList.push(childchildmat);
			
			mat.nextMatList.push(childmat);
			
			
			childmat = new MaterialItemVo();
			childmat.matName = "卷材UV";
			childmat.nextMatList = new Vector.<MaterialItemVo>();
			
			childchildmat = new MaterialItemVo();
			childchildmat.matName = "正喷";
			childchildmat.nextMatList = new Vector.<MaterialItemVo>();
			
			var childchildmat1 = new MaterialItemVo();
			childchildmat1.matName = "1层白";
			childchildmat1.nextMatList = new Vector.<MaterialItemVo>();
			childchildmat.nextMatList.push(childchildmat1);
			
			 childchildmat1 = new MaterialItemVo();
			childchildmat1.matName = "2层白";
			childchildmat1.nextMatList = new Vector.<MaterialItemVo>();
			childchildmat.nextMatList.push(childchildmat1);
			childchildmat1 = new MaterialItemVo();
			childchildmat1.matName = "3层白";
			childchildmat1.nextMatList = new Vector.<MaterialItemVo>();
			childchildmat.nextMatList.push(childchildmat1);
			
			childmat.nextMatList.push(childchildmat);
			
			childchildmat = new MaterialItemVo();
			childchildmat.matName = "背喷";
			childchildmat.nextMatList = new Vector.<MaterialItemVo>();
			childmat.nextMatList.push(childchildmat);
			
			childchildmat = new MaterialItemVo();
			childchildmat.matName = "双面喷";
			childchildmat.nextMatList = new Vector.<MaterialItemVo>();
			childmat.nextMatList.push(childchildmat);
			
			mat.nextMatList.push(childmat);
			maimat.nextMatList.push(mat);
			///////////////////////////////////////////////////////////////////工艺结束
			
			
			 mat = new MaterialItemVo();
			mat.matName = "上光油";
			mat.nextMatList = new Vector.<MaterialItemVo>();
			
			
			var childmat:MaterialItemVo = new MaterialItemVo();
			childmat.matName = "哑面";
			childmat.nextMatList = new Vector.<MaterialItemVo>();		
			
			mat.nextMatList.push(childmat);
			
			
			childmat = new MaterialItemVo();
			childmat.matName = "亮面";
			childmat.nextMatList = new Vector.<MaterialItemVo>();
					
			
			mat.nextMatList.push(childmat);
				
			maimat.nextMatList.push(mat);
////////////////////////////////////////////////////////
			
			mat = new MaterialItemVo();
			mat.matName = "异性切割";
			mat.nextMatList = new Vector.<MaterialItemVo>();
			maimat.nextMatList.push(mat);

			mat = new MaterialItemVo();
			mat.matName = "装裱";
			mat.nextMatList = new Vector.<MaterialItemVo>();
			maimat.nextMatList.push(mat);		
			
			childMatList.push(maimat);
			
			
		}
	}
}