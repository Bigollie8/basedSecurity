<?php
include_once ("toucanfuncs/db.class.php");
include_once ("toucanfuncs/functions.class.php");

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

$dsync = substr(time(), 0, 9) - $_POST['unix'];
$timestamp = substr(time(), 0, 9) - $dsync;

$encrypt = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp . "basedSecurity1");

$key = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp . "basedSecurity2");

$clientEncrypt = $_POST['encryption'];

if ($clientEncrypt == $encrypt) {
    $array = array();
    //$array['plaintext'] = $_POST['deviceID'] . $timestamp . "basedSecurity" . $_POST['vendorID'];
    $array['same'] = $key;

    die(json_encode($array));
} else {
    functions::sendFailedLoad("unknown", "unknown", "unknown", $_POST['vendorID'], $_POST['deviceID'], "heartbeat failed.", $timestamp, $_POST['unix']);
    $array = array();
    //((int)$_POST['vendorID']) . ((int)$_POST['deviceID']) . $timestamp + 1 . "basedSecurity1");
    $array['reason'] = "Heartbeat fail (PHP side)";
    die(json_encode($array));
}

?>