package com
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.http.mxml.HTTPService;
	public class MyRoomMateEvent extends Event
	{
		public static const PlaceMyAddEvent:String ="PlaceMyAdEvent";
		private var dataCollection:ArrayCollection;
		
		
		public function MyRoomMateEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
		   super(type, bubbles, cancelable);
		}
		
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

