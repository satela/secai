package script.usercenter
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.utils.Handler;
	
	import model.HttpRequestUtil;
	
	import script.ViewManager;
	import script.usercenter.item.MemberItem;
	import script.usercenter.item.OrganizeItem;
	
	import ui.usercenter.OrganizeMgrPanelUI;
	
	public class OrganizeMrgControl extends Script
	{
		private var uiSkin:OrganizeMgrPanelUI;
		
		private var curMemberdata:Object;
		public function OrganizeMrgControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as OrganizeMgrPanelUI;
			
			uiSkin.organizelist.itemRender = OrganizeItem;
			
			uiSkin.organizelist.vScrollBarSkin = "";
			uiSkin.organizelist.repeatX = 7;
			uiSkin.organizelist.spaceY = 5;
			uiSkin.organizelist.spaceX = 15;

			uiSkin.organizelist.renderHandler = new Handler(this, updateOrganizeList);
			uiSkin.organizelist.selectEnable = true;
			uiSkin.organizelist.selectHandler = new Handler(this,selectOrganize);
			
			uiSkin.memberlist.itemRender = MemberItem;
			
			uiSkin.memberlist.vScrollBarSkin = "";
			uiSkin.memberlist.repeatX = 1;
			uiSkin.memberlist.spaceY = 5;

			uiSkin.memberlist.renderHandler = new Handler(this, updateMemberList);
			uiSkin.memberlist.selectEnable = false;
			
			uiSkin.distributePanel.visible = false;
			
			var temparr:Array = [];
			
			uiSkin.memberlist.array = temparr;
			
			uiSkin.organizelist.array = temparr;
			uiSkin.createOrganizePanel.visible = false;
			
			uiSkin.setAuthorityPanel.visible = false;
			uiSkin.closeauthoritybtn.on(Event.CLICK,this,onCloseAuthorityPanel);
			uiSkin.confirmauthoritybtn.on(Event.CLICK,this,updateMemberAuthority);

			uiSkin.createOrganize.on(Event.CLICK,this,showCretePanel);
			
			uiSkin.organizeNameInput.maxChars = 20;
			uiSkin.createBtnOk.on(Event.CLICK,this,onConfirmCreateOrganize);
			uiSkin.memberlist.on(Event.MOUSE_OVER,this,pauseParentScroll);
			uiSkin.memberlist.on(Event.MOUSE_OUT,this,resumeParentScroll);
			
			uiSkin.moveOkbtn.on(Event.CLICK,this,onMoveMemberSure);
			uiSkin.closeDist.on(Event.CLICK,this,onCloseDistribute);
			uiSkin.btncloseCreate.on(Event.CLICK,this,onCloseCreate);

			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getMyOrganize,this,onGetAllOrganizeBack,null,"post");
			
			EventCenter.instance.on(EventCenter.DELETE_ORGANIZE_BACK,this,refreshOrganize);
			EventCenter.instance.on(EventCenter.MOVE_MEMBER_DEPT,this,moveMember);
			EventCenter.instance.on(EventCenter.DELETE_DEPT_MEMBER,this,refreshOrganizeMemebers);
			
			EventCenter.instance.on(EventCenter.SET_MEMEBER_AUTHORITY,this,setMemberAuthority);

			

		}
		
		private function onGetAllOrganizeBack(data:*):void{
			
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				uiSkin.organizelist.array = result.depts;
				if(result.depts.length > 0)
				{
					uiSkin.organizelist.selectedIndex = 0;
					(uiSkin.organizelist.cells[0] as OrganizeItem).selected = true;
				}
			}
			
		}
		private function refreshOrganize():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getMyOrganize,this,onGetAllOrganizeBack,null,"post");

		}
		
		private function showCretePanel():void
		{
			uiSkin.createOrganizePanel.visible = true;
		}
		
		private function onConfirmCreateOrganize():void
		{
			if(uiSkin.organizeNameInput.text == "")
			{
				ViewManager.showAlert("请输入组织名称");
				return;
			}
			
			var param:String = "name=" + uiSkin.organizeNameInput.text;
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.createOrganize,this,onCreateBack,param,"post");

			uiSkin.createOrganizePanel.visible = false;
		}
		
		private function onCreateBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getMyOrganize,this,onGetAllOrganizeBack,null,"post");
			}
		}
		private function pauseParentScroll():void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,false);
		}
		private function resumeParentScroll():void
		{
			EventCenter.instance.event(EventCenter.PAUSE_SCROLL_VIEW,true);
		}
		
		private function updateMemberList(cell:MemberItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		private function updateOrganizeList(cell:OrganizeItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
		
		private function selectOrganize(index:int):void
		{
			for each(var item:OrganizeItem in uiSkin.organizelist.cells)
			{
				item.setselected(uiSkin.organizelist.array[index].dt_id);
			}
			//(uiSkin.organizelist.cells[index] as OrganizeItem).selected = true;
			
			var params:String = "dept=" + uiSkin.organizelist.array[index].dt_id;
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOrganizeMembers,this,onGetOrganizeMembersBack,params,"post");

			
						
		}
		
		private function onGetOrganizeMembersBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				uiSkin.memberlist.array = result.members;
			}
		}
		
		private function moveMember(data:Object):void
		{
			curMemberdata = data;
			uiSkin.distributePanel.visible = true;
			
			var allOrganize:Array = uiSkin.organizelist.array;
			var arr:Array = [];
			for(var i:int=0;i < allOrganize.length;i++)
			{
				arr.push(allOrganize[i].dt_name);
			}
			
			uiSkin.organizeCom.labels = arr.join(",");
			uiSkin.organizeCom.selectedIndex = 0;
			//trace("arr:" + arr.length);
			
		}
		
		private function setMemberAuthority(data:Object):void
		{
			curMemberdata = data;
			
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOrganizeMemberAuthority,this,onGetOrganizeMemberAuthBack,null,"post");

			
		}
		
		private function onGetOrganizeMemberAuthBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				if(curMemberdata)
				{
					if(result.users[curMemberdata.uid] != null)
					{
						curMemberdata.privileges = result.users[curMemberdata.uid].data;
						
						uiSkin.accoutname.text = "设置账号：" + curMemberdata.phonenumber + " 的权限";
						uiSkin.setAuthorityPanel.visible = true;
						for(var i:int=1;i < 6;i++)
						{
							
							uiSkin["authorityRdo" + i].selectedIndex =  parseInt(curMemberdata.privileges[i]);
						}
					
					}
				
				}
				
			}
		}
		
		
		private function onCloseAuthorityPanel():void
		{
			uiSkin.setAuthorityPanel.visible = false;

		}
		
		private function updateMemberAuthority():void
		{
			var postdata:Object = {};
			postdata.uid = curMemberdata.uid;
			
			postdata.privilege = {};
			for(var i:int=1;i < 6;i++)
			{
				//var pri:Object = {};
				postdata.privilege[i] = uiSkin["authorityRdo" + i].selectedIndex.toString();
				//pri.value = uiSkin["authorityRdo" + i].selectedIndex;
				//postdata.privilege.push(pri);
			}
			uiSkin.setAuthorityPanel.visible = false;

			//var params:String = "dept=" + todept + "&uid=" + curMemberdata.uid;
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.setOrganizeMemberAuthority,this,onUpdateOrganizeMemberAuthBack,"data=" + JSON.stringify(postdata),"post");
		}
		
		private function onUpdateOrganizeMemberAuthBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				ViewManager.showAlert("设置成功");
			}
			else
			{
				ViewManager.showAlert("设置失败");

			}
		}
		private function onCloseDistribute():void
		{
			uiSkin.distributePanel.visible = false;
		}
		private function onMoveMemberSure():void
		{
			if(curMemberdata == null)
				return;
			if(uiSkin.organizeCom.selectedIndex < 0)
			{
				ViewManager.showAlert("请选择要移动到的组织");
				return;
			}
			
			var todept:int = uiSkin.organizelist.array[uiSkin.organizeCom.selectedIndex].dt_id;
			if(curMemberdata.dept == todept)
			{
				ViewManager.showAlert("该用户已经在这个组织里");
				return;
			}
			
			var params:String = "dept=" + todept + "&uid=" + curMemberdata.uid;
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.moveOrganizeMembers,this,onMoveOrganizeMemberBack,params,"post");
		}
		
		private function onCloseCreate():void
		{
			this.uiSkin.createOrganizePanel.visible = false;
		}
		private function onMoveOrganizeMemberBack(data:*):void
		{
			var result:Object = JSON.parse(data as String);
			if(result.status == 0)
			{
				var params:String = "dept=" + uiSkin.organizelist.array[uiSkin.organizelist.selectedIndex].dt_id;
				HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOrganizeMembers,this,onGetOrganizeMembersBack,params,"post");
			}
			uiSkin.distributePanel.visible = false;

		}
		
		private function refreshOrganizeMemebers():void
		{
			var params:String = "dept=" + uiSkin.organizelist.array[uiSkin.organizelist.selectedIndex].dt_id;
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getOrganizeMembers,this,onGetOrganizeMembersBack,params,"post");
		}
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.DELETE_ORGANIZE_BACK,this,refreshOrganize);
			EventCenter.instance.off(EventCenter.MOVE_MEMBER_DEPT,this,moveMember);
			EventCenter.instance.off(EventCenter.DELETE_DEPT_MEMBER,this,refreshOrganizeMemebers);
			EventCenter.instance.off(EventCenter.SET_MEMEBER_AUTHORITY,this,setMemberAuthority);

		}
	}
}