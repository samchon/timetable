import data.base.Profile;
import data.URL;
import data.subject.Lecture;

import flash.events.Event;
import flash.events.InvokeEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.*;

private var httFile:File;
private var isInvoked:Boolean;

/*
	파일 처리에 관한 부분은 액션 스크립트를 따로 배우지 않으면 알아보기 힘들다
	액션 스크립트를 따로 배울 게 아니라면 넘어가도 무방하다.
*/

private function handleInvoke(event:InvokeEvent):void {
	if(event.currentDirectory == null || event.arguments.length != 1)
		return;
	httFile = event.currentDirectory.resolvePath(event.arguments[0]);
	if (isFirstLogin == false)
		openFile();
	else
		isInvoked = true;
}
private function open():void {
	httFile = new File();
	httFile.addEventListener(Event.SELECT, openReply);
	httFile.browse([new FileFilter("Hangang Time Table File (htt)", "*.htt")]);
}
private function openReply(event:Event):void {
	(event.target as File).removeEventListener(Event.SELECT, openReply);
	openFile();
}
private function openFile():void {
	var stream:FileStream = new FileStream();
	stream.open(httFile, FileMode.READ);
	
	var replyData:URLVariables = new URLVariables( stream.readUTFBytes(stream.bytesAvailable) );
	for(var i:int = 0; i < replyData.length; i++)
		apply( replyData["code" + i], replyData["divide" + i] );
}
private function save():void {
	var file:File = new File(File.desktopDirectory.nativePath + File.separator + fileName + ".htt");
	file.addEventListener(Event.SELECT, handleSave);
	file.browseForSave("시간표 저장");
}
private function handleSave(event:Event):void {
	(event.target as File).removeEventListener(Event.SELECT, handleSave);
	var file:File = event.target as File;
	var text:String = saveForAndroid();
	trace(text);
	
	var stream:FileStream = new FileStream();
	stream.open(file, FileMode.WRITE);
	stream.writeUTFBytes( text );
	stream.close();
}

public function get fileName():String {
	return Profile.name + "(" + Profile.id + ") " + Profile.year + "년 " + Profile.semester + "학기 시간표";
}
public function saveForAndroid():String {
	var flashVars:String = "Dummy1=1&length=" + applyAC.length;
	for(var i:int = 0; i < applyAC.length; i++)
		flashVars += "&code" + i + "=" + (applyAC[i] as Lecture).code + "&divide" + i + "=" + (applyAC[i] as Lecture).divide;
	
	var sendURL:URLRequest = new URLRequest(data.URL.url + "save.php");
	var formData:URLVariables = new URLVariables();
	formData.id = Profile.id;
	formData.year = Profile.year;
	formData.semester = Profile.semester;
	formData.code = flashVars;
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.POST;
	
	var phpLoader:URLLoader = new URLLoader();
	phpLoader.dataFormat = URLLoaderDataFormat.TEXT;
	phpLoader.load(sendURL);
	
	return flashVars;
}
