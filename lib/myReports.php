<?php
require "PSWrequest.php";

$request = new PSWrequest("mySales.db");

switch($_GET["tab"]) {
	case "Clients":
		$request->view("clients");
		break;
	case "logClients":
		$request->view("_clients_");
		break;
	case "Products":
		$request->view("products");
		break;
	case "logProducts":
		$request->view("_products_");
		break;
	case "Sales":
		$request->view("sales");
		break;
	case "logSales":
		$request->view("_sales_");
		break;
};

$request->getQuery();
?>
