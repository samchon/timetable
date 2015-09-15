import data.base.Profile;
import data.history.History;
import data.html.Table;
import data.subject.SubjectVector;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;

private var progress:Progress;
[Bindable]private var semesterAC:ArrayCollection = new ArrayCollection();
[Bindable]private var applyAC:ArrayCollection = new ArrayCollection();
[Bindable]private var scoreAC:ArrayCollection = new ArrayCollection();

[Bindable]public var html:String = "";

private function main(event:FlexEvent):void {
	this.removeEventListener(FlexEvent.CREATION_COMPLETE, main);
	Root.windows.push( this );
	
	subjectVectors = new Vector.<SubjectVector>(History.vector.length, true);
	for(var i:int = 0; i < History.vector.length; i++)
		semesterAC.addItem( History.vector[i] );
	
	if(isDivide == false)
		getDivide();
}
public function get fileName():String {
	if(semesterCombo.selectedItem == null)
		return "empty";
	var history:History = semesterCombo.selectedItem as History;
	
	return Profile.name + "(" + Profile.id + ") " + history.year + "년 " + history.semester + "학기 시간표";
}
private function apply(index:int):void {
	var history:History = History.vector[index];
	calcScore(index);
	applyAC = history.applyAC;
	html = Table.getTable(applyAC, history.year, history.semester);
}
public function logout():void {
	//static을 초기화시켜줘야 한다.
	subjectVectors = new Vector.<SubjectVector>();
	this.close();
}