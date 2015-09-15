import data.base.Score;
import data.history.History;

import flash.sampler.Sample;

import mx.collections.ArrayCollection;

[Bindable]private var scoreAC:ArrayCollection = new ArrayCollection();
public function calcScore(isFirst:Boolean = false):void {
	trace("calcScore");
	var codes:Vector.<String> = new Vector.<String>(); //???
	var i:int, j:int, k:int;
	var isDuplicated:Boolean;
	var kind:String;
	
	if(isFirst == true) {
		scoreAC.addItem( new Score("기존 학점") );
		scoreAC.addItem( new Score("신청 학점") );
		scoreAC.addItem( new Score("총 학점") );
		
		//기존 학점
		for(i = 0; i < History.vector.length; i++) {
			for(j = 0; j < History.vector[i].lectures.length; j++) {
				isDuplicated = false;
				for(k = 0; k < codes.length; k++)
					if(History.vector[i].lectures[j].code == codes[i])
						isDuplicated = true;
				
				if(isDuplicated == true)
					continue;
				
				codes.push( History.vector[i].lectures[j].code );
				scoreAC[0][ History.vector[i].lectures[j].kind ] += History.vector[i].lectures[j].credit;
			}
		}
		scoreAC[0].calc();
	}else{
		scoreAC[1] = new Score("신청 학점");
		scoreAC[2] = new Score("총 학점");
	}
	//신청 학점
	for(i = 0; i < applyAC.length; i++)
		scoreAC[1][ applyAC[i].kind ] += applyAC[i].credit;
	scoreAC[1].calc();
	
	//총 학점
	scoreAC[2].add(scoreAC[0]);
	for(i = 0; i < applyAC.length; i++) {
		isDuplicated = false;
		for(j = 0; j < codes.length; j++)
			if(applyAC[i].code == codes[j]) {
				isDuplicated = true;
				break;
			}
		if(isDuplicated)
			continue;
		
		codes.push( applyAC[i].code );
		scoreAC[2][ applyAC[i].kind ] += applyAC[i].credit;
	}
	scoreAC[2].calc();
	scoreAC.refresh();
}