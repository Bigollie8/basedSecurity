-- Security version 2.0
-- Developed by Ollie#0069 

--#region Important vars
local http                       = require("gamesense/http") or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=19253 on the lua workshop.")
local ffi                        = require("ffi") or error("0x20 Contact admin")
local md5                        = require("gamesense/md5") or error("Subscribe to md5 on forum")
local js                         = panorama.open()
local client                     = _G["client"]

local vars = {
    brand                        = "Toucan",
    discord                      = "discord.gg/a7AJHgmmtp",
    authurl                      = "https://pedohunters.info/index.php",
    size                         = #readfile(_NAME .. ".lua"),
    attempts                     = 1,
    content                      = "           LOADING......",
    color                        = "ffffffff",
    content1                     = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
    content2                     = "\affffffff            Powered by : \aAEF8DB  based\aAEB5F8  Security",
    content3                     = "                   Starting Loader                        ",
    content4                     = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

}

local auth = {
    reset                        = false,
    username                     = "714137351059931177", -- discordid
    name                         = "Admin", -- name duh
    role                         = "Debug ", -- role
    version                      = " V 0.6", -- dont touch
    uid                          = "1",  -- just make up a number for now lmfao 
    updatedate                   = "2/27/22 10:23pm CST",-- dont touch
    unix                         =  string.sub(client.unix_time(),0,9)
}

local branding = {
    hex    = 0000000,
    loading1 = ui.new_label("Config","Lua","\ada1df2  " .. vars.content1),
    loading2 = ui.new_label("Config","Lua","\ada1df2  " .. vars.content2),
    displaylabel = ui.new_label("Config","Lua","\ada1df2  " .. vars.content3),
    loading3 = ui.new_label("Config","Lua","\ada1df2  " .. vars.content4),
    flip   = false
}

local themeR, themeG, themeB       = 174, 248, 219
local theme2R, theme2G, theme2B    = 198, 174, 248
local failR,failG,failB            = 248, 177, 174
local successR, successG, successB = 192, 248, 174 
local pendingR, pendingG, pendingB = 248, 241, 174
--#endregion

local counter = 0
--#region Branding

local red,blue,green = 0,0,0


function rgb_to_hex(r, g, b)
     r = r/255
     g = g/255
     b = b/255
	return string.format("%02x%02x%02x", math.floor(r*255), math.floor(g*255), math.floor(b*255))
end

local themeHex = rgb_to_hex(themeR,themeG,themeB)
local theme2Hex = rgb_to_hex(theme2R,theme2G,theme2B)
local failHex = rgb_to_hex(failR,failG,failB)
local succesHex = rgb_to_hex(successR,successG,successB)
local pendingHex = rgb_to_hex(pendingR,pendingG,pendingB)



local function watermark()
    local frequency = globals.curtime() * 3
    local height = 255
    local offset = 0
    red = math.abs(math.sin(0.3*frequency + 0) * height + offset)
    green = math.abs(math.sin(0.3*frequency + 2) * height + offset)
    blue = math.abs(math.sin(0.3*frequency + 4) * height + offset)
    branding.hex = rgb_to_hex(red,green,blue)
    --RGB

    
    --LoadingAnimation

    --Status
        
    local function handleVisablity(toggle)
        
        ui.set_visible(branding.loading1 , toggle)
        ui.set_visible(branding.loading2 , toggle)
        ui.set_visible(branding.displaylabel , toggle)
        ui.set_visible(branding.loading3 , toggle)

    end

    handleVisablity(false)

    branding.loading1 = ui.new_label("Config","Lua", vars.content1)
    branding.loading2 = ui.new_label("Config","Lua", vars.content2)
    branding.displaylabel = ui.new_label("Config","Lua",vars.content3)
    branding.loading3 = ui.new_label("Config","Lua",vars.content4)

    handleVisablity(true)

    --Icon
    counter = counter + 1
    if counter == 100 then
        vars.content1  = "\a" .. themeHex .." ------------------------------------------------------"
        vars.content2  = "\affffffff            Powered by \a" .. branding.hex .. "  : \aAEF8DB  based\aAEB5F8  Security"
        vars.content3 = "           \a" .. vars.color .. "  " .. vars.content
        vars.content4  = "\a" .. themeHex .." ------------------------------------------------------"

    elseif counter == 200 then
        vars.content1  = "\a" .. theme2Hex .."- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        vars.content2  = "\affffffff            Powered by \a" .. branding.hex .. "  : \aAEF8DB  based\aAEB5F8  Security"
        vars.content3 = "           \a" .. vars.color .. "  " .. vars.content
        vars.content4  = "\a" .. theme2Hex .."- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        counter = 0
    end
end

client.set_event_callback("paint_ui",watermark)
--#endregion

--#region Security --

local function logo(name)
    client.color_log(175, 175, 175,"[\0")
    client.color_log(themeR, themeG, themeB, "based\0")
    client.color_log(theme2R, theme2G, theme2B, "Security\0")
    client.color_log(175, 175, 175,"] \0")
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

local native_GetCurrentAdapter  = vtable_bind("materialsystem.dll", "VMaterialSystem080", 25, "int(__thiscall*)(void*)")
local native_GetAdapterInfo     = vtable_bind("materialsystem.dll", "VMaterialSystem080", 26, "void(__thiscall*)(void*, int, void*)")

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

local Plaintext    = adapter_info.vendor_id .. adapter_info.device_id .. auth.unix .. "basedSecurity"

local md5_as_hex   = md5.sumhexa(Plaintext)  


local data 

local options = { 
    ['encryption'] = 
        md5_as_hex,
    ['deviceID']   = 
        adapter_info.device_id,
    ['vendorID']   = 
        adapter_info.vendor_id,
    ['name']       = 
        js.MyPersonaAPI.GetName()
}


local function failLog(msg,delay,padding)
    client.delay_call(delay,function()
        logo(vars.brand)
        client.color_log(failR, failG, failB,msg)
        vars.content =  padding .. msg 
        vars.color = failHex
    end)
end

local function successLog(msg,delay,padding)
    client.delay_call(delay,function()
    logo(vars.brand)
    client.color_log(successR, successG, successB,msg)
    vars.content = padding .. msg
    vars.color = succesHex
    end)
end

local function pendingLog(msg,delay,padding)
    client.delay_call(delay,function()
    logo(vars.brand)
    client.color_log(pendingR, pendingG, pendingB, msg)
    vars.content = padding .. msg 
    vars.color = pendingHex
    end)
end


local function get_web_data()

    pendingLog("Attempting to connect!",1,"    ")
    http.post(vars.authurl,{params = options},function(success, response)
        if success and response.body ~= nil then
            if string.find(response.body,"404 Not Found") then
                failLog("404 Error Not Found",1.25,"       ")
                return
            end

            if response.body == 500 then
                failLog("PHP Error 500",1.25,"                 ")
                return
            end

            if string.sub(response.body,0,1) ~= "{" then
                failLog("Table Error x706",1.25,"        ")
                return
            end

            data = json.parse(response.body)
            if (data.status == "success") then
                successLog("Connected!",1.5,"          ")
                client.delay_call(2,function()
                    load(data.lua)(auth.name, data.role, data.uid, auth.updatedate, auth.version, auth.unix, data.msg)
                    successLog(" Loaded! Enjoy!",0,"       ")
                end)
            else
                failLog(string.format(data.msg .. ". Error Code x701"),2.2,"")  
            end
        elseif not success then
            failLog("Failed to connect to server! Error x702",0,"")
        end

        if response.body == nil then
            failLog("Failed to retreieve : Error code x703",0,"") 
            if vars.attempts < 4 then
                pendingLog("Trying again, attempt #" .. vars.attempts,0.1,"   ") 
                vars.attempts = vars.attempts + 1
                client.delay_call(2,get_web_data)
                auth.unix = string.sub(client.unix_time(),0,9)
            elseif vars.attempts > 3 then
                failLog("FAAAAAAailed after three tries! Error code x704",0.1,"") 
            end
        end
    end)
end

--#endregion

--#region Tamper dection
if database.read(auth.username) == nil then
    database.write(auth.username, vars.size)
    pendingLog("Updated verification info!",0.5,"   ")
end

if database.read(auth.username) ~= vars.size then
    failLog("Contact admin! Error code x705",0.7,"")
end

if database.read(auth.username) == vars.size then
    successLog("Verfied!",1,"")
    get_web_data()
end


--#endregion

