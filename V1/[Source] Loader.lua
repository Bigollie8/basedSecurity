-- Security version 3.1.4
-- Developed by Ollie#0069 & .audit#1111 (aka Melly)

--#region Important vars
local http                      = require("gamesense/http") or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=19253 on the lua workshop.")
local ffi                       = require("ffi") or error("0x20 Contact admin")
local md5                       = require("gamesense/md5") or error("Subscribe to md5 on forum")
local base64                    = require "gamesense/base64" or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=21619 on the lua workshop.")
local js                        = panorama.open()
local ui_set_visible            = ui.set_visible
local ui_new_label              = ui.new_label
local client_set_event_callback = client.set_event_callback
local client_color_log          = client.color_log
local client_delay_call         = client.delay_call
local database_write            = database.write
local database_read             = database.read
local table_bind                = vtable_bind
local get_time                  = client.unix_time()
local json_parse                = json.parse
local global_curtime            = globals.curtime() 
local get_size                  = #readfile(_NAME .. ".lua")

local vars = {
    attempts                    = 2,
    counter                     = 0,
    color                       = "ffffffff",
    data                        = nil,
    firstloop                   = false,
    version                     = 1.4
}


--UNIX MAY NOT MATCH NEED TO VERIFY
local info = {
    username = "Admin",
    vendorID = "0"
    deviceID = "0"
    unix = string.sub(get_time,0,9),
    plaintext = "BasedSecurity"
}

vars = {
    payload = ""
    key = 0
    encryptedPayload = "" 
    hash = ""
    url = ""
}

local auth = {
    reset                       = false,
    size                        = get_size,
    alreadyauth                 = false
}

local branding = {
    brand                       = "basedSecurity",
    half1                       = "based",
    half2                       = "Security",
    hex                         =  0000000,
    flip                        = false,
    frame1                      = ui.new_label("Config","Lua","-"),
    tag                         = ui.new_label("Config","Lua","-"),
    version                     = ui.new_label("Config","Lua","-"),
    frame2                      = ui.new_label("Config","Lua","-"),
    animationSpeed              = 60,
}


local tag = {
    ["stage9"]  = "d",
    ["stage10"] = "ed",
    ["stage11"] = "sed",
    ["stage12"] = "ased",
    ["stage13"] = "based",
    ["stage14"] = " based",
    ["stage15"] = "  based",
    ["stage16"] = "   based",
    ["stage17"] = "    based",
    ["stage18"] = "     based",
    ["stage19"] = "      based",
    ["stage20"] = "       based",
    ["stage21"] = "        based",
    ["stage22"] = "         based",
    ["stage23"] = "          based",
    ["stage24"] = "           based",
    ["stage25"] = "            based",
    ["stage26"] = "             based",
    ["stage27"] = "              based",
    ["stage28"] = "               based",
    ["stage29"] = "               based",
    ["stage30"] = "               based",
    ["stage31"] = "               based",
    ["stage32"] = "               based",
    ["stage33"] = "               based",
    ["stage34"] = "               based",
    ["stage35"] = "               based",
    location = 1,
    flip = false
}

local seconday = {
    ["stage1"] = " ",
    ["stage2"] = "y",
    ["stage3"] = "ty",
    ["stage4"] = "ity",
    ["stage5"] = "rity",
    ["stage6"] = "urity",
    ["stage7"] = "curity",
    ["stage8"] = "ecuirty",
    ["stage9"] = "Security",
    ["stage10"] = "Security",
    ["stage11"] = "Security",
    ["stage12"] = "Security",
    ["stage13"] = "Security",
    ["stage14"] = "Security",
    ["stage15"] = "Security",
    ["stage16"] = "Security",
    ["stage17"] = "Security",
    ["stage18"] = "Security",
    ["stage19"] = "Security",
    ["stage20"] = "Security",
    ["stage21"] = "Security",
    ["stage22"] = "Security",
    ["stage23"] = "Security",
    ["stage24"] = "Security",
    ["stage25"] = "Security",
    ["stage26"] = "Security",
    ["stage27"] = "Security",
    ["stage28"] = "Security",
    ["stage29"] = "Security",
    ["stage30"] = "Security",
    ["stage31"] = "Security",
    ["stage32"] = "Security",
    ["stage33"] = "Security",
    ["stage34"] = "Security",
    ["stage35"] = "Security",
    location = 1,
    flip = false
}

local beta = {
    ["stage1"] = " ",
    ["stage2"] = " ",
    ["stage3"] = " ",
    ["stage4"] = " ",
    ["stage5"] = "]",
    ["stage6"] = "A]",
    ["stage7"] = "TA]",
    ["stage8"] = "ETA]",
    ["stage9"] = "BETA]",
    ["stage10"] = " [BETA]",
    ["stage11"] = "  [BETA]",
    ["stage12"] = "   [BETA]",
    ["stage13"] = "    [BETA]",
    ["stage14"] = "     [BETA]",
    ["stage15"] = "      [BETA]",
    ["stage16"] = "       [BETA]",
    ["stage17"] = "        [BETA]",
    ["stage18"] = "         [BETA]",
    ["stage19"] = "          [BETA]",
    ["stage20"] = "           [BETA]",
    ["stage21"] = "            [BETA]",
    ["stage22"] = "             [BETA]",
    ["stage23"] = "              [BETA]",
    ["stage24"] = "               [BETA]",
    ["stage25"] = "                [BETA]",
    ["stage26"] = "                 [BETA]",
    ["stage27"] = "                  [BETA]",
    ["stage28"] = "                   [BETA]",
    ["stage29"] = "                    [BETA]",
    ["stage30"] = "                    [BETA]",
    ["stage31"] = "                    [beta]",
    ["stage32"] = "                    [beta]",
    ["stage33"] = "                    [beta]",
    ["stage34"] = "                    [BETA]",
    ["stage35"] = "                    [BETA]",
    location = 1,
    flip = false
}

--#endregion

--#region Branding

local function rgb_to_hex(r,g,b)
    local rgb = (r * 0x10000) + (g * 0x100) + b
    return "\a" .. string.format("%06x", rgb):upper() .."FF"
end

local r,g,b = 255,255,255 -- cleanup lol

local function rainbow()
    r = math.floor(math.sin(globals.realtime() * 2) * 127 + 128)
    g = math.floor(math.sin(globals.realtime() * 2 + 2) * 127 + 128)
    b = math.floor(math.sin(globals.realtime() * 2 + 4) * 127 + 128)
end 

local colors =  {
    theme1                      = {174, 248, 219},
    theme2                      = {198, 174, 248},
    loaderTheme1                = {r, g, b},
    loaderTheme2                = {r, g, b},
    fail                        = {248, 177, 174},
    success                     = {192, 248, 174},
    pending                     = {248, 241, 174},
    RGB                         = {0  , 0  ,   0}
}

local hexTable =  {
    themeHex                    = rgb_to_hex(colors.theme1[1],colors.theme1[2],colors.theme1[3]),
    theme2Hex                   = rgb_to_hex(colors.theme2[1],colors.theme2[2],colors.theme2[3]),
    loaderThemeHex1             = rgb_to_hex(colors.loaderTheme1[1],colors.loaderTheme1[2],colors.loaderTheme1[3]),
    loaderThemeHex2             = rgb_to_hex(colors.loaderTheme2[1],colors.loaderTheme2[2],colors.loaderTheme2[3]),
    failHex                     = rgb_to_hex(colors.fail[1],colors.fail[2],colors.fail[3]),
    succesHex                   = rgb_to_hex(colors.success[1],colors.success[2],colors.success[3]),
    pendingHex                  = rgb_to_hex(colors.pending[1],colors.pending[2],colors.pending[3]) 
}


local function watermark() -- there has to be a way better than up, maybe making it update vars that change only
    if not ui.is_menu_open() then return end
    
    colors = {
        theme1                      = {174, 248, 219},
        theme2                      = {198, 174, 248},
        loaderTheme1                = {r, g, b},
        loaderTheme2                = {r, g, b},
        fail                        = {248, 177, 174},
        success                     = {192, 248, 174},
        pending                     = {248, 241, 174},
        RGB                         = {0  , 0  ,   0}
    }

    hexTable =  {
        themeHex                    = rgb_to_hex(colors.theme1[1],colors.theme1[2],colors.theme1[3]),
        theme2Hex                   = rgb_to_hex(colors.theme2[1],colors.theme2[2],colors.theme2[3]),
        loaderThemeHex1             = rgb_to_hex(colors.loaderTheme1[1],colors.loaderTheme1[2],colors.loaderTheme1[3]),
        loaderThemeHex2             = rgb_to_hex(colors.loaderTheme2[1],colors.loaderTheme2[2],colors.loaderTheme2[3]),
        failHex                     = rgb_to_hex(colors.fail[1],colors.fail[2],colors.fail[3]),
        succesHex                   = rgb_to_hex(colors.success[1],colors.success[2],colors.success[3]),
        pendingHex                  = rgb_to_hex(colors.pending[1],colors.pending[2],colors.pending[3]) 
    }

    ui.set(branding.frame1,hexTable.loaderThemeHex1 .. "-                \aFFFFFFFFPowered by".. hexTable.loaderThemeHex1 .."             -")
    
    if tag.location > 8 then 
        ui.set(branding.tag, "\aFFFFFFFF" .. tag["stage"..tag.location] .. hexTable.loaderThemeHex1 ..  seconday["stage" .. tag.location])
        ui.set(branding.version,hexTable.loaderThemeHex1 .. beta["stage" .. tag.location])
        vars.firstloop = true 

    else
        ui.set(branding.tag, hexTable.loaderThemeHex1 .. seconday["stage"..tag.location])
        ui.set(branding.version,hexTable.loaderThemeHex1 .. beta["stage" .. tag.location])

    end
    ui.set(branding.frame2,hexTable.loaderThemeHex1 .. "-                                               -")

    vars.counter = vars.counter + 1

    if tag.location >= 35 then
        tag.flip = true
    elseif tag.location <= 1 then
        tag.flip = false
    end

    if vars.counter >= branding.animationSpeed then
        vars.counter = 0 
        if tag.flip then
            tag.location = tag.location - 1
        elseif not tag.flip then
            tag.location = tag.location + 1
        else
            print("Reload Loader!")
        end
    end
end


client_set_event_callback("paint_ui",function()
   
    watermark()
    rainbow()
    
end)

--#endregion


--#region Security --

--#region FFI

local material_adapter_info_t  =
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

local native_GetCurrentAdapter  = table_bind("materialsystem.dll", "VMaterialSystem080", 25, "int(__thiscall*)(void*)")
local native_GetAdapterInfo     = table_bind("materialsystem.dll", "VMaterialSystem080", 26, "void(__thiscall*)(void*, int, void*)")

local function get_adapter_info()
    local current_adapter       = native_GetCurrentAdapter()
    local adapter_info          = material_adapter_info_t()

    native_GetAdapterInfo(current_adapter, adapter_info)

    return {
        driver_name             = ffi.string(adapter_info.driver_name),
        vendor_id               = adapter_info.vendor_id,
        device_id               = adapter_info.device_id,
        sub_sys_id              = adapter_info.sub_sys_id,
        revision                = adapter_info.revision,
        dx_support_level        = adapter_info.dx_support_level,
        min_dx_support_level    = adapter_info.min_dx_support_level,
        max_dx_support_level    = adapter_info.max_dx_support_level,
        driver_version_high     = adapter_info.driver_version_high,
        driver_version_low      = adapter_info.driver_version_low
    }
end

--#endregion

--#region Logging

local function logo(name)
    client_color_log(175, 175, 175,"[\0")
    client_color_log(colors.theme1[1],colors.theme1[2],colors.theme1[3], branding.half1 .. "\0")
    client_color_log(colors.theme2[1],colors.theme2[2],colors.theme2[3], branding.half2 .. "\0")
    client_color_log(175, 175, 175,"] \0")
end

local function failLog(msg,delay,padding)
    client_delay_call(delay,function()
        logo(branding.brand)
        client_color_log(colors.fail[1],colors.fail[2],colors.fail[3], msg)
        vars.content            = padding .. msg 
        vars.color              = hexTable.failHex
    end)
end

local function successLog(msg,delay,padding)
    client_delay_call(delay,function()
        logo(branding.brand)
        client_color_log(colors.success[1],colors.success[2],colors.success[3], msg)
        vars.content            = padding .. msg
        vars.color              = hexTable.succesHex
    end)
end

local function pendingLog(msg,delay,padding)
    client_delay_call(delay,function()
        logo(branding.brand)
        client_color_log(colors.pending[1],colors.pending[2],colors.pending[3], msg)
        vars.content            = padding .. msg 
        vars.color              = hexTable.pendingHex
    end)
end

--#endregion

local ine

local function blacklist_check() -- Sauron loader 
    for i = 65, 90 do 
        ine = i
        local dir = string.char(i)..":\\Windows\\System32\\drivers\\etc\\hosts"
        local hosts_file = readfile(dir)
    
        if (hosts_file and hosts_file:find(auth.authurl)) or (hosts_file and hosts_file:find(auth.authip)) then
            failLog('Error 0x22 | Ip blacklisted - Not allowed >:(', 0,"")
            return true
        end
    end
end

local function anti_http_debug() -- Sauron loader
    local file_data = readfile(string.format(string.char(ine) .. ':\\Program Files (x86)\\Steam\\logs\\ipc_SteamClient.log'))

    if file_data and string.find(file_data, auth.authurl)  or file_data and string.find(file_data, auth.authip) then
        failLog('Error 0x23 | Debugfile found', 0,"")
        return true
    end  
end

failLog("-------------------------",0,"") 

local adapter_info              = get_adapter_info()
local md5_as_hex                = md5.sumhexa(adapter_info.vendor_id .. adapter_info.device_id .. (auth.unix) .. "basedSecurity")  
-- table this

local options = { 
    ['encryption']              = md5_as_hex,
    ['deviceID']                = adapter_info.device_id,
    ['vendorID']                = adapter_info.vendor_id,
    ['name']                    = js.MyPersonaAPI.GetName(),
    ['delay']                   = auth.unix,
    ['username']                = username
}

local function filesize(reset)
    if database_read("aura") == nil or reset then
        database_write("aura", auth.size)
        pendingLog("Updated verification info!",0,"   ")
    end
    
    if database_read("aura") ~= auth.size then
        failLog("Contact admin! Error - 0x15",0," ")
        return true
    end
    
    if database_read("aura") == auth.size and not auth.alreadyauth then
        successLog("Verfied!",0,"             ")
        auth.alreadyauth = true
        return false
    end
end

local function updateUrls()
    auth.payload = info[username]
    
    auth.authurl = 

end

-- this should be able to be in a table lol
local alphabet = "base64"
local plaintext

local function get_web_data()
    
    if not pcall(load("return true")) then print("Someones trying to hook load") return false end

    --#region heartbeat
    local heartbeatVars = {
        url = "",
        checktime = tonumber(string.sub(get_time,0,9)),
        key = 1,
        data = nil
    }
    
    local info = { 
        ['encryption']              = nil,
        ['deviceID']                = adapter_info.device_id,
        ['vendorID']                = adapter_info.vendor_id,
        ['unix']                    = 0,
        ['username']                = username,
        ['fails']                   = 0
    }
    
    local function heartbeat()
        local unix = client.unix_time()
        info['unix'] = tonumber(string.sub(unix,0,9))
        if heartbeatVars.checktime <= info['unix'] then
            info['encryption'] = md5.sumhexa(adapter_info.vendor_id .. adapter_info.device_id .. (info['unix']) .. "basedSecurity1")  
            heartbeatVars.checktime = heartbeatVars.checktime + 1
            http.post(heartbeatVars.url,{params = info},function(success, response)
                if success and response.body ~= nil then
                    if (heartbeatVars.checktime - info['unix'] ) ~= 1 then failLog("Error 0x98 | Delay failed",0,"");return end
                    heartbeatVars.key = md5.sumhexa(adapter_info.vendor_id .. adapter_info.device_id .. (info['unix']) .. "basedSecurity2")  
                    heartbeatVars.data = json.parse(response.body)
                    if heartbeatVars.data.same ~= heartbeatVars.key then
                      info['fails'] = info['fails'] + 1
                      pendingLog("WARNING! heartbeat fail #" .. info['fails'],0,"")
                      if info['fails'] < 3 then return end
                      local x = 100
                      failLog("Crash triggered | failed heartbeat |",0,"")
                      while x > 0 do
                        x = x + 1
                      end
                  end
                else
                    print(response.body)
                end
            end)
        end
      end
    
    client.set_event_callback("paint_ui",heartbeat)
    --#endregion

    if blacklist_check() then return end

    if anti_http_debug() then return end

    pendingLog("Attempting to connect!",0.5,"    ")

    http.post(auth.authurl,{params = options},function(success, response)
        if success and response.body ~= nil then

            if string.sub(response.body,0,1) ~= "{" then
                plaintext = base64.decode(response.body,alphabet)
            else
                plaintext = response.body
            end

            vars.data = json_parse(plaintext)


            if string.find(plaintext,"404 Not Found") then failLog("Error 0x404 | Page not found",1.25,"       ") return end

            if string.sub(plaintext,0,1) ~= "{" then failLog("Error 0x16 | Improper server response",1.25,"        ") return end

            if (vars.data.msg == "Not authorized") then 
                if vars.data.reason == nil then
                    failLog("Error 0x44 | Not authorized",1.25, "         ")
                    return
                else
                    failLog("Error 0x44 | Not authorized | " ..  vars.data.reason, 1.25, "         ")
                    return
                end
            end

--            if (vars.data.version < vars.version) then print("Updated Required for loader") return end

            if (filesize(true)) then return end

            if (vars.data.status == "success" and not vars.data.blocked) then
                successLog("Connected!",1.5,"          ")
                client_delay_call(2,function()
                    if vars.data.lua == nil or vars.data.lua == false then
                        failLog("Error 0x17 | Error loading LUA",0," ")
                    else
                        local key = 5
                        load(vars.data.lua)(vars.data.payload,key)
                        successLog("Loaded! Enjoy!",0,"         ")
                    end
                end)
            elseif vars.attempts ~= 4 and vars.data.status == "false" then 
                failLog(string.format(vars.data.msg),1,"") 
                vars.attempts = vars.attempts + 1
                client.delay_call(5,get_web_data)
            elseif vars.status == false then
                failLog("Error | Not authorized",2.2,"")
                return
            else
                failLog("Error 0x99 | Please contact admin",0,"")
            end
---------------------------------------------------------------------------------------------------------------
        elseif response.body == nil or not success then
            failLog("Error 0x13 | Failed to connect to server",1,"") 
            if vars.attempts ~= 4 then
                failLog("-------------------------",1.2,"") 
                pendingLog("Trying again, attempt #" .. vars.attempts,1.5,"   ")  
                vars.attempts = vars.attempts + 1
                client_delay_call(3,get_web_data)
                auth.unix = string.sub(get_time,0,9)
            elseif vars.attempts > 3 then
                failLog("-------------------------",1.1,"") 
                failLog("Error 0x14 | To many attempts, failed to laod",1.2,"            ") 
                return
            end
---------------------------------------------------------------------------------------------------------------
        else
            if response.body ~= nil then
                local plaintext = base64.decode(response.body,alphabet)
                print(plaintext)
            else
                print(response.body)
            end
        end
    end)
end

--#endregion 



pendingLog("Starting",0.1,"             ")
client.delay_call(1,get_web_data)
--#endregion