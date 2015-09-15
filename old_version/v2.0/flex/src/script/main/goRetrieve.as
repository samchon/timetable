import data.base.Retrieve;
import data.subject.Lecture;
import data.subject.Subject;

private function goRetrieve(index:int, value:String):void {
	lectureAC.removeAll();

	var column:String;
	var i:int;
	var j:int;
	
	switch(index) {
		case Retrieve.NAME:
			column = "name";
			break;
		case Retrieve.CODE:
			column = "code";
			break;
		case Retrieve.PROFESSOR:
			column = "professor";
			break;
		case Retrieve.KIND:
			column = "kind";
			break;
	}
	
	for(i = 0; i < subjects.length; i++)
		for(j = 0; j < subjects[i].length; j++)
			if( nameFilter(subjects[i][j][column]).indexOf(nameFilter(value)) != -1 )
				lectureAC.addItem( subjects[i][j] );
}
private function nameFilter(value:String):String {
	value = value.replace(RegExp(/ /g), "");
	value = value.toUpperCase();
	
	return value;
}