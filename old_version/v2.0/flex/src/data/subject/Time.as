package data.subject
{
	import data.Util;
	import data.subject.Lecture;
	
	public class Time
	{
		public static const weeks:Array = [null, "월", "화", "수", "목", "금"];
		
		private var _lecture:Lecture;
		private var _room:String;	//강의실
		private var _day:int;		//요일
		private var _hour:int;		//교시
		
		public function Time($lec:Lecture, $r:String, $d:String, $h:int) {
			_lecture = $lec;
			_room = Util.gapRemover($r);
			$d = Util.gapRemover($d);
			for(var i:int = 0; i < weeks.length; i++)
				if(weeks[i] == $d)
					break;
			_day = i;
			_hour = $h;
			
			$lec.push( this );
		}
		public function get lecture():Lecture	{	return _lecture;	}
		public function get room():String		{	return _room;		}
		public function get day():int			{	return _day;		}
		public function get hour():int			{	return _hour;		}
		
		//inline operator string 기능을 함 -> 표 그릴 때 각 셀에 들어가는 내용이다.
		public function toString():String {
			var str:String =	
				"			<b>" + lecture.name + " - " + lecture.divide + "</b><br>\n" +
				"			" + lecture.professor + "<br>\n" +
				"			" + room + "\n";
			
			return str;
		}
	}
}