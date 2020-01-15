<?php
require "PSWrequest.php";
$query = 0;
$request = new PSWrequest("mySales.db");

switch ($action) {
	case 0:
		$request->insert($table, $_POST);
		break;
	case 1:
		$request->update($table, $_POST, "_id_");
		break;
	case 2:
		$request->delete($table, $_POST, "_id_");
		break;
	case 3:
		$request->view($table);
		$query = 1;
		break;
}

if ($query) {
	$request->getQuery();
} else {
	$request->getResponse();
}

$request->close();
?>
