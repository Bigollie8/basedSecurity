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

$encrypt = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp . "basedSecurity1");
$encrypt2 = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp . "basedSecurity1");
$encrypt3 = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp - 1 . "basedSecurity1");
$encrypt4 = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp + 1 . "basedSecurity1");

$key = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp . "basedSecurity2");
$key2 = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp + 1 . "basedSecurity2");
$key3 = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp - 1 . "basedSecurity2");

$clientEncrypt = $_POST['encryption'];

if ($clientEncrypt == $encrypt3 || $clientEncrypt == $encrypt4) {
    $array = array();
    //$array['plaintext'] = $_POST['deviceID'] . $timestamp . "basedSecurity" . $_POST['vendorID'];
    $array['same'] = $key;
    $array['Plus'] = $key2;
    $array['Minus'] = $key3;

    die(json_encode($array));
} else {
    functions::sendFailedLoad("unknown", "unknown", "unknown", $_POST['vendorID'], $_POST['deviceID'], "heartbeat failed.", $timestamp, $_POST['unix']);
    $balls = array();
    //((int)$_POST['vendorID']) . ((int)$_POST['deviceID']) . $timestamp + 1 . "basedSecurity1");
    $balls['plain'] = $_POST['vendorID'] . $_POST['deviceID'] . $timestamp . "basedSecurity1";
    $balls['nagga ballssss'] = $_POST['vendorID'] . $_POST['deviceID'] . $timestamp + 1 . "basedSecurity1";
    $balls['minus ballssss'] = $_POST['vendorID'] . $_POST['deviceID'] . $timestamp - 1 . "basedSecurity1";
    $balls['encrypt'] = $encrypt3;
    die(json_encode($balls));
}

?>