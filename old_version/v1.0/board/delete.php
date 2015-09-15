<?

 include("../../ConDB.php");
 include("dbName.php");
 
 $subject = addslashes($subject);
 $memo = addslashes($memo);
 $id = addslashes($id);
 
 $query = "SELECT uid, fid, sort, id, writer, subject, memo, ip, date, hit, depth FROM $dbName WHERE uid='$uid'";
 $Result = mysql_query($query, $ConDB);
 $row = mysql_fetch_array($Result);
 
 $uid = $row[uid];
 $fid = $row[fid];
 $sort = $row[sort];
 $subject = $row[subject];
 $memo = $row[memo];
 $id = $row[id];
 $writer = $row[writer];
 $ip = $row[ip];
 $date = $row[date];
 $hit = $row[hit];
 $depth = $row[depth];
 
 $delete_db = $dbName."_delete";
 $query = "INSERT INTO $delete_db VALUES ('', '$fid', '$sort', '$id', '$writer', $subject', '$memo', '$ip', '$date', '$hit', '$depth')";
 $Result = mysql_query($query, $ConDB);

 $query = "UPDATE $dbName SET subject='삭제된 글입니다.', memo='삭제된 글입니다.' WHERE uid='$uid'";
 $Result = mysql_query($query, $ConDB);
 
 if($Result) {
 	$res = "ok";
 }else{
 	$res = "fail";
 }
 echo "Dummy=1&res=$res";
 mysql_close($ConDB);

?>