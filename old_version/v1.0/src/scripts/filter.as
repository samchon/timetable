import flash.net.URLVariables;
import mx.controls.Alert;

private function weekAndTimeCheck(code:String):Boolean {
	return true;
}
private function strReplace_emptyRemover(words:String):String {
	words = words.replace(RegExp(/ /g), "");
	words = words.replace(RegExp(/&nbsp;/g), "");
	words = words.replace(RegExp(/\n/g), "");
	words = words.replace(RegExp(/\t/g), "");
	
	return words;
}
private function check(code:String, alert:Boolean):Boolean {
	var res:URLVariables = sql.query("select index from tableArray where code=" + code);
	if(res) {
		if(alert)
			Alert.show("같은 과목이 이미 있습니다.", "Error");
		return true;
	}else{
		return false;
	}
}
private function getDetailFromTableTimeArray(week:int, hour:int):String {
	var weekArray:Array = new Array("월", "화", "수", "목", "금");
	for(var $i:int = 0; $i < tableTimeArray.length; $i++) {
		if(tableTimeArray[$i].week == weekArray[week] && tableTimeArray[$i].hour == hour) {
			return tableTimeArray[$i].detail;
		}
	}
	return null;
}
private function getMinimumFromTableTimeArray():int {
	var $Result:URLVariables;
	for(var res:int = 0; res < 15; res++) {
		$Result = sql.query("select hour from tableTimeArray where hour=" + res);
		if($Result)
			return res;
	}
	return 0;
}
private function getMaximumFromTableTimeArray():int {
	var $Result:URLVariables;
	for(var res:int = 15; res > 0; res--) {
		$Result = sql.query("select hour from tableTimeArray where hour=" + res);
		if($Result)
			return res;
	}
	return res;
}