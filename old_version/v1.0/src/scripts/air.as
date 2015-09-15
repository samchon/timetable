// ActionScript file
import air.update.ApplicationUpdaterUI;
import air.update.events.UpdateEvent;

import flash.desktop.NativeApplication;
import flash.desktop.NativeProcess;
import flash.desktop.Updater;
import flash.display.Loader;
import flash.events.Event;
import flash.net.*;

private var currentVersion:String = "";

private var updater:ApplicationUpdaterUI = new ApplicationUpdaterUI();

private var air:Object = new Object();
private var airLoader:Loader = new Loader();
private var AppPath:String = "http://gotoweb.co.kr/hansung/timetable.air";
private var AppID:String = "timetable";
private var AirVersion:String = "3.1";

private function updaterMain():void {
	var applicationDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
	var adns:Namespace = applicationDescriptor.namespace();
	currentVersion = applicationDescriptor.adns::versionNumber.toString();
	
	airLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, airLoadComplete);
	airLoader.load(new URLRequest("http://airdownload.adobe.com/air/browserapi/air.swf"));
	
	//if(NativeProcess.isSupported) {
		var sendURL:URLRequest = new URLRequest("http://gotoweb.co.kr/hansung/hansungTimeTable.xml")
		sendURL.method = URLRequestMethod.POST;
		
		var versionLoader:URLLoader = new URLLoader();
		versionLoader.dataFormat = URLLoaderDataFormat.TEXT;
		versionLoader.addEventListener(Event.COMPLETE, handleNativeVersionComplete);
		versionLoader.load(sendURL);
	/*}else{
		updater.updateURL = "http://gotoweb.co.kr/hansung/hansungTimeTable.xml";
		updater.isCheckForUpdateVisible = false;
		updater.addEventListener(UpdateEvent.INITIALIZED, update);
		
		updater.initialize();
	}*/
}

private function handleNativeVersionComplete(e:Event):void {
	var replyData:XML = new XML(e.target.data);
	var udns:Namespace = replyData.namespace();
	var replyVersion:String = replyData.udns::versionNumber.toString();
	
	//echo("현재 : " + currentVersion + ", 업데이트 : " + replyVersion, "Check");
	
	if(replyVersion != currentVersion && replyVersion != "") {
		updateWin.visible = true;
	}
}
private function appUpdater():void {
	air.installApplication(AppPath, AirVersion);
	this.stage.nativeWindow.close();
}
private function airLoadComplete(e:Event):void {
	air = airLoader.content;
}
private function update(e:UpdateEvent):void {
	updater.checkNow();
}