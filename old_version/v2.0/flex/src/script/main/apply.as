import data.subject.Lecture;
import data.subject.Subject;

import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.events.DragEvent;

private function applyFromDragDrop(event:DragEvent):void {
	var lecture:Lecture =  event.dragSource.dataForFormat("items")[0] as Lecture;
	apply(lecture.code, lecture.divide);
}
private function cancelApplied(event:MouseEvent):void {
	var selectedIndices:Array = applyGrid.selectedIndices;
	if(selectedIndices.length == 0)
		return;
	
	selectedIndices.sort(); //선택 순서에 따라 뒤바뀔 수 있으니 오름차순 정렬은 필수
	for(var i:int = selectedIndices.length - 1; i >= 0; i--)
		applyAC.removeItemAt( selectedIndices[i] );
	
	//calcScore();
	//drawHTML();
}
public function apply(code:String, divide:String):void {
	code = code.toUpperCase();
	divide = divide.toUpperCase();
	
	var lecture:Lecture = null;
	
	var i:int;
	var j:int;
	var k:int;
	
	//존재하지 않는 코드
	if(subjects.hasOwnProperty(code) == false) {
		Alert.show("그 과목" + "(" + code + ")은(는) 존재하지 않습니다.", "신청 오류");
		return;
	}
	//존재하지 않는 코드
	if(subjects[code].hasOwnProperty(divide) == false) {
		Alert.show("그 분반" + "(" + divide + ")은(는) 존재하지 않습니다.", "신청 오류");
		return;
	}
	
	/*
	=====================================================
		여기서부터 신청할 수 있는 지 체크
	=====================================================
	*/
	lecture = subjects[code][divide];
	
	//동일 과목이 있는 지를 체크
	for(i = 0; i < applyAC.length; i++)
		if((applyAC[i] as Lecture).code == lecture.code) {
			Alert.show("이미 동일한 과목을 신청하셨습니다 - " + lecture.code, "신청 오류");
			return;
		}
	//동일 시간대가 있는 지를 체크
	for(i = 0; i < applyAC.length; i++)
		for(j = 0; j < (applyAC[i] as Lecture).length; j++)
			for(k = 0; k < lecture.length; k++)
				if( (applyAC[i] as Lecture)[j].day == lecture[k].day && (applyAC[i] as Lecture)[j].hour == lecture[k].hour ) {
					Alert.show("시간이 중복되는 과목이 존재합니다.\n\t - " + (applyAC[i] as Lecture).name + "(" + (applyAC[i] as Lecture).code + ")", "신청 오류");
					return;
				}
	
	applyAC.addItem( lecture );	//최종적인 신청 적용
}