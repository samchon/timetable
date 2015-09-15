<? 

 include("../../ConDB.php");
 include("dbName.php");
 
 $query = "UPDATE $dbName SET hit = hit + 1 WHERE uid='$uid'";
 $Result = mysql_query($query, $ConDB);
 
 $query = "SELECT uid, fid, id, writer, subject, memo, ip, date, hit, depth FROM $dbName WHERE uid='$uid'";
 $Result = mysql_query($query, $ConDB);
 $row = mysql_fetch_array($Result);
 
 $uid = $row[uid];

 $subject = $row[subject];
 $subject = stripslashes($subject);
 $subject = str_replace("%", "%25", $subject);
 $subject = str_replace("&", "%26", $subject);
 $subject = str_replace("+", "%2B", $subject);

 $memo = $row[memo];
 $memo = stripslashes($memo);
 $memo = str_replace("%", "%25", $memo);
 $memo = str_replace("&", "%26", $memo);
 $memo = str_replace("+", "%2B", $memo);
 
 $id = $row[id];
 $id = stripslashes($id);
 $id = str_replace("%", "%25", $id);
 $id = str_replace("&", "%26", $id);
 $id = str_replace("+", "%2B", $id);
 
 $writer = $row[writer];
 $writer = stripslashes($writer);
 $writer = str_replace("%", "%25", $writer);
 $writer = str_replace("&", "%26", $writer);
 $writer = str_replace("+", "%2B", $writer);
 
 $ip = $row[ip];
 $date = date("Y.m.d H:i:s", $row[date]);
 $hit = $row[hit];
 $depth = $row[depth];

 for ($j=1; $j < $depth; $j++) {
	$subject = "\t" + $subject;
 }
 
 $str = "Dummy=1&";
 $str.= "uid=".$uid."&";
 $str.= "hit=".$hit."&";
 $str.= "date=".$date."&";
 $str.= "id=".$id."&";
 $str.= "writer=".$writer."&";
 $str.= "subject=".$subject."&";
 $str.= "memo=".$memo."&";
 $str.= "ip=".$ip;
 
 echo $str;
 mysql_close($ConDB);
 
?>