<?

	include("../../ConDBi.php");
	include("dbName.php");
	
	$uid = $_POST["uid"];
	$subject = $_POST["subject"];
	$memo = $_POST["memo"];
	
	$stmt -> prepare("UPDATE {$dbName} SET subject = ?, memo = ?, ip = ?, timestamp = now() WHERE uid = ?");
	$stmt -> bind_param("sssd", $subject, $memo, $ip, $uid);
	$stmt -> execute();
	
	if($stmt -> affected_rows > 0)
		$res = "ok";
	else
		$res = "fail";
	echo "Dummy=1&res=$res";
	
	$stmt -> close();
	$mysqli -> close();

?>