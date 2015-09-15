package data.subject
{
	import data.Util;
	import data.base.Major;
	import data.base.Profile;
	import data.subject.Time;
	
	import flash.utils.Dictionary;

	public dynamic class Subject {
		/*
			Dynamic class로 선언하면 현재 이 Subject에
			map<string, void*, less<string> > 의 변수를 하나 가지게 되며
			
			inline map<string, void*, less<string> > operator[](string& name) 의 함수도 추가되는 격이다
		*/
		/*
			과목 코드 단위,
				제일 최상단의 부모 테이블이나 사용자가 보게 되는 일은 없다.
				이 것의 자식 격인 lecture가 사용자가 보게 되는 것
		
		======================================
		모두 1:N 관계이며
		
			Subject 과목 정보
				Lecture 분반, 강의 정보
					Time 강의 시간 정보
		======================================
		*/
		private var _code:String; // PK
		private var _name:String;
		
		private var _kind:String;
		private var _grade:int;
		private var _credit:int;
		
		private var _lectures:Vector.<Lecture>; // Child
		
		public function Subject($code:String, $name:String, $kind:String, $grade:int, $credit:int) {
			_code = Util.gapRemover($code);
			_name = Util.gapRemover($name);
			_kind = Util.gapRemover($kind);
			_grade = $grade;
			_credit = $credit;
			
			kindFilter();
			_lectures = new Vector.<Lecture>();
		}
		private function kindFilter():void { //다전공 과목을 다전공에 맞게, 타 전공을 일선으로 변경
			if(kind.charAt(0) != "전")
				return;
			
			var majorCode:String = code.substr(0, 3);
			if( (Major.list[Profile.major] as Major).code == majorCode )
				return;
			
			if( Profile.secondMajor != -1 && (Major.list[Profile.secondMajor] as Major).code == majorCode )
				_kind = "다" + _kind;
			else
				_kind = "일선";
		}
		
		public function get code():String				{	return _code;		}
		public function get name():String				{	return _name;		}
		public function get kind():String				{	return _kind;		}
		public function get grade():int					{	return _grade;		}
		public function get credit():int				{	return _credit;		}
		public function get lectures():Vector.<Lecture>	{	return _lectures;	}
		
		/*
		=========================================
			Dictionary에 관한 함수
		=========================================
		*/
		public function get length():int {
			return _lectures.length;
		}
		public function push(lec:Lecture):void {
			//자식(Lecture)과(와)의 1:N 연결 관계를 이어주는 역할을 한다. 
			//자식의 포인터를 받아와서 배열에 넣어줌
			
			this[lec.divide] = lec; //KEY
			this[length] = lec;		//번호를 KEY로 넣어 배열처럼 쓸 수도 있게 해 준다.
			_lectures.push( lec );
		}
		
		/*
		=============================================
			강의 목록 파싱에 관한 함수
		
				이 부분은 따로 설명하기가 어렵다.
				강의목록 HTML 소스를 열심히 해석하는 수 밖에
		=============================================
		*/
		
		public static function parse(replyData:String, subjects:SubjectVector, subSet:SubjectVector = null):void {
			var replyData:String = Util.emptyRemover(replyData);
			//trace(replyData);
			var codes:Array;
			var divides:Array;
			var times:Array;
			var components:Array;
			
			var code:String;
			var name:String;
			var kind:String;
			var grade:int;
			var credit:int;
			
			var divide:String;
			var professor:String;
			var link:String;
			var mid:String;
			
			var room:String;
			var day:String;
			var hour:int;
			
			var tempArray:Array;
			var tempString:String;
			
			var i:int;
			var j:int;
			var k:int;
			
			var subject:Subject;
			var lecture:Lecture;
			var time:Time;
			
			replyData = Util.between(replyData, "<table width=\"670\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">", "</table>");
			
			//Subject 구성
			codes = Util.betweens(replyData, /<tr><td bgcolor=#...... align=center> .......<\/td>/, null);
			for(i = 0; i < codes.length; i++) {
				tempArray = Util.betweens(codes[i], "align=center>", "</td>");
				
				code = Util.between(codes[i], "Javascript:letturerplanview('", "');\" title='강의계획서조회'>").substr(-8, 7);
				name = Util.between(codes[i], " align=left>", "</td>");
				
				kind = tempArray[0];
				tempString = tempArray[4]; grade = (tempString == "전학년") ? 0 : int(tempString); //전학년이면 0으로 한다. 
				credit = int(tempArray[1]);
				
				divides = Util.betweens(codes[i], "Javascript:letturerplanview('", null);
				
				//Subject 중복 확인 후, 없을 시에 새로이 구성
				if(subjects.hasOwnProperty(code) == true)
					subject = subjects[code];
				else {
					subject = new Subject(code, name, kind, grade, credit);
					if(subSet != null)
						subSet.push( subject );
					subjects.push( subject );
				}

				//Lecture 구성
				for(j = 0; j < divides.length; j++) {
					tempArray = Util.betweens(divides[j], " align=center>", "</td>");
					
					divide = Util.between(divides[j], "title='강의계획서조회'>", "</a>");
					link   = Util.between(divides[j], null, "');\" title='강의계획서조회'>");
					mid = tempArray[0];
					professor = tempArray[2];
					
					lecture = new Lecture(subject, divide, link, professor, mid);
					//trace("\t" + lecture.divide, lecture.link, lecture.professor, lecture.mid);
					
					times = divides[j].split("</tr>");
					times.splice(times.length - 1, 1);
					
					//Time 구성
					for(k = 0; k < times.length; k++) {
						tempArray = Util.betweens(times[k], " align=center>", "</td>");
						if(k == 0) {
							day  = tempArray[3];
							hour = int( tempArray[4] );
						}else{
							day  = tempArray[9];
							hour = int( tempArray[10]);
						}
						room = Util.between(times[k], " align=left>", "</td>");
						room = room.replace("(야)", "");
						room = room.replace("지하", "B");
						
						if(lecture.mid == "야" && hour <= 5)
							hour += 10;
						time = new Time(lecture, room, day, hour);
						//trace("\t\t" + time.room, time.day, time.hour);
					}
				}
			}
		}
	}
}