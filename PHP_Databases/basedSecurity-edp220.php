<?php
    include_once ("basedSecurityfuncs/db.class.php");
    include_once ("basedSecurityfuncs/functions.class.php");

    Database::initialize();

    $checkForLuas = mysqli_query(Database::$conn, "SELECT `luas` FROM users WHERE `username` = '{$_POST['username']}'");
    $THIS = mysqli_fetch_array($checkForLuas);
    $array = array("luas" => $THIS['luas']);
    die(json_encode($array));
?>