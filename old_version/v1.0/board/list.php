<?

include("../../ConDB.php");
include("dbName.php");

$query = "SELECT count(*) FROM $dbName WHERE sort='$sort'";
$Result = mysql_query($query, $ConDB);
$total_num = mysql_result($Result,0,0);
mysql_free_result($Result);

if(!$page) {
	$page = 1;
}

$total_pagenum = ceil($total_num/$a_pagenum);
$first = $a_pagenum*($page-1);

if($searchType == "none") {
	$query = "SELECT uid,id,writer,subject,date,depth,hit FROM $dbName WHERE sort='$sort' ORDER BY fid DESC, depth ASC LIMIT $first, $a_pagenum";
}else{
	$query = "SELECT count(*) FROM $dbName WHERE sort='$sort' AND $searchType LIKE '%$searchTxt%'";
	$Reslt = mysql_query($query, $ConDB);
 	$Result = mysql_query($query, $ConDB);
	$total_num = mysql_result($Result,0,0);
	mysql_free_result($Result);
	
	$query = "SELECT uid,id,writer,subject,date,depth FROM $dbName WHERE sort='$sort' AND $searchType LIKE '%$searchTxt%' ORDER BY fid DESC, depth ASC LIMIT $first, $a_pagenum";
}
$Result = mysql_query($query, $ConDB);
$first_num = $total_num - $first;
$str = "Dummy=1&";

$i = 0;
while ($row = mysql_fetch_array($Result)) {
	$uid = $row[uid];
    $id = $row[id];
	$writer = $row[writer];
    $subject = $row[subject];
	$hit = $row[hit];
    if ( date("Ymd",$signdate) == date("Ymd", $row[date]) ) {
		$date = date("H:i:s", $row[date]);
    }else{
		$date = date("Y.m.d", $row[date]);
    }
    $depth = strlen($row[depth]);
	
	$subject = stripslashes($subject);
    $subject = str_replace("%", "%25", $subject);
    $subject = str_replace("&", "%26", $subject);
    $subject = str_replace("+", "%2B", $subject);
	$subject = $subject;
	
	$id = stripslashes($id);
    $id = str_replace("%", "%25", $id);
    $id = str_replace("&", "%26", $id);
    $id = str_replace("+", "%2B", $id);
	
	$writer = stripslashes($writer);
    $writer = str_replace("%", "%25", $writer);
    $writer = str_replace("&", "%26", $writer);
    $writer = str_replace("+", "%2B", $writer);

    $str.="uid".$i."=".$uid."&";
    $str.="id".$i."=".$id."&";
	$str.="writer".$i."=".$writer."&";
	$str.="subject".$i."=".$subject."&";
    $str.="date".$i."=".$date."&";
	$str.="hit".$i."=".$hit."&";
	$str.="depth".$i."=".$depth."&";
    $i++;
}
$str.="total_pagenum=".$total_pagenum."&";
$str.="page=".$page."&";
$str.="first_num=".$first_num."&";
$str.="amount=".$i;

echo $str;
mysql_close($ConDB);

?>