import flash.events.Event;
import flash.net.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.messaging.management.ObjectName;

private function goModify(receivedData:String):void {
	var secondTotalScore:int = 0;
	var secondBasisScore:int = 0;
	var secondDesignatedScore:int = 0;
	var secondFreeScore:int = 0;
	var comboCode:String = sql.query("select combo from majorArray where code=" + theSecondMajorCode).combo0;
	
	receivedData = receivedData.split("총성적내역")[0];
	var total:Array = receivedData.split("<tdalign=\"left\"width=\"300\"><fontsize=\"3\"face=\"굴림\">");
	total.splice(0, 1);
	
	var $i:int = 0;
	var $modifyLength:int = total.length;
	var secondModifyArray:Array = new Array();
	
	goRequest();
	function goRequest():void {
		if($i < $modifyLength) {
			secondModifyArray = new Array();
			var year:int = total[$i].split("학년도")[0];
			var semester:int = total[$i].split("학년도")[1].split("학기")[0];
			historyArray.addItem({label:year + "학년도 " + semester + "학기", year:year, semester:semester});
			
			if(total[$i].indexOf(theSecondMajorCode) != -1) {
				var majorFreeArray:Array = total[$i].split(theSecondMajorCode);
				majorFreeArray.splice(0, 1);
				for(var $j:int = 0; $j < majorFreeArray.length; $j++) {
					var majorFreeCode:String = theSecondMajorCode + majorFreeArray[$j].split("</td>")[0];
					var secondGrade:String = majorFreeArray[$j].split("</td><tdalign=\"center\"><fontsize=\"2\"face=\"굴림\">")[3].split("</td>")[0];
					if(secondGrade != "F")
						secondModifyArray.push(majorFreeCode);
				}
			}
			var sendURL:URLRequest = new URLRequest("http://www.hansung.ac.kr/servlet/s_jik.jik_siganpyo_s_list");
			var formData:URLVariables = new URLVariables();
			formData.year = year;
			formData.semester = semester;
			formData.majorcode = comboCode;
			
			sendURL.data = formData;
			sendURL.method = URLRequestMethod.GET;
			
			var subjectLoader:URLLoader = new URLLoader();
			subjectLoader.dataFormat = URLLoaderDataFormat.TEXT;
			subjectLoader.addEventListener(Event.COMPLETE, handleReply);
			subjectLoader.load(sendURL);
		}else{
			if(invokeBoolean)
				openFile();
			loginFinished = true;
		}
	}
	var appliedSecond:Boolean = false;
	function handleReply(e:Event):void {
		var replyData:String = strReplace_emptyRemover(e.target.data);
		for(var $k:int = 0; $k < secondModifyArray.length; $k++) {
			if(replyData.indexOf("복전") != -1 || replyData.indexOf("부전") != -1)
				appliedSecond = true;
			var sort:String = replyData.split(secondModifyArray[$k] + "</td>")[1].split("align=center>")[1].split("</td>")[0];
			var thisScore:int = int(replyData.split(secondModifyArray[$k] + "</td>")[1].split("align=center>")[2].split("</td>")[0]);
			secondTotalScore += thisScore;
			switch(sort) {
				case "전기" :
					secondBasisScore += thisScore;
					break;
				case "전지" :
					secondDesignatedScore += thisScore;
					break;
				case "전선" :
					secondFreeScore += thisScore;
					break;
			}
		}
		$i++;
		var garbage:int = doModify();
		goRequest();
	}
	function doModify():int {
		if($i == $modifyLength) {
			if(!appliedSecond)
				majorNormal = majorNormal - secondMajorTotal;
			scoreArray.setItemAt({index:"기존 학점", totalScore : unModifiedScoreArray[0].totalScore, majorTotal : unModifiedScoreArray[0].majorTotal, secondMajorTotal : secondTotalScore, cultureTotal : unModifiedScoreArray[0].cultureTotal - secondTotalScore,
				majorBasis : unModifiedScoreArray[0].majorBasis, majorDesignated : unModifiedScoreArray[0].majorDesignated, majorFree : unModifiedScoreArray[0].majorFree, 
				secondMajorBasis : secondBasisScore, secondMajorDesignated : secondDesignatedScore, secondMajorFree : secondFreeScore, majorNormal : majorNormal,
				cultureEssential : unModifiedScoreArray[0].cultureEssential, cultureA : unModifiedScoreArray[0].cultureA, cultureB : unModifiedScoreArray[0].cultureB, cultureFree : unModifiedScoreArray[0].cultureFree}, 0);
			scoreArray.setItemAt({index:"예상 총 학점", totalScore : unModifiedScoreArray[0].totalScore, majorTotal : unModifiedScoreArray[0].majorTotal, secondMajorTotal : secondTotalScore, cultureTotal : unModifiedScoreArray[0].cultureTotal - secondTotalScore,
				majorBasis : unModifiedScoreArray[0].majorBasis, majorDesignated : unModifiedScoreArray[0].majorDesignated, majorFree : unModifiedScoreArray[0].majorFree, 
				secondMajorBasis : secondBasisScore, secondMajorDesignated : secondDesignatedScore, secondMajorFree : secondFreeScore, majorNormal : unModifiedScoreArray[0].majorNormal,
				cultureEssential : unModifiedScoreArray[0].cultureEssential, cultureA : unModifiedScoreArray[0].cultureA, cultureB : unModifiedScoreArray[0].cultureB, cultureFree : unModifiedScoreArray[0].cultureFree}, 2);
		}
		return 0;
	}
}
private var totalScore:int = 0;
private var majorTotal:int = 0;
private var secondMajorTotal:int = 0;
private var cultureTotal:int = 0;
private var majorBasis:int = 0;
private var majorDesignated:int = 0;
private var majorFree:int = 0;
private var secondMajorBasis:int = 0;
private var secondMajorDesignated:int = 0;
private var secondMajorFree:int = 0;
private var majorNormal:int = 0;
private var cultureEssential:int = 0;
private var cultureA:int = 0;
private var cultureB:int = 0;
private var cultureFree:int = 0;

private function addScore(kind:String, credit:int):int {
	totalScore += credit;
	switch(kind) {
		case "전기" :
			majorBasis += credit;
			majorTotal += credit;
			break;
		case "전지" :
			majorDesignated += credit;
			majorTotal += credit;
			break;
		case "전선" : 
			majorFree += credit;
			majorTotal += credit;
			break;
		case theSecondMajorTypeToColumn+"전기" :
			secondMajorBasis += credit;
			secondMajorTotal += credit;
			break;
		case theSecondMajorTypeToColumn+"전지" :
			secondMajorDesignated += credit;
			secondMajorTotal += credit;
			break;
		case theSecondMajorTypeToColumn+"전선" :
			secondMajorFree += credit;
			secondMajorTotal += credit;
			break;
		case "일선" :
			majorNormal += credit;
			cultureTotal += credit;
			break;
		case "교필" :
			cultureEssential += credit;
			cultureTotal += credit;
			break;
		case "핵교A" :
			cultureA += credit;
			cultureTotal += credit;
			break;
		case "핵교B" :
			cultureB += credit;
			cultureTotal += credit;
			break;
		case "일교" :
			cultureFree += credit;
			cultureTotal += credit;
			break;
	}
	scoreArray.setItemAt({index:"신청 학점", totalScore : totalScore, majorTotal : majorTotal, secondMajorTotal : secondMajorTotal, 
		majorBasis : majorBasis, majorDesignated : majorDesignated, majorFree : majorFree, cultureTotal : cultureTotal,
		secondMajorBasis : secondMajorBasis, secondMajorDesignated : secondMajorDesignated, secondMajorFree : secondMajorFree, majorNormal : majorNormal,
		cultureEssential : cultureEssential, cultureA : cultureA, cultureB : cultureB, cultureFree : cultureFree}, 1);
	scoreArray.setItemAt({index: "예상 총 학점", totalScore : scoreArray[0].totalScore +  totalScore, majorTotal : scoreArray[0].majorTotal +  majorTotal, secondMajorTotal : scoreArray[0].secondMajorTotal +  secondMajorTotal, 
		majorBasis : scoreArray[0].majorBasis +  majorBasis, majorDesignated : scoreArray[0].majorDesignated +  majorDesignated, majorFree : scoreArray[0].majorFree +  majorFree, cultureTotal : scoreArray[0].cultureTotal +  cultureTotal,
		secondMajorBasis : scoreArray[0].secondMajorBasis +  secondMajorBasis, secondMajorDesignated : scoreArray[0].secondMajorDesignated +  secondMajorDesignated, secondMajorFree : scoreArray[0].secondMajorFree +  secondMajorFree, majorNormal : scoreArray[0].majorNormal +  majorNormal,
		cultureEssential : scoreArray[0].cultureEssential +  cultureEssential, cultureA : scoreArray[0].cultureA +  cultureA, cultureB : scoreArray[0].cultureB +  cultureB, cultureFree : scoreArray[0].cultureFree +  cultureFree}, 2);
	return 0;
}
private function delScore(kind:String, credit:int):void {	
	totalScore -= credit;
	switch(kind) {
		case "전기" :
			majorBasis -= credit;
			majorTotal -= credit;
			break;
		case "전지" :
			majorDesignated -= credit;
			majorTotal -= credit;
			break;
		case "전선" : 
			majorFree -= credit;
			majorTotal -= credit;
			break;
		case theSecondMajorTypeToColumn+"전기" :
			secondMajorBasis -= credit;
			secondMajorTotal -= credit;
			break;
		case theSecondMajorTypeToColumn+"전지" :
			secondMajorDesignated -= credit;
			secondMajorTotal -= credit;
			break;
		case theSecondMajorTypeToColumn+"전선" :
			secondMajorFree -= credit;
			secondMajorTotal -= credit;
			break;
		case "일선" :
			majorNormal -= credit;
			cultureTotal -= credit;
			break;
		case "교필" :
			cultureEssential -= credit;
			cultureTotal -= credit;
			break;
		case "핵교A" :
			cultureA -= credit;
			cultureTotal -= credit;
			break;
		case "핵교B" :
			cultureB -= credit;
			cultureTotal -= credit;
			break;
		case "일교" :
			cultureFree -= credit;
			cultureTotal -= credit;
			break;
	}
	scoreArray.setItemAt({index:"신청 학점", totalScore : totalScore, majorTotal : majorTotal, secondMajorTotal : secondMajorTotal, 
		majorBasis : majorBasis, majorDesignated : majorDesignated, majorFree : majorFree, cultureTotal : cultureTotal,
		secondMajorBasis : secondMajorBasis, secondMajorDesignated : secondMajorDesignated, secondMajorFree : secondMajorFree, majorNormal : majorNormal,
		cultureEssential : cultureEssential, cultureA : cultureA, cultureB : cultureB, cultureFree : cultureFree}, 1);
	scoreArray.setItemAt({index: "예상 총 학점", totalScore : scoreArray[0].totalScore -  totalScore, majorTotal : scoreArray[0].majorTotal -  majorTotal, secondMajorTotal : scoreArray[0].secondMajorTotal -  secondMajorTotal, 
		majorBasis : scoreArray[0].majorBasis -  majorBasis, majorDesignated : scoreArray[0].majorDesignated -  majorDesignated, majorFree : scoreArray[0].majorFree -  majorFree, cultureTotal : scoreArray[0].cultureTotal -  cultureTotal,
		secondMajorBasis : scoreArray[0].secondMajorBasis -  secondMajorBasis, secondMajorDesignated : scoreArray[0].secondMajorDesignated -  secondMajorDesignated, secondMajorFree : scoreArray[0].secondMajorFree -  secondMajorFree, majorNormal : scoreArray[0].majorNormal -  majorNormal,
		cultureEssential : scoreArray[0].cultureEssential -  cultureEssential, cultureA : scoreArray[0].cultureA -  cultureA, cultureB : scoreArray[0].cultureB -  cultureB, cultureFree : scoreArray[0].cultureFree -  cultureFree}, 2);
}