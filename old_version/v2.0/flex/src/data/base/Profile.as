package data.base
{

	public class Profile
	{
		//기본 신상 정보
		public static var id:String;	//학번
		public static var name:String;	//이름
		
		//전공 및 이차전공 정보
		public static var major:int = -1;			//전공 - Major.list[i]의 i에 해당
		[Bindable]public static var secondMajorType:int = 0;	//전공 타입 - 0: 심화, 1: 복수, 2: 부
		public static var secondMajor:int = -1;		//이차전공, 전공(위의 int major 변수)과 마찬가지로  Major.list[i]의 i에 해당
		
		//현재의 년, 학기
		public static var year:int;
		public static var semester:int;
		
		//초기화, 로그아웃 때 쓴다.
		public static function clear():void {
			id = name = "";
			major = secondMajor = -1;
			secondMajorType = 0;
			year = semester = 0;
		}
	}
}