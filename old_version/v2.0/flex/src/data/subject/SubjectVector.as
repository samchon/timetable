package data.subject
{
	/*
	map<string, Subject*, less<string> >
	
		Dynamic class로 선언하면 현재 이 Subject에
		map<string, void*, less<string> > 의 변수를 하나 가지게 되며
		
		inline map<string, void*, less<string> > operator[](string& name) 의 함수도 추가되는 격이다
	*/
	public dynamic class SubjectVector
	{
		private var _length:int = 0;
		public function SubjectVector()
		{
			
		}
		public function push(subject:Subject):void {
			this[_length++] = subject;
			this[subject.code] = subject;
		}
		public function get length():int {
			return _length;
		}
	}
}