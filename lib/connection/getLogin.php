<?php
require_once('dbLogin.php');

$email=$_GET['email'];
$password=$_GET['password'];

$query = "SELECT * FROM accounts Where email = '$email'";
$stm = $conn->prepare($query);
$stm->execute();
$row = $stm->fetchAll(PDO::FETCH_ASSOC);

if(empty($row)){
    echo json_encode($row);
}else{
    
    if(password_verify($password, $row[0]['password'])){
        echo json_encode($row);
    }else{
        $row=[];
        echo json_encode($row);
    }
}
?>