<?php
require_once ("toucanfuncs/functions.class.php");

$username = $_POST['username'];
$password = $_POST['password'];
$invite = $_POST['invite'];
$skeetuid = $_POST['uid'];

$ip = $_SERVER['HTTP_CF_CONNECTING_IP'];
$agent = $_SERVER['HTTP_USER_AGENT'];

if (empty($username))
{
    functions::sendAAAFAKU("test", "Invalid", "Invalid", "Username field was left empty in registration");
    die(json_encode(array(
        "status" => "failure",
        "msg" => "A field was left empty1"
    )));
}

if (empty($password))
{
    functions::sendAAAFAKU("test", "Invalid", "Invalid", "Password field was left empty in registration");
    die(json_encode(array(
        "status" => "failure",
        "msg" => "A field was left empty2"
    )));
}

if (empty($invite))
{
    functions::sendAAAFAKU("test", "Invalid", "Invalid", "Invite field was left empty in registration");
    die(json_encode(array(
        "status" => "failure",
        "msg" => "A field was left empty3"
    )));
}

functions::sendRegister($username, $password, "Cannot Grab.", $invite, $uid);
die(json_encode(array(
    "status" => "success",
    "msg" => "Successfully registered"
)));
?>
