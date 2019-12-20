<?php
require "PSWrequest.php";

$request = new PSWrequest("mySales.db");

switch($_GET["tab"]) {
	case "clients":
		$request->view("_vw_clients");
		break;
	case "logclients":
		$request->view("_log_clients");
		break;
	case "products":
		$request->view("_vw_products");
		break;
	case "logproducts":
		$request->view("_log_products_");
		break;
	case "sales":
		$request->view("_vw_sales");
		break;
	case "logsales":
		$request->view("_log_sales_");
		break;
};

$request->getQuery();
$request->close();
?>
