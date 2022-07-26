local args = {...}

--#region Decryption

local function generate_matrix(filler,rows,cols)
    local matrix = {}
    local c,location = 1,1
    for r=1,rows do
        matrix[r] = {}
        for j=location, rows*cols do
            if c == cols + 1 then
                c = 1
                location = j
                break
            end
            matrix[r][c] = filler  
            c = c + 1
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

local function table_to_string(tbl)
    local result = ""
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result .. v
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

local function matrix_to_string(matrix)
    local string = ""
    for _,r in ipairs(matrix) do
       string = string .. table_to_string(r) 
    end
    return string
end

local function decrypt(msg,key)
    local message = ""

    local k_index = 1

    local msg_indx = 1
    local msg_len = #msg
    local msg_tbl = string_to_table(msg)

    local col = key
    local row = math.ceil((msg_len/col))

    local matrix = generate_matrix("true",row,col)
    
    for _=1, col do 
        for r=1, row do
            matrix[r][k_index] = msg_tbl[msg_indx]
            msg_indx = msg_indx + 1
        end
        k_index = k_index + 1
    end
    message = matrix_to_string(matrix)
    return message
end

local info = decrypt(args[1],5)

info = string.gsub(info,"_","")

function Split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local args = (Split(info," "))

--#endregion

local vars = {
    username = "",
    role     = "",
    uid      = 0,
    unix     = 0,
    msg      = ""
}


local function payload(args)

    local function informationVerification(args) -- OTHER WAY TO DETIRMIN IF INFO IS INVALID
        if #args ~= 5 then 
            print("Error 0x21 | Not Authorized")  
            return false 
        elseif true then -- check differance in unix with hard coded differance
            print("detected false info")
            return false
        elseif true then -- make a good handshake
            print("detected false info")
            return false
        elseif true then -- verify custom hash
            print("detected false info")
            return false
        elseif true then
            print("detected false info")
            return false
        else
            vars.username = args[1]
            vars.role = args[2]
            vars.uid = args[3]
            vars.unix = args[4]
            vars.msg = args[5]
            return true
        end
    end

    local function banUser(bool)
        if bool then
            print("Verified!")
            return false
        else
            print("YOU HAVE BEEN BANNED")
            return true
        end
    end

    local function lua()
        local function intiHeartbeat()
            --#region security 
            local ffi = require("ffi")
            local md5 = require 'gamesense/md5' or error("error 203 - MD5 Required")
            local http = require("gamesense/http") or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=19253 on the lua workshop.")


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
            
            
            local heartbeatVars = {
                url = "https://baseddepartment.store/basedSecurity-edp222.php",
                checktime = tonumber(string.sub(client.unix_time(),0,9)) + 1,
                interval =1,
                key = 1,
                data = nil
            }
            
            
            local info = {
                ['encryption']              = nil,
                ['deviceID']                = adapter_info.device_id,
                ['vendorID']                = adapter_info.vendor_id,
                ['unix']                    = tonumber(string.sub(client.unix_time(),0,9)),
                ['fails']                   = 0
            }
            
            local function heartbeat()
                local unix = client.unix_time()
                info['unix'] = tonumber(string.sub(unix,0,9))
                if heartbeatVars.checktime <= info['unix'] then
                    info['encryption'] = md5.sumhexa(adapter_info.vendor_id .. adapter_info.device_id .. (info['unix']) .. "basedSecurity1")  --replace with sha256
                    heartbeatVars.checktime = heartbeatVars.checktime + heartbeatVars.interval
                    http.post(heartbeatVars.url,{params = info},function(success, response)
                        if success and response.body ~= nil then
                            heartbeatVars.key = md5.sumhexa(adapter_info.vendor_id .. adapter_info.device_id .. (info['unix']) .. "basedSecurity2")  
                            heartbeatVars.data = json.parse(response.body)
                            if heartbeatVars.data.same ~= heartbeatVars.key then
                                print("Detection")
                                info['fails'] = info['fails'] + 1
                                print("WARNING! heartbeat fail #" .. info['fails'])
                                if info['fails'] <= 3 then return end
                                    local x = 100
                                    while x > 0 do
                                        x = x + 1
                                end
                            end
                        end
                    end)
                end
            end
            
            --#endregion

            client.set_event_callback("paint_ui",heartbeat)
        end
        
        if banUser(informationVerification(args)) then print("Failed check") return end

        intiHeartbeat()

        --#region Put the lua in here 
        -- Toucan.lua for gamesense.pub
        -- Developed by Ollie#0069

        local surface = require('gamesense/surface') or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=18793 on the lua workshop.")
        local chat = require("gamesense/chat") or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=30625 on the lua workshop.")
        local anti_aim = require('gamesense/antiaim_funcs') or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=29665 on the lua workshop.")
        local http = require("gamesense/http") or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=19253 on the lua workshop.")
        local ffi = require("ffi")
        local md5 = require 'gamesense/md5' or error("error 203 - MD5 Required")
        local easing = require 'gamesense/easing'

        local ui = _G["ui"]
        local client = _G["client"]
        local entity = _G["entity"]
        local local_player = entity.get_local_player()
        local ui_reference, ui_set, ui_set_visible, ui_get = ui.reference, ui.set, ui.set_visible, ui.get
        local client_get_cvar, client_set_cvar = client.get_cvar, client.set_cvar
        local ent_get_prop, ent_get_local = entity.get_prop, entity.get_local_player
        local getLocalPlayer = entity.get_local_player
        local getClassname = entity.get_classname
        local getPlayerWeapon = entity.get_player_weapon
        local setEventCallback = client.set_event_callback
        local client_color_log = client.color_log
        local client_delay_call = client.delay_call

        local username = vars.username
        local role = vars.role
        local uid = vars.uid
        local updatedate = "5/23/22"
        local version = "V 0.9.1"


        chat.print("{grey}[{bluegrey}Toucan{grey}] : {bluegrey}Welcome {orange}" , username)
        chat.print("{grey}[{bluegrey}Toucan{grey}] :{bluegrey} Last updated : {orange}", updatedate) 

        --#region Global Vars

        local rage = 
        {
            hitchance = ui_reference("Rage","Aimbot","Minimum hit chance"),
            doubletap = {ui_reference("Rage","Other","Double tap")},
            doubletapMode = ui_reference("Rage","Other","Double tap mode"),
            doubletapHC = ui_reference("Rage","Other","Double tap hit chance"),
            doubleTapFL = ui_reference("Rage","Other","Double tap fake lag limit"),
            doubletapQS = ui_reference("Rage","Other","Double Tap quick stop"),
            quickstop = {ui_reference("Rage","Other","Quick Stop")},
            delayShot = ui_reference("Rage","Other","Delay shot"),
            safePoint = ui_reference("Rage","Aimbot","Prefer safe point"),
            fakeduck = ui_reference("Rage","Other","Duck peek assist"),
            quickPeek = {ui_reference("Rage","Other","Quick peek assist")},
            mindmg = ui_reference("Rage","Aimbot","Minimum damage"),
            forceSafePoint = ui_reference("Rage","Aimbot","Force safe point")
        }

        local aa = 
        { 
            Enabled = ui_reference("AA","Anti-aimbot angles","Enabled"),
            Pitch = ui_reference("AA","Anti-aimbot angles","Pitch"),
            YawBase = ui_reference("AA","Anti-aimbot angles","Yaw base"),
            Yaw = {ui_reference("AA","Anti-aimbot angles","Yaw")},
            YawJitter = {ui_reference("AA","Anti-aimbot angles","Yaw jitter")},
            BodyYaw = {ui_reference("AA","Anti-aimbot angles","Body yaw")},
            FreestandingBodyYaw = ui_reference("AA","Anti-aimbot angles","Freestanding body yaw"),
            FakeYawLimit = ui_reference("AA","Anti-aimbot angles","Fake yaw limit"),
            EdgeYaw = ui_reference("AA","Anti-aimbot angles","Edge yaw"),
            Freestanding = {ui_reference("AA","Anti-aimbot angles","Freestanding")},
            Roll = ui_reference("AA","Anti-aimbot angles", "Roll")
        }

        local fakelag = 
        {
            enabled = {ui_reference("AA","Fake Lag","Enabled")},
            fakelagamount = ui_reference("AA", "Fake lag", "Amount"),
            variance = ui_reference("AA","Fake Lag","Variance"),
            limit = ui_reference("AA","Fake Lag","Limit")
        }

        local other =
        {
            slowmotion = {ui_reference("AA","Other","Slow motion")},
            slowmotiontype = ui_reference("AA","Other","Slow motion type"),
            legmovement = ui_reference("AA","Other","Leg movement"),
            onshotantiaim = {ui_reference("AA","Other","On shot anti-aim")},
            PingSpike = {ui_reference("MISC","Miscellaneous","Ping spike")}
        }

        local DTSpeed = ui_reference("MISC", "Settings","sv_maxusrcmdprocessticks")

        ui_set_visible(DTSpeed,true)

        local assets = 
        {
            tr = 0,
            tb = 128,
            tg = 128,
            ta = 255,
            font = surface.create_font("Impact Regular", 14, 500, {0x010}),
            storedmode = "",
            antibruteflag = false,
            sw = 0,
            sh = 0 ,
            red = 0,
            green = 0,
            blue = 0,
            red2 = 0,
            green2 = 0,
            blue2 = 0,
            red3 = 0,
            green3 = 0,
            blue3 = 0,
            should_swap = false,
            storedmindmg = ui_get(rage.mindmg),
            abstep = 1,
            jspeed = 0,
            menucolor = ui_reference("Misc","Settings","Menu color"),
            swayspeed = 0,
            lc = false,
            cache = "",
            choke = 0,
            FlickState = "",
            dtreset = true,
            slowwalkreset = false,
            dttoggle = false,
            resetct = false
        }
        local mr,mg,mb = ui.get(assets.menucolor)
        assets.sw, assets.sh = client.screen_size()

        local fonts = {
        Tahoma = surface.create_font("Tahoma", 13, 300, {0x200}),
        Tahomabold = surface.create_font("Tahoma", 13, 500, {0x200}),
        Georgia = surface.create_font("Georgia", 13, 300, {0x010}),
        Georgiabold = surface.create_font("Georgia", 13, 500, {0x010}),
        Consolas = surface.create_font("Consolas", 13, 300, {0x010}),
        Consolasbold = surface.create_font("Consolas", 13, 500, {0x010}),
        ink = surface.create_font("Ink Free", 14, 300, {0x210}),
        inkbold = surface.create_font("Ink Free", 14, 500, {0x210}),
        ComicSans = surface.create_font("Comic Sans MS", 15, 300, {0x010}),
        ComicSansbold = surface.create_font("Comic Sans MS", 15, 500, {0x010}),
        Ebrima = surface.create_font("Ebrima", 13, 300, {0x010}),
        Ebrimabold = surface.create_font("Ebrima", 13, 500, {0x010}),
        Franklin = surface.create_font("Franklin Gothic Medium", 14, 300, {0x010}),
        Franklinbold = surface.create_font("Franklin Gothic Medium", 14, 500, {0x010}),
        Segoe = surface.create_font("Seoge Print", 13, 300, {0x010}),
        Segoebold = surface.create_font("Seoge Print", 13, 500, {0x010}),
        Constantia = surface.create_font("Constantia", 13, 300, {0x020}),
        Constantiabold = surface.create_font("Constantia", 13, 500, {0x020})
        }

        local AA = {
        vx = 0,
        vy = 0,
        velocity = 0,
        speed = 0,
        state = "Static",
        }

        local antiaim = {
        ["active"] = {
            ["Crouch in air"] = {"Down","At targets",180,0,"Center",-7,"Jitter",89,false,60,"default"},
            ["In air"] = {"Down","At targets",180,1,"Offset",0,"Jitter",89,false,55,"default"},
            ["Crouch"] = {"Down","Local view",180,0,"Center",0,"Static",12,false,60,"default"},
            ["Standing"] = {"Down","At targets",180,0,"Offset",-2,"Jitter",89,false,60,"default"},
            ["slowWalk"] = {"Down","At targets",180,0,"Offset",4,"Opposite",89,false,36,"default"},
            ["Running"] = {"Down","At targets",180,0,"Offset",2,"Jitter",5,false,60,"default"}
        },

        ["Default"] = {
            ["Crouch in air"] = {"Down","At targets",180,0,"Center",-7,"Jitter",89,false,60,"default"},
            ["In air"] = {"Down","At targets",180,1,"Offset",0,"Jitter",89,false,55,"default"},
            ["Crouch"] = {"Down","At targets",180,0,"Center",0,"Static",12,false,60,"default"},
            ["Standing"] = {"Default","At targets",180,5,"Center",-8,"Jitter",89,false,45,"default"},
            ["slowWalk"] = {"Down","At targets",180,0,"Offset",4,"Opposite",89,false,36,"default"},
            ["Running"] = {"Down","At targets",180,0,"Offset",2,"Jitter",5,false,60,"default"}
        },

        ["Static"] = {
            ["Crouch in air"] = {"Down","At targets",180,0,"Center",0,"Static",-35,false,55,"static"},
            ["In air"] = {"Down","At targets",180,1,"Center",0,"Static",-35,false,55,"static"},
            ["Crouch"] = {"Down","Local view",180,0,"Center",0,"Static", 4 ,false,55,"static"},
            ["Standing"] = {"Down","At targets",180,0,"Center",0,"Static",-35,false,55,"static"},
            ["slowWalk"] = {"Down","At targets",180,0,"Center",0,"Static",-35,false,55,"static"},
            ["Running"] = {"Down","At targets",180,0,"Center",0,"Static",-35,false,55,"static"}
        },
        ["Jitter"] = {
            ["Crouch in air"] = {"Down","At targets",180,0,"Center",-7,"Jitter",89,false,60,"jitter"},
            ["In air"] = {"Down","At targets",180,1,"Offset",0,"Jitter",89,false,55,"jitter"},
            ["Crouch"] = {"Down","At targets",180,0,"Center",4,"Static",89,false,42,"jitter"},
            ["Standing"] = {"Down","At targets",180,5,"center",-8,"Jitter",89,false,45,"jitter"},
            ["slowWalk"] = {"Down","At targets",180,0,"Offset",4,"Opposite",89,false,46,"jitter"},
            ["Running"] = {"Down","At targets",180,0,"Offset",2,"Jitter",89,false,60,"jitter"}
        },
        ["Infinity"] = {
            ["Crouch in air"] = {"Default","At targets",180,5,"Center",-8,"Jitter",89,false,45,"Infinity"},
            ["In air"] = {"Default","At targets",180,5,"Center",-8,"Jitter",89,false,45,"Infinity"},
            ["Crouch"] = {"Default","At targets",180,5,"Center",-8,"Jitter",89,false,45,"Infinity"},
            ["Standing"] = {"Default","At targets",180,5,"Center",-8,"Jitter",89,false,45,"Infinity"},
            ["slowWalk"] = {"Default","At targets",180,5,"Center",-8,"Jitter",89,false,45,"Infinity"},
            ["Running"] = {"Default","At targets",180,5,"Center",-8,"Jitter",89,false,45,"Infinity"},
        },
        ["Beast"] = {
            ["Crouch in air"] = {"Default","At targets",180,-1,"Center",72,"Jitter",0,false,55,"Beast"},
            ["In air"] = {"Default","At targets",180,-1,"Center",72,"Jitter",0,false,55,"Beast"},
            ["Crouch"] = {"Down","At targets",180,0,"Center",0,"Static",12,false,60,"Beast"},
            ["Standing"] = {"Default","At targets",180,5,"Center",37,"Opposite",5,false,60,"Beast"},
            ["slowWalk"] = {"Default","At targets",180,-39,"Offset",79,"Jitter",0,false,48,"Beast"},
            ["Running"] = {"Default","At targets",180,-39,"Offset",79,"Jitter",0,false,60,"Beast"}
        },
        ["Sol"] = {
            ["Crouch in air"] = {"Down","At targets",180,0,"Center",82,"Jitter",0,true,60,"Sol"},
            ["In air"] ={"Down","At targets",180,0,"Center",82,"Jitter",0,true,60,"Sol"},
            ["Crouch"] = {"Down","At targets",180,0,"Center",82,"Jitter",0,true,60,"Sol"},
            ["Standing"] = {"Down","At targets",180,-7,"Center",60,"Jitter",21,true,60,"Sol"},
            ["slowWalk"] = {"Down","At targets",180,0,"Center",82,"Jitter",0,true,60,"Sol"},
            ["Running"] = {"Down","At targets",180,0,"Center",82,"Jitter",0,true,60,"Sol"}
        },
        ["Insightful"] = {
            ["Crouch in air"] = {"Down","At targets",180,0,"Offset",99,"Jitter",-47,false,60,"insightful"},
            ["In air"] = {"Down","At targets",180,1,"center",88,"Jitter",17,false,55,"insightful"},
            ["Crouch"] = {"Down","At targets",180,0,"Offset",99,"Jitter",-47,false,60,"insightful"},
            ["Standing"] = {"Down","At targets",180,0,"Center",0,"Static",-35,false,55,"static"},
            ["slowWalk"] = {"Down","At targets",180,0,"Offset",99,"Jitter",-47,false,36,"insightful"},
            ["Running"] = {"Down","At targets",180,0,"Offset",99,"Jitter",-47,false,60,"insightful"}
        }
        }
        --#endregion

        local function disableExploits()
        ui.set(rage.doubletap[1], false)
        ui.set(other.onshotantiaim[1],false)
        end

        --#region Menu Construction
        local menu = {
        ui.new_label("AA","Anti-Aimbot angles", "\aB6B665FF       -------------Toucan-------------"),
        Menumanger = ui.new_combobox("AA","Anti-Aimbot angles","Menu selection","AA","Rage","Other"),
        seperator1 = ui.new_label("AA","Anti-Aimbot angles", "--------------------------------------------------"),
        EnableAA = ui.new_checkbox("AA","Anti-Aimbot angles","Enable anti-aim"),
        debug = ui.new_checkbox("AA","Anti-Aimbot angles","Enable AA Debug"),
        antibrute = ui.new_checkbox("AA","Anti-Aimbot angles","Enable anti-bruteforce"),
        ToggleRoll = ui.new_checkbox("AA", "Anti-Aimbot angles", "Enable Custom roll"),
        CustomRoll = ui.new_combobox("AA","Anti-Aimbot angles","Roll modes","Static","Jitter","Sway"),
        RollRange = ui.new_slider("AA","Anti-Aimbot angles", "Roll range", -50, 50, 0, true, "", 1),
        seperator2 = ui.new_label("AA","Anti-Aimbot angles", "--------------------------------------------------"),
        SelectionAA = ui.new_combobox("AA","Anti-Aimbot angles","AA Selection","Movement Based","Flick exploit"),
        GlobalAA = ui.new_combobox("AA","Anti-Aimbot angles","Global AA Type","Default","Static","Jitter","Infinity","Sol","Beast","Insightful"),
        EnableBuilder = ui.new_checkbox("AA","Anti-Aimbot angles","Enable anti-aim Builder"),
        BuilderAA = ui.new_combobox("AA","Anti-Aimbot angles","AA Builder","Crouch in air","In air","Crouch","Standing","slowWalk","Running"),
        disclaimer = ui.new_label("AA","Anti-Aimbot angles", "! You need to disable all other exploits !"),
        disableExploits = ui.new_button("AA","Anti-Aimbot angles","Disable Exploits",disableExploits),
        invert = ui.new_hotkey("AA", "Anti-Aimbot angles", "Invert", false),
        disablers = ui.new_multiselect("AA", "Anti-Aimbot angles", "Disable when", {"High speed", "In air"}),
        Knife_dt = ui.new_checkbox("AA", "Anti-Aimbot angles", "Disable DT on knife"),
        legit_e_key = ui.new_checkbox("AA","Anti-Aimbot angles", "Legit AA on E"),
        lconpeak = ui.new_checkbox("AA","Anti-Aimbot angles","!EXPERIMENTAL! LC on peak (awp)(scout)"),
        doubletap = ui.new_checkbox("AA", "Anti-Aimbot angles", "Enable doubletap"),
        DTselection = ui.new_combobox("AA","Anti-Aimbot angles","Doubletap selection","Normal","Fast","Adaptive"),
        JitterSpeed = ui.new_slider("AA","Anti-Aimbot angles", "Jitter speed", 5, 100, 12, true, "%", 1),
        Idealtick = ui.new_hotkey("AA","Anti-Aimbot angles", "Ideal Tick", false),
        MinDMGoverride = ui.new_hotkey("AA","Anti-Aimbot angles", "Min dmg override", false),
        mindmgval = ui.new_slider("AA","Anti-Aimbot angles", "Min dmg override value", 1, 100, 12, true, "hp", 1),
        EnableIndicators = ui.new_checkbox("AA","Anti-Aimbot angles","Enable Indicators",true),
        clantagen = ui.new_checkbox("AA", "Anti-Aimbot angles", "Clantag"),
        console_log = ui.new_checkbox("AA","Anti-Aimbot angles","Console Logs",true),
        WatermarkCB = ui.new_checkbox("AA","Anti-Aimbot angles","Enable Watermark",true),
        watermarkselection = ui.new_multiselect("AA","Anti-Aimbot angles","Features in watermark",{"Name","Ping","Fps","UID","Version"}),
        crosshair_indicator_en = ui.new_checkbox("AA", "Anti-Aimbot angles", "Crosshair indicators"),
        fontselection = ui.new_combobox("AA","Anti-Aimbot angles","Font selection","Tahoma","Georgia","Consolas","ink","ComicSans","Ebrima","Franklin","Segoe","Constantia"),
        easteregg = ui.new_checkbox("AA", "Anti-Aimbot angles", "Enable Easteregg"),
        customtheme = ui.new_checkbox("AA","Anti-Aimbot angles","Custom theme"),
        color1L = ui.new_label("AA","Anti-Aimbot angles","Theme 1"),
        color1 = ui.new_color_picker("AA","Anti-Aimbot angles","Theme 1",255,255,255,255),
        color2L = ui.new_label("AA","Anti-Aimbot angles","Theme 2"),
        color2 = ui.new_color_picker("AA","Anti-Aimbot angles","Theme 2",0,0,0,255),
        color3L = ui.new_label("AA","Anti-Aimbot angles","Background"),
        color3 = ui.new_color_picker("AA","Anti-Aimbot angles","Background",0,0,0,255),
        color4L = ui.new_label("AA","Anti-Aimbot angles","Active Text"),
        color4 = ui.new_color_picker("AA","Anti-Aimbot angles","Active Text",0,255,0,255),
        SlowwalkEnable = ui.new_checkbox("AA", "Anti-Aimbot angles", "Slow Walk"),
        SlowwalkSpeed = ui.new_slider("AA", "Anti-Aimbot angles", "Speed", 1, 245, 40, true, "%"),
        seperator3 = ui.new_label("AA","Anti-Aimbot angles", "--------------------------------------------------"),
        }

        --#endregion

        --#region Menu Update AA

        local aatypes = {"Default","Static","Jitter", "Infinity", "Beast", "Sol", "Insightful"}

        local movementTypes = {"Crouch in air","In air","Crouch","Standing","slowWalk","Running"}

        local AAmenu = {}
        for k,v in pairs(movementTypes) do
        table.insert(AAmenu,ui.new_combobox("AA", "Anti-aimbot angles", v, aatypes))
        end

        local function updateAA()
        if ui.get(menu.EnableBuilder) then
        for k,v in pairs(movementTypes) do
        antiaim["active"][v] = antiaim[ui.get(AAmenu[k])][v]
        end
        else
            for k,v in pairs(movementTypes) do
            antiaim["active"][v] = antiaim[ui.get(menu.GlobalAA)][v]
            end
        end
        end

        --#endregion


        --#region Manage menu
        local function Managemenu()

        if ui_get(menu.Menumanger) == "AA"  then
            ui.set_visible(menu.EnableAA, true)
            ui.set_visible(menu.lconpeak, false)
            ui.set_visible(menu.antibrute, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Movement Based"))
            ui.set_visible(menu.GlobalAA,not ui.get(menu.EnableBuilder) and  (ui.get(menu.SelectionAA) == "Movement Based") and ui.get(menu.EnableAA))
            ui.set_visible(menu.EnableBuilder, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Movement Based"))
            ui.set_visible(menu.BuilderAA, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Movement Based") and ui.get(menu.EnableBuilder))
            for k,v in pairs(AAmenu) do
            if movementTypes[k] == ui.get(menu.BuilderAA) then
                ui.set_visible(AAmenu[k], ui.get(menu.EnableAA) and ui.get(menu.EnableBuilder))
            else
                ui.set_visible(AAmenu[k], false)
            end
            end
            ui.set_visible(menu.seperator2,true)
            ui.set_visible(menu.seperator3,false)
            ui.set_visible(menu.SelectionAA, ui.get(menu.EnableAA))
            ui.set_visible(menu.invert, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Flick exploit"))
            ui.set_visible(menu.disablers, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Flick exploit"))
            ui.set_visible(menu.disclaimer, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Flick exploit"))
            ui.set_visible(menu.disableExploits, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Flick exploit"))
            ui.set_visible(menu.debug, ui.get(menu.EnableAA))
            ui.set_visible(menu.doubletap, false)
            ui.set_visible(menu.DTselection, false)
            ui.set_visible(menu.Knife_dt, false)
            ui.set_visible(menu.Idealtick, false)
            ui.set_visible(menu.legit_e_key, false)
            ui.set_visible(menu.MinDMGoverride, false)
            ui.set_visible(menu.ToggleRoll, true) 
            ui.set_visible(menu.CustomRoll, ui.get(menu.ToggleRoll))
            ui.set_visible(menu.RollRange, (ui.get(menu.CustomRoll) == "Static" or ui.get(menu.CustomRoll) == "Jitter") and ui.get(menu.ToggleRoll))
            ui.set_visible(menu.JitterSpeed, (ui.get(menu.CustomRoll) == "Jitter") and ui.get(menu.ToggleRoll))
            ui.set_visible(menu.mindmgval, false)
            ui.set_visible(menu.EnableIndicators, false)
            ui.set_visible(menu.WatermarkCB, false)
            ui.set_visible(menu.watermarkselection, false)
            ui.set_visible(menu.clantagen, false)
            ui.set_visible(menu.console_log, false)
            ui.set_visible(menu.crosshair_indicator_en, false)
            ui.set_visible(menu.fontselection, false)
            ui.set_visible(menu.easteregg, false)
            ui.set_visible(menu.color1L, false)
            ui.set_visible(menu.color1, false)
            ui.set_visible(menu.color2L, false)
            ui.set_visible(menu.color2, false)
            ui.set_visible(menu.color3L, false)
            ui.set_visible(menu.color3, false)
            ui.set_visible(menu.color4L, false)
            ui.set_visible(menu.color4, false)
            ui.set_visible(menu.SlowwalkEnable,false)
            ui.set_visible(menu.SlowwalkSpeed,false)
            ui.set_visible(menu.customtheme, false)
        elseif ui_get(menu.Menumanger) == "Rage"  then
            for k,v in pairs(AAmenu) do
                ui.set_visible(AAmenu[k],false)        
            end
            ui.set_visible(menu.seperator2,false)
            ui.set_visible(menu.seperator3,true)
            ui.set_visible(menu.BuilderAA,false)
            ui.set_visible(menu.EnableBuilder,false)
            ui.set_visible(menu.GlobalAA,false)
            ui.set_visible(menu.disableExploits, false)
            ui.set_visible(menu.disclaimer, false)
            ui.set_visible(menu.lconpeak, true)
            ui.set_visible(menu.EnableAA, false)
            ui.set_visible(menu.Idealtick, true)
            ui.set_visible(menu.debug, false)
            ui.set_visible(menu.SelectionAA, false)
            ui.set_visible(menu.invert, false)
            ui.set_visible(menu.disablers, false)
            ui.set_visible(menu.antibrute, false)
            ui.set_visible(menu.antibrute, false)
            ui.set_visible(menu.ToggleRoll, false)
            ui.set_visible(menu.RollRange, false)
            ui.set_visible(menu.CustomRoll, false)
            ui.set_visible(menu.JitterSpeed, false)
            ui.set_visible(menu.doubletap, true)
            ui.set_visible(menu.DTselection, ui.get(menu.doubletap))
            ui.set_visible(menu.Knife_dt, true)
            ui.set_visible(menu.legit_e_key, true)
            ui.set_visible(menu.MinDMGoverride, true)
            ui.set_visible(menu.mindmgval, true)
            ui.set_visible(menu.WatermarkCB, false)
            ui.set_visible(menu.EnableIndicators, false)
            ui.set_visible(menu.watermarkselection, false)
            ui.set_visible(menu.clantagen, false)
            ui.set_visible(menu.console_log, false)
            ui.set_visible(menu.crosshair_indicator_en, false)
            ui.set_visible(menu.fontselection, false)
            ui.set_visible(menu.easteregg, false)
            ui.set_visible(menu.color1, false)
            ui.set_visible(menu.color1L, false)
            ui.set_visible(menu.color2, false)
            ui.set_visible(menu.color2L, false)
            ui.set_visible(menu.color3L, false)
            ui.set_visible(menu.color3, false)
            ui.set_visible(menu.color4L, false)
            ui.set_visible(menu.color4, false)
            ui.set_visible(menu.customtheme, false)
            ui.set_visible(menu.SlowwalkEnable,true)
            ui.set_visible(menu.SlowwalkSpeed,ui.get(menu.SlowwalkEnable))
        else
            for k,v in pairs(AAmenu) do
            ui.set_visible(AAmenu[k],false)        
            end
            ui.set_visible(menu.BuilderAA,false)
            ui.set_visible(menu.EnableBuilder,false)
            ui.set_visible(menu.seperator3,true)
            ui.set_visible(menu.seperator2,false)
            ui.set_visible(menu.GlobalAA,false)
            ui.set_visible(menu.disclaimer, false)
            ui.set_visible(menu.disableExploits, false)
            ui.set_visible(menu.antibrute, false)
            ui.set_visible(menu.lconpeak, false)
            ui.set_visible(menu.EnableAA, false)
            ui.set_visible(menu.SelectionAA, false)
            ui.set_visible(menu.invert, false)
            ui.set_visible(menu.disablers, false)
            ui.set_visible(menu.debug, false)
            ui.set_visible(menu.Idealtick, false)
            ui.set_visible(menu.antibrute, false)
            ui.set_visible(menu.ToggleRoll, false)
            ui.set_visible(menu.RollRange, false)
            ui.set_visible(menu.CustomRoll, false)
            ui.set_visible(menu.JitterSpeed, false)
            ui.set_visible(menu.doubletap, false)
            ui.set_visible(menu.DTselection, false)
            ui.set_visible(menu.Knife_dt, false)
            ui.set_visible(menu.legit_e_key, false)
            ui.set_visible(menu.MinDMGoverride, false)
            ui.set_visible(menu.mindmgval, false)
            ui.set_visible(menu.WatermarkCB, true)
            ui.set_visible(menu.EnableIndicators, true)
            ui.set_visible(menu.watermarkselection, ui.get(menu.WatermarkCB))
            ui.set_visible(menu.clantagen, true)
            ui.set_visible(menu.console_log, true)
            ui.set_visible(menu.crosshair_indicator_en, true)
            ui.set_visible(menu.fontselection, true)
            ui.set_visible(menu.easteregg, (ui.get(menu.fontselection) == "ComicSans"))
            ui.set_visible(menu.customtheme, true)
            ui.set_visible(menu.color1, ui.get(menu.customtheme))
            ui.set_visible(menu.color1L, ui.get(menu.customtheme))
            ui.set_visible(menu.color2, ui.get(menu.customtheme))
            ui.set_visible(menu.color2L, ui.get(menu.customtheme))
            ui.set_visible(menu.color3, ui.get(menu.customtheme))
            ui.set_visible(menu.color3L, ui.get(menu.customtheme))
            ui.set_visible(menu.color4L, ui.get(menu.customtheme))
            ui.set_visible(menu.color4, ui.get(menu.customtheme))
            ui.set_visible(menu.SlowwalkEnable,false)
            ui.set_visible(menu.SlowwalkSpeed,false)

        end
        end
        --#endregion


        --#region global functions

        --#region Branding

        local branding = {
        vars = {
        brand                       = "Toucan",
        half1                       = "Tou",
        half2                       = "can",
        hex                         = 0000000,
        },
        colors =  {
        theme1                      = {174, 248, 219},
        theme2                      = {198, 174, 248},
        loaderTheme1                = {r, g, b},
        loaderTheme2                = {r, g, b},
        fail                        = {248, 177, 174},
        success                     = {192, 248, 174},
        pending                     = {248, 241, 174},
        RGB                         = {0  , 0  ,   0}
        },
        }
        local function logo()
        client_color_log(175, 175, 175,"[\0")
        client_color_log(branding.colors.theme1[1],branding.colors.theme1[2],branding.colors.theme1[3], branding.vars.half1 .. "\0")
        client_color_log(branding.colors.theme2[1],branding.colors.theme2[2],branding.colors.theme2[3], branding.vars.half2 .. "\0")
        client_color_log(175, 175, 175,"] \0")
        end

        local function failLog(msg,delay)
        client_delay_call(delay,function()
            logo()
            client_color_log(branding.colors.fail[1],branding.colors.fail[2],branding.colors.fail[3], msg)
        end)
        end

        local function successLog(msg,delay)
        client_delay_call(delay,function()
            logo()
            client_color_log(branding.colors.success[1],branding.colors.success[2],branding.colors.success[3], msg)
        end)
        end

        local function pendingLog(msg,delay)
        client_delay_call(delay,function()
            logo()
            client_color_log(branding.colors.pending[1],branding.colors.pending[2],branding.colors.pending[3], msg)
        end)
        end
        --#endregion

        local function rainbow()
            local frequency = globals.curtime() * 3
            local height = 255
            local offset = 0
            if not ui.get(menu.customtheme) then
            assets.red = math.abs(math.sin(0.3*frequency + 0) * height + offset)
            assets.green = math.abs(math.sin(0.3*frequency + 2) * height + offset)
            assets.blue = math.abs(math.sin(0.3*frequency + 4) * height + offset)
            assets.red2 = math.abs(math.sin(0.3*frequency + 10) * height + offset)
            assets.green2 = math.abs(math.sin(0.3*frequency + 12) * height + offset)
            assets.blue2 = math.abs(math.sin(0.3*frequency + 14) * height + offset)
            assets.red3 = math.abs(math.sin(0.3*frequency + 20) * height + offset)
            assets.green3 = math.abs(math.sin(0.3*frequency + 22) * height + offset)
            assets.blue3 = math.abs(math.sin(0.3*frequency + 24) * height + offset)
            elseif ui.get(menu.customtheme) then
            assets.red, assets.green,assets.blue = ui.get(menu.color1)
            assets.red2, assets.green2,assets.blue2 = ui.get(menu.color2)
            end
        end


        local function toggle_aa_visability(flag)
        
            ui_set_visible(aa.Enabled, flag)
            ui_set_visible(aa.YawJitter[1], flag)
            ui_set_visible(aa.YawJitter[2], flag)
            ui_set_visible(aa.YawBase, flag)
            ui_set_visible(aa.Yaw[1], flag)
            ui_set_visible(aa.Yaw[2], flag)
            ui_set_visible(aa.Pitch, flag)
            ui_set_visible(aa.FreestandingBodyYaw, flag)
            ui_set_visible(aa.Freestanding[1], flag)
            ui_set_visible(aa.Freestanding[2], flag)
            ui_set_visible(aa.FakeYawLimit, flag)
            ui_set_visible(aa.EdgeYaw, flag)
            ui_set_visible(aa.BodyYaw[1], flag)
            ui_set_visible(aa.BodyYaw[2], flag)    
            ui_set_visible(aa.Roll, flag)    
        end

        local function GetClosestPoint(A, B, P)
            local a_to_p = { P[1] - A[1], P[2] - A[2] }
            local a_to_b = { B[1] - A[1], B[2] - A[2] }

            local atb2 = a_to_b[1]^2 + a_to_b[2]^2

            local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
            local t = atp_dot_atb / atb2
            
            return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
        end

        function surface.draw_gradient_text(x, y, r, g, b, a, r2, g2, b2, a2, f, text)
        local fullText = ""
        for i = 1, text:len() do
            local w = surface.get_text_size(f, fullText)
            local percent = math.max(0, math.min(1, (text:len() - i) / text:len()))

            local finalR = r * percent + r2 * (1 - percent)
            local finalG = g * percent + g2 * (1 - percent)
            local finalB = b * percent + b2 * (1 - percent)
            local finalA = a * percent + a2 * (1 - percent)

            surface.draw_text(x + w, y, finalR, finalG, finalB, finalA, f, text:sub(i, i))

            fullText = fullText .. text:sub(i, i)
        end
        end

        local contains = function(table, value)
        for _, v in ipairs(ui_get(table)) do
            if v == value then
                return true
            end
        end
        return false
        end

        local function includes(t, v)
        for _,val in ipairs(t) do
            if v == val then
                return true
            end
        end

        return false
        end

        local x = 6
        local y = assets.sh/2 + 10

        local moving = false
        local moving2 = false


        local function intersect(rangex,rangey,xc,yc)
        local mx, my = surface.get_mouse_pos()
        local leftClick = client.key_state(0x01);
        if mx >= xc - 10 and mx <= (xc + rangex) and my >= yc - 10 and my <= yc + rangey and leftClick and not moving2 then
            moving = true
        end
        if moving and leftClick then
            x = mx - 10
            y = my - 10
        elseif not leftClick then
            moving = false
        end
        end

        local function checkbounds(indicatorhight)
        local mx, my = surface.get_mouse_pos()
        if mx + 125 >= assets.sw and moving then
            x = assets.sw-150 
        end
        if my == 0 and moving then
            y = 1
        end
        if mx == 0 and moving then
            x = 0
        end
        if my + (indicatorhight)*20 >= assets.sh and moving then
            y = assets.sh - (indicatorhight)*20 - 20
        end
        end

        local a = 6 
        local b = assets.sh/2 + 120



        local function aaintersect(rangea,rangeb,xc,yc)
        local mx, my = surface.get_mouse_pos()
        local leftClick = client.key_state(0x01);
        if mx >= xc - 50 and mx <= (xc + rangea) and my >= yc - 20 and my <= yc + rangeb and leftClick and not moving then
            moving2 = true
        end
        if moving2 == true and leftClick then
            a = mx - 10
            b = my - 5
        elseif not leftClick then
            moving2 = false
        end
        end

        local function aacheckbounds(indicatorhight)
        local mx, my = surface.get_mouse_pos()
        if mx +150 >= assets.sw and moving2 then
            a = assets.sw-150 
        end
        if my == 0 and moving2 then
            b = 1
        end
        if mx == 0 and moving2 then
            a = 0
        end
        if my + 10 >= assets.sh and moving2 then
            b = assets.sh - 20
        end
        end

        --#endregion


        --#region Watermark 

        local function watermarklength()
        local length = #(ui.get(menu.watermarkselection))
        return string.rep("%s / ", length)
        end 

        local frametimes = {} -- Not in a function
        local fps_prev = 0-- Not in a function

        local function AccumulateFps()
        local ft = globals.absoluteframetime()
        
        if ft > 0 then
            table.insert(frametimes, 1, ft)
        end

        local count = #frametimes

        if count == 0 then
            return 0
        end

        local i, accum = 0, 0

        while accum < 0.5 do
            i = i + 1
            accum = accum + frametimes[i]
            if i >= count then
            break
            end
        end

        accum = accum / i

        while i < count do
            i = i + 1
            table.remove(frametimes)
        end

        local fps = 1 / accum
        local rt = globals.realtime()

        if math.abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
            fps_prev = fps
            last_update_time = rt
        else
            fps = fps_prev
        end

        return math.floor(fps + 0.5)
        end



        local function newWatermark()
        if ui.get(menu.WatermarkCB) then
            
            local vars = {}
            local ping = math.floor(client.latency() * 1000)
            local watermarkselection = ui.get(menu.watermarkselection)
            
            table.insert(vars,"Toucan")

            for i =1, #watermarkselection do
                
                if watermarkselection[i] == "Name" then
                    table.insert(vars,username)
                end
                if watermarkselection[i] == "Ping" then
                    table.insert(vars,"Ping : " .. ping)
                end
                if watermarkselection[i] == "Fps" then
                    table.insert(vars,"Fps : " .. AccumulateFps())
                end
                if watermarkselection[i] == "UID" then
                    table.insert(vars,"UID : ".. uid)
                end
                if watermarkselection[i] == "Version" then
                table.insert(vars,version)
            end
            end

            if vars[1] == "Toucan" then
            table.insert(vars,role)
            end

            local font = fonts[ui.get(menu.fontselection)]
            local newWatermarkLenth = surface.get_text_size(font, string.format(watermarklength() .. "%s   ", vars[1] , vars[2],vars[3],vars[4],vars[5],vars[6]))
            local r,g,b,ba
            if ui.get(menu.customtheme) then
            r,g,b,ba = ui.get(menu.color3)
            else
            r,g,b,ba = 35,35,35,a
            end
            local tr, tg, tb, ta = 255 ,255 ,255 ,255
            -- Watermark bar 
            surface.draw_filled_gradient_rect(assets.sw - newWatermarkLenth - 12,4, newWatermarkLenth +4, 6, assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, true)
            -- Watermark
            surface.draw_filled_rect(assets.sw - newWatermarkLenth - 10, 6, newWatermarkLenth, 20, 35,35,35,255)
            -- Outline
            surface.draw_filled_rect(assets.sw - newWatermarkLenth - 10, 6, newWatermarkLenth, 20, r, g, b, ba) 
            -- Text
            if ui.get(menu.easteregg) and ui.get(menu.fontselection) == "ComicSans" then
                surface.draw_gradient_text(assets.sw - newWatermarkLenth - 5, 9 , assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, fonts[ui.get(menu.fontselection)], string.format(watermarklength() .. "%s",  vars[1] , vars[2],vars[3],vars[4],vars[5],vars[6]))
            else
            surface.draw_text(assets.sw - newWatermarkLenth - 5, 9, tr, tg, tb, ta, fonts[ui.get(menu.fontselection)], string.format(watermarklength() .. "%s",  vars[1] , vars[2],vars[3],vars[4],vars[5],vars[6]))
            end
        end
        end

        --#endregion indicators 


        --#region Clan-tag 
        local function time_to_ticks(time)
            return math.floor(time / globals.tickinterval() + 1)
        end
        
        local function tag_anim(text, indices)
        local text_anim = "                 " .. text .. "                        " 
        local tickcount = globals.tickcount() + time_to_ticks(client.latency())
        local i = tickcount / time_to_ticks(0.5)

        i = math.floor(i % #indices)
        i = indices[i+1]+1

        return string.sub(text_anim, i, i+15)
        end
        
        local function run_tag_animation()
        local clan_tag = tag_anim("Toucan❀", {0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 10, 9, 9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0}) -- how long do u want the each word to be
        if clan_tag ~= clan_tag_prev then
            client.set_clan_tag(clan_tag)
        end
        clan_tag_prev = clan_tag
        end
        
        local function clantag()
        if ui_get(menu.clantagen) then
            run_tag_animation()
            assets.resetct = false
        elseif not ui_get(menu.clantagen) and not assets.resetct then 
            client.set_clan_tag("")
            assets.resetct = true
        end
        end
        --#endregion


        --#region Anti-brute  -- Rave is boss

        client.set_event_callback("bullet_impact", function(c)
            if ui_get(menu.antibrute) and entity.is_alive(entity.get_local_player()) then
                local ent = client.userid_to_entindex(c.userid)
                if not entity.is_dormant(ent) and entity.is_enemy(ent) then
                    local ent_shoot = { entity.get_prop(ent, "m_vecOrigin") }
                    ent_shoot[3] = ent_shoot[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
                    local player_head = {entity.hitbox_position(entity.get_local_player(), 0) }
                    local closest = GetClosestPoint(ent_shoot, { c.x, c.y, c.z }, player_head)
                    local delta = { player_head[1]-closest[1], player_head[2]-closest[2] }
                    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)

                    if math.abs(delta_2d) < 26 then
                        assets.should_swap = true
                    end
                end
            end
        end)

        client.set_event_callback("run_command", function(c)
            if ui_get(menu.antibrute) and assets.should_swap then
                ui_set(aa.BodyYaw[2], - ui_get(aa.BodyYaw[2]))
                assets.should_swap = false
                successLog("Anti-Bruting",0)
            end
        end)

        --#endregion


        --#region animation

        --Created by - Ollie#0069

        local Load = {
            ["stage0"] = "   ",
            ["stage1"] = " ⠋ ",
            ["stage2"] = " ⠃ ",
            ["stage3"] = " ⠇ ",
            ["stage4"] = " ⠆ ",
            ["stage5"] = " ⠦ ",
            ["stage6"] = " ⠤ ",
            ["stage7"] = " ⠴ ",
            ["stage8"] = " ⠰ ",
            ["stage9"] = " ⠸ ",
            ["stage10"] = " ⠘ ",
            ["stage11"] = " ⠙ ",
            ["stage12"] = " ⠉ ",
            location = 0
        }

        local counter = 0

        --#endregion


        --#region Movement based AA
        local speed
        local movestate
        local function anti_aim()
        if entity.get_prop(local_player, "m_lifeState") ~= 0 then return end
        if not (ui.get(menu.SelectionAA) == "Movement Based") then return end

        local vx, vy = entity.get_prop(local_player, "m_vecVelocity")
        movestate = (entity.get_prop(entity.get_local_player(), "m_fFlags"))

        if (vx == nil or vy == nil) then vx = 0; vy = 0 end

        speed = math.floor(math.min(10000, math.sqrt(vx^2 + vy^2)) + 0.5)

        if movestate == 262 and ui.get(rage.doubletap[2]) and ui.get(rage.doubletap[1]) then
            AA.state = "Crouch in air"
            ui.set(aa.YawBase, antiaim["active"]["Crouch in air"][2])
            ui.set(aa.Yaw[1], antiaim["active"]["Crouch in air"][3])
            ui.set(aa.Yaw[2], antiaim["active"]["Crouch in air"][4])
            ui.set(aa.YawJitter[1], antiaim["active"]["Crouch in air"][5])
            ui.set(aa.YawJitter[2], antiaim["active"]["Crouch in air"][6])
            ui.set(aa.BodyYaw[1], antiaim["active"]["Crouch in air"][7])
            ui.set(aa.Pitch, antiaim["active"]["Crouch in air"][1])
            ui.set(aa.BodyYaw[2],antiaim["active"]["Crouch in air"][8])
            ui.set(aa.FreestandingBodyYaw, antiaim["active"]["Crouch in air"][9])
            ui.set(aa.FakeYawLimit, antiaim["active"]["Crouch in air"][10])
        elseif movestate == 262 or (client.key_state(0x11) and client.key_state(0x20)) then
            AA.state = "Crouch in air"
            ui.set(aa.YawBase, antiaim["active"]["Crouch in air"][2])
            ui.set(aa.Yaw[1], antiaim["active"]["Crouch in air"][3])
            ui.set(aa.Yaw[2], antiaim["active"]["Crouch in air"][4])
            ui.set(aa.YawJitter[1], antiaim["active"]["Crouch in air"][5])
            ui.set(aa.YawJitter[2], antiaim["active"]["Crouch in air"][6])
            ui.set(aa.BodyYaw[1], antiaim["active"]["Crouch in air"][7])
            ui.set(aa.Pitch, antiaim["active"]["Crouch in air"][1])
            ui.set(aa.BodyYaw[2],antiaim["active"]["Crouch in air"][8])
            ui.set(aa.FreestandingBodyYaw, antiaim["active"]["Crouch in air"][9])
            ui.set(aa.FakeYawLimit, antiaim["active"]["Crouch in air"][10])
        elseif movestate == 256 or client.key_state(0x20) then 
            AA.state = "In air"
            ui.set(aa.Pitch, antiaim["active"]["In air"][1])
            ui.set(aa.YawBase, antiaim["active"]["In air"][2])
            ui.set(aa.Yaw[1], antiaim["active"]["In air"][3])
            ui.set(aa.Yaw[2], antiaim["active"]["In air"][4])
            ui.set(aa.YawJitter[1], antiaim["active"]["In air"][5])
            ui.set(aa.YawJitter[2], antiaim["active"]["In air"][6])
            ui.set(aa.BodyYaw[1], antiaim["active"]["In air"][7])
            ui.set(aa.BodyYaw[2],antiaim["active"]["In air"][8])    
            ui.set(aa.FreestandingBodyYaw,antiaim["active"]["In air"][9])
            ui.set(aa.FakeYawLimit, antiaim["active"]["In air"][10])
        elseif movestate == 263 then
            AA.state = "Crouch"
            ui.set(aa.Pitch, antiaim["active"]["Crouch"][1])
            ui.set(aa.YawBase, antiaim["active"]["Crouch"][2])
            ui.set(aa.Yaw[1], antiaim["active"]["Crouch"][3])
            ui.set(aa.Yaw[2], antiaim["active"]["Crouch"][4])
            ui.set(aa.YawJitter[1], antiaim["active"]["Crouch"][5])
            ui.set(aa.YawJitter[2], antiaim["active"]["Crouch"][6])
            ui.set(aa.BodyYaw[1], antiaim["active"]["Crouch"][7])
            ui.set(aa.BodyYaw[2],antiaim["active"]["Crouch"][8])
            ui.set(aa.FreestandingBodyYaw,antiaim["active"]["Crouch"][9])
            ui.set(aa.FakeYawLimit, antiaim["active"]["Crouch"][10])
        elseif ui.get(other.slowmotion[2]) then
            AA.state = "slowWalk"
            ui.set(aa.Pitch, antiaim["active"]["slowWalk"][1])
            ui.set(aa.YawBase, antiaim["active"]["slowWalk"][2])
            ui.set(aa.Yaw[1], antiaim["active"]["slowWalk"][3])
            ui.set(aa.Yaw[2], antiaim["active"]["slowWalk"][4])
            ui.set(aa.YawJitter[1], antiaim["active"]["slowWalk"][5])
            ui.set(aa.YawJitter[2], antiaim["active"]["slowWalk"][6])
            ui.set(aa.BodyYaw[1], antiaim["active"]["slowWalk"][7])
            ui.set(aa.BodyYaw[2],antiaim["active"]["slowWalk"][8])
            ui.set(aa.FreestandingBodyYaw,antiaim["active"]["slowWalk"][9])
            ui.set(aa.FakeYawLimit, antiaim["active"]["slowWalk"][10])
        elseif speed > 20 then
            AA.state = "Running"
            ui.set(aa.Pitch, antiaim["active"]["Running"][1])
            ui.set(aa.YawBase, antiaim["active"]["Running"][2])
            ui.set(aa.Yaw[1], antiaim["active"]["Running"][3])
            ui.set(aa.Yaw[2], antiaim["active"]["Running"][4])
            ui.set(aa.YawJitter[1], antiaim["active"]["Running"][5])
            ui.set(aa.YawJitter[2], antiaim["active"]["Running"][6])
            ui.set(aa.BodyYaw[1], antiaim["active"]["Running"][7])
            ui.set(aa.BodyYaw[2],antiaim["active"]["Running"][8])
            ui.set(aa.FreestandingBodyYaw,antiaim["active"]["Running"][9])
            ui.set(aa.FakeYawLimit, antiaim["active"]["Running"][10])
        elseif movestate == 257 then
            AA.state = "Standing"
            ui.set(aa.Pitch, antiaim["active"]["Standing"][1])
            ui.set(aa.YawBase, antiaim["active"]["Standing"][2])
            ui.set(aa.Yaw[1], antiaim["active"]["Standing"][3])
            ui.set(aa.Yaw[2], antiaim["active"]["Standing"][4])
            ui.set(aa.YawJitter[1], antiaim["active"]["Standing"][5])
            ui.set(aa.YawJitter[2], antiaim["active"]["Standing"][6])
            ui.set(aa.BodyYaw[1], antiaim["active"]["Standing"][7])
            ui.set(aa.BodyYaw[2],antiaim["active"]["Standing"][8])
            ui.set(aa.FreestandingBodyYaw,antiaim["active"]["Standing"][9])
            ui.set(aa.FakeYawLimit, antiaim["active"]["Standing"][10])
        else
            print(movestate)
        end

        local red,green,blue,alpha
        if ui.get(menu.customtheme) then
            red,green,blue = ui.get(menu.color3)
        else
            red,green,blue,alpha = 35,35,35,255
        end
        
        local tw,th = surface.get_text_size(fonts[ui.get(menu.fontselection)], " Toucan ".. role .. " / " .. AA.state .. "    ")
        if counter > 20 then

            Load.location = Load.location + 1
            counter = 0
            if Load.location == 12 then
                Load.location = 1
            end
        end
        counter = counter + 1
        aaintersect(tw,20,a,b)
        aacheckbounds(th)
        
        local debug = {
            "Algorithm - " ..antiaim["active"][AA.state][11],
            "Fake  limit - " ..antiaim["active"][AA.state][10]
        }

        if ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Movement Based") then
            renderer.text(a +tw-10, b, assets.red, assets.green, assets.blue, 255, "-", 0,Load["stage"..Load.location])
            surface.draw_filled_gradient_rect(a-2,b -2, tw + 7, 7, assets.red, assets.green, assets.blue, alpha, assets.red2, assets.green2, assets.blue2, alpha, true)
            surface.draw_filled_rect(a, b, tw + 3, th + 3, red, green, blue, alpha)
            surface.draw_text(a, b , assets.red, assets.green, assets.blue, alpha, fonts[ui.get(menu.fontselection)], " Toucan ".. role .. " / " .. AA.state .. " ")
            if ui.get(menu.debug) then
            surface.draw_filled_rect(a+3,b+20,tw -3,#debug*19,assets.red, assets.green, assets.blue,100)
            surface.draw_filled_rect(a+5,b+22,tw -7,#debug*17,35,35,35,255)
        
            for k, v in pairs(debug) do
                local vw = surface.get_text_size(fonts[ui.get(menu.fontselection)], v)
                surface.draw_text(a+(tw/2-(vw/2)) +2 ,6+ b + k*17,255,255,255,255,fonts[ui.get(menu.fontselection)],v)
            end
            end
        end 
        end
        --#endregion


        --#region Flick AA

        local process_ref = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"); ui.set_visible(process_ref, true)

        local function can_flick()
        if (ui.get(rage.doubletap[2]) == true) then
            assets.FlickState = "Disabled : Doubletap"
            return false
        end

        if (ui.get(other.onshotantiaim[2]) == true) then
            assets.FlickState = "Disabled : Onshot"
            return false
        end

        if not ui.get(menu.EnableAA) then
            return false
        end

        if ui.get(menu.SelectionAA) == "Movement Based" then
            return false
        end
        
        ui.set(menu.antibrute, false)

        if not local_player then
            return false
        end



        local dis = ui.get(menu.disablers)
        


        if (ui.get(other.slowmotiontype) == "Favor anti-aim") and (ui.get(other.slowmotion[2]) == true) then
            assets.FlickState = "Disabled : Favor AA"
            return false
        end

        if includes(dis, "In air") then
            local flags = entity.get_prop(local_player, "m_fFlags")
            local on_ground = bit.band(flags, bit.lshift(1, 0)) == 1

            if not on_ground or client.key_state(0x20) then
            assets.FlickState = "Disabled : In air"
                return false
            end
        end

        if includes(dis, "High speed") then
            local m_vecVelocity = {entity.get_prop(local_player, "m_vecVelocity")}
            local velocity = math.sqrt(m_vecVelocity[1] * m_vecVelocity[1] + m_vecVelocity[2] * m_vecVelocity[2])
            if velocity > 220 then
                assets.FlickState = "Disabled : Speed"
                return false
                
            end
        end

        return true
        end

        client.set_event_callback("setup_command", function(cmd)

            if ui.get(menu.SelectionAA) == "Movement Based" then return end

            assets.choke = 0
            if not can_flick() then
            ui.set(process_ref, 15)
            ui.set(fakelag.limit, 14)
            return
            end
            ui.set(aa.Pitch, "Down")
            ui.set(aa.YawBase, "Local view")
            ui.set(aa.Yaw[1], 180)
            ui.set(aa.YawJitter[1], "Off")
            ui.set(aa.YawJitter[2],0)
            ui.set(aa.BodyYaw[1], "Static")
            ui.set(aa.FakeYawLimit, 50)

            cmd.allow_send_packet = false
            local inverted = ui.get(menu.invert) and -1 or 1
            assets.FlickState = "Active : Flicking"
            if cmd.chokedcommands == ui.get(fakelag.limit) - 2 then
                ui.set(aa.Yaw[2], 121 * inverted)
                ui.set(aa.BodyYaw[2], math.abs(ui.get(aa.BodyYaw[2])) * inverted)
            elseif cmd.chokedcommands >= 0 then
                ui.set(aa.Yaw[2], 12 * inverted)
            end

            ui.set(process_ref, 18)
            ui.set(fakelag.limit, 17)
            assets.choke = cmd.chokedcommands
        end)

        local function flickAAindicators()
        local tw,th = surface.get_text_size(fonts[ui.get(menu.fontselection)], " Toucan ".. role .. " | Flick AA      " )
        
        if ui.get(menu.EnableAA) and ui.get(menu.SelectionAA) == "Flick exploit" then
            aaintersect(tw,20,a,b)
            aacheckbounds(th)
            
            surface.draw_filled_gradient_rect(a-2,b -2, tw + 7, 7, assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, true)
            surface.draw_filled_rect(a, b, tw + 3, th + 3, 35, 35, 35, 255)
            surface.draw_gradient_text(a, b , assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, fonts[ui.get(menu.fontselection)], "   Toucan ".. role .. " | Flick AA" )
            if ui.get(menu.debug) then
            surface.draw_filled_rect(a + 4, b + 17, tw -4, th + 50, 35, 35, 35, 150)
            surface.draw_filled_rect(a + 82 ,b + 24, 52, 5, 0, 0, 0, 255)
            surface.draw_filled_rect(a + 82 ,b + 24, 50 * ((ui.get(process_ref) - 1) - assets.choke) / (ui.get(process_ref) - 1),5,assets.red,assets.blue,assets.green,255)
            surface.draw_text(a+ 10,b+19, 200,  200,  200, 255,assets.font, ui.get(menu.invert) and "Peaking : Right" or "Peaking : Left")
            surface.draw_text(a + 10, b + 30, 200,  200,  200, 255,assets.font,assets.FlickState)
            surface.draw_text(a + 10, b + 42, 200,  200,  200, 255,assets.font,"Yaw base : " .. ui.get(aa.YawBase))
            surface.draw_text(a + 10, b + 54, 200,  200,  200, 255,assets.font,"Body Yaw degree : " .. ui.get(aa.BodyYaw[2]))
            surface.draw_text(a + 10, b + 66, 200,  200,  200, 255,assets.font,"Yaw degree : " .. ui.get(aa.Yaw[2]))
            surface.draw_text(a + 10, b + 66, 200,  200,  200, 255,assets.font,"Yaw degree : " .. ui.get(aa.Yaw[2]))
            end
        end
        end

        --#endregion


        --#region Crosshair indicator

        local crosshaircheck = {
        {
            name = "Toucan ".. role ,
            value = "rainbow"
        },
        {
        name = "DT",
        value = false
        },
        {
        name =" IT",
        value= false
        },
        {
        name = "OS",
        value = false
        },
        {
        name = "FD",
        value= false,
        },
        {
        name = "MD" .. ui.get(rage.mindmg),
        value = false
        }
        }

        -- - t = time (should go from 0 to duration)
        -- - b = begin (value of the property being ease.)
        -- - c = change (ending value of the property - beginning value of the property)
        -- - d = duration
        local t = 20
        local b = 5
        local c = 5
        local d = 100

        local function crosshair() 

        if entity.get_prop(local_player, "m_lifeState") ~= 0 then return end

        if ui.get(menu.crosshair_indicator_en) then

            crosshaircheck[1].value = ui.get(menu.antibrute)  
            if ui.get(menu.SelectionAA) == "Movement Based" then
                crosshaircheck[1].name =  "Toucan ".. role .. " / " .. AA.state .. " "
            else
                crosshaircheck[1].name = "Toucan ".. role
            end
            crosshaircheck[1].value = "rainbow"

            crosshaircheck[2].value = ui_get(rage.doubletap[1]) and ui_get(rage.doubletap[2])

            crosshaircheck[3].value = ui.get(menu.Idealtick)

            crosshaircheck[4].value = ui_get(other.onshotantiaim[2]) and ui_get(other.onshotantiaim[1])

            crosshaircheck[5].value = ui_get(rage.fakeduck)

            crosshaircheck[6].name = "MD : " .. ui_get(rage.mindmg)
            crosshaircheck[6].value = ui.get(menu.MinDMGoverride)

            local red,green,blue,alpha
            if ui.get(menu.customtheme) then
            red,green,blue,alpha = ui.get(menu.color4)
            else
            red,green,blue,alpha = 0,255,0,255
            end

            --#region Easing
            if entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1 then
            if b < 100 then b = easing.quad_out(t, b, c, d) end
            else
            if b > 0 then b = easing.quad_in(65,b,-c,-d) end
            end
            --#endregion

            surface.draw_filled_gradient_rect(assets.sw/2-75 + b, assets.sh/2+ 45 ,150,35,10,10,10,150,75,75,75,50,false)

            for k, v in ipairs(crosshaircheck) do
            local iw = surface.get_text_size(fonts[ui.get(menu.fontselection)], v.name)
            if v.value == false then
                if ui.get(menu.easteregg) and ui.get(menu.fontselection) == "ComicSans" then
                surface.draw_gradient_text(assets.sw/2 - 120 + (25*k) + b, assets. sh/2+ 65, assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, fonts[ui.get(menu.fontselection)], v.name)
                else
                surface.draw_text(assets.sw/2 - 120 + (25*k) + b,assets. sh/2+ 65, 255, 255, 255, a, fonts[ui.get(menu.fontselection)], v.name)
                end
            elseif v.value == true then 
                surface.draw_text(assets.sw/2 - 120 + (25*k)+ b, assets.sh/2 + 65, red, green, blue, alpha, fonts[ui.get(menu.fontselection)], v.name)
            elseif v.value == "rainbow" then
                surface.draw_gradient_text(assets.sw/2 - iw/2 + 3+ b, assets.sh/2+ 49 + (k-1)*12,assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, fonts[ui.get(menu.fontselection)], v.name)
            end
            end
        end
        end
        --#endregion


        --#region Roll modes

        local add = true
        local storage = 0

        local function roll(cmd)
        if entity.is_alive(entity.get_local_player()) and ui.get(menu.ToggleRoll) then

            if ui.get(menu.CustomRoll) == "Jitter" and assets.jspeed >= ui.get(menu.JitterSpeed) then
            storage = -storage
            ui_set(aa.Roll, storage)
            assets.jspeed = 0
            elseif ui.get(menu.CustomRoll) == "Jitter" and assets.jspeed < ui.get(menu.JitterSpeed) then
            assets.jspeed = assets.jspeed + 1
            if storage ~= ui.get(menu.RollRange) and (storage * -1) ~= ui.get(menu.RollRange) then
                storage = ui.get(menu.RollRange)
            end
            end

            --------------------------------------------------------------------------

            if ui.get(menu.CustomRoll) == "Sway" and not add then
            assets.swayspeed = assets.swayspeed - .25
            ui.set(aa.Roll, assets.swayspeed)
            if assets.swayspeed <= -50 then
                add = true
            end

            elseif ui.get(menu.CustomRoll) == "Sway" and add then
            assets.swayspeed = assets.swayspeed + .25
            ui.set(aa.Roll, assets.swayspeed)
            if assets.swayspeed >= 50 then
                add = false
            end
            end
            --------------------------------------------------------------------------

            if ui.get(menu.CustomRoll) == "Static" then
            ui.set(aa.Roll, ui.get(menu.RollRange))
            end
        end
        end

        --#endregion 


        --#region Disable DT and onshot on knife

        local function DisableKnifeDT()
            local weapon = getClassname(getPlayerWeapon(local_player))
            if not local_player then
                return
            end
            if ui.get(menu.Knife_dt) and not assets.lc then
            ui_set(rage.doubletap[1], not (weapon == "CKnife" or weapon == "CWeaponTaser"))
            ui_set(other.onshotantiaim[1], not (weapon == "CKnife" or weapon == "CWeaponTaser"))
            assets.dtreset = false
            elseif ui.get(menu.Knife_dt) and not assets.lc and not (weapon == "CKnife" or weapon == "CWeaponTaser") and not assets.dtreset  then
            ui_set(rage.doubletap[1],true)
            ui_set(other.onshotantiaim[1],true)
            assets.dtreset = true
            elseif not ui.get(menu.Knife_dt) and not assets.dtreset then
            ui_set(rage.doubletap[1],true)
            ui_set(other.onshotantiaim[1],true)
            assets.dtreset = true
            end
        end
        --#endregion


        --#region Double tap
        local function DT()
        local weapon = getClassname(getPlayerWeapon(local_player))
        local ping = math.floor(client.latency() * 1000)
            if not assets.dttoggle and not ui.get(menu.doubletap) then
            ui_set(rage.doubletap[1], false)
            assets.dttoggle = true
            end
            
        if ui_get(menu.doubletap) and not (weapon == "CKnife" or weapon == "CWeaponTaser") then
            if assets.dttoggle and ui.get(menu.doubletap) then
                ui.set(rage.doubletap[1],true)
                assets.dttoggle = false
            end
            if ui_get(menu.DTselection) == "Normal" then
                ui_set(rage.doubletapMode,"Defensive")
                ui_set(rage.doubletapHC,15)
                ui_set(rage.doubleTapFL,1)
                ui_set(DTSpeed, 16)
            elseif ui_get(menu.DTselection) == "Fast" then
                ui_set(rage.doubletapMode,"Offensive")
                ui_set(rage.doubletapHC,0)
                ui_set(rage.doubleTapFL,1)
                ui_set(DTSpeed, 17)
            elseif ui_get(menu.DTselection) == "Adaptive" then
                if ping <= 50 then
                    ui_set(rage.doubletapMode,"Offensive")
                    ui_set(rage.doubletapHC,23)
                    ui_set(rage.doubleTapFL,1)
                    ui_set(DTSpeed, 17)
                elseif ping <= 80 then
                    ui_set(rage.doubletapMode,"Offensive")
                    ui_set(rage.doubletapHC,27)
                    ui_set(rage.doubleTapFL,1)
                    ui_set(DTSpeed, 15)
                else
                    ui_set(rage.doubletapMode,"Offensive")
                    ui_set(rage.doubletapHC,30)
                    ui_set(rage.doubleTapFL,1)
                    ui_set(DTSpeed, 14)
                end
            end
        end
        end
        --#endregion


        --#region Ideal Tick
        local check = true
        local Storedvars 

        local function SaveITS()
        Storedvars =
            {
                DT1 = ui.get(rage.doubletap[1]),
                DT2 = ui.get(rage.doubletap[2]),
                FLA = ui.get(fakelag.fakelagamount),
                FLL = ui.get(fakelag.limit),
                FS = ui.get(aa.Freestanding[1]),
                VAR = ui.get(fakelag.variance)
            } 
        end

        local function Idealtickfunction()
        if ui.get(menu.Idealtick) then
            ui.set(other.onshotantiaim[1],false)
            ui.set(rage.doubletap[1], true)
            ui.set(rage.doubletap[2], "Always on")
            ui.set(fakelag.fakelagamount, "Maximum")
            ui.set(fakelag.variance,"13")
            ui.set(fakelag.limit,1)
            ui.set(aa.Freestanding[2],"Always on")
            ui.set(aa.Freestanding[1],"Default")
            check = false
        elseif not check and not ui.get(menu.Idealtick) then
            ui.set(other.onshotantiaim[1],true)
            ui.set(other.onshotantiaim[2],"Toggle")
            ui.set(rage.doubletap[1], Storedvars.DT1)
            ui.set(rage.doubletap[2], "Toggle")
            ui.set(fakelag.fakelagamount, Storedvars.FLA)
            ui.set(fakelag.variance,Storedvars.FLL)
            ui.set(fakelag.limit,Storedvars.FLL)
            ui.set(aa.Freestanding[1],Storedvars.FS)
            ui.set(aa.Freestanding[2],"On hotkey")
            check = true
        end
        if not ui_get(menu.Idealtick) then
            SaveITS()
        end
        end

        --#endregion


        --#region Legit AA on E No Paint
        -- Legit AA  on E (https://gamesense.pub/forums/viewtopic.php?id=22529) --

        client.set_event_callback("setup_command",function(e)
        local weaponn = entity.get_player_weapon()
        if ui_get(menu.legit_e_key) then
            if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
                if e.in_attack == 1 then
                    e.in_attack = 0 
                    e.in_use = 1
                end
            else
                if e.chokedcommands == 0 then
                e.in_use = 0
                end
            end
            ui_set(aa.Freestanding[1], "True")
        end
        end)  
        --#endregion


        --#region console log (Melly)
        
        local hitboxes = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}-- Not in a function
        local pdamage, pbacktrack, breaklc, phitchance-- Not in a function

        client.set_event_callback("aim_fire", function(e) 
        pdamage = e.damage
        pbacktrack = globals.tickcount() - e.tick
        breaklc = e.teleported
        phitchance = e.hit_chance
        end)
        
        client.set_event_callback("aim_hit", function(e)
        if ui_get(menu.console_log) then
            groups = hitboxes[e.hitgroup+1]
            successLog(string.format("[%s] Hit %s's %s for %s (%s remaining | backtrack: %s | lc: %s | Predicted damage: %s)", e.id, entity.get_player_name(e.target), groups, e.damage, entity.get_prop(e.target, "m_iHealth"), pbacktrack, breaklc,pdamage),0)
        end
        end)

        client.set_event_callback("aim_miss", function(e)
        if ui_get(menu.console_log) then
            groups = hitboxes[e.hitgroup+1]
            failLog(string.format("[%s] Missed %s due to %s (hitchance: %s | hitbox: %s | predicted damage: %s)", e.id, entity.get_player_name(e.target), e.reason, math.floor(phitchance + 0.5), groups, pdamage),0)
        end
        end)

        --#endregion


        --#region MinDMG override
        local function mindmgen()
        if ui_get(rage.mindmg) ~= ui_get(menu.mindmgval) then      
            assets.storedmindmg = ui_get(rage.mindmg)
        end
        if ui_get(menu.MinDMGoverride) then
            ui_set(rage.mindmg,ui_get(menu.mindmgval))
        else
            ui_set(rage.mindmg,assets.storedmindmg)
        end
        end
        --#endregion


        --#region Lag comp on peak -- https://gamesensical.gitbook.io/docs/developers/development/examples/head_dot
        local flipped = false

        local function lagcomp()
        local eye_x, eye_y, eye_z = client.eye_position()
        local enemies = entity.get_players(true)
        local weapon = getClassname(getPlayerWeapon(local_player))
        
        if ui.get(menu.lconpeak) and weapon == "CWeaponSSG08" or ui.get(menu.lconpeak) and weapon == "CWeaponAWP" and ui_get(rage.doubletap[1]) and ui_get(rage.doubletap[2]) and not ui_get(other.onshotantiaim[2]) then
            for i=1, #enemies do
            
            local entindex = enemies[i]
            local head_x, head_y, head_z = entity.hitbox_position(entindex, 0) -- head
            local fraction, entindex_hit = client.trace_line(local_player, eye_x, eye_y, eye_z, head_x, head_y, head_z)
            if entindex_hit == entindex or fraction == 1 then
                ui.set(rage.doubletap[1], false)
                flipped = true
                assets.lc = true
            elseif (entindex_hit ~= entindex or fraction ~= 1) and flipped then
                ui.set(rage.doubletap[1], true)
                flipped = false  
                assets.lc = false
            end
        end
        elseif weapon ~= "CWeaponSSG08" and weapon ~= "CWeaponAWP" then
            assets.lc = false
        end
        end

        --#endregion


        --#region indicators
        local function indicators()
            
        local indicatortable = {}

        if ui_get(rage.doubletap[1]) and ui_get(rage.doubletap[2]) then
            table.insert(indicatortable, "Double Tap")
        end

        if ui_get(other.onshotantiaim[1]) and ui_get(other.onshotantiaim[2]) then
            table.insert(indicatortable, "On Shot Anti-Aim")
        end

        if ui_get(rage.fakeduck) then
            table.insert(indicatortable, "Fake Duck")
        end

        if ui_get(rage.quickPeek[1]) and ui_get(rage.quickPeek[2]) and not ui.get(menu.Idealtick) then
            table.insert(indicatortable, "Quick Peek")
        end

        if ui.get(menu.MinDMGoverride) then
            table.insert(indicatortable, "Min Dmg : " .. ui.get(menu.mindmgval))
        end

        if ui.get(menu.Idealtick) then
            table.insert(indicatortable, "Ideal Tick")
        end

        if ui_get(other.PingSpike[1]) and ui_get(other.PingSpike[2]) then
            table.insert(indicatortable, "Ping Spike")
        end

        if ui_get(rage.safePoint) then
            table.insert(indicatortable, "Prefer Safe Point")
        end

        if ui_get(rage.forceSafePoint) then
            table.insert(indicatortable, "Force Safe Point")
        end

        if assets.lc then
            table.insert(indicatortable, "Fake lag")
        end
        local tr, tg, tb, ta = 255 ,255 ,255 ,255
        local ih = #indicatortable
        local indicatorwidth = surface.get_text_size(fonts[ui.get(menu.fontselection)], "Indicators")  
        local r,g,b,ba
        if ui.get(menu.customtheme) then
            r,g,b,ba = ui.get(menu.color3)
        else
            r,g,b,ba = 35,35,35,255
        end
        if ui.get(menu.EnableIndicators) == true and ih ~= 0 then    
            -- Adaptive box
            intersect(140,50,x,y)
            checkbounds(ih)
            surface.draw_filled_gradient_rect(x-2,y-2, 144, 10, assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, true)
            surface.draw_filled_gradient_rect(x-2,y+(ih-1)*20 +37, 144, 10, assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, true)
            surface.draw_filled_rect(x,y,140,45 + (ih-1)*20, r, g, b, ba)      
            -- Text rendering
            for i = 1, #indicatortable do
                local tw,th = surface.get_text_size(fonts[ui.get(menu.fontselection)], indicatortable[i]) 
                if ui.get(menu.easteregg) and ui.get(menu.fontselection) == "ComicSans" then
                ui.set(assets.menucolor, assets.red,assets.green,assets.blue,255)
                surface.draw_gradient_text(x + 70 - tw/2, y + 28 + (i-1)*20 , assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, fonts[ui.get(menu.fontselection)], indicatortable[i])
                else
                ui.set(assets.menucolor, mr,mg,mb,255)
                surface.draw_text(x + 70 - tw/2, y + 28 + (i-1)*20, tr, tg, tb, ta, fonts[ui.get(menu.fontselection)], indicatortable[i])
                end
                
            end

            surface.draw_text(x - indicatorwidth/2 + 70, y+ 5, tr, tg, tb, ta, fonts[ui.get(menu.fontselection)], "Indicators")
            surface.draw_filled_gradient_rect(x+8,y + 23, 125, 2, assets.red, assets.green, assets.blue, 255, assets.red2, assets.green2, assets.blue2, 255, true)
            end
        end
        
        --#endregion

        
        --#region SlowWalk Credit : Unknown i have had it so long i forogt
        local function setSpeed(newSpeed)
            if newSpeed == 245 then
                return
            end
            local LocalPlayer = ent_get_local
            local vx, vy = ent_get_prop(LocalPlayer(), "m_vecVelocity")
            local velocity = math.floor(math.min(10000, math.sqrt(vx*vx + vy*vy) + 0.5))
            local maxvelo = newSpeed

            if(velocity<maxvelo) then
                client_set_cvar("cl_sidespeed", maxvelo)
                client_set_cvar("cl_forwardspeed", maxvelo)
                client_set_cvar("cl_backspeed", maxvelo)
            end

            if(velocity>=maxvelo) then
                local kat=math.atan2(client_get_cvar("cl_forwardspeed"), client_get_cvar("cl_sidespeed"))
                local forward=math.cos(kat)*maxvelo;
                local side=math.sin(kat)*maxvelo;
                client_set_cvar("cl_sidespeed", side)
                client_set_cvar("cl_forwardspeed", forward)
                client_set_cvar("cl_backspeed", forward)
            end
        end


        client.set_event_callback("run_command", function ()
            if not ui_get(menu.SlowwalkEnable) and assets.slowwalkreset then
            setSpeed(450)
            assets.slowwalkreset = false
                return
            end

            if not ui_get(other.slowmotion[2]) then
                setSpeed(450)
            else
                setSpeed(ui_get(menu.SlowwalkSpeed))
            assets.slowwalkreset = true
            end
        end) 
        --#endregion


        --#region Driver code
        local function on_paint_ui()
        rainbow()    
        newWatermark()
        Managemenu()
        updateAA()
        toggle_aa_visability(false)
        end

        local function on_paint()
        anti_aim()
        clantag()
        mindmgen()
        Idealtickfunction()
        crosshair()
        indicators()
        roll()
        lagcomp()
        flickAAindicators()
        end

        local function on_setupcommand()
        DT()
        DisableKnifeDT()
        end

        client.set_event_callback("player_death",function()
        local alive = entity.is_alive(getLocalPlayer)    
        if alive and ui.get(menu.EnableAA) and ui.get(menu.SelectionAA) == "Movement Based" then
            assets.cache = AA.state
            failLog("[Toucan] Died with state : " .. assets.cache,0)    
        end
        end)

        client.set_event_callback("setup_command", on_setupcommand)
        setEventCallback("paint_ui",on_paint_ui)
        setEventCallback("paint",on_paint)

        client.set_event_callback("setup_command", function(e)
        if ui.is_menu_open() then
            e.in_attack = 0
        end
        end)

        client.set_event_callback("shutdown",function()
        toggle_aa_visability(true)
        end)

        --#endregion


        --#endregion
    
    end

    local function driver()
        lua()
    end

    driver()
end

payload(args)