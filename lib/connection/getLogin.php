<?php
require_once('db.php');
$query = 'SELECT * FROM login';
$stm = $conn->prepare($query);
$stm->execute();
$row = $stm->fetchAll(PDO::FETCH_ASSOC);
echo json_encode($row);
?>