-- Security version 4.0
-- Developed by Ollie#0069 

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
local username                  = "Admin"

--#endregion

--#region Global Tables

local vars = {
    attempts                    = 2,
    counter                     = 0,
    color                       = "ffffffff",
    data                        = nil,
    firstloop                   = false,
    version                     = 1.4
}

local auth = {
    authurl                     = "https://basedsecurity.net",
    authip                      = "172.67.163.57",
    reset                       = false,
    size                        = get_size,
    unix                        = string.sub(get_time,0,9),
    alreadyauth                 = false
}

local connectionVars = {
    payload = "",
    key = 0,
    encryptedPayload = "",
    hash = "",
    url = "",
}

local heartbeatVars = {
    payload = "",
    key = 0,
    encryptedPayload = "",
    hash = "",
    url = "",
    checktime = tonumber(string.sub(get_time,0,9)),
    data = nil
}

--#endregion

--#region Branding Vars

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

local r,g,b = 255,255,255 -- cleanup lol

local function rainbow()
    r = math.floor(math.sin(globals.realtime() * 2) * 127 + 128)
    g = math.floor(math.sin(globals.realtime() * 2 + 2) * 127 + 128)
    b = math.floor(math.sin(globals.realtime() * 2 + 4) * 127 + 128)
end 

local function rgb_to_hex(r,g,b)
    local rgb = (r * 0x10000) + (g * 0x100) + b
    return "\a" .. string.format("%06x", rgb):upper() .."FF"
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

--#endregion

--#region Branding Animation

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

--#region Encryption

local function combine(table1,table2)
    local string1,string2 ="",""
    for _, v in pairs(table1) do
        if type(v) == "string" then
            string1 = string1 .. v
        else
            string1 = string1 .. tostring(v)
        end
    end
    for _, p in pairs(table2) do
        if type(p) == "string" then
            string2 = string2 .. p
        else
            string2 = string2 .. tostring(p)
        end
    end
    return string1 .. string2
end

local function table_to_matrix(table,col,row)
    local matrix = {}
    local f,location = 1,1
    for i=1, row do
        matrix[i] = {}
        for j=location, #table do
            if f == col + 1 then
                f = 1
                location = j
                break
            end
            matrix[i][f] = table[j]
            f = f + 1
        end
    end
    return matrix
end


local function string_to_table(string)
    local storage = {}
    for x in string:gmatch "." do
        table.insert(storage,x) 
    end
    return storage
end

local function encrypt(msg,key)
    local cipher = ""

    local msg_len = #msg
    local msg_lst = string_to_table(msg)
    local col = key
    local row = math.ceil((msg_len/col))
    local fill_null = (row * col) - msg_len
    local void = string_to_table(string.rep("_" , fill_null))
    local combined = string_to_table(combine(msg_lst, void))
    local matrix = table_to_matrix(combined,col,row)

    for i=1, col do
        for x,r in ipairs(matrix) do

            if matrix[x] == nil then
                print("Error decrypting")
                return nil
            end
        
            cipher = cipher .. matrix[x][i]
        end
    end
    return cipher
end

--#endregion

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

local logColors = {
    ['fail']                        = {248, 177, 174},
    ['success']                     = {192, 248, 174},
    ['pending']                     = {248, 241, 174},
}

local function logo(name)
    client_color_log(175, 175, 175,"[\0")
    client_color_log(colors.theme1[1],colors.theme1[2],colors.theme1[3], branding.half1 .. "\0")
    client_color_log(colors.theme2[1],colors.theme2[2],colors.theme2[3], branding.half2 .. "\0")
    client_color_log(175, 175, 175,"] \0")
end

local function log(msg,delay,padding,status)
    client_delay_call(delay,function()
        logo(branding.brand)
        client_color_log(colors[status][1],colors[status][2],colors[status][3], msg)
        vars.content            = padding .. msg
    end)
end

--#endregion

--#region Security

local adapter_info              = get_adapter_info()

local securityVars = {
    ['deviceID']                = adapter_info.device_id,
    ['vendorID']                = adapter_info.vendor_id,
    ['unix']                    = 0,
    ['username']                = username,
    ['fails']                   = 0
}

--#region Filesize Check

local function filesize(reset)
    if database_read("based") == nil or reset then
        database_write("based", auth.size)
        log("Updated verification info!",0,"   ",'pending')
    end
    
    if database_read("based") ~= auth.size then
        log("Contact admin! Error - 0x15",0," ",'fail')
        return true
    end
    
    if database_read("based") == auth.size and not auth.alreadyauth then
        log("Verfied!",0,"             ",'success')
        auth.alreadyauth = true
        return false
    end
end

--#endregion

--#region Update Vars Functions

local function updateAuthVars() -- 
    local unix = client.unix_time() -- hold ill send full encryption working for you maybe you can see whats up
    connectionVars.payload = string.format("%s:%s:%s:%s", securityVars.username, securityVars.vendor_id, securityVars.device_id, securityVars.unix)
    connectionVars.key = tonumber(string.sub(unix,0,9)) + 3
    if connectionVars.key > 10 then
        connectionVars.key = connectionVars.key - 10
    end
    connectionVars.encryptedPayload = encrypt(connectionVars.payload,connectionVars.key)
    connectionVars.hash = md5.sumhexa(connectionVars.encryptedPayload)
    connectionVars.url = "http://basedsecurity.net" .. '/login/' .. connectionVars.encryptedPayload .. '/' .. connectionVars.hash
end

local function updateHeartbeatVars()
    local unix = client.unix_time()
    heartbeatVars.payload = string.format("%s:%s:%s:%s", securityVars.username, securityVars.vendor_id, securityVars.device_id, securityVars.unix)
    heartbeatVars.key = tonumber(string.sub(unix,0,9)) + 3
    if heartbeatVars.key > 10 then
        heartbeatVars.key = heartbeatVars.key - 10
    end
    heartbeatVars.encryptedPayload = encrypt(heartbeatVars.payload,heartbeatVars.key)
    heartbeatVars.hash = md5.sumhexa(heartbeatVars.encryptedPayload)
    heartbeatVars.url = "http://basedsecurity.net" + '/login/'+ heartbeatVars.encryptedPayload +'/' + heartbeatVars.hash
end

print(encrypt("testing this stupid encryption shit",2))
--#endregion

--#endregion
