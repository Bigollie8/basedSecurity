<?php
    include_once ("toucanfuncs/db.class.php");
    include_once ("toucanfuncs/functions.class.php");

    Database::initialize();

    $sentName = $_POST['username'];

    $banUser = mysqli_query(Database::$conn, "UPDATE users SET `blocked` = 1 WHERE `username` = '$sentName'") or die("Failed to ban user");

    die("Success");
?>