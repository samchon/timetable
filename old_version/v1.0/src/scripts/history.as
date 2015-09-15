import flash.events.Event;
import flash.net.*;
import flash.system.System;

import mx.collections.ArrayCollection;

[Bindable]public var historyArray:ArrayCollection = new ArrayCollection();
[Bindable]public var historyTableArray:ArrayCollection = new ArrayCollection();
[Bindable]public var historyTableTimeArray:ArrayCollection = new ArrayCollection();

private var theHistoryYear:int = 0;
private var theHistorySemester:int = 0;

[Bindable]private var historyHTMLText:String = "";

private function historyCombo_Change(e:Event):void {
	historyTableArray.removeAll();
	historyTableTimeArray.removeAll();
	theHistoryYear = historyCombo.selectedItem.year;
	theHistorySemester = historyCombo.selectedItem.semester;
	
	var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr/servlet/s_dae.dae_gwajae_1");
	var formData:URLVariables = new URLVariables();
	
	formData.year = theHistoryYear;
	formData.hakgi = theHistorySemester;
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.GET;
	
	var subjectLoader:URLLoader = new URLLoader();
	subjectLoader.dataFormat = URLLoaderDataFormat.TEXT;
	subjectLoader.addEventListener(Event.COMPLETE, handleReply);
	subjectLoader.load(sendURL);
	
	function handleReply(e:Event):void {
		var codes:Array = new Array();
		var replyData:String = e.target.data;
		replyData = replyData.split("<SELECT NAME=\"gyokwa\" onChange=\"JavaScript:gwajae(1);\">")[1].split("</SELECT>")[0];
		
		var replyArray:Array = replyData.split("<option value=\"");
		replyArray.splice(0, 1);
		
		for(var $i:int = 0; $i < replyArray.length; $i++) {
			var codeMerged:String = replyArray[$i].split("\">")[0];
			addHistory(codeMerged.substr(0, 7), codeMerged.substr(-1, 1), theHistoryYear, theHistorySemester);
		}
	}
}
private function addHistory(code:String, divide:String, year:int, semester:int):void {
	code = code.toUpperCase();
	divide = divide.toUpperCase();
	
	var major:String;
	if(!check(code, false)) {
		if(code.substring(0, 3) == "CAH" || code.substring(0, 3) == "CBH" || code.substring(0, 3) == "CAS" || code.substring(0, 3) == "CBS" || 
			code.substring(0, 3) == "CAA" || code.substring(0, 3) == "CBA" || code.substring(0, 3) == "REQ" || code.substring(0, 3) == "CBE" || code.substring(0, 3) == "CAE") {
			major = "GEN";
		}else{
			major = code.substring(0, 3);
		}
		
		var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr/servlet/s_jik.jik_siganpyo_s_list");
		var formData:URLVariables = new URLVariables();
		formData.year = year;
		formData.semester = semester;
		formData.majorcode = sql.query("select combo from majorArray where code=" + major).combo0//searchFromArrayCollection_StringToString("majorArray", "code", "combo", major);
		
		sendURL.data = formData;
		sendURL.method = URLRequestMethod.GET;
		
		
		var subjectLoader:URLLoader = new URLLoader();
		subjectLoader.dataFormat = URLLoaderDataFormat.TEXT;
		subjectLoader.addEventListener(Event.COMPLETE, handleReply);
		subjectLoader.load(sendURL);
	}
	
	function handleReply(e:Event):uint {
		var replyData:String = strReplace_emptyRemover(e.target.data);
		
		if(replyData.indexOf(code + divide) == -1) {
			//Alert.show(divide + "반은 존재하지 않습니다.", "Error");
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
			var subjectClass:String = infoPart1.split("align=left>")[2].split("</td>")[0];
			
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
			if(history_searchFromArrayCollection_Time(weekArray, hourArray)) {
				return 0;
			}
			historyTableArray.addItem({code:code, subject:subjectName, divide:divide, kind:subjectKind, credit:subjectCredit, professor:subjectProfessor, link:subjectLink});
			
			for(var $i:int = 0; $i < weekArray.length; $i++)
				historyTableTimeArray.addItem({code:code, week:weekArray[$i], hour:hourArray[$i], detail:detail});
		}
		history_tableRefresh();
		return 0;
	}
}
private function history_searchFromArrayCollection_Time(week:Array, hour:Array):Boolean {
	for(var $i:int = 0; $i < historyTableTimeArray.length; $i++) {
		for(var $j:int = 0; $j < week.length; $j++) {
			if(week[$j] == historyTableTimeArray[$i].week) {
				for(var $k:int = 0; $k < hour.length; $k++) {
					if(hour[$k] == historyTableTimeArray[$i].hour) {
						//Alert.show("다른 과목과 시간대가 겹칩니다. : ", "Error");
						return true;
					}
				}
			}
		}
	}
	return false;
}













































// ActionScript file
private function history_getDetailFromTableTimeArray(week:int, hour:int):String {
	for(var $i:int = 0; $i < historyTableTimeArray.length; $i++) {
		if(historyTableTimeArray[$i].week == weekArray[week] && historyTableTimeArray[$i].hour == hour) {
			return historyTableTimeArray[$i].detail;
		}
	}
	return "";
}
private function history_getMinimumFromTableTimeArray():int {
	var $Result:URLVariables;
	for(var res:int = 0; res < 15; res++) {
		$Result = sql.query("select hour from historyTableTimeArray where hour=" + res);
		if($Result)
			return res;
	}
	return 0;
}
private function history_getMaximumFromTableTimeArray():int {
	var $Result:URLVariables;
	for(var res:int = 15; res > 0; res--) {
		$Result = sql.query("select hour from historyTableTimeArray where hour=" + res);
		if($Result)
			return res;
	}
	return res;
}
private function history_tableRefresh():void {
	var min:int = history_getMinimumFromTableTimeArray();
	var max:int = history_getMaximumFromTableTimeArray();
	
	historyMinCheck.label = "(최소)처음 시간 : " + min + "교시";
	historyMaxCheck.label = "(최대)마지막 시간 : " + max + "교시";
	
	var htmlStart:String = 
		"<html>\n" +
		"<head>\n" +
		"<title>" + theName + "(" + theAccount + ") " + theHistoryYear + "년 " + theHistorySemester + "학기 시간표</title>\n" +
		"<style>\n" +
		"	table {\n" +
		"		font-size : 10pt;\n" +
		"	}\n" +
		"	td {\n" +
		"		text-align : center;\n" +
		"	}\n" +
		"	.week {\n" +
		"		padding : 10px;\n" +
		"		color : white;\n" +
		"		background-color : #00376F;\n" +
		"	}\n" +
		"	.hour {\n" +
		"		text-align : left;\n" +
		"		color : white;\n" +
		"		background-color : #0058B0;\n" +
		"	}\n" +
		"</style>\n" +
		"</head>\n\n" +
		"<body><br>\n" + 
		"<table border='1' bordercolor='#CCCCCC' align='center' cellpadding='5' cellspacing='0'>\n" + 
		"	<tr class='week'>\n" +
		"		<th width='120'>시간</td>\n" +
		"		<th width='120'>월</td>\n" +
		"		<th width='120'>화</td>\n" +
		"		<th width='120'>수</td>\n" +
		"		<th width='120'>목</td>\n" +
		"		<th width='120'>금</td>\n" +
		"	</tr>\n";
	
	var htmlFor:String = "";;
	
	var $i:int = (historyMinCheck.selected) ? min : 1;
	var $length:int = (historyMaxCheck.selected) ? (max + 1) : hourArray.length;
	
	var detail:String;
	for(; $i < $length; $i++) {
		if(hourArray[$i] == "주야교대") {
			htmlFor += "	<tr>\n" +
				"		<td height='10' colspan='6'></td>\n" +
				"	</tr>\n";
		}else{
			htmlFor += "	<tr>\n" +
				"		<td class='hour'>" + hourArray[$i] + "</td>\n";
			for(var $j:int = 0; $j < 5; $j++) {
				detail = history_getDetailFromTableTimeArray($j, $i);
				if(detail) {
					var $prevCheck:String = history_getDetailFromTableTimeArray($j, $i-1);
					var $l:int = 1;
					var $try:int = $i+1;
					while(history_getDetailFromTableTimeArray($j, $try) == detail) {
						$l++;
						$try++;
					}
					if($prevCheck != detail)
						if($l == 1)
							htmlFor += "		<td bgcolor='#FBFDFF'>" + detail + "</td>\n";
						else
							htmlFor += "		<td bgcolor='#FBFDFF' rowspan=" + $l + ">" + detail + "</td>\n";
				}else{
					htmlFor += "		<td bgcolor='#EEEFFF'></td>\n";
				}
			}
			htmlFor += "	</tr>\n";
			/*
			for(var $j:int = 0; $j < 5; $j++) {
				detail = getDetailFromTableTimeArray($j, $i);
				if(detail) {
					var $prevCheck:String = getDetailFromTableTimeArray($j, $i-1);
					var $l:int = 1;
					var $try:int = $i+1;
					while(getDetailFromTableTimeArray($j, $try) == detail) {
						$l++;
						$try++;
					}
					if($prevCheck != detail)
						if($l == 1)
							htmlFor += "		<td bgcolor='#FBFDFF'>" + detail + "</td>\n";
						else
							htmlFor += "		<td bgcolor='#FBFDFF' rowspan=" + $l + ">" + detail + "</td>\n";
				}else{
					htmlFor += "		<td bgcolor='#EEEFFF'></td>\n";
				}
			}
			htmlFor += "	</tr>\n";
			*/
		}
	}
	
	var htmlLast:String = "</table>\n</body>\n</html>";
	//Alert.show(htmlStart + htmlFor + htmlLast, "Copy");
	
	historyHTMLText = htmlStart + htmlFor + htmlLast;
}