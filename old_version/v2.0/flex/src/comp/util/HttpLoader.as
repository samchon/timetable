package comp.util {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class HttpLoader extends URLLoader {
		public var param:*;
		public function HttpLoader(request:URLRequest=null) {
			super(request);
		}
	}
}