package data.html
{
	public class TimeIndex
	{
		private var _hour:int;
		private var _day:int;
		
		public function TimeIndex(h:int, d:int)
		{
			_hour = h;
			_day = d;
		}
		public function get hour():int	{	return _hour;	}
		public function get day():int	{	return _day;	}
	}
}