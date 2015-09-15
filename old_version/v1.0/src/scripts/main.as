import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.*;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.events.DragEvent;
import mx.managers.PopUpManager;

private var todayYear:uint;
private var todayMonth:uint;
private var theYear:uint;
private var theSemester:uint;
private var theName:String;
[Bindable]private var theMajor:String;
private var theMajorCode:String;
private var theSecondMajorCode:String;
private var theSecondMajorType:String = "none";

[Bindable]public var tableArray:ArrayCollection = new ArrayCollection();
[Bindable]public var tableTimeArray:ArrayCollection = new ArrayCollection();

[Bindable]private var tableHTMLText:String = "";

private function lectureDataGrid_dragCompleteHandler(e:DragEvent):void {
	var timer:Timer = new Timer(50, 0);
	timer.addEventListener(TimerEvent.TIMER, timerEvent);
	timer.start();
	var code:String = lectureDataGrid.selectedItem.code;
	var divide:String = lectureDataGrid.selectedItem.divide;
	var $Result:URLVariables = sql.query("delete from tableArray where code=" + code + " and divide=" + divide);
	
	function timerEvent(e:TimerEvent):void {
		if(!$Result) {
			addSubject(code, divide, true);
			timer.stop();
		}
	}
}
private function tableDataGrid_DoubleClick(e:MouseEvent):void {
	var lecturePopup:lectureWindow = PopUpManager.createPopUp(this, lectureWindow, true) as lectureWindow;
	lecturePopup.link = tableDataGrid.selectedItem.link;
	lecturePopup.subject = tableDataGrid.selectedItem.subject;
	lecturePopup.code = tableDataGrid.selectedItem.code;
	lecturePopup.divide = tableDataGrid.selectedItem.divide
	PopUpManager.centerPopUp(lecturePopup);
}
private function addSubject(code:String, divide:String, alert:Boolean):int {
	code = code.toUpperCase();
	divide = divide.toUpperCase();
	
	var major:String;
	if(!check(code, alert)) {
		if(code.substring(0, 3) == "CAH" || code.substring(0, 3) == "CBH" || code.substring(0, 3) == "CAS" || code.substring(0, 3) == "CBS" || 
			code.substring(0, 3) == "CAA" || code.substring(0, 3) == "CBA" || code.substring(0, 3) == "REQ" || code.substring(0, 3) == "CBE" || code.substring(0, 3) == "CAE") {
			major = "GEN";
		}else{
			major = code.substring(0, 3);
		}
		
		var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr/servlet/s_jik.jik_siganpyo_s_list");
		var formData:URLVariables = new URLVariables();
		formData.year = theYear;
		formData.semester = theSemester;
		formData.majorcode = sql.query("select `combo` from `majorArray` where code=" + major).combo0;
		
		sendURL.data = formData;
		sendURL.method = URLRequestMethod.GET;
		
		var subjectLoader:URLLoader = new URLLoader();
		subjectLoader.dataFormat = URLLoaderDataFormat.TEXT;
		subjectLoader.addEventListener(Event.COMPLETE, handleReply);
		subjectLoader.load(sendURL);
	}
	
	function handleReply(e:Event):void {
		var replyData:String = strReplace_emptyRemover(e.target.data);
		
		if(replyData.indexOf(code + divide) == -1) {
			if(alert)
				Alert.show(code + " / " + divide + "\n입력에 실패하였습니다.\n존재하지 않는 반이거나 오류일 수 있습니다." , "Error");
			else
				addSubject(code, divide, false);
		}else{
			var infoPart1:String = replyData.split(code+"</td>")[1].split("</tr>")[0];
			
			var subjectName:String = infoPart1.split("align=left>")[1].split("</td>")[0];
			var subjectKind:String = infoPart1.split("align=center>")[1].split("</td>")[0];
			if(subjectKind == "전기" || subjectKind == "전지" || subjectKind == "전선") {
				if(major != theMajorCode.substring(0, 3)) {
					if (major == theSecondMajorCode) {
						if(theSecondMajorType == "double")
							subjectKind = "복수" + subjectKind;
						else
							subjectKind = "부" + subjectKind;
					}else{
						subjectKind = "일선";;
					}
				}
			}
			var subjectCredit:int = infoPart1.split("align=center>")[2].split("</td>")[0];
			var subjectLink:String = infoPart1.split("letturerplanview('")[1].split("');")[0];
			var infoPart2:String = replyData.split(code + divide + "');")[1].split("</tr>")[0];
			
			var subjectMid:String = infoPart2.split("align=center>")[1].split("</td>")[0];
			var subjectProfessor:String = infoPart2.split("align=center>")[3].split("</td>")[0];
			var subjectDay:String = infoPart2.split("align=center>")[4].split("</td>")[0];
			var subjectClass:String = infoPart2.split("align=left>")[1].split("</td>")[0];
			
			var subjectTimeDivider:String = replyData.split(code + divide)[1];
			var subjectTimeArray:Array;
			if(subjectTimeDivider.indexOf("Javascript") == -1) {
				subjectTimeArray = subjectTimeDivider.split("</table>")[0].split("</tr>");
			}else{
				subjectTimeArray = subjectTimeDivider.split("Javascript")[0].split("</tr>");
			}
			
			var weekArray:Array = new Array();
			var hourArray:Array = new Array();
			var detail:String = "<b>" + subjectName + " " + divide + "</b>" + "<br>" + subjectProfessor + "<br>" + subjectClass;
			
			for(var i:int = 0; i < subjectTimeArray.length - 1; i++) {
				var day:String = "";
				var hour:uint = 0;

				if(i == 0) {
					day = subjectTimeArray[i].split("align=center>")[4].split("</td>")[0];
					hour = uint(subjectTimeArray[i].split("align=center>")[5].split("</td>")[0]);
				}else{
					day = subjectTimeArray[i].split("align=center>")[9].split("</td>")[0];
					hour = subjectTimeArray[i].split("align=center>")[10].split("</td>")[0];
				}
				if(subjectMid == "야" && hour <= 5)
					hour += 10;
				weekArray.push(day);
				hourArray.push(hour);
			}
			for(var $k:int = 0; $k < weekArray.length; $k++)
				if(sql.query("select index from tableTimeArray where week=" + weekArray[$k] + " and hour=" + hourArray[$k])) {
					Alert.show("다른 과목과 시간대가 겹칩니다.", "Error");
					return;
				}
			tableArray.addItem({code:code, subject:subjectName, divide:divide, kind:subjectKind, credit:subjectCredit, professor:subjectProfessor, link:subjectLink});
			
			var temp:int = addScore(subjectKind, subjectCredit);
			for(var $i:int = 0; $i < weekArray.length; $i++)
				tableTimeArray.addItem({code:code, week:weekArray[$i], hour:hourArray[$i], detail:detail});
		}
		tableRefresh();
		return;
	}
	return 0;
}
private function delSubject():void {
	var timer:Timer = new Timer(250, 0);
	timer.addEventListener(TimerEvent.TIMER, timerEvent);
	timer.start();
	if(!tableDataGrid.selectedItems)
		return;
	var selectedArray:Array = tableDataGrid.selectedItems;
	var $Result:URLVariables = new URLVariables();
	var code:String;
	var i:int = 0;
	sql.refresh();
	while(i < selectedArray.length) {
		code = selectedArray[i].code;
		delScore(selectedArray[i].kind, selectedArray[i].credit);
		tableArray.removeItemAt(tableDataGrid.selectedIndices[i]);
		sql.push("delete from `tableTimeArray` where `code`='" + code +"'");
		i++;
	}
	$Result = sql.deleteAll();
	function timerEvent(e:TimerEvent):void {
		if($Result) {
			tableRefresh();
			timer.stop();
		}
	}
}
private function goCommunity():void {
	var communityWindow:community = PopUpManager.createPopUp(this, community, true) as community;
	communityWindow.parentWidth = this.width;
	communityWindow.parentHeight = this.height;
	communityWindow.your_id = theAccount;
	communityWindow.your_name = theName;
	communityWindow.theURL = "http://gotoweb.co.kr/hansung/";
	PopUpManager.centerPopUp(communityWindow);
}

