import flash.net.*;

// ActionScript file
private function goApply():void {
	for(var $i:int = 0; $i < tableArray.length; $i++)
		doApply(tableArray[$i].code, tableArray[$i].divide);
}
private function doApply(code:String, divide:String):void {
	//http://www.hansung.ac.kr/jsp/sugang/h_sugang_sincheong_i02_s_20100219.jsp?&gwamok=CAE0008&bunban=N&yy=2011&hakgi=2&hakbun=1194060
	var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr/jsp/sugang/h_sugang_sincheong_i02_s_20100219.jsp");
	var formData:URLVariables = new URLVariables();
	formData.gwamok = code;
	formData.bunban = divide;
	formData.yy = theYear;
	formData.hakgi = theSemester;
	formData.hakbun = theAccount;
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.POST;
	
	var applyLoader:URLLoader = new URLLoader();
	applyLoader.dataFormat = URLLoaderDataFormat.TEXT;
	applyLoader.load(sendURL);
}