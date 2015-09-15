import comp.util.HttpLoader;

import data.base.Profile;
import data.URL;
import data.Util;
import data.base.Major;
import data.subject.*;

import flash.events.Event;
import flash.net.*;
import flash.utils.ByteArray;

import mx.collections.ArrayCollection;

private var lectureCompleted:int = 0;						//불러오기가 완료된 전공 갯수
private var subjects:SubjectVector = new SubjectVector();	//과목 목록
private var lecutresInMajor:Vector.<SubjectVector> = new Vector.<SubjectVector>(); //각 전공 내 과목 목록

private function getLecture():void {
	for(var i:int = 0; i < Major.list.length; i++) { //Major.list.length
		lecutresInMajor.push( new SubjectVector() );
		//http://info.hansung.ac.kr/servlet/s_jik.jik_siganpyo_s_list?year=2013&semester=1&majorcode=K131
		
		var sendURL:URLRequest = new URLRequest(URL.lecture);
		var formData:URLVariables = new URLVariables();
		formData.year		=	Profile.year;
		formData.semester	=	Profile.semester;
		formData.majorcode	=	(Major.list[i] as Major).url;
		
		sendURL.data = formData;
		sendURL.method = URLRequestMethod.GET; //여기선 POST로 보내면 안 된다.
		
		var lectureLoader:HttpLoader = new HttpLoader();
		lectureLoader.dataFormat = URLLoaderDataFormat.BINARY;
		lectureLoader.param = i;
		lectureLoader.addEventListener(Event.COMPLETE, handleLecture);
		lectureLoader.load(sendURL);
	}
}
private function handleLecture(event:Event):void {
	var lectureLoader:HttpLoader = event.target as HttpLoader;
	lectureLoader.removeEventListener(Event.COMPLETE, handleLecture);
	
	var index:int = lectureLoader.param;
	var replyData:String = Util.encode(lectureLoader.data as ByteArray);
	
	//파싱
	Subject.parse(replyData, subjects, lecutresInMajor[index]);
	
	//완료 후 처리
	progress.completed();
	if(++lectureCompleted == Major.list.length && Profile.major != -1) {
		lectureCompleted = 0;
		majorComboChanged();
		if(isInvoked == true) {
			openFile();
			isInvoked = false;
		}
	}
}