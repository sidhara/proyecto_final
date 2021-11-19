<?php
$servername = "localhost";
$username = "id17787775_root";
$password = "^C/EQ[1UD]qyG_*4";
$database = "users";

try {
    $conn = new PDO("mysql:host=$servername;dbname=$database", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    //echo "Connected successfully"; 
    } catch(PDOException $e) {    
    //echo "Connection failed: " . $e->getMessage();
    }
?>