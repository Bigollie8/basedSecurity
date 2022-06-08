<?php
include_once ("gloriusfuncs/db.class.php");
include_once ("gloriusfuncs/functions.class.php");
include_once ("gloriusfuncs/userinfo.class.php");

Database::initialize();

$response = array("status" => "error", "msg" => "Not authorized");
/*
        Anti hack systems
*/
$ip = mysqli_real_escape_string(Database::$conn, $_SERVER["HTTP_CF_CONNECTING_IP"]);
$agent = mysqli_real_escape_string(Database::$conn, $_SERVER['HTTP_USER_AGENT']);
$timestamp = substr(time() , 0, 9);
$keytime = substr(time() , 0, 9);
$vendorID = mysqli_real_escape_string(Database::$conn, (int)$_POST['vendorID']);
$deviceID = mysqli_real_escape_string(Database::$conn, (int)$_POST['deviceID']);
$encrypt_match = md5(((int)$_POST['vendorID']) . ((int)$_POST['deviceID']) . $timestamp . "basedSecurity");
$encrypt_match_2 = md5(((int)$_POST['vendorID']) . ((int)$_POST['deviceID']) . $timestamp - 1 . "basedSecurity");
$key = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp . "basedSecurity2");
$key2 = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp + 1 . "basedSecurity2");
$key3 = md5($_POST['vendorID'] . $_POST['deviceID'] . $timestamp - 1 . "basedSecurity2");

if (empty($agent)) $agent = "";

if (empty($_POST['encryption']))
{
    functions::sendRandom("Empty", $ip, $agent, "Invalid", "Invalid", "Empty encryption string.");
    functions::insertlogging($ip, "empty", $agent, 0, 0, "unknown", "empty encryption string");
    die(base64_encode(json_encode($response)));
}
if (empty($_POST['username'])) {
    functions::insertlogging($ip, "empty", $agent, 0, 0, "unknown", "Posted username was empty");
    die(base64_encode(json_encode($response)));
}

if (isset($_POST['encryption']))
{
    if (empty($_POST['name']))
    {
        functions::insertlogging($ip, "empty", $agent, 0, 0, "unknown", "emtpy data in name");
        die(base64_encode(json_encode($response)));
    }
    $name = mysqli_real_escape_string(Database::$conn, $_POST['name']);

    if (empty($_POST['vendorID']))
    {
        functions::sendHackLog($name, $ip, $agent, "Invalid", "Invalid", "Empty data for: VendorID.");
        functions::insertlogging($ip, $name, $agent, 0, 0, "unknown", "emtpy data in vendorID");
        die(base64_encode(json_encode($response)));
    }
    if (empty($_POST['deviceID']))
    {
        functions::insertlogging($ip, $name, $agent, 0, 0, "unknown", "emtpy data in deviceID");
        functions::sendHackLog($name, $ip, $agent, "Invalid", "Invalid", "Empty data for: DeviceID.");
        die(base64_encode(json_encode($response)));
    }

    if (strlen($_POST['vendorID']) > 5)
    {
        functions::insertlogging($ip, $name, $agent, 0, 0, "unknown", "fake data in vendorID");
        functions::sendHackLog(functions::$name, $ip, $agent, "Invalid", "Invalid", "Information for: VendorID was tampered with.");
        die(base64_encode(json_encode($response)));
    }

    if (strlen($_POST['deviceID']) > 5)
    {
        functions::sendHackLog($name, $ip, $agent, "Invalid", "Invalid", "Information for: DeviceID was tampered with.");
        functions::insertlogging($ip, $name, $agent, 0, 0, "unknown", "fake data in deviceID");
        die(base64_encode(json_encode($response)));
    }

    if (!is_numeric($_POST['vendorID']))
    {
        functions::sendHackLog($name, $ip, $agent, "Invalid", "Invalid", "Information for: VendorID was tampered with. (changed to string)");
        functions::insertlogging($ip, $name, $agent, 0, 0, "unknown", "vendorID not integer");
        die(base64_encode(json_encode($response)));
    }

    if (!is_numeric($_POST['deviceID']))
    {
        functions::sendHackLog($name, $ip, $agent, "Invalid", "Invalid", "Information for: DeviceID was tampered with. (changed to string)");
        functions::insertlogging($ip, $name, $agent, 0, 0, "unknown", "deviceID not integer");
        die(base64_encode(json_encode($response)));
    }

    if (empty($_POST['delay']))
    {
        functions::sendHackLog($name, $ip, $agent, "Invalid", "Invalid", "Delay was tampered with.");
        functions::insertlogging($ip, $name, $agent, 0, 0, "unknown", "Delay was empty.");
        die(base64_encode(json_encode($response)));
    }

    if (!is_numeric($_POST['delay']))
    {
        functions::sendHackLog($name, $ip, $agent, "Invalid", "Invalid", "Delay was tampered with. (not int)");
        functions::insertlogging($ip, $name, $agent, 0, 0, "unknown", "Delay was not an integer.");
        die(base64_encode(json_encode($response)));
    }

    $checkForVendor = mysqli_query(Database::$conn, "SELECT `id`, `username`, `vendorID`, `deviceID` FROM users WHERE `username` = '{$_POST['username']}'");
    $THIS = mysqli_fetch_array($checkForVendor);
    if ($THIS['vendorID'] == 0 && $THIS['deviceID'] == 0) {
        mysqli_query(Database::$conn, "UPDATE `users` SET `vendorID` = '{$_POST['vendorID']}', `deviceID` = '{$_POST['deviceID']}' WHERE `username` = '{$_POST['username']}'") or die(base64_encode(json_encode(array(
            "vendorID" => $_POST['vendorID'],
            "deviceID" => $_POST['deviceID'],
            "num" => mysqli_num_rows($checkForVendor)))));
    }
    /*
            Anti hack systems
    */
    if ($agent != "Valve/Steam HTTP Client 1.0 (730)")
    {
        functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "wrong user agent, woops");
        functions::sendFailedLoad($name, "unknown", $ip, $vendorID, $deviceID, "Useragent tampered.", $timestamp, $_POST['delay']);
        die(base64_encode(json_encode($response)));
    }
    
    // Anti hack
    $log = mysqli_query(Database::$conn, "SELECT `id` FROM `hackinglog` WHERE `ip` = '$ip' AND `last_seen` <= DATE_SUB(CURDATE(),INTERVAL -1 day)") or         die(base64_encode(json_encode($response)));
    if (mysqli_num_rows($log) > 9)
    {
        functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "more then 9 failed attempts");
        mysqli_query(Database::$conn, "UPDATE `users` SET `blocked` = 'True' WHERE `ip` = '$ip'");
        functions::sendBan($name, "unknown", $ip, $vendorID, $deviceID, "User has failed to load more than 9 times. Automatically blocked user.");
        die(base64_encode(json_encode($response)));
    }

    if (strlen($_POST['encryption']) < 4)
    {
        functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "encryption length to small");
        die(base64_encode(json_encode($response)));
    }

    if ($_POST['encryption'] != $encrypt_match)
    {
        if ($_POST['encryption'] != $encrypt_match_2) {
            functions::sendFailedLoad($name, $_POST['encryption'], $ip, $encrypt_match, $encrypt_match_2, "Wrong encryption key", $timestamp, $_POST['delay']);
            functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "Wrong encryption key");
            die(json_encode(functions::$wrongEncryption));
        }
        if ($_POST['encryption'] != $key) {
            functions::sendFailedLoad($name, $_POST['encryption'], $ip, $encrypt_match, $encrypt_match_2, "Wrong encryption key", $timestamp, $_POST['delay']);
            functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "Wrong encryption key");
            die(json_encode(functions::$wrongEncryption));
        }
        if ($_POST['encryption'] != $key2) {
            functions::sendFailedLoad($name, $_POST['encryption'], $ip, $encrypt_match, $encrypt_match_2, "Wrong encryption key", $timestamp, $_POST['delay']);
            functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "Wrong encryption key");
            die(json_encode(functions::$wrongEncryption));
        }
        if ($_POST['encryption'] != $key3) {
            functions::sendFailedLoad($name, $_POST['encryption'], $ip, $encrypt_match, $encrypt_match_2, "Wrong encryption key", $timestamp, $_POST['delay']);
            functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "Wrong encryption key");
            die(json_encode(functions::$wrongEncryption));
        }
    }

    $check = mysqli_query(Database::$conn, "SELECT id, last_encryption FROM authlog WHERE vendorID = '$vendorID' AND deviceID = '$deviceID' order by id desc limit 1") or         die(base64_encode(json_encode($response)));
    if (mysqli_num_rows($check) > 0)
    {
        $THIS = mysqli_fetch_array($check);

        if ($THIS['last_encryption'] == $encrypt_match)
        {
            functions::sendFailedLoad($name, $encrypt_match, $ip, $vendorID, $deviceID, "Same encryption key", $timestamp, $_POST['delay']);
            functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "Same encryption key");
            die(json_encode(functions::$sameEncryption));
        }
    }

    $check2 = mysqli_query(Database::$conn, "SELECT `id`, `username`, `role`, `blocked` FROM users WHERE `vendorID` = '$vendorID' AND `deviceID` = '$deviceID'") or die(json_encode(functions::$blocked));
    if (mysqli_num_rows($check2) < 1)         die(base64_encode(json_encode($response)));

    $THIS = mysqli_fetch_array($check2);
    mysqli_query(Database::$conn, "INSERT INTO `authlog` (ip, `name`, user_agent, vendorID, deviceID, last_encryption) VALUES('$ip', '{$THIS['username']}', '$agent', '$vendorID', '$deviceID', '$encrypt_match')") or         die(base64_encode(json_encode($response)));

    mysqli_query(Database::$conn, "UPDATE users SET `last_loaded` = NOW(), ip = '{$_SERVER["HTTP_CF_CONNECTING_IP"]}' WHERE id = '{$THIS['id']}'") or         die(base64_encode(json_encode($response)));

    if ($THIS['blocked'] === "True")
    {
        functions::sendBan($THIS['username'], $encrypt_match, $ip, $_POST['vendorID'], $_POST['deviceID'], "User is blocked.");
        die(base64_encode(json_encode($response)));
    }
    elseif ($THIS['blocked'] === "False")
    {
        $response['msg'] = "Authorized";
        $response['status'] = "success";
        $response['name'] = $THIS['username'];
        $response['role'] = $THIS['role'];
        $response['uid'] = $THIS['id'];
        $response['lua'] = file_get_contents("builds/glorius/{$THIS['role']}.lua");
        functions::sendLoginWebhook($THIS['username'], $_POST['encryption'], $ip, $_POST['vendorID'], $_POST['deviceID'], $timestamp, $_POST['delay']);
        die(base64_encode(json_encode($response)));
    }
}
die(base64_encode(json_encode($response)));
?>