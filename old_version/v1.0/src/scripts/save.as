import flash.desktop.NativeApplication;
import flash.desktop.NativeProcess;
import flash.desktop.Updater;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.*;
import flash.net.FileFilter;
import flash.utils.ByteArray;
import flash.utils.Timer;

import mx.graphics.codec.PNGEncoder;

private var httFile:File;

private function newFile():void {
	tableArray.removeAll();
	tableTimeArray.removeAll();
	tableHTMLText = "";
	
	totalScore = 0;
	majorTotal = 0;
	secondMajorTotal = 0;
	cultureTotal = 0;
	majorBasis = 0;
	majorDesignated = 0;
	majorFree = 0;
	secondMajorBasis = 0;
	secondMajorDesignated = 0;
	secondMajorFree = 0;
	majorNormal = 0;
	cultureEssential = 0;
	cultureA = 0;
	cultureB = 0;
	cultureFree = 0;
	
	scoreArray.setItemAt({index:"신청 학점", totalScore : 0, majorTotal : 0, secondMajorTotal : 0, cultureTotal : 0,
		majorBasis : 0, majorDesignated : 0, majorFree : 0,
		secondMajorBasis : 0, secondMajorDesignated : 0, secondMajorFree : 0, majorNormal : 0,
		cultureEssential : 0, cultureA : 0, cultureB : 0, cultureFree : 0}, 1);
	
	scoreArray.setItemAt({index: "예상 총 학점", totalScore : scoreArray[0].totalScore +  totalScore, majorTotal : scoreArray[0].majorTotal +  majorTotal, secondMajorTotal : scoreArray[0].secondMajorTotal +  secondMajorTotal, 
		majorBasis : scoreArray[0].majorBasis +  majorBasis, majorDesignated : scoreArray[0].majorDesignated +  majorDesignated, majorFree : scoreArray[0].majorFree +  majorFree, cultureTotal : scoreArray[0].cultureTotal +  cultureTotal,
		secondMajorBasis : scoreArray[0].secondMajorBasis +  secondMajorBasis, secondMajorDesignated : scoreArray[0].secondMajorDesignated +  secondMajorDesignated, secondMajorFree : scoreArray[0].secondMajorFree +  secondMajorFree, majorNormal : scoreArray[0].majorNormal +  majorNormal,
		cultureEssential : scoreArray[0].cultureEssential +  cultureEssential, cultureA : scoreArray[0].cultureA +  cultureA, cultureB : scoreArray[0].cultureB +  cultureB, cultureFree : scoreArray[0].cultureFree +  cultureFree}, 2);
}
private function open():void {
	httFile = new File();
	httFile.addEventListener(Event.SELECT, openSelect);
	httFile.browse([new FileFilter("Hangang Time Table File (htt)", "*.htt")]);
}
private function openSelect(e:Event):void {
	openFile();
}
private function openFile():void {
	var stream:FileStream = new FileStream();
	stream.open(httFile, FileMode.READ);
	
	var replyData:URLVariables = new URLVariables(stream.readMultiByte(stream.bytesAvailable, "euc-kr"));
	
	var $i:int = 0;
	while($i < replyData.length) {
		addSubject(replyData["code" + $i], replyData["divide" + $i], false);
		$i++;
	}
}
private function save():void {
	var output:String = "Dummy1=1&";
	for(var $i:int = 0; $i < tableArray.length; $i++) {
		output += "code" + $i + "=" + tableArray[$i].code + "&divide" + $i + "=" + tableArray[$i].divide + "&";
	}
	output += "length=" + $i + "&Dummy2=2";
	
	var sendURL:URLRequest = new URLRequest("http://gotoweb.co.kr/hansung/save.php");
	var formData:URLVariables = new URLVariables();
	formData.account = theAccount;
	formData.code = output;
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.POST;
	
	var phpLoader:URLLoader = new URLLoader();
	phpLoader.dataFormat = URLLoaderDataFormat.TEXT;
	phpLoader.load(sendURL);
	
	var fileName:String = theName + "(" + theAccount + ") " + theYear + "년 " + theSemester + "학기 시간표";
	
	var file:File = new File(File.desktopDirectory.nativePath + File.separator + fileName + ".htt");
	file.addEventListener(Event.SELECT, saveFile);
	file.browseForSave("시간표 저장");
	
	function saveFile():void {
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		stream.writeMultiByte(output, "euc-kr");
		stream.close();
	}
}
private function export(type:String):void {
	var output:String;
	var fileName:String;
	if(currentState == "tableFrame" || currentState == "hansungFrame") {
		output = tableHTMLText;
		fileName = theName + "(" + theAccount + ") " + theYear + "년 " + theSemester + "학기 시간표";
	} else {
		output = historyHTMLText
		fileName = theName + "(" + theAccount + ") " + theHistoryYear + "년 " + theHistorySemester + "학기 시간표";
	}
	
	var file:File = new File(File.desktopDirectory.nativePath + File.separator + fileName + "." + type);
	file.addEventListener(Event.SELECT, saveFile);
	
	if(type == "doc")
		file.browseForSave("워드로 추출");
	else
		file.browseForSave("엑셀로 추출");
	
	function saveFile():void {
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		//stream.writeUTFBytes(output);
		stream.writeMultiByte(output, "euc-kr");
		stream.close();
		file.openWithDefaultApplication();
	}
}
protected function saveAsPNG(e:MouseEvent):void {	
	var pngSource:BitmapData = new BitmapData(this.stage.stageWidth, this.stage.stageHeight);
	pngSource.draw(this);
	var pngEncoder:PNGEncoder = new PNGEncoder();
	var pngData:ByteArray = pngEncoder.encode(pngSource); 
	
	var fileName:String;
	if(currentState == "tableFrame" || currentState == "hansungFrame")
		fileName = theName + "(" + theAccount + ") " + theYear + "년 " + theSemester + "학기 시간표.png";
	else if(currentState == "historyFrame")
		fileName = theName + "(" + theAccount + ") " + theHistoryYear + "년 " + theHistorySemester + "학기 시간표.png";
	
	var file:File = new File(File.desktopDirectory.nativePath + File.separator + fileName);
	file.addEventListener(Event.SELECT, saveFile);
	file.browseForSave("Export to PNG");
	
	function saveFile(e:Event):void {
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		stream.writeBytes(pngData);
		stream.close();
		file.openWithDefaultApplication();
	}
}