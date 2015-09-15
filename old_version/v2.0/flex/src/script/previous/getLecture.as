import comp.util.HttpLoader;

import data.URL;
import data.Util;
import data.base.Major;
import data.history.History;
import data.history.HistoryLecture;
import data.subject.Lecture;
import data.subject.Subject;
import data.subject.SubjectVector;

import flash.events.Event;
import flash.net.*;
import flash.utils.ByteArray;

import mx.managers.PopUpManager;

import spark.components.ComboBox;
import spark.events.IndexChangeEvent;

public static var subjectVectors:Vector.<SubjectVector>;
private var lectureCompleted:int = 0;
public var lectureLength:int = 0;

private function getLecture(event:IndexChangeEvent):void {
	var index:int = (event.target as ComboBox).selectedIndex;
	if(subjectVectors[index] != null) {
		apply(index);
		return;
	}
	var history:History = History.vector[index];
	var majors:Vector.<Major> = new Vector.<Major>();
	var major:Major;
	var isDuplicated:Boolean;
	
	subjectVectors[index] = new SubjectVector();
	progress = PopUpManager.createPopUp(this, Progress, true) as Progress;
	progress.parentMovie = this;
	progress.parentMode = Progress.LECTURE;
	PopUpManager.centerPopUp(progress);
	
	for(var i:int = 0; i < history.length; i++) {
		isDuplicated = false;
		if( Major.map.hasOwnProperty( history[i].code.substr(0, 3) ) == false )
			continue;
		major = Major.map[ history[i].code.substr(0, 3) ];
		for(var j:int = 0; j < majors.length; j++)
			if(major == majors[j])
				isDuplicated = true;
		if(isDuplicated == false)
			majors.push( major );
	}
	lectureLength = majors.length;
	
	for(i = 0; i < majors.length; i++) {
		var sendURL:URLRequest = new URLRequest(URL.lecture);
		var formData:URLVariables = new URLVariables();
		formData.year		=	history.year;
		formData.semester	=	history.semester;
		formData.majorcode	=	majors[i].url;
		
		sendURL.data = formData;
		sendURL.method = URLRequestMethod.GET; //여기선 POST로 보내면 안 된다.
		
		var lectureLoader:HttpLoader = new HttpLoader();
		lectureLoader.dataFormat = URLLoaderDataFormat.BINARY;
		lectureLoader.param = new Object();
		lectureLoader.param.index = index;
		lectureLoader.param.page = i;
		lectureLoader.addEventListener(Event.COMPLETE, handleLecture);
		lectureLoader.load(sendURL);
	}
}
private function handleLecture(event:Event):void {
	var lectureLoader:HttpLoader = event.target as HttpLoader;
	lectureLoader.removeEventListener(Event.COMPLETE, handleLecture);
	
	var index:int = lectureLoader.param.index;
	var page:int = lectureLoader.param.page;
	var replyData:String = Util.encode(lectureLoader.data as ByteArray);
	var subjectVector:SubjectVector = subjectVectors[index];
	
	var historyLecture:HistoryLecture;
	var code:String;
	var divide:String;
	
	subjectVector = new SubjectVector();
	
	Subject.parse(replyData, subjectVector, null);
	
	for(var i:int = 0; i < History.vector[index].length; i++) {
		historyLecture = History.vector[index][i];
		code = historyLecture.code;
		divide = historyLecture.divide;
		
		if(divide != "-1") //계절학기 과목의 divide: -1
			if( subjectVector.hasOwnProperty(code) == true) //사이버 과목은 false가 된다.
				historyLecture.lecture = subjectVector[code][divide];
	}
	
	progress.completed();
	if(++lectureCompleted == lectureLength) {
		lectureCompleted = lectureLength = 0;
		apply(lectureLoader.param.index);
	}
}











