import flash.events.Event;
import flash.net.*;
import flash.system.System;

import mx.controls.Alert;
public var major:String;
public var secondMajor:String;
import mx.events.ValidationResultEvent;
import mx.collections.ArrayCollection;
import flash.desktop.NativeApplication;
import flash.events.InvokeEvent;
import flash.filesystem.File;
import flash.data.EncryptedLocalStore;
import flash.utils.ByteArray;
import Classes.aql.aql;

private var theAccount:String;
private var thePass:String;
private var loginSharedObject:SharedObject;
private var invokeBoolean:Boolean = false;
private var sql:aql;

private var unModifiedScoreArray:ArrayCollection = new ArrayCollection();
[Bindable]private var scoreArray:ArrayCollection = new ArrayCollection();
[Bindable]private var theSecondMajorTypeToColumn:String = "none";
[Bindable]private var theSecondMajorBoolean:Boolean = false;

private var loginFinished:Boolean = false;

private function main():void {
	System.useCodePage = true;
	sql = new aql(this);
	NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeListener);
	updaterMain();
	
	var date:Date = new Date();
	todayYear = date.getFullYear();
	todayMonth = date.getMonth()+1;

	loginSharedObject = SharedObject.getLocal("Hangang_HTT");
	if(loginSharedObject.data.id != null) {
		login_id.text = loginSharedObject.data.id;
		login_pass.text = loginSharedObject.data.pass;
		secondMajorCheckCombo.selectedIndex = loginSharedObject.data.type;
		secondMajorCombo.selectedIndex = loginSharedObject.data.second;
		
		doLogin();
	}
}
private function invokeListener(e:InvokeEvent):void {
	if(e.currentDirectory == null || e.arguments.length != 1)
		return;
	httFile = e.currentDirectory.resolvePath(e.arguments[0]);
	if(loginFinished)
		openFile();
	else
		invokeBoolean = true;
}
private function checkValidator(item:Object):Boolean {
	if(item.validate().type == ValidationResultEvent.INVALID)
		return false;
	else
		return true;
}
private function doLogout():void {
	loginSharedObject.clear();
	this.currentState = "loginFrame";
	login_id.text = null;
	login_pass.text = null;
	secondMajorCheckCombo.selectedIndex = 0;
	secondMajorCombo.selectedIndex = -1;
	loginCookie.selected = false;
	secondMajorCombo.enabled = false;
	newFile();
}
private function doLogin():void {
	if(checkValidator(idValidator) && checkValidator(passValidator)) {
		theAccount = login_id.text;
		thePass = login_pass.text;
		
		var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr/servlet/s_gong.gong_login_ssl");
		var formData:URLVariables = new URLVariables();
		formData.id = theAccount;
		formData.passwd = thePass;
		
		sendURL.data = formData;
		sendURL.method = URLRequestMethod.POST;
		
		var loginLoader:URLLoader = new URLLoader();
		loginLoader.dataFormat = URLLoaderDataFormat.TEXT;
		loginLoader.addEventListener(Event.COMPLETE, handleReply);
		loginLoader.load(sendURL);
		
		function handleReply(e:Event):void {
			var replyData:String = e.target.data;
			if(replyData.indexOf("아이디와 비밀번호가 일치하지 않습니다.") != -1) {
				mx.controls.Alert.show("아이디와 비밀번호가 일치하지 않습니다.", "Alert");
			}else{
				if(loginCookie.selected) {
					loginSharedObject.data.id = login_id.text;
					loginSharedObject.data.pass = login_pass.text;
					loginSharedObject.data.type = secondMajorCheckCombo.selectedIndex;
					loginSharedObject.data.second = secondMajorCombo.selectedItem ? secondMajorCombo.selectedIndex : -1;
					loginSharedObject.flush();
				}
				if(secondMajorCombo.selectedItem) {
					theSecondMajorCode = secondMajorCombo.selectedItem.code;
					theSecondMajorType = secondMajorCheckCombo.selectedItem.data;
					theSecondMajorBoolean = true;
					if(theSecondMajorType == "double")
						theSecondMajorTypeToColumn = "복수";
					else
						theSecondMajorTypeToColumn = "부";
				}
				getSemester();
			}
		}
	}
}
private function getSemester():void {
	var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr/servlet/s_jik.jik_siganpyo_s_list");
	var formData:URLVariables = new URLVariables();
	if(todayMonth == 12) {
		formData.year = todayYear + 1;
		formData.semester = 1;
	}else{
		formData.year = todayYear;
		formData.semester = 2;
	}
	formData.majorcode = "D040";
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.GET;
	
	var semesterLoader:URLLoader = new URLLoader();
	semesterLoader.dataFormat = URLLoaderDataFormat.TEXT;
	semesterLoader.addEventListener(Event.COMPLETE, handleReply);
	semesterLoader.load(sendURL);
	
	function handleReply(e:Event):void {
		var replyData:String = e.target.data;
		if(todayMonth == 12) {
			if(replyData.indexOf("MGT") != -1) {
				theYear = todayYear + 1;
				theSemester = 1;
			}else{
				theYear = todayYear;
				theSemester = 2;
			}
		}else{
			theYear = todayYear;
			if(replyData.indexOf("MGT") != -1) {		
				theSemester = 2;
			}else{
				theSemester = 1;
			}
		}
		getPersonalProfile();
	}
}
private function getPersonalProfile():void {
	var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr/servlet/s_dae.dae_top_menu");	
	var profileLoader:URLLoader = new URLLoader();
	profileLoader.dataFormat = URLLoaderDataFormat.TEXT;
	profileLoader.addEventListener(Event.COMPLETE, handleReply);
	profileLoader.load(sendURL);
	
	function handleReply(e:Event):void {
		var replyData:String = e.target.data;
		
		theName = replyData.split("이름 : ")[1].split("</font>")[0];
		theMajor = replyData.split("전공 : ")[1].split("</font>")[0];
		theMajor = theMajor.replace(RegExp(/&/g), "·");
		
		getMajorCode();
	}
}
[Bindable]private var panelTitle:String = "";
private function getMajorCode():void {
	var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr:2003/dcd_haksa/owa/ps_hi2300");
	var formData:URLVariables = new URLVariables();
	formData.as_hakbun = theAccount;
	formData.as_password = thePass;
	
	sendURL.data = formData;
	sendURL.method = URLRequestMethod.GET;
	
	var majorLoader:URLLoader = new URLLoader();
	majorLoader.dataFormat = URLLoaderDataFormat.TEXT;
	majorLoader.addEventListener(Event.COMPLETE, handleReply);
	majorLoader.load(sendURL);
	
	function handleReply(e:Event):void {
		var replyData:String = e.target.data;
		
		var temp:Array = replyData.split("<td align=\"center\"><font size=\"2\" face=\"굴림\">전기")[0].split("<font size=\"2\" face=\"굴림\">");
		theMajorCode = temp[temp.length - 1].substring(0, 3);
		
		replyData = strReplace_emptyRemover(replyData);
		var score:String = replyData.split("총성적내역")[1].split("백분위점수")[0].split("</CENTER></TABLE>")[0];
		var scores:Array = score.split("<CENTER>");
		
		var totalScore:int = scores[2].split("</CENTER>")[0];
		var majorBasis:int = scores[7].split("</CENTER>")[0];
		var majorDesignated:int = scores[8].split("</CENTER>")[0];
		var majorFree:int = scores[9].split("</CENTER>")[0];
		var majorNormal:int = scores[10].split("</CENTER>")[0];
		var majorTotal:int = majorBasis + majorDesignated + majorFree;
		var cultureEssential:int = scores[3].split("</CENTER>")[0];
		var cultureA:int = scores[4].split("</CENTER>")[0];
		var cultureB:int = scores[5].split("</CENTER>")[0];
		var cultureFree:int = scores[6].split("</CENTER>")[0];
		var cultureTotal:int = majorNormal + cultureEssential + cultureA + cultureB + cultureFree;
		
		if(!theSecondMajorBoolean) {
			scoreArray.addItem({index:"기존 학점", totalScore : totalScore, majorTotal : majorTotal, majorBasis : majorBasis, 
				majorDesignated : majorDesignated, majorFree : majorFree, majorFree : majorFree, majorNormal : majorNormal,
				cultureEssential : cultureEssential, cultureA : cultureA, cultureB : cultureB, cultureFree : cultureFree, cultureTotal : cultureTotal});
			scoreArray.addItem({index:"신청 학점", totalScore : 0, majorTotal : 0, majorBasis : 0, 
				majorDesignated : 0, majorFree : 0, majorFree : 0, majorNormal : 0,
				cultureEssential : 0, cultureA : 0, cultureB : 0, cultureFree : 0, cultureTotal : 0});
			scoreArray.addItem({index:"예상 총 학점", totalScore : totalScore, majorTotal : majorTotal, majorBasis : majorBasis, 
				majorDesignated : majorDesignated, majorFree : majorFree, majorFree : majorFree, majorNormal : majorNormal,
				cultureEssential : cultureEssential, cultureA : cultureA, cultureB : cultureB, cultureFree : cultureFree, cultureTotal : cultureTotal});
		}else{
			var secondMajorTotal:int;
			var secondMajorBasis:int;
			var secondMajorDesignated:int;
			var secondMajorFree:int;
			
			scoreArray.addItem({index:"기존 학점", totalScore : totalScore, majorTotal : majorTotal, secondMajorTotal : secondMajorTotal, cultureTotal : cultureTotal,
				majorBasis : majorBasis, majorDesignated : majorDesignated, majorFree : majorFree,
				secondMajorBasis : secondMajorBasis, secondMajorDesignated : secondMajorDesignated, secondMajorFree : secondMajorFree, majorNormal : majorNormal,
				cultureEssential : cultureEssential, cultureA : cultureA, cultureB : cultureB, cultureFree : cultureFree});
			scoreArray.addItem({index:"신청 학점", totalScore : 0, majorTotal : 0, secondMajorTotal : 0, cultureTotal : 0,
				majorBasis : 0, majorDesignated : 0, majorFree : 0,
				secondMajorBasis : 0, secondMajorDesignated : 0, secondMajorFree : 0, majorNormal : 0,
				cultureEssential : 0, cultureA : 0, cultureB : 0, cultureFree : 0});
			scoreArray.addItem({index:"예상 총 학점", totalScore : totalScore, majorTotal : majorTotal, secondMajorTotal : secondMajorTotal, 
				majorBasis : majorBasis, majorDesignated : majorDesignated, majorFree : majorFree, cultureTotal : cultureTotal,
				secondMajorBasis : secondMajorBasis, secondMajorDesignated : secondMajorDesignated, secondMajorFree : secondMajorFree, majorNormal : majorNormal,
				cultureEssential : cultureEssential, cultureA : cultureA, cultureB : cultureB, cultureFree : cultureFree});
			unModifiedScoreArray.addItem({index:"예상 총 학점", totalScore : totalScore, majorTotal : majorTotal, secondMajorTotal : secondMajorTotal, cultureTotal : cultureTotal,
				majorBasis : majorBasis, majorDesignated : majorDesignated, majorFree : majorFree,
				secondMajorBasis : secondMajorBasis, secondMajorDesignated : secondMajorDesignated, secondMajorFree : secondMajorFree, majorNormal : majorNormal,
				cultureEssential : cultureEssential, cultureA : cultureA, cultureB : cultureB, cultureFree : cultureFree});
		}
		
		currentState = "tableFrame";
		currentState = "hansungFrame";
		panelTitle = theName + "(" + theMajor + ") " + theYear + "년 " + theSemester + "학기 시간표";
		if(theAccount == '1194060')
			applyBtn.visible = true;
		goModify(replyData);
	}
}
private function secondMajorCheckCombo_Handler():void {
	if(secondMajorCheckCombo.selectedItem.data == "deep") {
		secondMajorCombo.enabled = false;
	}else{
		secondMajorCombo.enabled = true;
	}
}