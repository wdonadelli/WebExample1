<?php
require "PSWrequest.php";

$request = new PSWrequest("mySales.db");

$request->insert("clients", $_POST);
$request->getResponse();
?>
