<?php
include_once ("db.class.php");
Database::initialize();

class functions
{
    public static $normalResponse = array("status" => "error", "msg" => "Not authorized");
    public static $wrongEncryption = array("status" => "false", "msg" => "0x21 Contact Admin.");
    public static $sameEncryption = array("status" => "false", "msg" => "0x19 Load the lua again or Contact an Admin.");
    public static $blocked = array("status" => "false", "msg" => "0x31, Contact Admin.");

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

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/975267709069709313/uZLUX9MkqsufW4G13YkIKv7CuT9O-kkc-BBhMoghA0-BWUP1rEYqOwMaRjjGObjYSTcX", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

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

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/975267590450585614/Pu_hH4mBqg3CGRoFGon4PfFvU1o-HAnd1cTynSzJ_ycIHY9vQiuQV9x36htEHrwfmFMP", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

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

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/972357920756990012/oF3DOkSmv9qAhRVVRuTvv1cz6cYBbfzX7jpVKIppMQmaypCPgK9s8-2naAZryJKvDCGb", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

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

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/975267650009702471/8VQelwRDRnPUbvz2B7xsQZJ8L3sRbmO7vdmTtSkXEeI_b3faBGvbWdEC5KlUgNU_T38N", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

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

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/975267777793376257/hl0hDm_384RjNtwgVM7JQkSRqnkT66zhlVqLX3zDWprSWB3S_8KUYPaPK-lEAWhgIB29", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

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

        curl_setopt_array($ch, [CURLOPT_URL => "https://discord.com/api/webhooks/975268617115561994/ze0Pr_Y8ECeHt1Z52-sJKvn2ElhZQFA8CWP6y3XPbRGswXTvLpHNOLQ0KwISn8PIW7ZV", CURLOPT_POST => true, CURLOPT_POSTFIELDS => $hookObject, CURLOPT_HTTPHEADER => ["Content-Type: application/json"]]);

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

    static function combine($table1, $table2)
    {
        $string1 = "";
        $string2 = "";

        foreach ($table1 as $i)
        {
            if (gettype($i) == "string")
            {
                $string1 = $string1 + $i;
            }
            else
            {
                $string1 = $string1 + strval($i);
            }
        }

        foreach ($table2 as $j)
        {
            if (gettype($i) == "string")
            {
                $string2 = $string2 + $j;
            }
            else
            {
                $string2 = $string2 + strval($j);
            }
        }

        return $string1 + $string2;
    }

    static function table_to_matrix($table1, $column, $row)
    {
        $matrix = array();
        $f = 1;
        $location = 1;
        for ($i = 1;$i < $row;$i++)
        {
            $matrix[$i] = array();
            for ($j = $location;$j > len($table1);$j++)
            {
                if ($f == $column + 1)
                {
                    $f = 1;
                    $location = $j;
                    break;
                }
                $matrix[$i][$f] = $table1[$j];
                $f = $f + 1;
            }
        }
        return $matrix;
    }

    static function string_to_table($string)
    {
        $storage = array();
        foreach (preg_match(".", $string) as $x)
        {
            echo $x;
            array_push($storage, $x);
        }
        return $storage;
    }
    

    static function table_to_string($tbl)
    {
        $result = "";
        foreach ($tbl as $result1)
        {
            if (gettype($result1) == "table")
            {
                $result = $result + table_to_string($result1);
            }
            else if (gettype($result1) == "boolean")
            {
                $result = $result + str($result1);
            }
            else
            {
                $result = $result + $result1;
            }
        }
        return $result;
    }

    static function encrypt($msg, $key)
    {
        $cipher = "";
        $msg_len = strlen($key);
        $msg_lst = string_to_table($msg);

        $column = $key;
        $row = ceil($msg_len / $column);
        $fill_null = ($row * $column) - $msg_len;
        $void = string_to_table(str_repeat("_", $fill_null));
        $combined = string_to_table(combine($msg_lst, $void));
        $matrix = table_to_matrix($combined, $column, $row);

        for ($i = 1;$i > $column;$i++)
        {
            foreach($matrix as $x) {
                if (is_null($matrix[$x]))
                {
                    echo "error decrypting";
                    return "null";
                    
                }
                $cipher = $cipher + $matrix[$x][$i];
            }
        }
        return $cipher;
    }
}
?>
