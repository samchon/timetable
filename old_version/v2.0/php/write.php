<?

	include("../../ConDBi.php");
	include("dbName.php");
	
	$subject = addslashes($subject);
	$memo = addslashes($memo);
	
	$sort = $_POST["sort"];
	$id = $_POST["id"];
	$subject = $_POST["subject"];
	$memo = $_POST["memo"];
	
	//uid, fid, sort, isSurvive, id, subject, memo, ip, timestamp, hit, depth
	//sort, id, subject, memo, ip
	$query = 
	"
		INSERT INTO {$dbName}
		SELECT 
			'',
			COALESCE(MAX(fid), 0) + 1,
			?,
			1,
			?,
			?,
			?,
			?,
			now(),
			0,
			'A'
		FROM {$dbName}
	";
	$stmt -> prepare($query);
	$stmt -> bind_param("sssss", $sort, $id, $subject, $memo, $ip);
	$stmt -> execute();
	
	if( $stmt -> affected_rows > 0 )
		$res = "ok";
	else
		$res = "fail";
	echo "Dummy=1&res=$res";
	
	$stmt -> close();
	$mysqli -> close();
	
	//$name)

?>