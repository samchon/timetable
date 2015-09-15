package data
{
	import flash.utils.ByteArray;

	public class Util
	{
		//엔터, 탭을 모두 지워준다. 파싱을 위해 필요함
		public static function emptyRemover(str:String):String {
			str = str.replace(RegExp(/\n/g), "");
			str = str.replace(RegExp(/\r/g), "");
			str = str.replace(RegExp(/\t/g), "");
			
			return str;
		}
		
		//앞뒤의 공백을 없애준다. -> gapRemover("  ABCD EFGH   ") -> "ABCD EFGH"
		public static function gapRemover(str:String):String {
			while (str.charAt(0) == " ")
				str = str.substr(1);
			while (str.charAt(str.length - 1) == " ")
				str = str.substr(0,str.length - 1);
			return str;
		}
		
		//var value:String = "ABCD|EFGH|IJK" -> between(value, "|", "|") -> result: EFGH
		public static function between(targ:String, start:* = null, last:* = null):String {
			if(start == null)
				return targ.substring(0, targ.indexOf(last));
			else if(last == null)
				return targ.substring(targ.indexOf(start) + start.length);
			else {
				var startPoint:int = targ.indexOf(start) + start.length;
				return targ.substring(targ.indexOf(start) + start.length, targ.indexOf(last, startPoint));
			}
		}
		
		//between은 하나만 한다. 이건 between 여러개를 해서 배열로 만들어준다.
		public static function betweens(targ:String, start:*, last:* = null):Array {
			var array:Array = targ.split(start);
			array.splice(0, 1);
			
			if(last != null)
				for(var i:int = 0; i < array.length; i++)
					array[i] = between(array[i], null, last);
			
			return array;
		}
		
		//EUC-KR -> UTF-8 변환을 위해 쓴다.
		public static function encode(bytes:ByteArray):String {
			if(
				(bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF) ||						//UTF-8 with BOM
				(bytes[0] == 0xFE && bytes[1] == 0xFF) ||											//UTF-16 Big Endian
				(bytes[0] == 0xFF && bytes[1] == 0xFE) ||											//UTF-16 Little Endian
				(bytes[0] == 0x0  && bytes[1] == 0x0  && bytes[2] == 0xFE && bytes[3] == 0xFF) ||	//UTF-32 Big Endian
				(bytes[0] == 0xFF && bytes[1] == 0xFE && bytes[2] == 0x0  && bytes[3] == 0x0)
			)
				return bytes.toString();
			
			//기타
			var ansiStr:String = bytes.readMultiByte(bytes.bytesAvailable, "ANSI");
			var unicodeStr:String = bytes.toString();
			
			if(ansiStr.length < unicodeStr.length)
				return ansiStr;
			else
				return unicodeStr;
		}
	}
}