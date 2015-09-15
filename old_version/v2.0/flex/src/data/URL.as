package data
{
	public class URL
	{
		public static const host:String = "http://samchon.org/";
		public static const url:String = host + "hansung/";														//게시판, 업데이터 정보
		public static const login:String = "http://info.hansung.ac.kr/servlet/s_gong.gong_login_ssl";			//로그인
		public static const semester:String = "http://info.hansung.ac.kr/servlet/s_jik.jik_siganpyo_s_up";		//년도, 학기를 알아보기 위한 공간
		public static const profile:String = "http://info.hansung.ac.kr/fuz/common/include/default/top.jsp";	//이름, 전공을 알아보기 위한 공간
		public static const lecture:String = "http://info.hansung.ac.kr/servlet/s_jik.jik_siganpyo_s_list";		//강의계획서 조회
		//http://info.hansung.ac.kr/servlet/s_jik.jik_siganpyo_s_list?year=2013&semester=1&majorcode=K131
		
		public static const history:String = "http://info.hansung.ac.kr/fuz/seongjeok/seongjeok.jsp";				//성적조회(누적) - 과목 코드를 구함
		public static const divide:String = "http://info.hansung.ac.kr/jsp/suup_pyunga/suup_pyunga_result_h.jsp";	//강의만족도 - 과거 시간표의 분반을 여기서 구한다.
	}
}