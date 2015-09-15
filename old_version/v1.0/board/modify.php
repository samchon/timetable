<?

 include("../../ConDB.php");
 include("dbName.php");

 $query = "UPDATE $dbName SET subject='$subject', memo='$memo', ip='$ip', date='$signdate' WHERE uid='$uid'";
 $Result = mysql_query($query, $ConDB);
 
 if($Result) {
 	$res = "ok";
 }else{
 	$res = "fail";
 }

 echo "Dummy=1&res=$res";
 mysql_close($ConDB);

?>