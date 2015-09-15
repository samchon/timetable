package Classes.aql 
{
	import flash.net.URLVariables;
	import flash.system.System;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;

	public class aql
	{
		private var Index:Object;
		private var $queryArray:String = null;
		public function aql(index:Object) {
			Index = index;
		}
		public function push($query:String):void {
			if(!$query || $query == "")
				return;
			if(!$queryArray)
				$queryArray = $query;
			else
				$queryArray += " or " + $query.split(" where ")[1];
		}
		public function refresh():void {
			$queryArray = null;
		}
		public function deleteAll():URLVariables {
			var replyData:URLVariables = query($queryArray);
			refresh();
			return replyData;
		}
		public function query($query:String):URLVariables {
			if($query.indexOf(" ") == -1 || $query.indexOf(" from ") == -1)
				return null;
			var returnValue:String = null;
			var startPoint:String = $query.split(" ")[0].toLocaleLowerCase();
			var $target:String = $query.split(" from ")[1].split(" ")[0];
			if($target.indexOf("`") != -1)
				$target = $target.split("`")[1].split("`")[0];
			var andBoolean:Boolean = false;
			
			var whereItemArray:Array = [];
			var whereValueArray:Array = [];
			var whereFormulaArray:Array = [];
			var whereString:String = "";
			if($query.indexOf(" where ") != -1) {
				whereString = $query.split(" where ")[1];
				var whereArray:Array = [];
				if(whereString.indexOf(" and ") != -1) {
					whereArray = whereString.split(" and ");
					andBoolean = true;
				}else if(whereString.indexOf(" or ") != -1) {
					whereArray = whereString.split(" or ");
				}else{
					whereArray.push(whereString);
				}
				for(var $w:int = 0; $w < whereArray.length; $w++) {
					if(whereArray[$w].indexOf(">=") != -1)
						whereFormulaArray.push(">=");
					else if(whereArray[$w].indexOf("<=") != -1)
						whereFormulaArray.push("<=");
					else if(whereArray[$w].indexOf("=") != -1)
						whereFormulaArray.push("=");
					else if(whereArray[$w].indexOf(">") != -1)
						whereFormulaArray.push(">");
					else if(whereArray[$w].indexOf("<") != -1)
						whereFormulaArray.push("<");
					whereItemArray.push(whereArray[$w].split(whereFormulaArray[$w])[0]);
					whereValueArray.push(whereArray[$w].split(whereFormulaArray[$w])[1]);
				}
				for(var $i:int = 0; $i < whereItemArray.length; $i++) {
					if(whereItemArray[$i].indexOf("`") != -1)
						whereItemArray[$i] = whereItemArray[$i].split("`")[1];
					else
						whereItemArray[$i] = whereItemArray[$i].replace(RegExp(/ /g), "");
					
					if(whereValueArray[$i].indexOf("'") != -1)
						whereValueArray[$i] = whereValueArray[$i].split("'")[1];
					else
						whereValueArray[$i] = whereValueArray[$i].replace(RegExp(/ /g), "");
				}
			}
			var selectItemArray:Array = [];
			switch(startPoint) {
				case "select" :
					var selectItemString:String = $query.split("select ")[1].split(" from ")[0];
					if(selectItemString.indexOf("`") != -1) {
						var tempSelectArray:Array = selectItemString.split("`");
						for(var $t:int = 1; $t < tempSelectArray.length; $t = $t + 2)
							selectItemArray.push(tempSelectArray[$t]);
					}else{
						var selectItemTempString:String = selectItemString.replace(RegExp(/ /g), "");
						selectItemArray = selectItemTempString.split(",");
					}
					returnValue = select($target, selectItemArray, whereItemArray, whereFormulaArray, whereValueArray, andBoolean, [], [], false);
					break;
				case "update" :
					break;
				case "modify" :
					break;
				case "delete" :
					selectItemArray.push("index");
					var deleteVariables:URLVariables = new URLVariables(select($target, selectItemArray, whereItemArray, whereFormulaArray, whereValueArray, andBoolean, [], [], false));
					if(!deleteVariables)
						return null;
					for(var $di:int = int(deleteVariables.length) - 1; $di >= 0; $di--)
						Index[$target].removeItemAt(deleteVariables["index"+$di]);
					returnValue = "res=ok&";
					break;
				case "insert" :
					break;
			}
			if(returnValue)
				return new URLVariables(returnValue);
			else
				return null;
		}
		private function select($target:String, selectItemArray:Array, whereItemArray:Array, whereFormulaArray:Array, whereValueArray:Array, whereAnd:Boolean, likeItemArray:Array, likeValueArray:Array, likeAnd:Boolean):String {
			var returnVariables:String = "";
			var i:int = 0;
			var andCount:int;
			var andLength:int = whereAnd ? whereItemArray.length : 1;
			for(var $i:int = 0; $i < Index[$target].length; $i++) {
				andCount = 0;
				if(whereItemArray.length != 0) {
					for(var $j:int = 0; $j < whereItemArray.length; $j++) {
						switch(whereFormulaArray[$j]) {
							case "=" :
								if(Index[$target][$i][whereItemArray[$j]] == whereValueArray[$j])
									andCount++;
								else if(whereItemArray[$j] == "index" && int(whereValueArray[$j]) == $i)
									andCount++;
								break;
							case ">" :
								if(Number(Index[$target][$i][whereItemArray[$j]]) < Number(whereValueArray[$j]))
									andCount++;
								else if(whereItemArray[$j] == "index" && int(whereValueArray[$j]) < $i)
									andCount++;
								break;
							case ">=" :
								if(Number(Index[$target][$i][whereItemArray[$j]]) <= Number(whereValueArray[$j]))
									andCount++;
								else if(whereItemArray[$j] == "index" && int(whereValueArray[$j]) <= $i)
									andCount++;
								break;
							case "<" :
								if(Number(Index[$target][$i][whereItemArray[$j]]) > Number(whereValueArray[$j]))
									andCount++;
								else if(whereItemArray[$j] == "index" && int(whereValueArray[$j]) > $i)
									andCount++;
								break;
							case "<=" :
								if(Number(Index[$target][$i][whereItemArray[$j]]) >= Number(whereValueArray[$j]))
									andCount++;
								else if(whereItemArray[$j] == "index" && int(whereValueArray[$j]) >= $i)
									andCount++;
								break;
						}
					}
				}else{
					andCount = 1;
				}
				if(andCount >= andLength) {
					for(var $k:int = 0; $k < selectItemArray.length; $k++)
						if(selectItemArray[$k] == "index") {
							returnVariables += "index" + i + "=" + $i + "&";
						} else {
							returnVariables += selectItemArray[$k] + i + "=" + Index[$target][$i][selectItemArray[$k]] + "&";
						}
					i++;
				}
			}
			if(!returnVariables) {
				return null;
			}else{
				return returnVariables + "length="+i;
			}
		}
	}
}