package com
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.http.mxml.HTTPService;
	public class MyCustomEvent extends Event
	{
		public static const ReloadEvent:String ="MyDataGridReloadEvent";
		public static const MyFormSubmitEvent:String ="MyFormSubmitEvent";
		public static const MyFormSearchEvent:String ="MyFormSearchEvent";
		
		public function MyCustomEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
		   super(type, bubbles, cancelable);
		}
		
		private var dataCollection:ArrayCollection;
		public function getDataCollection():ArrayCollection
		{
			return dataCollection;
		}
		public function setDataCollection(dataCollection:ArrayCollection):void
		{
			this.dataCollection = dataCollection;
		}
		
		
	}
}

