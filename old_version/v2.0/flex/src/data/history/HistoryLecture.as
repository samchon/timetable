package data.history
{
	import data.Util;
	import data.subject.Lecture;
	
	import flash.events.Event;

	public class HistoryLecture
	{
		private var _history:History;
		private var _lecture:Lecture;
		private var _code:String;	//과목 코드
		private var _kind:String;	//종류 - 일반교양, 전공필수 등
		private var _credit:int;	//학점(시수) - 2학점짜리, 3학점짜리
		private var _divide:String;	//과목 분반
		
		public function HistoryLecture($history:History, $kind:String, $credit:int, $code:String, $divide:String = "-1") {
			if($kind.charAt(0) == "복" || $kind.charAt(0) == "부" || $kind.charAt(0) == "연")
				$kind = "다" + $kind.substr(1);
			
			_history = $history;
			_kind = $kind;
			_credit = $credit;
			_code = $code;
			_divide = $divide;
			
			$history.push( this );
		}
		public function get history():History	{	return _history;			}
		public function get year():int			{	return history.year;		}
		public function get semester():int		{	return history.semester;	}
		public function get kind():String		{	return _kind;				}
		public function get credit():int		{	return _credit;				}
			
		public function get code():String		{	return _code;				}
		public function get divide():String		{	return _divide;				}
		
		public function set divide(d:String):void 		{	_divide = d;	}
		public function set lecture(lec:Lecture):void {
			history.applyAC.addItem( lec );
			_lecture = lec;
		}
		public function set kind($kind:String):void	{
			$kind = data.Util.gapRemover($kind);
			$kind = "다" + $kind;
			
			_kind = $kind;
		}
	}
}