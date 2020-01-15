<?php
$action = 3;

switch($_GET["tab"]) {
	case "clients":
		$table = "_vw_clients";
		break;
	case "logclients":
		$table = "_log_clients";
		break;
	case "products":
		$table = "_vw_products";
		break;
	case "logproducts":
		$table = "_log_products";
		break;
	case "sales":
		$table = "_vw_sales";
		break;
	case "logsales":
		$table = "_log_sales";
		break;
};

require "crud.php";
?>
