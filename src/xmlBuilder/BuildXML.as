package xmlBuilder
{
	import allibilliHTTP.HttpUtil;
	
	import events.AlliBilliEvent;
	
	import mx.containers.VBox;
	import mx.core.UIComponent;
	import mx.rpc.events.ResultEvent;

	public class BuildXML extends UIComponent
	{
		private var accordians:XML;
		static private var leftAcc:XMLList;
		static private var rightAcc:XMLList;
		private var http:HttpUtil=new HttpUtil();
		public function BuildXML()
		{
		}

		public function loadAccordians():void
		{
			http.sendRequest("accordians.xml", acc_resultHandler);
		}

		public function loadTree(obj:Object):void
		{
			http.sendRequest(obj.URL, tree_resultHandler);
		}

		public function getLeftAccordians():XMLList
		{
			return leftAcc;
		}

		public function getRightAccordians():XMLList
		{
			return rightAcc;
		}

		private function tree_resultHandler(event:ResultEvent):void
		{
			event.stopPropagation();
			event.preventDefault();
			var xml:XML=event.result as XML;
			var evt:AlliBilliEvent=new AlliBilliEvent(AlliBilliEvent.ACC_TREE_BUILD, true, true);
			evt.accTreeBuild_XML= xml;
			dispatchEvent(evt);
		}
		
		private function acc_resultHandler(event:ResultEvent):void
		{
			event.stopPropagation();
			event.preventDefault();

			var httpOperation:Object=event.target;
			if (httpOperation != null){
				httpOperation.removeEventListener(ResultEvent.RESULT, acc_resultHandler);
			}
			if (event != null)
			{
				var xml:XML=event.result as XML;

				leftAcc=xml..left as XMLList;
				rightAcc=xml..right as XMLList;

				var evt:AlliBilliEvent=new AlliBilliEvent(AlliBilliEvent.START_BUILD_UI, true, true);
				dispatchEvent(evt);
			}
		}
	}
}
