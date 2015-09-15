<?

	include("../../ConDBi.php");
	include("dbName.php");
	
	$searchType = $_POST["searchType"];
	$searchTxt = $_POST["searchTxt"];
	
	$a_pagenum = $_POST["a_pagenum"];
	$page = $_POST["page"];
	$sort = $_POST["sort"];
		
	if($searchType == "none")
		$query = "SELECT count(*) FROM $dbName WHERE sort = ? AND isSurvive = 1";
	else
		$query = "SELECT count(*) FROM $dbName WHERE sort = ? AND {$searchType} LIKE '%{$searchTxt}%' AND isSurvive = 1";
		
	$stmt -> prepare($query);
	$stmt -> bind_param("s", $sort);
	$stmt -> execute();
	$stmt -> bind_result($total_num); //--> count(*) to $total_num
	$stmt -> fetch();
	
	if(!$page)
		$page = 1;
	$total_pagenum = ceil($total_num/$a_pagenum);
	$first = $a_pagenum*($page-1);
	
	if($searchType == "none")
		$query = 
		"
			SELECT 
				B.uid, B.fid, concat_ws('', M.name, '(', B.id, ')') nick, B.subject, B.ip, 
				CASE date_format(B.timestamp, '%Y-%m-%d') != date_format(now(), '%Y-%m-%d')
					WHEN TRUE THEN date_format(timestamp, '%Y-%m-%d')
					ELSE date_format(timestamp, '%H:%i:%S')
				END as timestamp,
				B.hit, B.depth
			FROM
				$dbName B INNER JOIN Hansung.member M
					ON B.id = M.id
			WHERE B.sort = ? AND B.isSurvive = 1
			ORDER BY B.fid DESC, B.depth ASC LIMIT ?, ?
		";
	else
		$query =
		"	
			SELECT * FROM
			(
				SELECT 
					B.uid, B.fid, concat_ws('', M.name, '(', B.id, ')') nick, B.subject, B.ip, 
					CASE date_format(B.timestamp, '%Y-%m-%d') != date_format(now(), '%Y-%m-%d')
						WHEN TRUE THEN date_format(timestamp, '%Y-%m-%d')
						ELSE date_format(timestamp, '%H:%i:%S')
					END as timestamp,
					B.hit, B.depth
				FROM
					$dbName B INNER JOIN Hansung.member M
						ON B.id = M.id
				WHERE B.sort = ? AND B.isSurvive = 1
			) T
			WHERE {$searchType} LIKE '%{$searchTxt}%'
			ORDER BY fid DESC, depth ASC LIMIT ?, ?
		";

	$stmt -> prepare($query);
	$stmt -> bind_param("sdd", $sort, $first, $a_pagenum);
	$stmt -> execute();
	$stmt -> bind_result($uid, $fid, $nick, $subject, $ip, $timestamp, $hit, $depth);	
	
	$first_num = $total_num - $first;
	$str = "Dummy=1";
	$i = 0;
	
	while( $stmt -> fetch() ) {
		$line = "";
		$depth = strlen($depth);
		
		$subject = stripslashes($subject);
		$subject = str_replace("%", "%25", $subject);
		$subject = str_replace("&", "%26", $subject);
		$subject = str_replace("+", "%2B", $subject);
		
		$line.= "&uid{$i}={$uid}";
		$line.= "&fid{$i}={$fid}";
		$line.= "&nick{$i}={$nick}";
		$line.= "&subject{$i}={$subject}";
		$line.= "&memo{$i}={$memo}";
		$line.= "&ip{$i}={$ip}";
		$line.= "&timestamp{$i}={$timestamp}";
		$line.= "&hit{$i}={$hit}";
		$line.= "&depth{$i}={$depth}";
		
		$str.= $line;
		$i++;
	}
	$str.="&total_pagenum=".$total_pagenum;
	$str.="&page=".$page;
	$str.="&first_num=".$first_num;
	$str.="&length=".$i;
	
	echo $str;
	$stmt -> close();
	$mysqli -> close();

?>