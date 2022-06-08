<?php
    class KeyValuePair
    {
        public $Key;
        public $Value;
    }

    function compare($first, $second) {
        return strcmp($first->Value, $second->Value);
    }

    function GetShiftIndexes($key)
    {
        $keyLength = strlen($key);
        $indexes = array();
        $sortedKey = array();
        $i;

        for ($i = 0; $i < $keyLength; ++$i) {
            $pair = new KeyValuePair();
            $pair->Key = $i;
            $pair->Value = $key[$i];
            $sortedKey[] = $pair;
        }

        usort($sortedKey, 'compare');
        $i = 0;

        for ($i = 0; $i < $keyLength; ++$i)
            $indexes[$sortedKey[$i]->Key] = $i;

        return $indexes;
    }
    function Encipher($input, $key, $padChar)
    {
        $output = "";
        $keyLength = $key;
        $input = ($totalChars % $keyLength == 0) ? $input : str_pad($input, $totalChars - ($totalChars % $keyLength) + $keyLength, $padChar, STR_PAD_RIGHT);
        $totalChars = strlen($input);
        $totalColumns = $key;
        $totalRows = ceil($totalChars / $totalColumns);
        $rowChars = array(array());
        $colChars = array(array());
        $currentRow = 0; $currentColumn = 0; $i = 0; $j = 0;
        $shiftIndexes = array_map('intval', str_split($key));

        for ($i = 0; $i < $totalChars; ++$i)
        {
            $currentRow = $i / $totalColumns;
            $currentColumn = $i % $totalColumns;
            $rowChars[$currentRow][$currentColumn] = $input[$i];
        }

        for ($i = 0; $i < $totalRows; ++$i)
            for ($j = 0; $j < $totalColumns; ++$j)
                $colChars[$j][$i] = $rowChars[$i][$j];

        for ($i = 0; $i < $totalColumns; ++$i) {
            for ($x = 0; $x < $totalRows; ++$x) {
                $output = $output + $colChars[$i][$x];
            }
        }
        return $output;
    }

    include_once("func/db.class.php");
    Database::initialize();

    $response = array("status" => "error", "msg" => "Not authorized");

    function insertLogging($ip, $name, $user_agent, $vendorID, $deviceID, $reason)
    {
        mysqli_query(Database::$conn, "INSERT INTO `hackinglog` (ip, `name`, user_agent, vendorID, deviceID, reason) VALUES('$ip', '$name', '$user_agent', '$vendorID', '$deviceID', '$reason')") or die(json_encode($response));
    }

    function blockUser($name) {
        mysqli_query(Database::$conn, "UPDATE `toucan` SET `blocked` = 'True' WHERE `toucan`.`username` = $name");
    }

    /*
        Anti hack systems
    */
    $encryptiontime = substr( time(), 7, 9 );
    $ip = mysqli_real_escape_string(Database::$conn, $_SERVER['REMOTE_ADDR']);
    $agent = mysqli_real_escape_string(Database::$conn, $_SERVER['HTTP_USER_AGENT']);
    $timestamp = substr( time(), 0, 9 );
    if(empty($agent)) $agent = "";

    if(empty($_POST['encryption']))
    {
        insertLogging($ip, "empty", $agent, 0, 0, "empty encryption string");
        die(json_encode($response));
    }
    if(isset($_POST['encryption']))
    {
        if(empty($_POST['name']))
        {
            insertLogging($ip, "empty", $agent, 0, 0, "emtpy data in name");
            die(json_encode($response));
        }
        $name = mysqli_real_escape_string(Database::$conn, $_POST['name']);

        if(empty($_POST['vendorID']))
        {
            insertLogging($ip, $name, $agent, 0, 0, "emtpy data in vendorID");
            die(json_encode($response));
        }
        if(empty($_POST['deviceID'])) 
        {
            insertLogging($ip, $name, $agent, 0, 0, "emtpy data in deviceID");
            die(json_encode($response));
        }

        if(strlen($_POST['vendorID']) != 4)
        {
            insertLogging($ip, $name, $agent, 0, 0, "fake data in vendorID");
            die(json_encode($response));
        }

        if(strlen($_POST['deviceID']) != 4)
        {
            insertLogging($ip, $name, $agent, 0, 0, "fake data in deviceID");
            die(json_encode($response));
        }

        if(!is_numeric($_POST['vendorID']))
        {
            insertLogging($ip, $name, $agent, 0, 0, "vendorID not integer");
            die(json_encode($response));
        }

        if(!is_numeric($_POST['deviceID']))
        {
            insertLogging($ip, $name, $agent, 0, 0, "deviceID not integer");
            die(json_encode($response));
        }

        /*
            Anti hack systems
        */
        $vendorID = mysqli_real_escape_string(Database::$conn, (int)$_POST['vendorID']);
        $deviceID = mysqli_real_escape_string(Database::$conn, (int)$_POST['deviceID']);

        if($agent != "Valve/Steam HTTP Client 1.0 (730)")
        {
            insertLogging($ip, $name, $agent, $vendorID, $deviceID, "wrong user agent, woops");
            blockUser($name);
            die(json_encode($response));
        }

        // Anti hack
        $log = mysqli_query(Database::$conn, "SELECT `id` FROM `hackinglog` WHERE `ip` = '$ip' AND `last_seen` <= DATE_SUB(CURDATE(),INTERVAL -1 day)") or die(json_encode($response));
        if(mysqli_num_rows($log) > 999)
        {
            insertLogging($ip, $name, $agent, $vendorID, $deviceID, "more then 9 failed attempts");
            blockUser($name);
            die(json_encode($response));
        }

        if(strlen($_POST['encryption']) < 4)
        {
            insertLogging($ip, $name, $agent, $vendorID, $deviceID, "encryption length to small");
            blockUser($name);
            die(json_encode($response));
        }

        $encrypt_match = md5(((int)$_POST['vendorID']).((int)$_POST['deviceID']).$timestamp."basedSecurity");

        if($_POST['encryption'] != $encrypt_match)
        {
            insertLogging($ip, $name, $agent, $vendorID, $deviceID, "Wrong encryption key");
            $enc = array("status" => "false", "msg" => "0x21 contact admin", "sent encryption key" => $_POST['encryption'], "generated encryption" => $encrypt_match);
            die(json_encode($enc));
        }

        $check = mysqli_query(Database::$conn, "SELECT id, last_encryption FROM authlog WHERE vendorID = '$vendorID' AND deviceID = '$deviceID' order by id desc limit 1") or die(json_encode($response));
        if(mysqli_num_rows($check) > 0)
        {
            $THIS = mysqli_fetch_array($check);

            if($THIS['last_encryption'] == $encrypt_match)
            {
                insertLogging($ip, $name, $agent, $vendorID, $deviceID, "Same encryption key");
                $enc1 = array("status" => "false", "msg" => "0x19 load the lua slower", "sent encryption key" => $THIS['last_encryption'], "generated encryption" => $encrypt_match);
                die(json_encode($enc1));
            }
        }

        mysqli_query(Database::$conn, "INSERT INTO `authlog` (ip, `name`, user_agent, vendorID, deviceID, last_encryption) VALUES('$ip', '$name', '$agent', '$vendorID', '$deviceID', '$encrypt_match')") or die(json_encode($response));
        
        $blockShit = array("status" => "false", "msg" => "0x30 contact admin.");
        $check2 = mysqli_query(Database::$conn, "SELECT `id`, `role`, `blocked` FROM toucan WHERE `vendorID` = '$vendorID' AND `deviceID` = '$deviceID'") or die(json_encode($blockShit));
        if(mysqli_num_rows($check2) < 1) die(json_encode($response));

        $THIS = mysqli_fetch_array($check2);
        
        mysqli_query(Database::$conn, "UPDATE toucan SET `last_loaded` = NOW(), ip = '{$_SERVER['REMOTE_ADDR']}' WHERE id = '{$THIS['id']}'") or die(json_encode($response));
        $luafile = mysqli_query(Database::$conn, "SELECT luafile FROM {$THIS['role']}") or die(json_encode($response));

        $BALLSS = mysqli_fetch_array($luafile);
        #$checkHackAmount = mysqli_query(Database::$conn, "SELECT `name`, `ip` FROM hackinglog WHERE ip = '{$_SERVER['REMOTE_ADDR']}'") or die(json_encode($response));
        #$updateHackAmount = mysqli_query(Database::$conn, "UPDATE toucan SET `hacklog` = mysqli_num_rows($checkHackAmount) WHERE ip = '{$_SERVER['REMOTE_ADDR']}'") or die(json_encode($response));
        
        if ($THIS['blocked'] === "True"){
            die(json_encode($ballss));
        } elseif ($THIS['blocked'] === "False") {
            $response['status'] = "success";
            $response['msg'] = md5($timestamp."basedSecurity".$_POST['vendorID'].$_POST['deviceID']);
            $response['lua'] = $BALLSS;
            
            die(json_encode($response));
        }
    }
    die(json_encode($response));
?>