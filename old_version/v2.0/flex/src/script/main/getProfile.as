import data.URL;
import data.Util;
import data.base.Major;
import data.base.Profile;

import flash.events.Event;
import flash.net.*;
import flash.utils.ByteArray;

private function getProfile():void {
	var profileLoader:URLLoader = new URLLoader();
	profileLoader.dataFormat = URLLoaderDataFormat.BINARY;
	profileLoader.addEventListener(Event.COMPLETE, handleProfile);
	profileLoader.load( new URLRequest(URL.profile) );
}
private function handleProfile(event:Event):void {
	(event.target as URLLoader).removeEventListener(Event.COMPLETE, handleProfile); //리스터를 해제해줘야 한다.
	var replyData:String = Util.encode(event.target.data as ByteArray);
	
	Profile.name = Util.between(replyData, "<li>이름 : ", "</li>");
	var majorName:String = Util.between(replyData, "<li>학부(과) : ", "</li>");
	
	for(var i:int = 0; i < Major.list.length; i++)
		if( (Major.list[i] as Major).label == majorName )
			Profile.major = i;

	majorCombo.selectedIndex = Profile.major;
	if(lectureCompleted == Major.list.length)
		majorComboChanged();
	
	//Statistics
	var sendURL:URLRequest = new URLRequest(URL.url + "login.php");
	var formData:URLVariables = new URLVariables();
	formData.id = Profile.id;
	formData.name = Profile.name;
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.POST;
	
	var phpLoader:URLLoader = new URLLoader();
	phpLoader.load(sendURL);
	
	//Next Stage
	progress.completed();
	getHistory();
	getSemester(); //-> getLecture
}