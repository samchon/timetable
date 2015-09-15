<? 

	include("../../ConDBi.php");
	include("dbName.php");
	
	$uid = $_POST["uid"];
	
	$query = "UPDATE $dbName SET hit = hit + 1 WHERE uid = ?"; //$uid
	$stmt -> prepare($query);
	$stmt -> bind_param("d", $uid);
	$stmt -> execute();
	 
	$query = 
	"
		SELECT uid, fid, concat_ws('', name, '(', B.id, ')') nick, subject, memo, timestamp, ip, hit, depth 
		FROM
			$dbName B INNER JOIN Hansung.member M
				ON B.id = M.id
		WHERE uid = ?"; //$uid
	$stmt -> prepare($query);
	$stmt -> bind_param("d", $uid);
	
	$stmt -> execute();
	//uid, fid, sort, isSurvive, id, subject, memo, ip, timestamp, hit, depth
	$stmt -> bind_result($uid, $fid, $nick, $subject, $memo, $timestamp, $ip, $hit, $depth);
	$stmt -> fetch();
	
	$subject = stripslashes($subject);
	$subject = str_replace("%", "%25", $subject);
	$subject = str_replace("&", "%26", $subject);
	$subject = str_replace("+", "%2B", $subject);
	
	$memo = stripslashes($memo);
	$memo = str_replace("%", "%25", $memo);
	$memo = str_replace("&", "%26", $memo);
	$memo = str_replace("+", "%2B", $memo);
	
	for ($j=1; $j < $depth; $j++)
		$subject = "\t" + $subject;
	 
	$str = "Dummy=1&";
	$str.= "uid=".$uid."&";
	$str.= "hit=".$hit."&";
	$str.= "timestamp=".$timestamp."&";
	$str.= "nick=".$nick."&";
	$str.= "subject=".$subject."&";
	$str.= "memo=".$memo."&";
	$str.= "ip=".$ip;
	 
	echo $str;
	
	$stmt -> close();
	$mysqli -> close();
 
?>