package data.history
{
	import data.subject.Subject;
	
	import mx.collections.ArrayCollection;

	public dynamic class History
	{
		/*
			History쪽은 날림으로 만들어서 설명하기 난해하고 지금 당장 적을 수 있는 게 없다.
			정 이 시간표에 관심이 있고, 자신이 더 공부하거나 이해하고 싶다면
			jhnam21th@naver.com으로 문의할 것
		*/		
		private var _year:int;
		private var _semester:int;
		private var _lectures:Vector.<HistoryLecture>;
		private var _secondOmittedMajors:Vector.<HistoryLecture>;
		
		public static var vector:Vector.<History> = new Vector.<History>();
		private var _applyAC:ArrayCollection = new ArrayCollection();
		
		public function History($year:int, $semester:int) {
			_lectures = new Vector.<HistoryLecture>();
			_secondOmittedMajors = new Vector.<HistoryLecture>();
			
			_year = $year;
			_semester = $semester;
		}
		public function get length():int {
			return _lectures.length;
		}
		public function push( hl:HistoryLecture ):void {
			this[hl.code] = hl;
			this[length] = hl;
			_lectures.push( hl );
		}
		public function addOmitted(omitted:HistoryLecture):void {
			_secondOmittedMajors.push( omitted );
		}
		public function get omitteds():Vector.<HistoryLecture> {
			return _secondOmittedMajors;
		}

		public function get applyAC():ArrayCollection	{	return _applyAC;	}
		public function get label():String {
			return year + "학년도 " + semester + "학기";
		}
		public function get year():int 		{	return _year;		}
		public function get semester():int	{	return _semester;	}
		public function get lectures():Vector.<HistoryLecture>	{	return _lectures;	}
	}
}