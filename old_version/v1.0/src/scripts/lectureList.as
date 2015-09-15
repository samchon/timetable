// ActionScript file
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.events.DragEvent;
import mx.managers.PopUpManager;

[Bindable]public var listArray:ArrayCollection = new ArrayCollection();

private function lectureDataGrid_DoubleClick(e:MouseEvent):void {
	var listPopup:lectureWindow = PopUpManager.createPopUp(this, lectureWindow, true) as lectureWindow;
	listPopup.link = lectureDataGrid.selectedItem.link;
	listPopup.subject = lectureDataGrid.selectedItem.subject;
	listPopup.code = lectureDataGrid.selectedItem.code;
	listPopup.divide = lectureDataGrid.selectedItem.divide
	PopUpManager.centerPopUp(listPopup);
}
private function getList(majorCode:String, combo:String):void {
	listArray.removeAll();
	
	var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr/servlet/s_jik.jik_siganpyo_s_list");
	var formData:URLVariables = new URLVariables();
	formData.year = theYear;
	formData.semester = theSemester;
	formData.majorcode = combo;
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.GET;
	
	
	var subjectLoader:URLLoader = new URLLoader();
	subjectLoader.dataFormat = URLLoaderDataFormat.TEXT;
	subjectLoader.addEventListener(Event.COMPLETE, handleReply);
	subjectLoader.load(sendURL);
	
	function handleReply(e:Event):void {
		var replyData:String = strReplace_emptyRemover(e.target.data);

		var codeArray:Array = replyData.split(/<tr><tdbgcolor=.......align=center>.........td>/);
		codeArray.splice(0, 1);
		
		for(var $i:int = 0; $i < codeArray.length; $i++) { //codeArray.length]
			//letturerplanview('2012 11105 86 ISE0056A
			var subjectCode:String = codeArray[$i].split(RegExp(/letturerplanvie............../))[1].split("');")[0].substring(0, 7);
			var listData:String = codeArray[$i];//replyData.split(subjectCode+"</td>")[1];
			var infoPart1:String = listData.split("</tr>")[0];
			
			var subjectName:String = infoPart1.split("align=left>")[1].split("</td>")[0];
			var subjectKind:String = infoPart1.split("align=center>")[1].split("</td>")[0];
			var subjectCredit:String = infoPart1.split("align=center>")[2].split("</td>")[0];
			var subjectGrade:String = infoPart1.split("align=center>")[5].split("</td>")[0];
			
			var divideArray:Array = codeArray[$i].split("Javascript");
			divideArray.splice(0, 1);
			
			for(var $j:int = 0; $j < divideArray.length; $j++) {
				var subjectDivide:String = divideArray[$j].split("title='강의계획서조회'>")[1].split("</a></td>")[0];
				var subjectLink:String = divideArray[$j].split("letturerplanview('")[1].split("');")[0];
				//20121110576REQ00137
				
				var infoPart2:String = listData.split("title='강의계획서조회'>"+subjectDivide+"</a>")[1].split("</tr>")[0];
				
				var subjectMid:String = infoPart2.split("align=center>")[1].split("</td>")[0];
				var subjectProfessor:String = infoPart2.split("align=center>")[3].split("</td>")[0];
				var subjectDay:String = infoPart2.split("align=center>")[4].split("</td>")[0];
				var subjectClass:String = infoPart2.split("align=left>")[1].split("</td>")[0];
				
				var subjectTimeDivider:String = replyData.split(subjectCode + subjectDivide)[1];
				var subjectTimeArray:Array;
				
				if(subjectTimeDivider.indexOf("Javascript") == -1) {
					subjectTimeArray = subjectTimeDivider.split("</table>")[0].split("</tr>");
				}else{
					subjectTimeArray = subjectTimeDivider.split("Javascript")[0].split("</tr>");
				}
				
				var days:String = "";
				var hours:String = "";
				for(var i:int = 0; i < subjectTimeArray.length - 1; i++) {
					var day:String = "";
					var hour:uint = 0;
					if(i == 0) {
						day = subjectTimeArray[i].split("align=center>")[4].split("</td>")[0];
						hour = uint(subjectTimeArray[i].split("align=center>")[5].split("</td>")[0]);
						
						toNight();
						
						days = day;
						hours = String(hour);
					}else{
						day = subjectTimeArray[i].split("align=center>")[9].split("</td>")[0];
						hour = subjectTimeArray[i].split("align=center>")[10].split("</td>")[0];
						
						toNight();
						
						days += "\n" + day;
						hours += "\n" + String(hour);
					}
					function toNight():void {
						if(subjectMid == "야" && hour <= 5)
							hour += 10;
					}
				}
				
				listArray.addItem({code:subjectCode, subject:subjectName, mid:subjectMid, kind:subjectKind, credit:subjectCredit, divide:subjectDivide, grade:subjectGrade+"\n\n\n\n\n　", professor:subjectProfessor, week:days, hour:hours, classRoom:subjectClass, link:subjectLink});
			}
		}
	}
}