package data.base
{
	public class Score
	{
		public var sort:String;
		public var 총점:int	=	0;
		public var 전공:int	=	0;
		public var 전기:int	=	0;
		public var 전지:int	=	0;
		public var 전선:int	=	0;
		public var 다전공:int	=	0;
		public var 다전기:int	=	0;
		public var 다전지:int	=	0;
		public var 다전선:int	=	0;
		public var 교양:int	=	0;
		public var 교필:int	=	0;
		public var 핵교A:int	=	0;
		public var 핵교B:int	=	0;
		public var 일교:int	=	0;
		public var 일선:int	=	0;
		
		public function Score(title:String) {
			sort = title;
		}
		public function add(score:Score):void {
			this.총점		+=	score.총점;
			this.전공		+=	score.전공;
			this.전기		+=	score.전기;
			this.전지		+=	score.전지;
			this.전선		+=	score.전선;
			this.다전공	+=	score.다전공;
			this.다전기	+=	score.다전기;
			this.다전지	+=	score.다전지;
			this.다전선	+=	score.다전선;
			this.교양		+=	score.교양;
			this.교필		+=	score.교필;
			this.핵교A	+=	score.핵교A;
			this.핵교B	+=	score.핵교B;
			this.일교		+=	score.일교;
			this.일선		+=	score.일선;
		}
		public function calc():void {
			전공	=	전기 + 전지 + 전선;
			다전공	=	다전기 + 다전지 + 다전선;
			교양	=	교필 + 핵교A + 핵교B + 일교;
			총점	=	전공 + 다전공 + 교양 + 일선;
		}
	}
}