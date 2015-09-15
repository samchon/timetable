import data.base.Score;
import data.history.History;

private function calcScore(index:int):void {
	var codes:Vector.<String> = new Vector.<String>(); //???
	var i:int, j:int, k:int;
	var isDuplicated:Boolean;
	var kind:String;
	
	scoreAC.removeAll();
	scoreAC.addItem( new Score("기존 학점") );
	scoreAC.addItem( new Score("신청 학점") );
	scoreAC.addItem( new Score("총 학점") );
	
	var history:History = History.vector[index];
	
	//기존 학점
	for(i = 0; i < index; i++) {
		for(j = 0; j < History.vector[i].length; j++) {
			isDuplicated = false;
			for(k = 0; k < codes.length; k++)
				if(History.vector[i][j].code == codes[i])
					isDuplicated = true;
			
			if(isDuplicated == true)
				continue;
			
			codes.push( History.vector[i][j].code );
			scoreAC[0][ History.vector[i][j].kind ] += History.vector[i][j].credit;
		}
	}
	scoreAC[0].calc();
	
	//신청 학점
	for(i = 0; i < history.length; i++)
		scoreAC[1][ history[i].kind ] += history[i].credit;
	scoreAC[1].calc();
	
	//총 학점
	scoreAC[2].add(scoreAC[0]);
	for(i = 0; i < history.length; i++) {
		isDuplicated = false;
		for(j = 0; j < codes.length; j++)
			if(history[i].code == codes[j]) {
				isDuplicated = true;
				break;
			}
		if(isDuplicated)
			continue;
		
		codes.push( history[i].code );
		scoreAC[2][ history[i].kind ] += history[i].credit;
	}
	scoreAC[2].calc();
	scoreAC.refresh();
}