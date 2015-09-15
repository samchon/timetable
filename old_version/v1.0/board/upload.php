<?
	$currentPath = "http://gotoweb.co.kr/hansung/board/";

	if($Path) {
		mkdir("uploads/".$Path);
		$uploadPath = "uploads/".$Path."/";
	}else{
		$uploadPath = "uploads/";
	}
	
	$fileName = basename($_FILES['Filedata']['name']);
	$finalName = $uploadPath.time()."_".rand()."_".$fileName;
	$exportName = $currentPath.$finalName;
	//$exportName = $finalName;

	if(move_uploaded_file($_FILES['Filedata']['tmp_name'], $finalName))
		echo "Dummy=1&res=ok&fileName=$fileName&filePath=$exportName";
	else
		echo "Dummy=1&res=failed";
?>