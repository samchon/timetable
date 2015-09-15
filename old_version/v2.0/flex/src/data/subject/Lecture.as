package data.subject {
	import data.Util;
	import data.subject.Time;
	
	public dynamic class Lecture {
		public static const DAY:int = 0;	//주간
		public static const NIGHT:int = 1;	//야간
		/*
			분반 단위, 즉 실질적인 각 수업 단위임
		
			이 클래스는 강의 목록으로서 사용자에게 보여지는 부분이기도 하다
			View 역할도 겸한다는 뜻
		*/
		
		private var _subject:Subject; 		//Parent
		private var _mid:int;				//주야 구분
		private var _divide:String;			//분반
		private var _link:String;			//강의계획서 링크 주소
		private var _professor:String;		//담당 교수
		private var _times:Vector.<Time>;	//강의 시각 및 장소
		
		public function Lecture($subject:Subject, $divide:String, $link:String, $professor:String, $mid:String) {
			_subject = $subject; //부모쪽의 포인터
			_divide = Util.gapRemover($divide);
			_link = Util.gapRemover($link);
			_professor = Util.gapRemover($professor);
			_mid = (Util.gapRemover($mid) == "주") ? 0 : 1;
			
			$subject.push( this ); //부모에게 자식의 포인터를 넘겨줌
			_times = new Vector.<Time>();
		}

		/*
		=========================================
			Array처럼 쓰기 위한 함수
		=========================================
		*/
		public function push(time:Time):void {
			this[length] = time;
			_times.push( time );
		}
		public function get length():int {
			return _times.length;
		}
		
		public function get subject():Subject		{	return _subject;		} //부모
		public function get times():Vector.<Time>	{	return _times;			} //자식
		public function get code():String			{	return subject.code;	}
		public function get name():String 			{	return subject.name;	}
		public function get kind():String			{	return subject.kind;	}
		public function get grade():int				{	return subject.grade;	}
		public function get credit():int			{	return subject.credit;	}
		public function get divide():String 		{	return _divide;			}
		public function get link():String			{	return _link;			}
		public function get professor():String		{	return _professor;		}

		public function get mid():String {	
			if(_mid == DAY) 
				return "주" 
			else 
				return "야"	
		}
		public function get day():String {
			var value:String = "";
			
			for(var i:int = 0; i < _times.length; i++)
				value += Time.weeks[_times[i].day] + "\n";
			
			for(i = _times.length; i < 4; i++)
				value += "\n";
			
			return value;
		}
		public function get hour():String {
			var value:String = "";
			
			for(var i:int = 0; i < _times.length; i++)
				value += _times[i].hour + "\n";
			
			for(i = _times.length; i < 4; i++)
				value += "\n";
			
			return value;
		}
		public function get room():String {
			var value:String = "";
			
			for(var i:int = 0; i < _times.length; i++)
				value += _times[i].room + "\n";
			
			for(i = _times.length; i < 4; i++)
				value += "\n";
			
			return value;
		}
	}
}