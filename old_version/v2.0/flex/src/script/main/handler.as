import comp.menu.MenuButton;

import data.base.Major;
import data.subject.Lecture;

import flash.events.MouseEvent;

import mx.controls.DataGrid;
import mx.events.DragEvent;

import spark.components.ComboBox;
import spark.events.IndexChangeEvent;

private function majorComboChanged():void {
	var index:int = majorCombo.selectedIndex;
	if(index == -1)
		return;
	
	lectureAC.removeAll();
	for(var i:int = 0; i < lecutresInMajor[index].length; i++)
		for(var j:int = 0; j < lecutresInMajor[index][i].length; j++)
			lectureAC.addItem( lecutresInMajor[index][i][j] );
}
public function syllabusDoubleClicked(event:MouseEvent):void {
	var selected:Lecture = (event.currentTarget as DataGrid).selectedItem as Lecture;
	if(selected == null)
		return;
	var url:String = selected.link;
	
	var syllabus:Syllabus = new Syllabus();
	syllabus.parentWindow = this;
	syllabus.url = url;
	syllabus.title = selected.name + "(" + selected.code + ") - " + selected.divide;
	syllabus.open();
}
public function menuButtonClicked(event:MouseEvent):void {
	var label:String = (event.currentTarget as MenuButton).label;
	
	switch(label) {
		case "새 파일":
			applyAC.removeAll();
			break;
		case "파일 저장":
			save();
			break;
		case "파일 열기":
			open();
			break;
		case "과거 시간표":
			var previous:Previous = new Previous();
			previous.open();
			break;
		case "게시판":
			var board:Board = new Board();
			board.parentMovie = this;
			board.open();
			break;
		case "로그아웃":
			logout();
			break;
		case "종료":
			this.exit();
			break;
	}
}