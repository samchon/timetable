<?

 include("../../ConDB.php");
 include("dbName.php");

 $query = "SELECT MAX(fid) FROM $dbName WHERE sort='$sort'";
 $Result = mysql_query($query,$ConDB);
 $row = mysql_fetch_row($Result);
 if (!$row) {
	 $fid = 0;
 }else{
	 $fid = $row[0] + 1;
 }

 $subject = addslashes($subject);
 $memo = addslashes($memo);
 $id = addslashes($id);
 $writer = addslashes($writer);

 $query = "INSERT INTO $dbName VALUES ('', '$fid', '$sort', '$id', '$writer', '$subject', '$memo', '$ip', '$signdate', '0', 'A')";
 $Result = mysql_query($query, $ConDB);

 if($Result) {
 	$res = "ok";
 }else{
 	$res = "fail";
 }
 echo "Dummy=1&res=$res";
 
 mysql_close($ConDB);

?>