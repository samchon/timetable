import data.subject.Lecture;
import data.base.Profile;
import data.html.Table;
import data.subject.Time;
import data.html.TimeIndex;

import mx.collections.ArrayCollection;

[Bindable]public var html:String = "";
private var records:Vector.<Vector.<Time>> = new Vector.<Vector.<Time>>(16, true);
private var timeIndexes:Vector.<TimeIndex> = new Vector.<TimeIndex>();
private var mergeTargetCells:Vector.<TimeIndex> = new Vector.<TimeIndex>();
//16(0~15교시) X 6(요일, 일~금) 칸

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

private function drawHTML(year:int = 0, semester:int = 0):void {
	html = Table.getTable(applyAC, Profile.year, Profile.semester);
}