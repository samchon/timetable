<?

	include("../../ConDBi.php");
	include("dbName.php");
	
	$uid = $_POST["uid"];
	
	$stmt -> prepare("UPDATE {$dbName} SET isSurvive = 0 WHERE uid = ?");
	$stmt -> bind_param("d", $uid);
	$stmt -> execute();
	
	if($stmt -> affected_rows > 0)
		$res = "ok";
	else
		$res = "fail";
	echo "Dummy=1&res=$res";
	
	$stmt -> close();
	$mysqli -> close();

?>