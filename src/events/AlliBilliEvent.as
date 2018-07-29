package events
{
	import flash.events.Event;
	
	
	public class AlliBilliEvent extends Event
	{
		public static var START_BUILD_UI:String = "START_BUILD_UI";
		public static var TAB_REFRESH:String = "TAB_REFRESH_CLICK";
		public static var ACC_TREE_BUILD:String = "ACC_TREE_BUILD";
		public var accTreeBuild_XML:XML;
		public function AlliBilliEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
		}
		
		
	}
}