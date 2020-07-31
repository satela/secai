package script.characterpaint
{
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.Label;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	import model.picmanagerModel.PicInfoVo;
	
	import script.ViewManager;
	
	import ui.characterpaint.CharacterPaintUI;
	
	public class CharacterMainControl extends Script
	{
		private var uiSkin:CharacterPaintUI;
		
		private static var u3ddiv:Object;
		private static var script:*;
		private static var scriptpr:*;

		private var picurl:String = "http://large-thumbnail-image.oss-cn-hangzhou.aliyuncs.com/18014398509938750.jpg";
		
		public var param:PicInfoVo;
		
		private var allsilder:Array;
		
		private var curselectColor:Label;
		
		public function CharacterMainControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as CharacterPaintUI;
			
			uiSkin.panel_main.vScrollBarSkin = "";
			uiSkin.panel_main.hScrollBarSkin = "";
			
			this.uiSkin.closebtn.on(Event.CLICK,this,closeView);
			
			uiSkin.mattype1.selectedIndex = 0;
			uiSkin.mattype2.selectedIndex = 0;
			uiSkin.mattype3.selectedIndex = 0;

			uiSkin.depth1.text = "1";
			uiSkin.depth2.text = "10";
			uiSkin.depth3.text = "10";

			uiSkin.createlayer1.on(Event.CLICK,this,oncreateLayer1);
			uiSkin.createlayer2.on(Event.CLICK,this,oncreateLayer2);
			
			uiSkin.createlayer3.on(Event.CLICK,this,oncreateLayer3);
			
			 allsilder = [uiSkin.alphasilder1,uiSkin.alphasilder2,uiSkin.alphasilder3];
			for(var i:int=0;i<allsilder.length;i++)
				allsilder[i].on(Event.CHANGE,this,onChangeAlpha,[i]);
			
			
			uiSkin.lightIntensity.on(Event.CHANGE,this,onChangeLigthIntensity);

			//this.uiSkin.fontsizeinput.on(Event.INPUT,this,onSizeChange);
			
			uiSkin.backimglist.itemRender = BackGroundItem;
			
			uiSkin.backimglist.vScrollBarSkin = "";
			uiSkin.backimglist.repeatX = 2;
			
			var imgback:Array = ["stone/stone1","stone/stone2","stone/stone3","wall/wall","wall/wall1","wall/wall2","wood/wood1","wood/wood2","wood/wood3"];
			
			uiSkin.backimglist.array = imgback;
			
			
			uiSkin.backimglist.renderHandler = new Handler(this, updateBackgroundList);
			uiSkin.backimglist.selectHandler = new Handler(this, onSelectHandler);

			uiSkin.backimglist.selectEnable = true;
			

			uiSkin.colorlist.itemRender = ColorItem;
			
			uiSkin.fontsizeinput.text = param.picPhysicWidth + "";
			
			//uiSkin.colorlist.vScrollBarSkin = "";
			uiSkin.colorlist.repeatX = 2;
			uiSkin.colorlist.spaceX = 2;
			uiSkin.colorlist.spaceY = 5;
			
			var colorlist:Array = ["FF0000","000000","808080","D3D3D3","FFFFFF","800000","F08080","A0522D","FF8C00","FFA500","DAA520","808000","BDB76B",
									"FFFF00","6B8E23","9ACD32","ADFF2F","006400","008000","00FF00","90EE90","40E0D0","008B8B","00FFFF","00BFFF","1E90FF",
									"4169E1","00008B","0000FF","48CD8B","7B68EE","8A2BE2","9400D3","800080","FF00FF","EE82EE"];
			
			uiSkin.colorlist.array = colorlist;
			
			
			uiSkin.colorlist.renderHandler = new Handler(this, updateColorList);
			uiSkin.colorlist.selectHandler = new Handler(this, onSelectColor);
			
			uiSkin.colorlist.selectEnable = true;
			
			uiSkin.colorpanel.visible = false;
			
			uiSkin.closecolor.on(Event.CLICK,this,onCloseColorPanel);

			if(param != null)
			{
				picurl = HttpRequestUtil.biggerPicUrl + param.fid + ".jpg";
			}
			
			var colorlbl:Array = [uiSkin.choosecolor1,uiSkin.choosecolor2,uiSkin.choosecolor3];
			for(var i:int=0;i < colorlbl.length;i++)
			{
				colorlbl[i].on(Event.CLICK,this,showColorPanel,[i]);
			}
			uiSkin.changSizeBtn.on(Event.CLICK,this,onchangeFontSize);
			initU3dWeb();
			
			Browser.window.layaCaller = this;
		}
		
		private function updateBackgroundList(cell:BackGroundItem):void
		{
			cell.setData(cell.dataSource);
			
			cell.setSelected(cell.dataSource == uiSkin.backimglist.array[uiSkin.backimglist.selectedIndex]);
		}
		
		private function onSelectHandler(index:int):void
		{
			for(var i:int=0;i < uiSkin.backimglist.cells.length;i++)
			{
				(uiSkin.backimglist.cells[i] as BackGroundItem).setSelected((uiSkin.backimglist.cells[i] as BackGroundItem).urlpath == uiSkin.backimglist.array[index]);
			}
			
			Browser.window.Unity3dWeb.changebackground(uiSkin.backimglist.array[index]);

		}
		
		private function updateColorList(cell:ColorItem):void
		{
			cell.setData(cell.dataSource);
			
		}
		
		private function onSelectColor(index:int):void
		{
			if(index < 0)
				return;
			//Browser.window.Unity3dWeb.changebackground(uiSkin.backimglist.array[index]);
			curselectColor.bgColor = "#" + uiSkin.colorlist.array[index];
			uiSkin.colorpanel.visible = false;

		}
		
		private function showColorPanel(index:int):void
		{
			uiSkin.colorlist.selectedIndex = -1;
			uiSkin.colorpanel.visible = true;
			curselectColor = uiSkin["choosecolor" + (index+1)];
					
		}
		
		private function onCloseColorPanel():void
		{
			uiSkin.colorpanel.visible = false;

		}
		private function initU3dWeb():void
		{
			if(u3ddiv == null)
			{
				u3ddiv = Browser.document.createElement("div");
				
				u3ddiv.style = "width: 900px; height: 830px;left:540px;top:-110px";
				u3ddiv.id = "gameContainer";
				
				Browser.document.body.appendChild(u3ddiv);
				
				var complete:int = 0;
				script = Browser.document.createElement("script");
				script.src = "webglout/Build/UnityLoader.js";
				script.onload = function(){
					//加载完成函数，开始调用模块的功能。
					//new一个js中的对象
					//var client = new Laya.Browser.window.Demo1();
					//client.start();
					trace("on load unoty");
					complete++;
					if(complete >= 2)
					{
						Browser.window.Unity3dWeb.createUnity();
					}
				}
				script.onerror = function(){
					//加载错误函数
				}
				Browser.document.body.appendChild(script);
				
				scriptpr = Browser.document.createElement("script");
				scriptpr.src = "webglout/TemplateData/UnityProgress.js";
				scriptpr.onload = function(){
					//加载完成函数，开始调用模块的功能。
					//new一个js中的对象
					//var client = new Laya.Browser.window.Demo1();
					//client.start();
					trace("on load unoty");
					complete++;
					if(complete >= 2)
					{
						Browser.window.Unity3dWeb.createUnity();
					}
				}
				scriptpr.onerror = function(){
					//加载错误函数
				}
				Browser.document.body.appendChild(scriptpr);
			}
			else
			{
				u3ddiv.style.display = "block";
				var size:Number = parseInt(uiSkin.fontsizeinput.text)/100;
				
				Browser.window.Unity3dWeb.changefontSize(size.toString());
				
				Browser.window.Unity3dWeb.createMesh(picurl);

			}
			
		}
		
		private function unityIsReady():void
		{
			var size:Number = parseInt(uiSkin.fontsizeinput.text)/100;
			
			Browser.window.Unity3dWeb.changefontSize(size.toString());
			
			Browser.window.Unity3dWeb.createMesh(picurl);
		}
		
		private function onChangeAlpha(index:int):void
		{
			
			Browser.window.Unity3dWeb.changelayerAlpha(index + "&" + allsilder[index].value/100);

		}
		
		private function onChangeLigthIntensity():void
		{
			Browser.window.Unity3dWeb.changeligthIntensity(uiSkin.lightIntensity.value/100+"");

		}
		private function oncreateLayer1():void
		{
			var str:String = "";
			
			var depth:Number = parseInt(uiSkin.depth1.text)/100;
			
			str += "0&";
			
			str += depth + "&";
			
			str += (uiSkin.mattype1.selectedIndex+1) + "&";
			
			str += (uiSkin.choosecolor1.bgColor);
			
			Browser.window.Unity3dWeb.createLayer(str);
		}
		private function oncreateLayer2():void
		{
			var str:String = "";
			str += "1&";
			
			var depth:Number = parseInt(uiSkin.depth2.text)/100;

			
			str += depth + "&";
			
			str += (uiSkin.mattype2.selectedIndex+1) + "&";
			
			str += (uiSkin.choosecolor2.bgColor);
			
			Browser.window.Unity3dWeb.createLayer(str);
		}
		
		private function oncreateLayer3():void
		{
			var str:String = "";
			str += "2&";
			
			var depth:Number = parseInt(uiSkin.depth3.text)/100;
			
			
			str += depth + "&";
			
			str += (uiSkin.mattype3.selectedIndex+1) + "&";
			
			str += (uiSkin.choosecolor3.bgColor);
			
			Browser.window.Unity3dWeb.createLayer(str);
		}
		
		
		private function onchangeFontSize():void
		{
			if(uiSkin.fontsizeinput.text == "")
				return;
			var size:Number = parseInt(uiSkin.fontsizeinput.text)/100;
			
			Browser.window.Unity3dWeb.changefontSize(size.toString());
		}
		
		
		private function closeView():void
		{
			ViewManager.instance.closeView(ViewManager.VIEW_CHARACTER_DEMONSTRATE_PANEL);
		}
		
		public override function onDestroy():void
		{
			if(u3ddiv != null)
			{
				u3ddiv.style.display = "none";

				//Browser.window.Unity3dWeb.closeUnity();
				//Browser.document.body.removeChild(u3ddiv);//添加到舞台
				//Browser.document.body.removeChild(script);
				//Browser.document.body.removeChild(scriptpr);
			}
		}
	}
}