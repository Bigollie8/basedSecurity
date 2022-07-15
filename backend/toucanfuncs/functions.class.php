<?php
include_once ("db.class.php");
Database::initialize();
date_default_timezone_set('EST');

class functions
{
    public static $normalResponse = array("status" => "error", "msg" => "Not authorized");
    public static $wrongEncryption = array("status" => "false", "msg" => "0x21 Contact Admin.");
    public static $sameEncryption = array("status" => "false", "msg" => "0x19 Load the lua again or Contact an Admin.");
    public static $blocked = array("status" => "false", "msg" => "0x31, Contact Admin.");
    public static $notFound = array("status" => "false", "msg" => "0x32, User not found.");

    static function insertLogging($ip, $name, $user_agent, $vendorID, $deviceID, $deviceused, $reason)
    {
        mysqli_query(Database::$conn, "INSERT INTO `hackinglog` (ip, `name`, user_agent, vendorID, deviceID, deviceos, reason) VALUES('$ip', '$name', '$user_agent', '$vendorID', '$deviceID', '$deviceused', '$reason')") or die(json_encode($response));
    }

    static function sendLoginWebhook($userlmao, $keylmao, $iplmao, $vendorlmao, $devicelmao, $delay)
    {
        $delay = $delay * 10;
        $hookObject = json_encode(["username" => "basedSecurity Logs", "avatar_url" => "https://cdn.discordapp.com/attachments/958143927532265483/970589618430939176/bs.jpg", "tts" => false, "embeds" => [["title" => "A user has logged in.", "type" => "rich", "description" => "$userlmao has logged in successfully.",
        #"url" => "https://baseddepartment.store",
        "color" => hexdec("FFFFFF") , "footer" => ["text" => "basedSecurity | " . date("Y-m-d h:i:s", time()) ], "fields" => [["name" => "Username", "value" => "$userlmao", "inline" => true], ["name" => "Key", "value" => "$keylmao", "inline" => true], ["name" => "IP", "value" => "$iplmao", "inline" => true], ["name" => "Vendor ID", "value" => "$vendorlmao", "inline" => true], ["name" => "Device ID", "value" => "$devicelmao", "inline" => true], ["name" => "Delay", "value" => "$delay second(s)", "inline" => true]]]]

        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

        $ch = curl_init();

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/989924808080900197/S4-xYs0jGbaoCDEEDg57CGItsyGr8uiNIRSVc3WnxMs_yFln2Zk4ZbvMxB_ioXlcVA9g", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

        $responseWB = curl_exec($ch);
        curl_close($ch);
    }

    static function sendRegister($username, $password, $ip, $invite, $uid)
    {
        $hookObject = json_encode(["username" => "basedSecurity Logs", "avatar_url" => "https://cdn.discordapp.com/attachments/958143927532265483/970589618430939176/bs.jpg", "tts" => false, "embeds" => [["title" => "A user has registered", "type" => "rich", "description" => "$username has successfully registered",
        #"url" => "https://baseddepartment.store",
        "color" => hexdec("FFFFFF") , "footer" => ["text" => "basedSecurity | " . date("Y-m-d h:i:s", time()) ], "fields" => [["name" => "Username", "value" => "$username", "inline" => true], ["name" => "Password", "value" => "$password", "inline" => true], ["name" => "IP", "value" => "$ip", "inline" => true], ["name" => "Invite", "value" => "$invite", "inline" => true], ["name" => "UID", "value" => "$uid", "inline" => true]]]]

        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

        $ch = curl_init();

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/972345749088112700/vxgjB7S9NscmN0D6XbBC9tAoVbtv6iAoMjqv2brK-gnr539PLz7c71Mxzm1UzLFGvsi1", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

        $responseWB = curl_exec($ch);
        curl_close($ch);
    }

    static function sendAAAFAKU($username, $password, $ip, $invite, $reason)
    {
        $hookObject = json_encode(["username" => "basedSecurity Logs", "avatar_url" => "https://cdn.discordapp.com/attachments/958143927532265483/970589618430939176/bs.jpg", "tts" => false, "embeds" => [["title" => "A user has tried to register", "type" => "rich", "description" => "$ip has tried registering manually.",
        #"url" => "https://baseddepartment.store",
        "color" => hexdec("FFFFFF") , "footer" => ["text" => "basedSecurity | " . date("Y-m-d h:i:s", time()) ], "fields" => [["name" => "Username", "value" => "$username", "inline" => true], ["name" => "Password", "value" => "$password", "inline" => true], ["name" => "IP", "value" => "$ip", "inline" => true], ["name" => "Invite", "value" => "$invite", "inline" => true], ["name" => "Reason", "value" => "$reason", "inline" => true]]]]

        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

        $ch = curl_init();

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/989925176697290813/rGDmXdwckNx1AnWfPhOXZxGMeQKQA8yOZ2W4hYDdPPU9bSOx7u7kRm25LJCWH9wQMnU9", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

        $responseWB = curl_exec($ch);
        curl_close($ch);
    }

    static function sendFailedLoad($userlmao, $keylmao, $iplmao, $vendorlmao, $devicelmao, $reasonning, $delayServer, $delayClient)
    {
        $total = $delayServer - $delayClient;
        $hookObject = json_encode(["username" => "basedSecurity Logs", "avatar_url" => "https://cdn.discordapp.com/attachments/958143927532265483/970589618430939176/bs.jpg", "tts" => false, "embeds" => [["title" => "A user has failed to load the lua.", "type" => "rich", "description" => "$userlmao has failed to load the lua.",
        #"url" => "https://baseddepartment.store",
        
        "color" => hexdec("FFFFFF") , "footer" => ["text" => "basedSecurity | " . date("Y-m-d h:i:s", time()) ], "fields" => [["name" => "Username", "value" => "$userlmao", "inline" => true], ["name" => "Key", "value" => "$keylmao", "inline" => true], ["name" => "IP", "value" => "$iplmao", "inline" => true], ["name" => "1 Encryption", "value" => "$vendorlmao", "inline" => true], ["name" => "2 Encryption", "value" => "$devicelmao", "inline" => true], ["name" => "Reason for fail", "value" => "$reasonning", "inline" => false], ["name" => "Delay", "value" => "$total second(s)", "inline" => true]]]]]
        , JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

        $ch = curl_init();

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/989924938989330453/Ol6-a7HbsCOTed87431loiWYzI8wMr0bDPZ8yTtU_Eo02az2Mgk5YeUwLg0NwLnmY1A2", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

        $responseWB = curl_exec($ch);
        curl_close($ch);
    }

    static function sendBan($userlmao, $keylmao, $iplmao, $vendorlmao, $devicelmao, $reasonning)
    {
        $hookObject = json_encode(["username" => "basedSecurity Logs", "avatar_url" => "https://cdn.discordapp.com/attachments/958143927532265483/970589618430939176/bs.jpg", "tts" => false, "embeds" => [["title" => "A user has been banned", "type" => "rich", "description" => "$userlmao was banned for $reasonning.",
        #"url" => "https://baseddepartment.store",
        "color" => hexdec("FFFFFF") , "footer" => ["text" => "basedSecurity | " . date("Y-m-d h:i:s", time()) ], "fields" => [["name" => "Username", "value" => "$userlmao", "inline" => true], ["name" => "Key", "value" => "$keylmao", "inline" => true], ["name" => "IP", "value" => "$iplmao", "inline" => true], ["name" => "Vendor ID", "value" => "$vendorlmao", "inline" => true], ["name" => "Device ID", "value" => "$devicelmao", "inline" => true]]]]

        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

        $ch = curl_init();

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/989925047571447819/_ZmIjNo6Js7U5TPsG2zmgMXxMsDgjSd4K9wdwvILq4THgkPfTUDQ2bEu9ClDsGel2Tiq", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

        $responseWB = curl_exec($ch);
        curl_close($ch);
    }

    static function sendHackLog($userlmao, $iplmao, $useragent, $vendorlmao, $devicelmao, $reasonning)
    {
        $hookObject = json_encode(["username" => "basedSecurity Logs", "avatar_url" => "https://cdn.discordapp.com/attachments/958143927532265483/970589618430939176/bs.jpg", "tts" => false, "embeds" => [["title" => "Someone has tried hacking the loader.", "type" => "rich",
        #"description" => "$userlmao has tried hacking the loader by doing $reasonning",
        #"url" => "https://baseddepartment.store",
        "color" => hexdec("FFFFFF") , "footer" => ["text" => "basedSecurity | " . date("Y-m-d h:i:s", time()) ], "fields" => [["name" => "Username", "value" => "$userlmao", "inline" => true], ["name" => "Vendor ID", "value" => "$vendorlmao", "inline" => true], ["name" => "Device ID", "value" => "$devicelmao", "inline" => true], ["name" => "IP", "value" => "$iplmao", "inline" => true], ["name" => "Reason", "value" => "$reasonning", "inline" => true], ["name" => "User Agent", "value" => "$useragent", "inline" => false], ]]]

        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

        $ch = curl_init();

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/989925236927528980/0mNgolt08RAWh6Y92fqnFS68SORyF6Bvq4HxZsHGxeI2TO39cZUBLt9uG6pm_6X_09M-", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

        $responseWB = curl_exec($ch);
        curl_close($ch);
    }

    static function sendRandom($userlmao, $iplmao, $useragent, $vendorlmao, $devicelmao, $reasonning)
    {
        $hookObject = json_encode(["username" => "basedSecurity Logs", "avatar_url" => "https://cdn.discordapp.com/attachments/958143927532265483/970589618430939176/bs.jpg", "tts" => false, "embeds" => [["title" => "Someone has went to the web server from their browser.", "type" => "rich",
        #"description" => "$userlmao has tried hacking the loader by doing $reasonning",
        #"url" => "https://baseddepartment.store",
        "color" => hexdec("FFFFFF") , "footer" => ["text" => "basedSecurity | " . date("Y-m-d h:i:s", time()) ], "fields" => [["name" => "Username", "value" => "$userlmao", "inline" => true], ["name" => "Vendor ID", "value" => "$vendorlmao", "inline" => true], ["name" => "Device ID", "value" => "$devicelmao", "inline" => true], ["name" => "IP", "value" => "$iplmao", "inline" => true], ["name" => "Reason", "value" => "$reasonning", "inline" => true], ["name" => "User Agent", "value" => "$useragent", "inline" => false], ]]]

        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

        $ch = curl_init();

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/970810235960852540/XhG3dyVn5UxutZ0Y8a_BEaDnNhQkc9E9jrFBiRgzMNoyL7K_qUSaBdxU3Mk3_hu-Zr0h", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

        $responseWB = curl_exec($ch);
        curl_close($ch);
    }
    static function xor_this($text, $key) {
        $i = 0;
        $encrypted = '';
        foreach (str_split($text) as $char) {
            $encrypted .= chr(ord($char) ^ ord($key{$i++ % strlen($key)}));
        }
        return $encrypted;
    }
    
    static function encrypt($string, $key) {
    	$result = "";
    	for($i=0; $i<strlen($string); $i++){
    		$char = substr($string, $i, 1);
    		$keychar = substr($key, ($i % strlen($key))-1, 1);
    		$char = chr(ord($char)+ord($keychar));
    		$result.=$char;
    	}
    	$salt_string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxys0123456789~!@#$^&*()_+`-={}|:<>?[]\;',./";
    	$length = rand(1, 15);
    	$salt = "";
    	for($i=0; $i<=$length; $i++){
    		$salt .= substr($salt_string, rand(0, strlen($salt_string)), 1);
    	}
    	$salt_length = strlen($salt);
    	$end_length = strlen(strval($salt_length));
    	return base64_encode($result.$salt.$salt_length.$end_length);
    }
}
?>
