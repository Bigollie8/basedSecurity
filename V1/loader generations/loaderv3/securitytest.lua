local args = {...}

if #args == 1 then
  args = {"Admin","live", "1",string.sub(client.unix_time(),0,9),"352463"}
end

local md5 = require("gamesense/md5") or error("Subscribe to md5 on forum")
local ffi = require("ffi") or error("0x20 Contact admin")

local username = args[1]
local role = args[2]
local uid = args[3]
local unix = args[4]
local check = args[5]

local menu = {
        ui.new_label("Lua","A", "\aB6B665FF       -------------Toucan-------------"),
        Menumanger = ui.new_combobox("Lua","A","Menu selection","AA","Rage","Other"),
        ui.new_label("Lua","A", "--------------------------------------------------"),
        EnableAA = ui.new_checkbox("Lua","A","Enable anti-aim"),
        SelectionAA = ui.new_combobox("Lua","A","AA Selection","Movement Based","Flick exploit"),
        EnabbleBuilder = ui.new_checkbox("Lua","A","Enable anti-aim Builder"),
        StateSelector =  ui.new_combobox("Lua","A","State Selector","Crouch_in_air","In_air","Crouch", "Standing","slowWalk","Running"),
        AAtype = ui.new_combobox("Lua","A","AA Type","default","static","jitter","largeJitter","insightful"),
        disclaimer = ui.new_label("Lua","A", "! You need to disable all other exploits !"),
        disableExploits = ui.new_button("Lua","A","Disable Exploits",function()
            print("Hello")
        end),
        invert = ui.new_hotkey("Lua", "A", "Invert", false),
        disablers = ui.new_multiselect("Lua", "A", "Disable when", {"High speed", "In air"}),
        debug = ui.new_checkbox("Lua","A","Enable AA Debug"),
        antibrute = ui.new_checkbox("Lua","A","Enable anti-bruteforce"),
        Knife_dt = ui.new_checkbox("Lua", "A", "Disable DT on knife"),
        legit_e_key = ui.new_checkbox("Lua","A", "Legit AA on E"),
        lconpeak = ui.new_checkbox("Lua","A","!EXPERIMENTAL! LC on peak (awp)(scout)"),
        doubletap = ui.new_checkbox("Lua", "A", "Enable doubletap"),
        DTselection = ui.new_combobox("Lua","A","Doubletap selection","Normal","Fast","Adaptive"),
        ToggleRoll = ui.new_checkbox("Lua", "A", "Enable Custom roll"),
        Rollrange = ui.new_slider("Lua","A", "Roll Range", 0, 50, 25, true, "", 1),
        CustomRoll = ui.new_combobox("Lua","A","Roll modes","Static","Jitter","Sway"),
        JitterSpeed = ui.new_slider("Lua","A", "Jitter speed", 5, 100, 12, true, "%", 1),
        Idealtick = ui.new_hotkey("Lua","A", "Ideal Tick", false),
        MinDMGoverride = ui.new_hotkey("Lua","A", "Min dmg override", false),
        mindmgval = ui.new_slider("Lua","A", "Min dmg override value", 0, 100, 12, true, "hp", 1),
        EnableIndicators = ui.new_checkbox("Lua","A","Enable Indicators",true),
        clantagen = ui.new_checkbox("Lua", "A", "Clantag"),
        console_log = ui.new_checkbox("Lua","A","Console Logs",true),
        WatermarkCB = ui.new_checkbox("Lua","A","Enable Watermark",true),
        watermarkselection = ui.new_multiselect("Lua","A","Features in watermark",{"Name","Ping","Fps","UID","Version"}),
        crosshair_indicator_en = ui.new_checkbox("Lua", "A", "Crosshair indicators"),
        crosshairselection = ui.new_multiselect("Lua","A","Crosshair selection",{"Anti-Aim","Doubletap","Ideal Tick","Onshot","Fake duck","Min DMG"}),
        disablebox = ui.new_checkbox("Lua", "A", "Disable box"),
        Oppacity = ui.new_slider("Lua","A", "Crosshair Oppacity", 0, 255, 200, true, "", 1),
        fontselection = ui.new_combobox("Lua","A","Font selection","Tahoma","Georgia","Consolas","ink","ComicSans","Ebrima","Franklin","Segoe","Constantia"),
        easteregg = ui.new_checkbox("Lua", "A", "Enable Easteregg"),
        customtheme = ui.new_checkbox("Lua","A","Custom theme"),
        colorl = ui.new_label("Lua","A","Theme 1"),
        color1 = ui.new_color_picker("Lua","A","Theme 1",255,255,255,255),
        colorL = ui.new_label("Lua","A","Theme 2"),
        color2 = ui.new_color_picker("Lua","A","Theme 2",0,0,0,0),
        ui.new_label("Lua","A", "--------------------------------------------------"),
        blocked = ui.new_label("AA","Anti-aimbot angles", "Handled by the pro's lol (as it flickers)' ;)"),
}

--#region AA values

    local antiaim = {
        ["active"] = {
          ["Crouch_in_air"] = {"Down","At targets",180,0,"Center",-7,"Jitter",60,89,"default"},
          ["In_air"] = {"Down","At targets",180,1,"Offset",0,"Jitter",55,89,"default"},
          ["Crouch"] = {"Down","At targets",180,0,"Center",0,"Static",60,12,"default"},
          ["Standing"] = {"Down","At targets",180,0,"Offset",-2,"Jitter",60,89,"default"},
          ["slowWalk"] = {"Down","At targets",180,0,"Offset",4,"Opposite",36,89,"default"},
          ["Running"] = {"Down","At targets",180,0,"Offset",2,"Jitter",60,5,"default"}
        },
      
       ["default"] = {
        ["Crouch_in_air"] = {"Down","At targets",180,0,"Center",-7,"Jitter",60,89,"default"},
        ["In_air"] = {"Down","At targets",180,1,"Offset",0,"Jitter",55,89,"default"},
        ["Crouch"] = {"Down","At targets",180,0,"Center",0,"Static",60,12,"default"},
        ["Standing"] = {"Down","At targets",180,0,"Offset",-2,"Jitter",60,89,"default"},
        ["slowWalk"] = {"Down","At targets",180,0,"Offset",4,"Opposite",36,89,"default"},
        ["Running"] = {"Down","At targets",180,0,"Offset",2,"Jitter",60,5,"default"}
      },
      
      ["static"] = {
        ["Crouch_in_air"] = {"Down","At targets",180,0,"Center",0,"Static",55,-35,"static"},
        ["In_air"] = {"Down","At targets",180,1,"Center",0,"Static",55,-35,"static"},
        ["Crouch"] = {"Down","At targets",180,0,"Center",0,"Static",55,-35,"static"},
        ["Standing"] = {"Down","At targets",180,0,"Center",0,"Static",55,-35,"static"},
        ["slowWalk"] = {"Down","At targets",180,0,"Center",0,"Static",55,-35,"static"},
        ["Running"] = {"Down","At targets",180,0,"Center",0,"Static",55,-35,"static"}
      },
      
      
      ["jitter"] = {
        ["Crouch_in_air"] = {"Down","At targets",180,0,"Center",-7,"Jitter",60,89,"jitter"},
        ["In_air"] = {"Down","At targets",180,1,"Offset",0,"Jitter",55,89,"jitter"},
        ["Crouch"] = {"Down","At targets",180,0,"Center",4,"Static",60,89,"jitter"},
        ["Standing"] = {"Down","At targets",180,0,"Offset",-2,"Jitter",60,89,"jitter"},
        ["slowWalk"] = {"Down","At targets",180,0,"Offset",4,"Opposite",36,89,"jitter"},
        ["Running"] = {"Down","At targets",180,0,"Offset",2,"Jitter",60,89,"jitter"}
      },
      
      ["largeJitter"] = {
        ["Crouch_in_air"] = {"Down","At targets",180,0,"Offset",-23,"Jitter",60,12,"largeJitter"},
        ["In_air"] = {"Down","At targets",180,1,"Offset",-40,"Jitter",55,12,"largeJitter"},
        ["Crouch"] = {"Down","At targets",180,0,"Offset",-10,"Jitter",60,12,"largeJitter"},
        ["Standing"] = {"Down","At targets",180,0,"Offset",-19,"Jitter",60,12,"largeJitter"},
        ["slowWalk"] = {"Down","At targets",180,0,"Offset",4,"Jitter",36,12,"largeJitter"},
        ["Running"] = {"Down","At targets",180,0,"Offset",14,"Jitter",60,12,"largeJitter"}
      },
      ["insightful"] = {
        ["Crouch_in_air"] = {"Down","At targets",180,0,"Offset",99,"Jitter",60,-47,"insightful"},
        ["In_air"] = {"Down","At targets",180,1,"center",88,"Jitter",55,17,"insightful"},
        ["Crouch"] = {"Down","At targets",180,0,"Offset",99,"Jitter",60,-47,"insightful"},
        ["Standing"] = {"Down","At targets",180,0,"Center",0,"Static",55,-35,"static"},
        ["slowWalk"] = {"Down","At targets",180,0,"Offset",99,"Jitter",36,-47,"insightful"},
        ["Running"] = {"Down","At targets",180,0,"Offset",99,"Jitter",60,-47,"insightful"}
      }
      }

    local state = ui.get(menu.StateSelector)

local function UpdateAA(flag)
    if flag then
        if ui.get(menu.StateSelector) ~= state then
            ui.set(menu.AAtype,antiaim["active"][ui.get(menu.StateSelector)][10])
            state = ui.get(menu.StateSelector)
        end
        if ui.get(menu.EnabbleBuilder) then
            antiaim["active"][ui.get(menu.StateSelector)][1] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][1]
            antiaim["active"][ui.get(menu.StateSelector)][2] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][2]
            antiaim["active"][ui.get(menu.StateSelector)][3] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][3]
            antiaim["active"][ui.get(menu.StateSelector)][4] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][4]
            antiaim["active"][ui.get(menu.StateSelector)][5] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][5]
            antiaim["active"][ui.get(menu.StateSelector)][6] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][6]
            antiaim["active"][ui.get(menu.StateSelector)][7] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][7]
            antiaim["active"][ui.get(menu.StateSelector)][8] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][8]
            antiaim["active"][ui.get(menu.StateSelector)][9] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][9]
            antiaim["active"][ui.get(menu.StateSelector)][10] = antiaim[ui.get(menu.AAtype)][ui.get(menu.StateSelector)][10]
        end
    end
end

--#endregion

--#region Menu

local function Managemenu(flag)
    if flag then
        if ui.get(menu.Menumanger) == "AA"  then
        ui.set_visible(menu.EnableAA, true)
        ui.set_visible(menu.lconpeak, false)
        ui.set_visible(menu.EnabbleBuilder, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Movement Based"))
        ui.set_visible(menu.StateSelector, ui.get(menu.EnabbleBuilder) and ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Movement Based"))
        ui.set_visible(menu.AAtype, ui.get(menu.EnabbleBuilder) and ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Movement Based"))
        ui.set_visible(menu.antibrute, ui.get(menu.EnableAA ) and ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Movement Based"))
        ui.set_visible(menu.SelectionAA, ui.get(menu.EnableAA))
        ui.set_visible(menu.disclaimer, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Flick exploit"))
        ui.set_visible(menu.invert, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Flick exploit"))
        ui.set_visible(menu.disablers, ui.get(menu.EnableAA) and (ui.get(menu.SelectionAA) == "Flick exploit"))
        ui.set_visible(menu.debug, ui.get(menu.EnableAA)and ui.get(menu.EnableAA))
        ui.set_visible(menu.doubletap, false)
        ui.set_visible(menu.DTselection, false)
        ui.set_visible(menu.Knife_dt, false)
        ui.set_visible(menu.Idealtick, false)
        ui.set_visible(menu.legit_e_key, false)
        ui.set_visible(menu.MinDMGoverride, false)
        ui.set_visible(menu.ToggleRoll, true) 
        ui.set_visible(menu.Rollrange, (ui.get(menu.CustomRoll) == "Jitter"))
        ui.set_visible(menu.CustomRoll, ui.get(menu.ToggleRoll))
        ui.set_visible(menu.JitterSpeed, (ui.get(menu.CustomRoll) == "Jitter") and ui.get(menu.ToggleRoll))
        ui.set_visible(menu.mindmgval, false)
        ui.set_visible(menu.EnableIndicators, false)
        ui.set_visible(menu.WatermarkCB, false)
        ui.set_visible(menu.watermarkselection, false)
        ui.set_visible(menu.clantagen, false)
        ui.set_visible(menu.console_log, false)
        ui.set_visible(menu.crosshair_indicator_en, false)
        ui.set_visible(menu.crosshairselection, false)
        ui.set_visible(menu.disablebox, false)
        ui.set_visible(menu.Oppacity, false)
        ui.set_visible(menu.fontselection, false)
        ui.set_visible(menu.easteregg, false)
        ui.set_visible(menu.color1, false)
        ui.set_visible(menu.color2, false)
        ui.set_visible(menu.colorL, false)
        ui.set_visible(menu.colorl, false)
        ui.set_visible(menu.customtheme, false)
        elseif ui.get(menu.Menumanger) == "Rage"  then
        ui.set_visible(menu.lconpeak, true)
        ui.set_visible(menu.EnableAA, false)
        ui.set_visible(menu.EnabbleBuilder,false)
        ui.set_visible(menu.Idealtick, true)
        ui.set_visible(menu.debug, false)
        ui.set_visible(menu.StateSelector, false)
        ui.set_visible(menu.AAtype, false)
        ui.set_visible(menu.SelectionAA, false)
        ui.set_visible(menu.invert, false)
        ui.set_visible(menu.disablers, false)
        ui.set_visible(menu.antibrute, false)
        ui.set_visible(menu.antibrute, false)
        ui.set_visible(menu.ToggleRoll, false)
        ui.set_visible(menu.CustomRoll, false)
        ui.set_visible(menu.Rollrange, false)
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
        ui.set_visible(menu.crosshairselection, false)
        ui.set_visible(menu.disablebox, false)
        ui.set_visible(menu.Oppacity, false)
        ui.set_visible(menu.fontselection, false)
        ui.set_visible(menu.easteregg, false)
        ui.set_visible(menu.color1, false)
        ui.set_visible(menu.color2, false)
        ui.set_visible(menu.colorL, false)
        ui.set_visible(menu.colorl, false)
        ui.set_visible(menu.customtheme, false)
        else
        ui.set_visible(menu.StateSelector, false)
        ui.set_visible(menu.AAtype, false)
        ui.set_visible(menu.EnabbleBuilder,false)
        ui.set_visible(menu.antibrute, false)
        ui.set_visible(menu.Rollrange,false)
        ui.set_visible(menu.lconpeak, false)
        ui.set_visible(menu.EnableAA, false)
        ui.set_visible(menu.SelectionAA, false)
        ui.set_visible(menu.invert, false)
        ui.set_visible(menu.disablers, false)
        ui.set_visible(menu.debug, false)
        ui.set_visible(menu.Idealtick, false)
        ui.set_visible(menu.antibrute, false)
        ui.set_visible(menu.ToggleRoll, false)
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
        ui.set_visible(menu.crosshairselection, ui.get(menu.crosshair_indicator_en))
        ui.set_visible(menu.disablebox, ui.get(menu.crosshair_indicator_en))
        ui.set_visible(menu.Oppacity, ui.get(menu.crosshair_indicator_en))
        ui.set_visible(menu.fontselection, true)
        ui.set_visible(menu.easteregg, (ui.get(menu.fontselection) == "ComicSans"))
        ui.set_visible(menu.customtheme, true)
        ui.set_visible(menu.color1, ui.get(menu.customtheme))
        ui.set_visible(menu.color2, ui.get(menu.customtheme))
        ui.set_visible(menu.colorL, ui.get(menu.customtheme))
        ui.set_visible(menu.colorl, ui.get(menu.customtheme))
        end
    end
  end

  --#endregion

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
  local Plaintext = unix ..  "basedSecurity" .. adapter_info.vendor_id .. adapter_info.device_id   
  local md5_as_hex  = md5.sumhexa(Plaintext)  
  print("MD5 from lua : " .. md5_as_hex)
  print("MD5 from server : " .. check)
  local function verify()
    if md5_as_hex == check then
        print("This is where lua would load")
    else
      print("This is a detection, game would be crashed here but i am nice")
      --local x = 100
      --while x > 0 do
      --  x = x + 1
      --end
    end
  end

verify()
Managemenu(true)



