package data.base {
	import mx.collections.ArrayCollection;

	public class SecondMajor {
		public static const DEEP:int = 0;
		public static const MULTI:int = 1;
		public static const MINOR:int = 2;
		
		private var _label:String;
		
		public function SecondMajor($label:String) {
			_label = $label;
		}
		public function get label():String	{	return _label;	}
		
		[Bindable]public static var list:ArrayCollection =
			new ArrayCollection
			([
				new SecondMajor("심화전공"),
				new SecondMajor("복수전공"),
				new SecondMajor("부전공")
			]);
	}
}