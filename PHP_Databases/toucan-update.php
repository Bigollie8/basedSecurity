<?php
include_once("toucanfuncs/db.class.php");
include_once("toucanfuncs/functions.class.php");

Database::initialize();

$response = array("msg" => "Invalid variable passed");


if (empty($_POST['vendorID'])) {
    die(json_encode($response));
}

if (empty($_POST['deviceID'])) {
    die(json_encode($response));
}

if (empty($_POST['username'])) {
    die(json_encode($response));
}

if (empty($_POST['uid'])) {
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
//make this better kinda sucks and can be exploited
$clientEncrypt = $_POST['encryption'];
$username = $_POST['username'];
$uid = $_POST['uid'];
$ip = mysqli_real_escape_string(Database::$conn, $_SERVER["HTTP_CF_CONNECTING_IP"]);
$vendorID = $_POST['vendorID'];
$deviceID = $_POST['deviceID'];
$steamID = $_POST['steamID'];

$check = mysqli_query(Database::$conn, "UPDATE users SET `steamID` = '$steamID' WHERE `vendorID` = '$vendorID' AND `deviceID` = '$deviceID'") or die(json_encode($response));
die(json_encode(array(
    "username" => $username,
    "uid" => $uid,
    "ip" => $ip,
    "vendorid" => $vendorID,
    "deviceid" => $deviceID
)));

?>