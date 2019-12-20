<?php
require "PSWrequest.php";

$request = new PSWrequest("mySales.db");

$request->update("clients", $_POST, "_id_");
$request->getResponse();
$request->close();
?>
