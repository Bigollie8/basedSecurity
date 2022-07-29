<?php
include_once ("aurafuncs/db.class.php");
include_once ("aurafuncs/functions.class.php");
include_once ("aurafuncs/userinfo.class.php");

Database::initialize();

function hacklog($ip, $name, $user_agent, $vendorID, $deviceID, $deviceused, $reason)
{
    mysqli_query(Database::$conn, "INSERT INTO `hackinglog` (ip, `name`, user_agent, vendorID, deviceID, deviceos, reason) VALUES('$ip', '$name', '$user_agent', '$vendorID', '$deviceID', '$deviceused', '$reason')") or die(json_encode($response));
}

$loginurl = "https://discord.com/api/webhooks/977884566125682698/FHM8jqh1qlg7ZDRiV7HlJuuQ4vl9UmB6LWHhpZQz_jsOTPXaIyunjsIgdhuaE8P51hPC";
$registerurl = "https://discord.com/api/webhooks/977884607611543554/zfn5Nzm2jTOr3V5nj33jk1ISIOOWjpHjyoUrSjy6SqjI118J89JoMAHc9F6BwnRVIuHL";
$randomurl = "https://discord.com/api/webhooks/977884655279833098/3pfK3KYayEv1O0bTNMSN-xewSR-g7hFcD5cnFBJGpa2xWfofU1cpzAH2fTSwq1Bd0XHT";
$hacklogurl = "https://discord.com/api/webhooks/977884655279833098/3pfK3KYayEv1O0bTNMSN-xewSR-g7hFcD5cnFBJGpa2xWfofU1cpzAH2fTSwq1Bd0XHT";
$failedurl = "https://discord.com/api/webhooks/977884629308674118/zUMOcZ37XnBHSkUAumOMdaoxTy3VEkX-DCvymlrCHWSin_uK_CffyhvWf0mjZiP5whYC";
$banurl = "https://discord.com/api/webhooks/977884675924189216/ZiPAPPAwJjPzGVOp1usyLl5etFCF1ZjbslC4p2EXIcxUwI1nQOJ35vCkzhzOFuXaCnch";
$heartbeaturl = "https://discord.com/api/webhooks/977884629308674118/zUMOcZ37XnBHSkUAumOMdaoxTy3VEkX-DCvymlrCHWSin_uK_CffyhvWf0mjZiP5whYC";

$response = array("status" => "error", "msg" => "Not authorized");

$ip = mysqli_real_escape_string(Database::$conn, $_SERVER["HTTP_CF_CONNECTING_IP"]);
$agent = mysqli_real_escape_string(Database::$conn, $_SERVER['HTTP_USER_AGENT']);
$timestamp = substr(time() , 0, 9);
$keytime = substr(time() , 0, 9);
$vendorID = mysqli_real_escape_string(Database::$conn, (int)$_POST['vendorID']);
$deviceID = mysqli_real_escape_string(Database::$conn, (int)$_POST['deviceID']);

if (empty($agent)) $agent = "";

if (empty($_POST['encryption']))
{
    #functions::random($randomurl, "Empty", "Invalid", $ip, $vendorID, $deviceID, "Empty encryption string", $agent);
    hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "Empty Encryption String");
    die(base64_encode(json_encode($response)));
}
if (empty($_POST['username'])) {
    hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "Posted username was empty");
    die(base64_encode(json_encode($response)));
}

if (isset($_POST['encryption']))
{
    if (empty($_POST['name']))
    {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "emtpy data in name");
        die(base64_encode(json_encode($response)));
    }
    $name = mysqli_real_escape_string(Database::$conn, $_POST['name']);

    if (empty($_POST['vendorID']))
    {
        #functions::random($hacklogurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, "Empty data for: vendorID", $agent);
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "emtpy data in vendorID");
        die(base64_encode(json_encode($response)));
    }
    if (empty($_POST['deviceID']))
    {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "emtpy data in deviceID");
        #functions::random($hacklogurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, "Empty data for: deviceID", $agent);
        die(base64_encode(json_encode($response)));
    }

    if (strlen($_POST['vendorID']) > 5)
    {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "vendorID was tampered with");
        #functions::random($hacklogurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, "vendorID was tampered with", $agent);
        $response["reason"] = "Invalid Vendor id length";
        die(base64_encode(json_encode($response)));
    }

    if (strlen($_POST['deviceID']) > 5)
    {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "deviceID was tampered with");
        #functions::random($hacklogurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, "deviceID was tampered with", $agent);
        $response["reason"] = "Invalid Device id length";
        die(base64_encode(json_encode($response)));
    }

    if (!is_numeric($_POST['vendorID']))
    {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "vendorID was tampered with (not int)");
        #functions::random($hacklogurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, "vendorID was tampered with (not int)", $agent);
        $response["reason"] = "Invalid Vendor id";
        die(base64_encode(json_encode($response)));
    }

    if (!is_numeric($_POST['deviceID']))
    {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "deviceID was tampered with (not int)");
        #functions::random($hacklogurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, "deviceID was tampered with (not int)", $agent);
        $response["reason"] = "Invalid Device id";
        die(base64_encode(json_encode($response)));
    }

    if (empty($_POST['delay']))
    {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "delay was tampered with (empty)");
        #functions::random($hacklogurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, "delay was tampered with (empty)", $agent);
        $response["reason"] = "Invalid Connection (0x25)";
        die(base64_encode(json_encode($response)));
    }

    if (!is_numeric($_POST['delay']))
    {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "delay was tampered with (not int)");
        #functions::random($hacklogurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, "delay was tampered with (not int)", $agent);
        $response["reason"] = "Invalid characters detected (0x20)";
        die(base64_encode(json_encode($response)));
    }

    $deSync = 0;

    if ($_POST['delay'] != $timestamp)
    {
        $deSync = $_POST['delay'] - $timestamp;
    }

    if (($_POST['delay']) - $timestamp > 1 || ($_POST['delay']) - $timestamp < -1 )
    {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "Time mismatch");
        #functions::random($hacklogurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, "There is a desync between server and user time", $agent);
        $response["reason"] = "Error, Reset system time";
        die(base64_encode(json_encode($response)));
    }

    
    $checkForVendor = mysqli_query(Database::$conn, "SELECT `id`, `username`, `vendorID`, `deviceID`, 'blocked' FROM users WHERE `username` = '{$_POST['username']}'");
    $THIS = mysqli_fetch_array($checkForVendor);

    $timestamp = $timestamp + $deSync;

    $encrypt_match = md5(((int)$THIS['vendorID']) . ((int)$THIS['deviceID']) . $timestamp . "basedSecurity");

    if ($THIS['vendorID'] == 0 && $THIS['deviceID'] == 0) {
        mysqli_query(Database::$conn, "UPDATE `users` SET `vendorID` = '{$_POST['vendorID']}', `deviceID` = '{$_POST['deviceID']}' WHERE `username` = '{$_POST['username']}'") or die(base64_encode(json_encode(array(
            "vendorID" => $_POST['vendorID'],
            "deviceID" => $_POST['deviceID'],
            "num" => mysqli_num_rows($checkForVendor)))));
            $response["reason"] = "Updated user info";
            die(base64_encode(json_encode($response)));
    }
    
    if ($THIS['vendorID'] != $_POST['vendorID'] && $THIS['deviceID'] != $_POST['deviceID']) {
        hacklog($ip, "Empty", $agent, 0, 0, "Unknown", "Info does not match");
        #functions::failed($failedurl, $name, $_POST['encryption'], $ip, $vendorID, $deviceID, $_POST['delay'], "Information does not match");
        $response["reason"] = "Info does not match username";
        die(base64_encode(json_encode($response)));
    }
    /*
            Anti hack systems
    */
    if ($agent != "Valve/Steam HTTP Client 1.0 (730)")
    {
        #functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "wrong user agent, woops");
        #functions::sendFailedLoad($name, "unknown", $ip, $vendorID, $deviceID, "Useragent tampered.", $timestamp, $_POST['delay']);
        die(base64_encode(json_encode($response)));
    }
    
    // Anti hack
    $log = mysqli_query(Database::$conn, "SELECT `id` FROM `hackinglog` WHERE `ip` = '$ip' AND `last_seen` <= DATE_SUB(CURDATE(),INTERVAL -1 day)") or         die(base64_encode(json_encode($response)));
    if (mysqli_num_rows($log) > 9)
    {
        #functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "more then 9 failed attempts");
        mysqli_query(Database::$conn, "UPDATE `users` SET `blocked` = 'True' WHERE `ip` = '$ip'");
        #functions::sendBan($name, "unknown", $ip, $vendorID, $deviceID, "User has failed to load more than 9 times. Automatically blocked user.");
        $response["reason"] = "Automatically blocked, please contact admin";
        die(base64_encode(json_encode($response)));
    }

    if (strlen($_POST['encryption']) < 4)
    {
        #functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "encryption length to small");
        die(base64_encode(json_encode($response)));
    }

    if ($_POST['encryption'] != $encrypt_match)
    {
        #functions::sendFailedLoad($name, $_POST['encryption'], $ip, $encrypt_match, $encrypt_match_2, "Wrong encryption key", $timestamp, $_POST['delay']);
        #functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "Wrong encryption key");
        die(json_encode(functions::$wrongEncryption));
    }

    $check = mysqli_query(Database::$conn, "SELECT id, last_encryption FROM authlog WHERE vendorID = '$vendorID' AND deviceID = '$deviceID' order by id desc limit 1") or         die(base64_encode(json_encode($response)));
    if (mysqli_num_rows($check) > 0)
    {
        $THIS = mysqli_fetch_array($check);

        if ($THIS['last_encryption'] == $encrypt_match)
        {
            #functions::sendFailedLoad($name, $encrypt_match, $ip, $vendorID, $deviceID, "Same encryption key", $timestamp, $_POST['delay']);
            #functions::insertlogging($ip, $name, $agent, $vendorID, $deviceID, "unknown", "Same encryption key");
            die(json_encode(functions::$sameEncryption));
        }
    }

    $check2 = mysqli_query(Database::$conn, "SELECT `id`, `username`, `role`, `blocked`, `luas` FROM users WHERE `vendorID` = '$vendorID' AND `deviceID` = '$deviceID'") or die(json_encode(functions::$blocked));
    if (mysqli_num_rows($check2) < 1)         die(base64_encode(json_encode($response)));

    $THIS = mysqli_fetch_array($check2);
    mysqli_query(Database::$conn, "INSERT INTO `authlog` (ip, `name`, user_agent, vendorID, deviceID, last_encryption) VALUES('$ip', '{$THIS['username']}', '$agent', '$vendorID', '$deviceID', '$encrypt_match')") or die(base64_encode(json_encode($response)));

    mysqli_query(Database::$conn, "UPDATE users SET `last_loaded` = NOW(), ip = '{$_SERVER["HTTP_CF_CONNECTING_IP"]}' WHERE id = '{$THIS['id']}'") or  die(base64_encode(json_encode($response)));
    $hash = hash('sha256','Testing');
    if ($THIS['blocked'] === "1")
    {
        #functions::ban($banurl, $username, $ip, $vendorID, $deviceID, "User is blocked.");
        die(base64_encode(json_encode($response)));
    }
    elseif ($THIS['blocked'] === "0")
    { 
        $word = $_POST['username'] . " " . $THIS['role'] . " " . $THIS['id'] . " " . $timestamp . " " . "Authorized" . " " . $hash;
        $response['msg'] = "Authorized";
        $response['status'] = "success";
        $response['name'] = $_POST['username'];
        $response['role'] = $THIS['role'];
        $response['uid'] = $THIS['id'];
        $response['reset'] = true;
        $response['version'] = 1.4;
        $response['hash'] = $hash;
        $response['unix'] = $timestamp;
        $response['payload'] = functions::luaEncrypt($word, 5);
        if (!is_null($_POST['lua']))
        {
            if (strstr($THIS['luas'], $_POST['lua']))
            {
                $response['lua'] = file_get_contents("builds/{$_POST['lua']}/{$_POST['role']}.lua");
            }
            else
            {
                $response['lua'] = "\"THIS['luas']\"={$THIS['luas']}\n\"POST['lua']\"={$_POST['lua']}";
            }
        }
        else
        {
            $response['lua'] = file_get_contents("builds/basedSecurity/{$THIS['role']}.lua");
        }
        #functions::login($loginurl, $username, $_POST['encryption'], $ip, $vendorID, $deviceID, $deSync);
        die(base64_encode(json_encode($response)));
    }
}
die(base64_encode(json_encode($response)));
?>
