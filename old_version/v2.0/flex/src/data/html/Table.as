package data.html
{
	
	import mx.collections.ArrayCollection;
	import data.subject.Lecture;
	import data.base.Profile;
	import data.subject.Time;

	public class Table
	{
		private static const hourLabel:Array =
			[
				"", 
				"<b>1교시</b><br>&nbsp;&nbsp;09:00 ~ 09:50", 
				"<b>2교시</b><br>&nbsp;&nbsp;10:00 ~ 10:50", 
				"<b>3교시</b><br>&nbsp;&nbsp;11:00 ~ 11:50", 
				"<b>4교시</b><br>&nbsp;&nbsp;12:00 ~ 12:50", 
				"<b>5교시</b><br>&nbsp;&nbsp;13:00 ~ 13:50", 
				"<b>6교시</b><br>&nbsp;&nbsp;14:00 ~ 14:50", 
				"<b>7교시</b><br>&nbsp;&nbsp;15:00 ~ 15:50", 
				"<b>8교시</b><br>&nbsp;&nbsp;16:00 ~ 16:50", 
				"<b>9교시</b><br>&nbsp;&nbsp;17:00 ~ 17:50", 
				"주야교대", 
				"<b>11교시</b><br>&nbsp;&nbsp;18:00 ~ 18:50", 
				"<b>12교시</b><br>&nbsp;&nbsp;18:55 ~ 19:45", 
				"<b>13교시</b><br>&nbsp;&nbsp;19:50 ~ 20:40", 
				"<b>14교시</b><br>&nbsp;&nbsp;20:45 ~ 21:35", 
				"<b>15교시</b><br>&nbsp;&nbsp;21:40 ~ 22:30"
			];
		
		/*
			표 그리기, HTML 태그 반환
				아마 이 시간표의 소스 중 가장 복합하고 난해할 것이다.
				HTML TABLE 태그, 특히 셀 병합에 대한 상당한 이해가 필요하다.
		*/
		public static function getTable(applyAC:ArrayCollection, year:int, semester:int):String {
			var html:String = "";
			
			var records:Vector.<Vector.<Time>> = new Vector.<Vector.<Time>>(16, true);
			var timeIndexes:Vector.<TimeIndex> = new Vector.<TimeIndex>();
			var mergeTargetCells:Vector.<TimeIndex> = new Vector.<TimeIndex>();
			
			//초기화
			if(year == 0) {
				year = Profile.year;
				semester = Profile.semester;
			}
			var lecture:Lecture;
			
			var min:int = 15;
			var max:int = 1;
			
			var isAlreadyMerged:Boolean; //이미 rowspan에 의해 병합, 기록되어 아무것도 하지 않아야 할 때
			var i:int;
			var j:int;
			var k:int;
			
			//먼저 시간 테이블을 비워주고
			for(i = 0; i < records.length; i++)
				records[i] = new Vector.<Time>(6, true);
			timeIndexes = new Vector.<TimeIndex>();
			mergeTargetCells = new Vector.<TimeIndex>();
			
			//시간대 별 포인터 배열 구성 -> 월요일 5교시의 Lecture: timeIndexes[1][5] as Lecture
			for(i = 0; i < applyAC.length; i++) {
				lecture = applyAC[i] as Lecture;
				for(j = 0; j < lecture.length; j++) {
					records[lecture[j].hour][lecture[j].day] = lecture[j];
					timeIndexes.push ( new TimeIndex(lecture[j].hour, lecture[j].day) );
				}
			}
			if(timeIndexes.length == 0)
				return "";
			
			//시작 시간, 끝 시간 산출
			for(i = 0; i < timeIndexes.length; i++)
				if(timeIndexes[i].hour < min)
					min = timeIndexes[i].hour;
			for(i = 0; i < timeIndexes.length; i++)
				if(timeIndexes[i].hour > max)
					max = timeIndexes[i].hour;
			
			//HTML 문서 헤더 구성
			html = 
				"<html>\n" +
				"<head>\n" +
				"<meta charset='utf-8'>\n" +
				"<title>" + Profile.name + "(" + Profile.id + ") " + year + "년 " + semester + "학기 시간표</title>\n" +
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
			
			//테이블 구성
			for(i = min; i <= max; i++) { //i -> 시간
				if(i == 10) { //주야 사이의 공백, 10교시는 존재하지 않음
					html += 
						"	<tr>\n" +
						"		<td height='5' colspan='6' bgcolor='#EEEFFF'></td>\n" +
						"	</tr>\n";
					continue;
				}
				
				//왼쪽 교시 및 시각 그리기
				html += "	<tr>\n" +
					"		<td class='hour'>" + hourLabel[i] + "</td>\n";
				
				//본격적인 시간표 각 항목 구성
				for(j = 1; j <= 5; j++) {	//j -> 요일
					if(records[i][j] == null)
						html += "		<td bgcolor='#EEEFFF'></td>\n";
					else {
						isAlreadyMerged = false;
						//이미 전 시간에도 같은 과목이라 rowspan 병합의 대상이 되었는지 찾고 -> Do Nothing
						for(k = 0; k < mergeTargetCells.length; k++)
							if(mergeTargetCells[k].hour == i && mergeTargetCells[k].day == j) {
								isAlreadyMerged = true;
								break;
							}
						if(isAlreadyMerged)
							continue;
						
						//아니라면, 기록 시에 다음 시간에도 같은 과목이어 rowspan의 병합 대상인지도 찾는다.
						for(k = 1; (i+k < records.length && records[i+k][j] != null && records[i+k][j].lecture == records[i][j].lecture); k++)
							mergeTargetCells.push( new TimeIndex(i+k, j) );
						
						html += "		<td rowspan='" + k + "' bgcolor='#FBFDFF'>\n" +
							records[i][j] +
							"		</td>\n";
					}
				}
				html += "	</tr>\n";
			}
			html += 
				"</table>\n" +
				"</body>\n" +
				"</html>";
			
			return html;
		}
	}
}