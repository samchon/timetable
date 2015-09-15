import comp.util.HttpLoader;

import data.URL;
import data.Util;
import data.base.Major;
import data.base.Profile;
import data.history.History;
import data.history.HistoryLecture;

import flash.events.Event;
import flash.net.*;
import flash.utils.ByteArray;

private var omittedCompleted:int = 0;
public var omittedLength:int = 0;

private function getHistory():void {
	var historyLoader:URLLoader = new URLLoader();
	historyLoader.dataFormat = URLLoaderDataFormat.BINARY;
	historyLoader.addEventListener(Event.COMPLETE, handleHistory);
	historyLoader.load( new URLRequest(URL.history) );
}
private function handleHistory(event:Event):void {
	var history:History;
	var historyLecture:HistoryLecture;
	
	(event.target as URLLoader).removeEventListener(Event.COMPLETE, handleHistory);
	var replyData:String = Util.emptyRemover( Util.encode(event.target.data as ByteArray) );
	
	//유독 이 부분은 td align="left" 와 그 다음 width="300" 사이에 공백이 두 칸 있다.
	/*
		histories는 각 학기별로의 나눔임
			1학년 1학기, 1학년 2학기, 2학년 1학기... 이런 식
	*/
	//<td align="left"  width="300"><font size="3" face="굴림">2011 학년도 1 학기</td>
	var semesters:Array = replyData.split("<td align=\"left\"  width=\"300\"><font size=\"3\" face=\"굴림\">"); //각 학기별
	var lectures:Array; //각 과목별
	var components:Array; //각 과목 속의 항목: REQ0001, A+ 등
	semesters.splice(0, 1);
	
	var title:String;
	var year:int;
	var semester:int;
	var code:String;
	var kind:String;
	var credit:int;
	
	var i:int;
	var j:int;
	
	for(i = 0; i < semesters.length; i++) {
		title = Util.between(semesters[i], null, "</td>"); //Dummy
		year = int(Util.between(title, null, "학년도"));
		semester = int(Util.between(title, "학년도", "학기"));
		
		//<td><font size="2" face="굴림">사고와 표현I</td>
		history = new History(year, semester);

		History.vector.push( history );
		lectures = Util.betweens(semesters[i], "<td><font size=\"2\" face=\"굴림\">");
		
		for(j = 0; j < lectures.length; j++) {
			components = Util.betweens(lectures[j], "<td align=\"center\"><font size=\"2\" face=\"굴림\">");
			/*
			데이타베이스론</td>
			<td align="center"><font size="2" face="굴림">MGT0020</td>
			<td align="center"><font size="2" face="굴림">복전선</td>
			<td align="center"><font size="2" face="굴림">3</td>
			<td align="center"><font size="2" face="굴림">A+</td>
			*/
			
			code = Util.between(components[0], null, "</td>");
			kind = Util.between(components[1], null, "</td>");			
			credit = int(Util.between(components[2], null, "</td>"));
			
			historyLecture = new HistoryLecture(history, kind, credit, code);
			if(kind == "일선" && Profile.secondMajor != -1 && (Major.list[Profile.secondMajor] as Major).code == code.substr(0, 3))
				history.addOmitted( historyLecture );
			/*
				======================================
				->	  왜 divide(분반)이 누락되었는가?    <-
				======================================
				
					  종합정보시스템의 성적 -> 성적조회(누적)에서는
					분반에 대한 정보를 얻을 수 없다.
					  때문에, 우선적으로 분반을 제외한 정보부터 기입한 뒤,
					옛날 시간표 보기를 했을 때, 이 빈 공간을 채워넣어줘야 한다.
			*/
		}
	}
	
	//희망 다전공 -> 일반선택으로 뜨는 누락 학기 수
	for(i = 0; i < History.vector.length; i++)
		if(History.vector[i].omitteds.length > 0)
			omittedLength++;
	
	progress.completed();
	if(omittedLength > 0)
		goHistoryOmitted();
}
private function goHistoryOmitted():void {
	for(var i:int = 0; i < History.vector.length; i++)
		if(History.vector[i].omitteds.length > 0) {
			var sendURL:URLRequest = new URLRequest(URL.lecture);
			var formData:URLVariables = new URLVariables();
			formData.year = History.vector[i].year;
			formData.semester = History.vector[i].semester;
			formData.majorcode	=	(Major.list[Profile.secondMajor] as Major).url;
			
			sendURL.data = formData;
			sendURL.method = URLRequestMethod.GET; //여기선 POST로 보내면 안 된다.
			
			var lectureLoader:HttpLoader = new HttpLoader();
			lectureLoader.dataFormat = URLLoaderDataFormat.BINARY;
			lectureLoader.param = i;
			lectureLoader.addEventListener(Event.COMPLETE, handleHistoryOmitted);
			lectureLoader.load(sendURL);
		}
}
private function handleHistoryOmitted(event:Event):void {
	var lectureLoader:HttpLoader = event.target as HttpLoader;
	lectureLoader.removeEventListener(Event.COMPLETE, handleHistoryOmitted);
	
	var index:int = lectureLoader.param;
	var replyData:String = Util.emptyRemover( Util.encode(lectureLoader.data as ByteArray) );
	
	var historyLecture:HistoryLecture;
	var segmentData:String;
	for(var i:int = 0; i < History.vector[index].omitteds.length; i++) {
		historyLecture = History.vector[index].omitteds[i];
		segmentData = Util.between(replyData, historyLecture.code + "</td>", "</tr>");
		historyLecture.kind = Util.gapRemover( Util.between(segmentData, "align=center>", "</td>") );
	}
	progress.completed();
	if(++omittedCompleted == omittedLength)
		omittedLength = omittedCompleted = 0;
}