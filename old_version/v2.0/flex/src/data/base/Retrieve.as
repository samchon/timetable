package data.base
{
	import mx.collections.ArrayCollection;

	public class Retrieve
	{
		public static const NAME:int = 0;
		public static const CODE:int = 1;
		public static const PROFESSOR:int = 2;
		public static const KIND:int = 3;
		
		public var _label:String;
		
		public function Retrieve($label:String) {
			_label = $label;
		}
		public function get label():String	{	return _label;	}
		
		[Bindable]public static var list:ArrayCollection = 
			new ArrayCollection
			([
				new Retrieve("과목명"),
				new Retrieve("코드명"),
				new Retrieve("교수명"),
				new Retrieve("분류명")
			]);
	}
}