package Classes.request
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.*;

	public class request extends Sprite
	{
		public var replyData:String;
		
		public function request($url:String, $formData:Object, $method:String = 'POST') {
			var replyData:String;
			
			var sendURL:URLRequest = new URLRequest($url);
			
			sendURL.data = $formData;
			sendURL.method = URLRequestMethod[$method];
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, handleReply);
			urlLoader.load(sendURL);
		}
		public function handleReply(e:Event):void {
			replyData = e.target.data;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}