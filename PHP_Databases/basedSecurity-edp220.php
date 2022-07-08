<?php
    include_once ("basedSecurityfuncs/db.class.php");
    include_once ("basedSecurityfuncs/functions.class.php");

    Database::initialize();

    $response = array("msg" => "Invalid variable passed");


    if (empty($_POST['vendorID'])) {
        die(json_encode($response));
    }

    if (empty($_POST['deviceID'])) {
        die(json_encode($response));
    }

    if (empty($_POST['encryption'])) {
        die(json_encode($response));
    }

    if (strlen($_POST['vendorID']) > 5) {
        die(json_encode($response));
    }

    if (strlen($_POST['deviceID']) > 5) {
        die(json_encode($response));
    }

    $timestamp = substr(time(), 0, 9);

    $desync = $_POST['unix'] - $timestamp;

    $unix = $timestamp + $desync;
    
    if ($desync > 2) {
        functions::sendFailedLoad($unix, "Desync", $desync, $_POST['vendorID'], $_POST['deviceID'], "Desync is to large.", $timestamp, $_POST['unix']);
        $failed = array("msg" => "Reset system time");
        die(json_encode($failed));
    }

    $encrypt = md5($_POST['vendorID'] . $_POST['deviceID'] . $unix . "basedSecurity1");
    $key = md5($_POST['vendorID'] . $_POST['deviceID'] . $unix . "basedSecurity2");
    $clientEncrypt = $_POST['encryption'];

    $checkForLuas = mysqli_query(Database::$conn, "SELECT `luas` FROM users WHERE `username` = '{$_POST['username']}'");

    if ($clientEncrypt ==$encrypt) {
        $array = array("luas" => $checkForLuas);
        die(json_encode($array));
    } else {
        functions::sendFailedLoad($unix, "Desync", $desync, $_POST['vendorID'], $_POST['deviceID'], "heartbeat failed.", $timestamp, $_POST['unix']);
        $failed = array("msg" => "Lua heartbeat fail");
        die(json_encode($failed));
    }

?>