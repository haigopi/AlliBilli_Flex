package com
{
	import flash.events.MouseEvent;
	import mx.controls.PopUpMenuButton;
	import mx.core.mx_internal;
	import mx.controls.Menu;
	import mx.core.ClassFactory;
	import mx.events.MenuEvent;
	import flash.events.Event;

	[Event(name="menuItemClick", type="mx.events.MenuEvent")]
	public class extendedPopUpMenuButton extends PopUpMenuButton
	{

		public function extendedPopUpMenuButton():void
		{
			super();
			openAlways=true;

			addEventListener("open", handleOpenClose);
			addEventListener("close", handleOpenClose);

		}

		public var isOpen:Boolean;

		private function handleOpenClose(event:Event):void
		{

			switch (event.type)
			{
				case "open":
					isOpen=true;
					break;
				case "close":
					isOpen=false;
					this.styleChanged("upSkin");
					break;
			}

		}

		override public function close():void
		{
			super.close();

		}

		override public function open():void
		{
			super.open();

		}

		override protected function clickHandler(event:MouseEvent):void
		{
			super.clickHandler(event);
		}


		override public function set dataProvider(value:Object):void
		{

			super.dataProvider=value;

		}

		private function handelItemClick(event:MenuEvent):void
		{
			var menuEvent:MenuEvent=new MenuEvent("menuItemClick");
			menuEvent.menu=Menu(popUp);
			menuEvent.menu.selectedIndex=Menu(popUp).selectedIndex;
			menuEvent.item=Menu(popUp).selectedItem
			menuEvent.itemRenderer=Menu(popUp).itemToItemRenderer(Menu(popUp).selectedItem);
			menuEvent.index=Menu(popUp).selectedIndex;
			dispatchEvent(menuEvent);

		}

		//override to block the default				
		override public function setStyle(styleProp:String, newValue:*):void
		{
		}


	}
}