import data.base.Profile;
import data.history.History;

import flash.events.InvokeEvent;

import mx.collections.ArrayCollection;
import mx.events.CollectionEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;

[Bindable]private var lectureAC:ArrayCollection = new ArrayCollection();	//Lecture가 들어가게 됨
[Bindable]private var applyAC:ArrayCollection = new ArrayCollection();		//신청 목록

public var isFirstLogin:Boolean = true;
private var progress:Progress;

private function main(event:FlexEvent):void {
	(event.target as timetable).removeEventListener(FlexEvent.CREATION_COMPLETE, main);
	
	applyAC.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleApplyChanged);
	this.addEventListener(InvokeEvent.INVOKE, handleInvoke);
	
	var update:Update = PopUpManager.createPopUp(this, Update, true) as Update;
	update.parentMovie = this;
	PopUpManager.centerPopUp(update);
}
private function handleApplyChanged(event:CollectionEvent):void {
	calcScore();
	drawHTML();
}
public function loginFinished():void {
	progress = PopUpManager.createPopUp(this, Progress, true) as Progress;
	progress.parentMovie = this;
	PopUpManager.centerPopUp(progress);
	
	/*
		getProfile
			getHistory
			getSemester
				getLecture
	*/
	getProfile();
}
private function logout():void {
	for(var i:int = 0; i < Root.windows.length; i++)
		if(Root.windows[i] is Previous)
			Root.windows[i].logout();
		else
			Root.windows[i].close();
	
	Profile.clear();
	applyAC.removeAll();
	scoreAC.removeAll();
	History.vector = new Vector.<History>();
	html = "";
	
	loginMovie.logout();
	this.currentState = "loginFrame";
}