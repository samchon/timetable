import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.system.System;

import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.elements.TextFlow;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.controls.Alert;

import textEditBar.FileIOHelper;

[Bindable]private var listData:ArrayCollection = new ArrayCollection();
private var sort:String = "free";
private var page:uint;
private var searchType:String;
private var searchTxt:String;

private var writeMode:String;
private var askType:String;
private var No:uint;

public var theURL:String; //
public var your_id:String; //
public var your_name:String; //
public var parentWidth:int; //
public var parentHeight:int; //

private function main():void {
	System.useCodePage = false;
	
	this.width = parentWidth * .75;
	this.height = parentHeight * .8;
	this.currentState = "List";
	doList(sort, 1, "none", "empty");
	this.stage.addEventListener(Event.RESIZE, handleResize);
}
private function editorMain():void {
	w_memo.foreignElementProps.upload_sendURL = new URLRequest(theURL + "board/upload.php");
	w_memo.foreignElementProps.upload_formData = new URLVariables();
	w_memo.foreignElementProps.upload_formData.Path = your_id;
}
private function handleResize(e:Event):void {
	if(parentWidth < this.width || parentHeight < this.height) {
		this.width = parentWidth * .75;
		this.height = parentHeight * .8;
	}
	this.x = (parentWidth - this.width) / 2;
	this.y = (parentHeight - this.height) / 2;
}

//글 목록 불러오기

private function doList(theSort:String, thePage:uint, theSearchType:String, theSearchTxt:String):void {
	listData.removeAll();
	
	this.currentState = "List";
	targetPage.value = thePage;
	
	var sendURL:URLRequest = new URLRequest(theURL + "board/list.php");
	var formData:URLVariables = new URLVariables();
	formData.sort = theSort;
	formData.a_pagenum = 100;
	formData.page = thePage;
	formData.searchType = theSearchType;
	formData.searchTxt = theSearchTxt;
	
	sort = theSort;
	page = thePage;
	searchType = theSearchType;
	searchTxt = theSearchTxt;
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.POST;
	
	var phpLoader:URLLoader = new URLLoader();
	phpLoader.dataFormat = URLLoaderDataFormat.TEXT;
	phpLoader.addEventListener(Event.COMPLETE, handleReply);
	
	phpLoader.load(sendURL);
}
private function handleReply(e:Event):void {
	var replyData:URLVariables = new URLVariables(e.target.data);
	
	var i:int = 0;
	while( i < replyData.amount ) {
		var spacer:String = "";
		for (var j:uint = 1; j < uint(replyData["depth"+i]); j++)
		{
			spacer +=  "        ";
		}
		listData.addItem({uid:replyData["uid"+i], subject:spacer + replyData["subject"+i], id:replyData["writer"+i] + "(" + replyData["id"+i] + ")", date:replyData["date"+i], hit:replyData["hit"+i]});
		i++;
	}
	
	targetPage.value = replyData.page = page;
	targetPage.maximum = replyData.total_pagenum;
	totalPageLabel.text = replyData.total_pagenum;
}

//글 읽어오기

private function doRead(theSort:String, theUid:uint):void {
	this.currentState = "Read";
	
	var sendURL:URLRequest = new URLRequest(theURL + "board/read.php");
	var formData:URLVariables = new URLVariables();
	formData.sort = theSort;
	formData.uid = theUid;
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.POST;
	
	var phpLoader:URLLoader = new URLLoader();
	phpLoader.dataFormat = URLLoaderDataFormat.TEXT;
	phpLoader.addEventListener(Event.COMPLETE, readReply);
	
	phpLoader.load(sendURL);
}
private function readReply(e:Event):void {	
	var replyData:URLVariables = new URLVariables(e.target.data);
	read_no.text = replyData.uid;
	read_nick.text = replyData.writer + "(" + replyData.id + ")";
	read_ip.text = "IP : " + replyData.ip;
	read_date.text = "Date : " + replyData.date;
	read_subject.text = replyData.subject;
	read_memo.textFlow = TextConverter.importToFlow(replyData.memo, TextConverter.TEXT_LAYOUT_FORMAT);
}

//글 쓰기

private function goWrite(theMode:String, theNo:uint, theSubject:String, theMemo:String):void {
	writeMode = theMode;
	No = theNo;
	
	if (theMode == "write") {
		w_subject.text = "";
		w_memo.clear();
		this.currentState = "Write";
	}else if (theMode == "modify" ) {
		if(read_nick.text == your_name + "(" + your_id + ")") {
			this.currentState = "Write";
			w_subject.text = read_subject.text;
			//w_memo.changeContent(read_memo.textFlow);
			w_memo.changeContent(FileIOHelper.moveTextFlow(read_memo.textFlow));
		}else{
			Alert.show("다른 사람의 글은 수정할 수 없습니다.", "게시판 오류");
		}
	}else if(theMode == "reply") {
		this.currentState = "Write";
		w_subject.text = "RE]" + read_subject.text;
		
		var replyLayout:String = FileIOHelper.exportToLayout(read_memo.textFlow);
		replyLayout = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<TextFlow" + replyLayout.split("<TextFlow")[1].split(">")[0] + ">" +
			"<p></p><p></p>" +
			"<p color=\"#000000\" fontFamily=\"Arial\" fontSize=\"12\" kerning=\"auto\" textAlign=\"left\" trackingRight=\"0\">" +
			"<span>============================ 다음은 원본 글입니다 ============================" +
			"</span></p><p></p>"
			+ replyLayout.split("<TextFlow")[1].split("xmlns=\"http://ns.adobe.com/textLayout/2008\">")[1].split("</TextFlow>")[0].replace(/<p/g, "<p textIndent=\"50\"")
			+ "</TextFlow>";
		
		w_memo.changeContent(TextConverter.importToFlow(replyLayout, TextConverter.TEXT_LAYOUT_FORMAT));
	}
}
private function doWrite():void {
	if(w_subject.text == "") {
		mx.controls.Alert.show("빈 항목이 있어서는 안 됩니다.", "Error has been occured");
	}else{
		var sendURL:URLRequest = new URLRequest(theURL + "board/" + writeMode + ".php");
		var formData:URLVariables = new URLVariables();
		
		formData.sort = sort;
		formData.id = your_id;
		formData.writer = your_name;
		formData.subject = w_subject.text;
		formData.memo = w_memo.layoutText;
		
		if(writeMode == "modify" || writeMode == "reply") {
			formData.uid = No;
		}
		
		sendURL.data = formData;
		sendURL.method = URLRequestMethod.POST;
		
		var phpLoader:URLLoader = new URLLoader();
		phpLoader.dataFormat = URLLoaderDataFormat.TEXT;
		phpLoader.addEventListener(Event.COMPLETE, writeReply);
		
		phpLoader.load(sendURL);
	}
	function writeReply(e:Event):void {
		var replyData:URLVariables = new URLVariables(e.target.data);
		if(replyData.res == "ok") {
			if(writeMode == "reply")
				doList(sort, page, searchType, searchTxt);
			else
				doList(sort, 1, "none", "empty");
		}
	}
}
// 비번 체크
private function goDelete():void {
	if(read_nick.text == your_name + "(" + your_id + ")") {
		var sendURL:URLRequest = new URLRequest(theURL + "board/delete.php");
		var formData:URLVariables = new URLVariables();
		formData.uid = read_no.text;
		
		sendURL.data = formData;
		sendURL.method = URLRequestMethod.POST;
		
		var phpLoader:URLLoader = new URLLoader();
		phpLoader.dataFormat = URLLoaderDataFormat.TEXT;
		phpLoader.addEventListener(Event.COMPLETE, delReply);
		phpLoader.load(sendURL);
	}else{
		Alert.show("다른 사람의 글은 삭제할 수 없습니다.", "게시판 오류");
	}
}
private function delReply(e:Event):void {
	var replyData:URLVariables = new URLVariables(e.target.data);
	if(replyData.res == "ok") {
		doList(sort, page, searchType, searchTxt);
	}
}