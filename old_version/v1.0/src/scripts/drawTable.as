import flash.net.URLVariables;
import flash.system.System;
// ActionScript file
private var tableMinChecked:Boolean = false;
private var tableMaxChecked:Boolean = false;
private var hourArray:Array = new Array("", "<b>1교시</b><br>&nbsp;&nbsp;09:00 ~ 09:50", "<b>2교시</b><br>&nbsp;&nbsp;10:00 ~ 10:50", "<b>3교시</b><br>&nbsp;&nbsp;11:00 ~ 11:50", 
	"<b>4교시</b><br>&nbsp;&nbsp;12:00 ~ 12:50", "<b>5교시</b><br>&nbsp;&nbsp;13:00 ~ 13:50", "<b>6교시</b><br>&nbsp;&nbsp;14:00 ~ 14:50", 
	"<b>7교시</b><br>&nbsp;&nbsp;15:00 ~ 15:50", "<b>8교시</b><br>&nbsp;&nbsp;16:00 ~ 16:50", "<b>9교시</b><br>&nbsp;&nbsp;17:00 ~ 17:50", 
	"주야교대", "<b>11교시</b><br>&nbsp;&nbsp;18:00 ~ 18:50", "<b>12교시</b><br>&nbsp;&nbsp;18:55 ~ 19:45", 
	"<b>13교시</b><br>&nbsp;&nbsp;19:50 ~ 20:40", "<b>14교시</b><br>&nbsp;&nbsp;20:45 ~ 21:35", "<b>15교시</b><br>&nbsp;&nbsp;21:40 ~ 22:30");
private var weekArray:Array = new Array("월", "화", "수", "목", "금");
private function tableRefresh():void {
	var min:int = getMinimumFromTableTimeArray();
	var max:int = getMaximumFromTableTimeArray();
	
	minCheck.label = "(최소)처음 시간 : " + min + "교시";
	maxCheck.label = "(최대)마지막 시간 : " + max + "교시";
	
	var htmlStart:String = 
		"<html>\n" +
		"<head>\n" +
		"<title>" + theName + "(" + theAccount + ") " + theYear + "년 " + theSemester + "학기 시간표</title>\n" +
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
		"		<th width='120'>시간</th>\n" +
		"		<th width='120'>월</th>\n" +
		"		<th width='120'>화</th>\n" +
		"		<th width='120'>수</th>\n" +
		"		<th width='120'>목</th>\n" +
		"		<th width='120'>금</th>\n" +
		"	</tr>\n";
	
	var htmlFor:String = "";;
	
	var $i:int = (minCheck.selected) ? min : 1;
	var $length:int = (maxCheck.selected) ? (max + 1) : hourArray.length;
	
	var detail:String;
	for(; $i < $length; $i++) {
		if(hourArray[$i] == "주야교대") {
			htmlFor += "	<tr>\n" +
				"		<td height='5' colspan='6' bgcolor='#EEEFFF'></td>\n" +
				"	</tr>\n";
		}else{
			htmlFor += "	<tr>\n" +
				"		<td class='hour'>" + hourArray[$i] + "</td>\n";
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
		}
	}
	
	var htmlLast:String = "</table>\n</body>\n</html>";
	//Alert.show(htmlStart + htmlFor + htmlLast, "Copy");
	
	tableHTMLText = htmlStart + htmlFor + htmlLast;
}