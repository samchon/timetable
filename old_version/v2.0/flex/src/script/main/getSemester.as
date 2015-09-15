import data.URL;
import data.Util;
import data.base.Profile;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

private function getSemester():void {
	var semesterLoader:URLLoader = new URLLoader();
	semesterLoader.addEventListener(Event.COMPLETE, handleSemester);
	semesterLoader.load(new URLRequest(URL.semester));
}
private function handleSemester(event:Event):void {
	(event.target as URLLoader).removeEventListener(Event.COMPLETE, handleSemester); //리스너를 해제해줘야 한다.
	var replyData:String = event.target.data;
	
	Profile.year		=	int(Util.between(replyData, "<select name=year><option value=", ">"));
	Profile.semester	= 	int(Util.between(replyData, "<select name=semester><option value=", ">"));
	
	trace(Profile.year + "년 " + Profile.semester + "학기");
	progress.completed();
	if(isFirstLogin == true)
		getLecture();
}