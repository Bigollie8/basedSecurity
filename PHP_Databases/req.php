<?php
require_once ("func/functions.class.php");

$username = $_POST['username'];
$password = $_POST['password'];
$invite = $_POST['invite'];
$ip = $_SERVER['HTTP_CF_CONNECTING_IP'];
$agent = $_SERVER['HTTP_USER_AGENT'];

//sendRegister($username, $password, $ip, $invite)
if ($ip != "73.27.46.202")
{
    die(json_encode(array(
        "status" => "failure",
        "msg" => "stop it."
    )));
}
//sendAAAFAKU($username, $password, $ip, $invite, $reason)
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

functions::sendRegister($username, $password, "Cannot Grab.", $invite);
die(json_encode(array(
    "status" => "success",
    "msg" => "Successfully registered"
)));
?>
