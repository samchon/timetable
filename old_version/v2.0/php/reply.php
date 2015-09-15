<?

	include("../../ConDBi.php");
	include("dbName.php");
	
	$uid = $_POST["uid"];
	$id = $_POST["id"];
	$subject = $_POST["subject"];
	$memo = $_POST["memo"];
	
	$query = "SELECT fid, depth, sort FROM $dbName WHERE uid = ?"; //$uid
	$stmt -> prepare($query);
	$stmt -> bind_param("d", $uid);
	
	$stmt -> execute();
	$stmt -> bind_result($fid, $depth, $sort);
	$stmt -> fetch();
	
	$query = "	SELECT depth, right(depth,1) 
				FROM $dbName 
				WHERE fid = ?
				AND length(depth) = length(?)+1 
					AND locate(?, depth) = 1 
				ORDER BY depth DESC LIMIT 1";
	$stmt -> prepare($query);
	$stmt -> bind_param("dss", $fid, $depth, $depth);
	
	$stmt -> execute();
	$stmt -> bind_result($result_depth, $result_right);
	$stmt -> fetch();
	
	if($result_depth) {
		$depth_head = substr($result_depth, 0, -1);
		$depth_foot = ++$result_right;
		$new_depth = $depth_head.$depth_foot;
	} else
		$new_depth = $depth."A";
	
	$subject = addslashes($subject);
	$memo = addslashes($memo);
	
	//uid, fid, sort, isSurvive, id, subject, memo, ip, timestamp, hit, depth
	$query = "INSERT INTO $dbName VALUES ('', ?, ?, 1, ?, ?, ?, ?, now(), 0, ?)";
	$stmt -> prepare($query);
	$stmt -> bind_param("dssssss", $fid, $sort, $id, $subject, $memo, $ip, $new_depth);
	$stmt -> execute();
	
	if($stmt -> affected_rows > 0)
		$res = "ok";
	else
		$res = "fail";
	 
	echo "Dummy=1&res=$res";
	
	$stmt -> close();
	$mysqli -> close();

?>