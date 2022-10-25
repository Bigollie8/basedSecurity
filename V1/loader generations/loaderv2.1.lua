-- Security version 2.0
-- Developed by Ollie#0069 

--#region Important vars
local http                      = require("gamesense/http") or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=19253 on the lua workshop.")
local ffi                       = require("ffi") or error("0x20 Contact admin")
local md5                       = require("gamesense/md5") or error("Subscribe to md5 on forum")
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
    content                     = "           LOADING......",
    color                       = "ffffffff",
    content1                    = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
    content2                    = "\affffffff            Powered by : \aAEF8DB  based\aAEB5F8  Security",
    content3                    = "                   Starting Loader                        ",
    content4                    = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
    data                        = nil,
    frequency                   = nil,
    height                      = 255,
    offset                      = 0
}

local auth = {
    authurl                     = "https://pedohunters.info/index.php",
    reset                       = false,
    name                        = "Admin", 
    role                        = "Debug ", 
    version                     = " V 0.6", 
    uid                         = "1", 
    updatedate                  = "2/27/22 10:23pm CST",
    size                        =  get_size,
    unix                        =  string.sub(get_time,0,9)
}

local branding = {
    brand                       = "basedSecurity",
    half1                       = "based",
    half2                       = "Security",
    hex                         = 0000000,
    loading1                    = ui_new_label("Config","Lua","\ada1df2  " .. vars.content1),
    loading2                    = ui_new_label("Config","Lua","\ada1df2  " .. vars.content2),
    displaylabel                = ui_new_label("Config","Lua","\ada1df2  " .. vars.content3),
    loading3                    = ui_new_label("Config","Lua","\ada1df2  " .. vars.content4),
    flip                        = false
}

local colors = {
    theme1                      = {174, 248, 219},
    theme2                      = {198, 174, 248},
    fail                        = {248, 177, 174},
    success                     = {192, 248, 174},
    pending                     = {248, 241, 174},
    RGB                         = {0  , 0  ,   0}
}

--#endregion

--#region Branding

local function rgb_to_hex(r, g, b)
     r                          = r/255
     g                          = g/255
     b                          = b/255
	return string.format("%02x%02x%02x", math.floor(r*255), math.floor(g*255), math.floor(b*255))
end

local hexTable =  {
    themeHex                    = rgb_to_hex(colors.theme1[1],colors.theme1[2],colors.theme1[3]),
    theme2Hex                   = rgb_to_hex(colors.theme2[1],colors.theme2[2],colors.theme2[3]),
    failHex                     = rgb_to_hex(colors.fail[1],colors.fail[2],colors.fail[3]),
    succesHex                   = rgb_to_hex(colors.success[1],colors.success[2],colors.success[3]),
    pendingHex                  = rgb_to_hex(colors.pending[1],colors.pending[2],colors.pending[3]) 
}

local function watermark()
    vars.frequency              = global_curtime * 3
    colors.RGB[1]               = math.abs(math.sin(0.3*vars.frequency + 0) * vars.height + vars.offset)
    colors.RGB[2]               = math.abs(math.sin(0.3*vars.frequency + 2) * vars.height + vars.offset)
    colors.RGB[3]               = math.abs(math.sin(0.3*vars.frequency + 4) * vars.height + vars.offset)
    branding.hex                = rgb_to_hex(colors.RGB[1],colors.RGB[2],colors.RGB[3])
        
    local function handleVisablity(toggle)
        
        ui_set_visible(branding.loading1     , toggle)
        ui_set_visible(branding.loading2     , toggle)
        ui_set_visible(branding.displaylabel , toggle)
        ui_set_visible(branding.loading3     , toggle)

    end

    handleVisablity(false)

    branding.loading1           = ui_new_label("Config","Lua", vars.content1)
    branding.loading2           = ui_new_label("Config","Lua", vars.content2)
    branding.displaylabel       = ui_new_label("Config","Lua", vars.content3)
    branding.loading3           = ui_new_label("Config","Lua", vars.content4)

    handleVisablity(true)

    --Icon
    vars.counter = vars.counter + 1
    if vars.counter == 100 then
        vars.content1           = "\a" .. hexTable.themeHex .." ------------------------------------------------------"
        vars.content2           = "\affffffff            Powered by \a" .. branding.hex .. "  : \aAEF8DB  based\aAEB5F8  Security"
        vars.content3           = "           \a" .. vars.color .. "  " .. vars.content
        vars.content4           = "\a" .. hexTable.themeHex .." ------------------------------------------------------"

    elseif vars.counter == 200 then
        vars.content1           = "\a" .. hexTable.theme2Hex .."- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        vars.content2           = "\affffffff            Powered by \a" .. branding.hex .. "  : \aAEB5F8  based\aAEF8DB  Security"
        vars.content3           = "           \a" .. vars.color .. "  " .. vars.content
        vars.content4           = "\a" .. hexTable.theme2Hex .."- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        vars.counter            = 0
    end
end

client_set_event_callback("paint_ui",watermark)
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

local adapter_info              = get_adapter_info()
local md5_as_hex                = md5.sumhexa(adapter_info.vendor_id .. adapter_info.device_id .. auth.unix .. "basedSecurity")  

local options = { 
    ['encryption']              = md5_as_hex,
    ['deviceID']                = adapter_info.device_id,
    ['vendorID']                = adapter_info.vendor_id,
    ['name']                    = js.MyPersonaAPI.GetName()
}

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
        vars.content            =  padding .. msg 
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

local function get_web_data()
    pendingLog("Attempting to connect!",0.7,"    ")
    http.post(auth.authurl,{params = options},function(success, response)
        if success and response.body ~= nil then
            database_write("SecurityStorage",response.body)
            if string.find(response.body,"404 Not Found") then
                failLog("404 Error - x404",1.25,"       ")
                return
            end

            if response.body == 500 then
                failLog("PHP Error - x500",1.25,"                 ")
                return
            end

            if string.sub(response.body,0,1) ~= "{" then
                failLog("Table Error - x706",1.25,"        ")
                return
            end

            vars.data = json_parse(response.body)

            if (vars.data.status == "success") then
                successLog("Connected!",1.5,"          ")
                client_delay_call(2,function()
                    if #vars.data.lua < 100 then
                        failLog("Failed to load. Error - x707",0," ")
                    else
                        load(vars.data.lua)(auth.name, vars.data.role, vars.data.uid, auth.unix, vars.data.msg)
                        successLog("Loaded! Enjoy!",0,"         ")
                    end
                end)
            else
                failLog(string.format(vars.data.msg .. ". Error - x701"),2.2,"")  
            end
            
        elseif response.body == nil or not success then
            failLog("Failed to connect. Error - x703",0.75,"") 
            if vars.attempts ~= 4 then
                pendingLog("Trying again, attempt #" .. vars.attempts,1,"   ") 
                vars.attempts = vars.attempts + 1
                client_delay_call(3,get_web_data)
                auth.unix = string.sub(get_time,0,9)
            elseif vars.attempts > 3 then
                failLog("Error - x704",1,"            ") 
                return
            end
        end
    end)
end

--#endregion
--#region Tamper dection
if database_read(auth.name) ~= nil then
    database_write(auth.name, auth.size)
    pendingLog("Updated verification info!",0.5,"   ")
end

if database_read(auth.name) ~= auth.size then
    failLog("Contact admin! Error - x705",0.7," ")
end

if database_read(auth.name) == auth.size then
    successLog("Verfied!",0.6,"             ")
    get_web_data()
end
--#endregion

