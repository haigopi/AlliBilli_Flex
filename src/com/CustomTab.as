package com
{

	import events.AlliBilliEvent;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	import mx.controls.Button;
	import mx.controls.tabBarClasses.*;
	import mx.core.DragSource;
	import mx.core.IFlexDisplayObject;
	import mx.core.mx_internal;
	import mx.events.DragEvent;
	import mx.events.ItemClickEvent;
	import mx.managers.DragManager;


	use namespace mx_internal;

	[Style(name="showCloseButton", type="Boolean")]
	public class CustomTab extends Tab
	{
		private var closeButton:Button;
		private var refreshButton:Button;
		private var dropIndicatorClass:Class=extended_TabDropIndicator;
		private var tabDropIndicator:IFlexDisplayObject;

		public function CustomTab()
		{
			super();
			mouseChildren=true;
			setStyle("paddingRight", 30);
			setStyle("textAlign", "left");
			setStyle("labelPlacement", "right");
			setStyle("verticalScrollPolicy", "off");
			setStyle("horizontalScrollPolicy", "off");
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			addEventListener(DragEvent.DRAG_ENTER, handleDragEnter);
			addEventListener(DragEvent.DRAG_DROP, handleDragDrop);
			addEventListener(DragEvent.DRAG_EXIT, handleDragExit);
			addEventListener(DragEvent.DRAG_OVER, handleDragOver);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			if (this.getStyle("showCloseButton") == true)
			{
				closeButton=new Button();
				refreshButton=new Button();
				
				closeButton.width=12;
				closeButton.height=12;
				closeButton.name="CloseButton"
				closeButton.toolTip="Close Tab";
				closeButton.styleName="CloseButton";
				closeButton.mouseEnabled=true;

				refreshButton.width=12;
				refreshButton.height=12;
				refreshButton.name="refreshButton";
				refreshButton.toolTip="Refresh Tab";
				refreshButton.styleName="RefreshButton";
				refreshButton.mouseEnabled=true;

				addChild(closeButton);
				addChild(refreshButton);
				closeButton.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				refreshButton.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			}
			tabDropIndicator=IFlexDisplayObject(new dropIndicatorClass());
			addChildAt(DisplayObject(tabDropIndicator), numChildren - 1)
			tabDropIndicator.visible=false;

		}

		private function handleDragEnter(event:DragEvent):void
		{
			if (event.dragSource.hasFormat('tabButton'))
			{
				var dropTarget:CustomTab=CustomTab(event.currentTarget);
				DragManager.acceptDragDrop(dropTarget);
				setChildIndex(DisplayObject(tabDropIndicator), numChildren - 1)
				tabDropIndicator.visible=true;
			}
		}

		private function handleDragOver(event:DragEvent):void
		{
			if (event.dragSource.hasFormat('tabButton'))
			{

			}
		}

		private function handleDragExit(event:DragEvent):void
		{
			tabDropIndicator.visible=false;
		}

		private function handleMouseMove(event:MouseEvent):void
		{
			if (event.buttonDown)
			{
				startTabDrag(event, "tabButton");
			}
		}

		private function handleDragDrop(event:DragEvent):void
		{

			var DragDropEvent:DragEvent=new DragEvent("TAB_DRAG_DROP", true, true, event.dragInitiator, event.dragSource, event.action, event.ctrlKey, event.altKey, event.shiftKey);
			dispatchEvent(DragDropEvent);
			tabDropIndicator.visible=false;

		}

		private function startTabDrag(event:MouseEvent, format:String):void
		{
			var dragInitiator:Button=Button(event.currentTarget);

			var ds:DragSource=new DragSource();
			ds.addData(this, format);

			var dragProxy:CustomTab=new CustomTab();
			dragProxy.label=label;
			dragProxy.setStyle("icon", getStyle("icon"));
			dragProxy.width=width;
			dragProxy.height=height;

			DragManager.doDrag(dragInitiator, ds, event, dragProxy);
		}

		private function handleMouseDown(event:MouseEvent):void
		{
			event.stopPropagation();
			event.preventDefault();
			if (event.target is Button && event.target.name == "CloseButton")
			{
				var closeEvent:ItemClickEvent=new ItemClickEvent("TAB_CLOSE_CLICK", true, true);
				closeEvent.index=parent.getChildIndex(this)
				closeButton.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				dispatchEvent(closeEvent);
			}
			if (event.target is Button && event.target.name == "refreshButton")
			{
				var refreshEvent:ItemClickEvent=new ItemClickEvent(AlliBilliEvent.TAB_REFRESH, true, true);
				refreshEvent.index=parent.getChildIndex(this)
				refreshButton.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				dispatchEvent(refreshEvent);
			}
		}

		override mx_internal function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight, offset);

			setChildIndex(getChildByName("CloseButton"), numChildren - 1);
			setChildIndex(getChildByName("refreshButton"), numChildren - 1);
			closeButton.move(width - 15, textField.y + 2);
			refreshButton.move(width - 30, textField.y + 2);
			explicitWidth=120;
		}
	}
}