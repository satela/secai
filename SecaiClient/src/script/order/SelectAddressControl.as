package script.order
{
	import eventUtil.EventCenter;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.utils.Handler;
	
	import model.Userdata;
	import model.orderModel.PaintOrderModel;
	import model.users.AddressVo;
	
	import script.ViewManager;
	
	import ui.order.SelectAddressPanelUI;
	
	public class SelectAddressControl extends Script
	{
		private var uiSkin:SelectAddressPanelUI;
		
		private var tempaddress:AddressVo;
		public function SelectAddressControl()
		{
			super();
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as SelectAddressPanelUI;
			
			uiSkin.list_address.itemRender = SelAddressItem;
			uiSkin.list_address.vScrollBarSkin = "";
			uiSkin.list_address.selectEnable = true;
			uiSkin.list_address.spaceY = 2;
			uiSkin.list_address.renderHandler = new Handler(this, updateAddressItem);
			
			uiSkin.list_address.selectHandler = new Handler(this,onSlecteAddress);
			
			uiSkin.btncancel.on(Event.CLICK,this,onCloseView);
			uiSkin.btnok.on(Event.CLICK,this,onConfirmSelectAddress);
			uiSkin.btnadd.on(Event.CLICK,this,onShowAddAdress);
			

			uiSkin.inputsearch.on(Event.INPUT,this,onSearchAddress);
			uiSkin.list_address.array = Userdata.instance.addressList;
			
			tempaddress = PaintOrderModel.instance.selectAddress;
			
			Laya.timer.once(10,null,function()
			{
				var cells:Vector.<Box> = uiSkin.list_address.cells;
				for(var i:int=0;i < cells.length;i++)
				{
					(cells[i] as SelAddressItem).ShowSelected = (cells[i] as SelAddressItem).address == PaintOrderModel.instance.selectAddress;
				}
			});
			EventCenter.instance.on(EventCenter.UPDATE_MYADDRESS_LIST,this,updateList);

			//PaintOrderModel.instance.selectAddress = null;
		}
		
		private function updateList(data:AddressVo):void
		{
			
			uiSkin.list_address.refresh();
			Laya.timer.once(10,null,function()
			{
				var cells:Vector.<Box> = uiSkin.list_address.cells;
				for(var i:int=0;i < cells.length;i++)
				{
					(cells[i] as SelAddressItem).ShowSelected = (cells[i] as SelAddressItem).address == tempaddress;
				}
			});
			
		}
		private function onShowAddAdress():void
		{
			ViewManager.instance.openView(ViewManager.VIEW_ADD_NEW_ADDRESS);
		}
		private function onSearchAddress():void
		{
			if(uiSkin.inputsearch.text == "")
			{
				uiSkin.list_address.array = Userdata.instance.addressList;
				return;
			}
			var tempadd:Array = [];
			for(var i:int=0;i < Userdata.instance.addressList.length;i++)
			{
				if((Userdata.instance.addressList[i].addressDetail as String).indexOf(uiSkin.inputsearch.text) >= 0)
				{
					tempadd.push(Userdata.instance.addressList[i]);
				}
			}
			uiSkin.list_address.array = tempadd;
		}
		private function onSlecteAddress(index:int):void
		{
			// TODO Auto Generated method stub
			
			//(uiSkin.list_address.cells[index] as SelAddressItem).ShowSelected = true;
			tempaddress = uiSkin.list_address.array[index];;
		
			Laya.timer.frameOnce(1,this,function(){
				
				for each(var item:SelAddressItem in uiSkin.list_address.cells)
				{
					item.ShowSelected = item.address == uiSkin.list_address.array[index];
				}
			});
		}
		
		private function updateAddressItem(cell:SelAddressItem):void
		{
			cell.setData(cell.dataSource);
		}
		private function onConfirmSelectAddress(index:int):void
		{
			// TODO Auto Generated method stub
			if(tempaddress != null)
			{
				PaintOrderModel.instance.selectAddress = tempaddress;
				EventCenter.instance.event(EventCenter.SELECT_ORDER_ADDRESS,tempaddress);
			}
			onCloseView();
		}
		
		private function onCloseView():void
		{
			// TODO Auto Generated method stub
			ViewManager.instance.closeView(ViewManager.VIEW_SELECT_ADDRESS);
		}
		public override function onDestroy():void
		{
			EventCenter.instance.off(EventCenter.UPDATE_MYADDRESS_LIST,this,updateList);
			
		}
	}
}