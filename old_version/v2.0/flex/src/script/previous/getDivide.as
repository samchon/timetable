import comp.util.HttpLoader;

import data.URL;
import data.Util;
import data.history.History;
import data.history.HistoryLecture;

import flash.events.Event;
import flash.net.*;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import mx.managers.PopUpManager;

private static var isDivide:Boolean = false;
private static var divideCompleted:int = 0;

private function getDivide():void {
	for(var i:int = 0; i < History.vector.length; i++) {
		if(i == 0) {
			progress = PopUpManager.createPopUp(this, Progress, true) as Progress;
			progress.parentMovie = this;
			progress.parentMode = Progress.DIVIDE;
			PopUpManager.centerPopUp(progress);
		}
		var sendURL:URLRequest = new URLRequest(URL.divide);
		var formData:URLVariables = new URLVariables();
		formData.hakneando = History.vector[i].year;
		formData.hakgi = History.vector[i].semester;
		
		sendURL.data = formData;
		sendURL.method = URLRequestMethod.POST;
		
		var jspLoader:HttpLoader = new HttpLoader();
		jspLoader.param = i;
		jspLoader.dataFormat = URLLoaderDataFormat.BINARY;
		jspLoader.addEventListener(Event.COMPLETE, handleDivide);
		jspLoader.load(sendURL);
	}
}
private function handleDivide(event:Event):void {
	var jspLoader:HttpLoader = event.target as HttpLoader;
	var index:int = jspLoader.param;
	var history:History = History.vector[index];
	
	var bytes:ByteArray = event.target.data;
	var replyData:String = Util.encode(bytes);	
	replyData = Util.between(replyData, "<select name=gwamok", "</select>");
	var lectures:Array = Util.betweens(replyData, "<option value=\"", "\"");
	
	var code:String;
	var divide:String;
	
	for(var i:int = 0; i < lectures.length; i++) {
		code = lectures[i].substr(0, 7);
		divide = lectures[i].substr(-1, 1);
		
		if(history.hasOwnProperty(code) == false)
			trace("'"+code+"'", "'"+divide+"'");
		else
			(history[code] as HistoryLecture).divide = divide;
	}
	if(++divideCompleted == History.vector.length) {
		divideCompleted = 0;
		isDivide = true;
	}
	progress.completed();
}