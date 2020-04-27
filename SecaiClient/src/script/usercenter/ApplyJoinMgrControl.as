package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	
	import script.ViewManager;
	import script.usercenter.item.ApplyJoinItem;
	
	import ui.usercenter.ApplyJoinMgrPanelUI;
	
	public class ApplyJoinMgrControl extends Script
	{
		private var uiSkin:ApplyJoinMgrPanelUI;
		private var curRequest:Object;
		
		private var allOrganize:Array;
		public function ApplyJoinMgrControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ApplyJoinMgrPanelUI;
			uiSkin.applylist.itemRender = ApplyJoinItem;
			
			//uiSkin.applylist.vScrollBarSkin = "";
			uiSkin.applylist.repeatX = 1;
			uiSkin.applylist.spaceY = 5;
			
			uiSkin.applylist.renderHandler = new Handler(this, updateApplyList);
			uiSkin.applylist.selectEnable = false;
			
			uiSkin.distributePanel.visible = false;
			
			
			uiSkin.applylist.array = [];
			
			uiSkin.applylist.on(Event.MOUSE_OVER,this,pauseParentScroll);
			uiSkin.applylist.on(Event.MOUSE_OUT,this,resumeParentScroll);
			uiSkin.closedistribute.on(Event.CLICK,this,onCloseDistributePanel);
			uiSkin.confirmJoin.on(Event.CLICK,this,onAgreeJoin);

			EventCenter.instance.on(EventCenter.AGREE_JOIN_REQUEST,this,showDistribute);
			EventCenter.instance.on(EventCenter.REFRESH_JOIN_REQUEST,this,refreshRequest);

			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getJoinOrganizeRequest,this,onGetJoinRequestBack,null,"post");

		}
		
		private function refreshRequest():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getJoinOrganizeRequest,this,onGetJoinRequestBack,null,"post");
		}
		private function onGetJoinRequestBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				uiSkin.applylist.array = result.reqs;
			}
		}
		
		private function showDistribute(data:Object):void
		{
			curRequest = data;
			uiSkin.distributePanel.visible = true;
			if(allOrganize == null)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getMyOrganize,this,onGetAllOrganizeBack,null,"post");
			}
		}
		
		private function onGetAllOrganizeBack(data:*):void{
			
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				allOrganize = result.depts;
				var arr:Array = [];
				for(var i:int=0;i < result.depts.length;i++)
				{
					arr.push(result.depts[i].dt_name);
				}
				//trace("arr:" + arr.length);
				uiSkin.deptbox.labels = arr.join(",");
			}
		}
		
		private function onAgreeJoin():void
		{
			if(curRequest == null)
				return;
			if(uiSkin.deptbox.selectedIndex < 0)
			{
				ViewManager.showAlert("请选择要分配到的组织");
				return;
			}
			var param:String = "id=" + curRequest.jp_id + "&opt=1&dept=" + allOrganize[uiSkin.deptbox.selectedIndex].dt_id;
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.handleJoinOrganizeRequest,this,onhandleBack,param,"post");

		}
		
		private function onhandleBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getJoinOrganizeRequest,this,onGetJoinRequestBack,null,"post");
				uiSkin.distributePanel.visible = false;
				ViewManager.showAlert("操作成功");
			}
		}
		private function onCloseDistributePanel():void
		{
			uiSkin.distributePanel.visible = false;
		}
		private function pauseParentScroll():void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,false);
		}
		private function resumeParentScroll():void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);
		}
		
		private function updateApplyList(cell:ApplyJoinItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.AGREE_JOIN_REQUEST,this,showDistribute);			
			EventCenter.instance.off(EventCenter.REFRESH_JOIN_REQUEST,this,refreshRequest);

		}
		
	}
}