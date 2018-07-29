package allibilliHTTP
{
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class HttpUtil
	{
		public var http:HTTPService=new HTTPService();
		//private static var serverURL:String="http://localhost:8080/AlliBilli/";
		private static var serverURL:String="http://services.allibilli.com/xml/";
		public function HttpUtil()
		{
		}

		public function sendRequest(URL:String, handler:Function):void
		{
			http.url=serverURL + URL;
			http.resultFormat="e4x";
			http.method="POST";
			trace(http.url);
			http.addEventListener(ResultEvent.RESULT, handler);
			http.send();
		}
	}
}