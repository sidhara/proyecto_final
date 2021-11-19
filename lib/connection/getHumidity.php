<?php
require_once('dbHumidity.php');

$username=$_GET['username'];

$query = "SELECT * FROM data WHERE username = '$username'";
$stm = $conn->prepare($query);
$stm->execute();
$row = $stm->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($row);
?>