package data.base {
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	public class Major {
		public static var map:Dictionary = new Dictionary();
		
		private var _label:String;
		private var _code:String;
		private var _url:String;
		
		public function Major($label:String, $code:String, $url:String) {
			_label = $label;
			_code = $code.toUpperCase();
			_url = $url.toUpperCase();
			
			map[$code] = this;
			if($code == "GEN") {
				map["REQ"] = this;
				map["CAE"] = this; 
				map["CBE"] = this;
				map["CAA"] = this;
				map["CBA"] = this;
				map["CAH"] = this;
				map["CBH"] = this;
				map["CAS"] = this;
				map["CBS"] = this;
			}
		}
		public function get label():String	{	return _label;	}
		public function get code():String	{	return _code;	}
		public function get url():String	{	return _url;	}	//강의목록을 얻어올 때, parameter에 쓰이는 정보
		
		[Bindable]public static var list:ArrayCollection = 
			new ArrayCollection
			([
				new Major("한국어문학부", "KOR", "A030"),
				new Major("영어영문학부", "ENG", "A040"),
				new Major("역사문화학부", "HIS", "A050"),
				new Major("지식정보학부", "LIS", "A060"),
				new Major("경영학부", "MGT", "D040"),
				new Major("무역학과", "TRA", "D121"),
				new Major("경제학과", "ECM", "D132"),
				new Major("행정학과", "PUB", "D142"),
				new Major("부동산학과", "EST", "D172"),
				new Major("부동산경영학과", "REM", "D181"),
				new Major("의생활학부", "DFB", "G010"),
				new Major("의류패션산업전공", "AFB", "G012"),
				new Major("패션디자인전공", "FAS", "G013"),
				new Major("인테리어디자인전공", "INT", "G033"),
				new Major("시각·영상디자인전공", "VIS", "G036"),
				new Major("인터랙티브엔터테인먼트", "ITA", "G038"),
				new Major("애니메이션·제품디자인전공", "ANP", "G039"),
				new Major("무용학과", "DAN", "G111"),
				new Major("회화과", "PAI", "G161"),
				new Major("멀티미디어공학과", "MME", "K101"),
				new Major("컴퓨터공학과", "COM", "K111"),
				new Major("정보통신공학과", "ICE", "K121"),
				new Major("정보시스템공학과", "ISE", "K131"),
				new Major("기계시스템공학과", "MEC", "K151"),
				new Major("산업경영공학과", "IND", "K161"),
				new Major("지식서비스·컨설팅연계전공", "KSC", "K511"),
				new Major("교직", "EDU", "N110"),
				new Major("교양", "GEN", "L110")
			]);
	}
}