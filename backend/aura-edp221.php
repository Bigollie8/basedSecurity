<?php
include_once ("aurafuncs/db.class.php");
include_once ("aurafuncs/functions.class.php");

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

if ($clientEncrypt ==$encrypt) {
    $array = array("same" => $key);
    die(json_encode($array));
} else {
    functions::sendFailedLoad($unix, "Desync", $desync, $_POST['vendorID'], $_POST['deviceID'], "heartbeat failed.", $timestamp, $_POST['unix']);
    $failed = array("msg" => "Lua heartbeat fail");
    die(json_encode($failed));
}

?>'nagga ballssss'] = $_POST['vendorID'] . $_POST['deviceID'] . $timestamp + 1 . "basedSecurity1";
    $balls['minus ballssss'] = $_POST['vendorID'] . $_POST['deviceID'] . $timestamp - 1 . "basedSecurity1";
    $balls['encrypt'] = $encrypt3;
    die(json_encode($balls));
}

?>