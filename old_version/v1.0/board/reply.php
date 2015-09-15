<?

 include("../../ConDB.php");
 include("dbName.php");

 $query = "SELECT fid, depth FROM $dbName WHERE uid='$uid'";
 $Result = mysql_query($query, $ConDB);
 $fid = mysql_Result($Result,0,0);
 $depth = mysql_Result($Result,0,1);
 mysql_free_Result($Result);
 
 $query = "SELECT depth,right(depth,1) FROM $dbName WHERE fid = $fid AND length(depth) = length('$depth')+1 AND locate('$depth',depth) = 1 ORDER BY depth DESC LIMIT 1";
 $Result = mysql_query($query, $ConDB); 
 $rows = mysql_num_rows($Result);
 if($rows) {
     $row = mysql_fetch_row($Result);
     $depth_head = substr($row[0],0,-1);
     $depth_foot = ++$row[1];
     $new_depth = $depth_head . $depth_foot;
 } else {
     $new_depth = $depth . "A";
 }

 $id = addslashes($id);
 $writer = addslashes($writer);
 $subject = addslashes($subject);
 $memo = addslashes($memo);

 $query = "INSERT INTO $dbName VALUES ('', '$fid', '$sort', '$id', '$writer', '$subject', '$memo', '$ip', '$signdate', '0', '$new_depth')";
 $Result = mysql_query($query,$ConDB);
 if($Result) {
 	$res = "ok";
 }else{
 	$res = "fail";
 }
 
 echo "Dummy=1&res=$res";
 mysql_close($ConDB);

?>