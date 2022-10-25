-- Generation 1.0
-- Developed by Ollie#0069
-- General Concept : Take the unique identifier for each computer
--                   gpu, this is mixed with 20 random digets in a
--                   colum cipher, the 20 random digets. This is then
--                   used as a password to connect to the server. Once verfied
--                   passes part of key to the actual lua script to continue 
--                   verifications


--#region Important vars

local http = require("gamesense/http") or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=19253 on the lua workshop.")
local Discord = require("gamesense/discord_webhooks") or error("Requires discord webhooks to send info to admins.")
local ffi = require("ffi") or error("Requires FFI - Please contact admin")
local client = _G["client"]

--#endregion

--#region discord shit

local Webhook = Discord.new("https://ptb.discord.com/api/webhooks/939992421637435413/9-vyG1rixTfE16ZQEiKOOdF2_aNqRfz0KJJ4RoDWOjy8dQm4zL7lEd6LeaD2O8n5oQjk")
local RichEmbed = Discord.newEmbed()

local website = "http://193.233.204.9/beta/Toucan-obfuscated.lua"
local authurl = "http://193.233.204.9/users/us_r_ta_3421.txt"
local username = "714137351059931177" -- discordid
local key =  "87123695424866150538" -- random 20 digit int
local name = "Admin" -- name duh
local role = "Debug " -- role
local version = role .." V 0.6" -- dont touch
local uid = "1"  -- just make up a number for now lmfao
local updatedate = "2/27/22 10:23pm CST"-- dont touch

local flag = 1

local row1 = {}
local row2 = {}
local row3 = {}
local row4 = {}

--#endregion

--#region Security and logging --

function Split(s, delimiter)
    result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end



local material_adapter_info_t =
    ffi.typeof [[ 
	struct {
		char driver_name[512];
		uint32_t vendor_id;
		uint32_t device_id;
		uint32_t sub_sys_id;
		uint32_t revision;
		int dx_support_level;
		int min_dx_support_level;
		int max_dx_support_level;
		uint32_t driver_version_high;
		uint32_t driver_version_low;
	}
]]

local native_GetCurrentAdapter = vtable_bind("materialsystem.dll", "VMaterialSystem080", 25, "int(__thiscall*)(void*)")
local native_GetAdapterInfo = vtable_bind("materialsystem.dll", "VMaterialSystem080", 26, "void(__thiscall*)(void*, int, void*)")

local function get_adapter_info()
    local current_adapter = native_GetCurrentAdapter()
    local adapter_info = material_adapter_info_t()

    native_GetAdapterInfo(current_adapter, adapter_info)

    return {
        driver_name = ffi.string(adapter_info.driver_name),
        vendor_id = adapter_info.vendor_id,
        device_id = adapter_info.device_id,
        sub_sys_id = adapter_info.sub_sys_id,
        revision = adapter_info.revision,
        dx_support_level = adapter_info.dx_support_level,
        min_dx_support_level = adapter_info.min_dx_support_level,
        max_dx_support_level = adapter_info.max_dx_support_level,
        driver_version_high = adapter_info.driver_version_high,
        driver_version_low = adapter_info.driver_version_low
    }
end

local adapter_info = get_adapter_info()

local Plaintext = adapter_info.vendor_id .. adapter_info.device_id .. key



for c in Plaintext:gmatch "." do
    if flag == 1 then
        table.insert(row1, c)
        flag = flag + 1
    elseif flag == 2 then
        table.insert(row2, c)
        flag = flag + 1
    elseif flag == 3 then
        table.insert(row3, c)
        flag = flag + 1
    elseif flag == 4 then
        table.insert(row4, c)
        flag = flag + 1
    else
        flag = 1
    end
end


local function table_to_string(tbl)
    local result = ""
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result .. k
        end

        -- Check the value type
        if type(v) == "table" then
            result = result .. table_to_string(v)
        elseif type(v) == "boolean" then
            result = result .. tostring(v)
        else
            result = result .. v
        end
    end
    return result
end

local function SendWebHook(success,color)
    Webhook:setUsername("TOUCAN")
    Webhook:setAvatarURL("")
    RichEmbed:setTitle("TOUCAN Load logs")
    RichEmbed:setDescription(version)
    RichEmbed:setThumbnail("https://cdn.discordapp.com/icons/770374971087388732/a_90e65c655cb31978f29c8f0b781338d6.webp?size=1024")
    RichEmbed:setColor(color)
    RichEmbed:addField("Username", name, true)
    RichEmbed:addField("Key", string.format(table_to_string(row2) .. table_to_string(row3) .. table_to_string(row1) .. table_to_string(row4)), true)
    RichEmbed:addField("Success", success, true)
    RichEmbed:addField("Vendor ID", adapter_info.vendor_id, true)
    RichEmbed:addField("Device ID", adapter_info.device_id, true)
    RichEmbed:addField("Driver Name", adapter_info.driver_name, true)
    Webhook:send(RichEmbed)
end

local function load_lua(x)
    load(x)(name,role, uid,updatedate,version,key,table_to_string(row2))
    print("Loaded")
end

local function get_web_data()
    print("Attempting to connect...")
    http.get(website, {authorization = {username ,string.format(table_to_string(row2) .. table_to_string(row3) .. table_to_string(row1) .. table_to_string(row4))}}, function(success, response)
        if success then
            print("connected")
            client.delay_call(5, function()
                load_lua(response.body)
            end)
        else
            client.color_log(255, 200, 0, "[Error] Failed to connect, reload lua or contact an admin")
        end
    end)
end

local function whitelist()
    http.get(authurl, {authorization = {username,string.format(table_to_string(row2) .. table_to_string(row3) .. table_to_string(row1) .. table_to_string(row4))}},function(success, response)
        local check = Split(response.body, ", ")
        for x = 2, 100, 2 do
            if check[x] == nil then
                print("You are not authed to use this lua please contact an admin")
                SendWebHook("False",16711680)
                break
            elseif string.find(check[x], string.format(table_to_string(row2) .. table_to_string(row3) .. table_to_string(row1) .. table_to_string(row4))) then
                get_web_data()
                -- Discord Log --
                SendWebHook("True",9811974)
                break
            end
        end
    end)
end
--#endregion

whitelist()