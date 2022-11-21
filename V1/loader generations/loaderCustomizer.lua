local client_color_log          = client.color_log
local ui_new_label              = ui.new_label
local ui_set_visible            = ui.set_visible

local vars = {
    content1                    = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
    content2                    = "           Powered by : \aAEF8DB  based\aAEB5F8  Security",
    content3                    = "                  Customizer Build",
    content4                    = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
    counter                     = 0,
    color                       = "ffffffff",
    content5                    = "                  Customizer Build",
}

local branding = {
    title                       = ui.new_label("LUA","A","          Based Secruity Customizer"),
    buffer                      = ui.new_label("LUA","A","----------------------------------------------"),
    brandlabel                  = ui.new_label("LUA","A","Brand Name"),
    brand                       = ui.new_textbox("LUA","A","Brandname"),
    half1label                  = ui.new_label("LUA","A","Half 1 Name"),
    half1                       = ui.new_textbox("LUA","A","Half1"),
    half2label                  = ui.new_label("LUA","A","Half 2 of Name"),
    half2                       = ui.new_textbox("LUA","A","Half2"),
    enableAnimation             = ui.new_checkbox("LUA","A","Enable animation"),
    animationStyle              = ui.new_combobox("LUA","A","Animation Style",{"Regular","Split"}),
    hex                         = "ffffff",
    flip                        = false,
    Warning                     = ui.new_label("LUA","A","   ! Color selection for menu is limited !"),
    theme1label                 = ui.new_label("Lua","A","Theme1 Color"),
    theme1                      = ui.new_color_picker("LUA", "A", "Theme1", 174, 248, 219, 255),
    theme2label                 = ui.new_label("Lua","A","Theme2 Color"),
    theme2                      = ui.new_color_picker("LUA", "A", "Theme2", 198, 174, 248, 255),
    loaderThemeLabel1           = ui.new_label("Lua","A","Loader Theme Color 1"),
    loaderTheme1                = ui.new_color_picker("LUA", "A", "Loader Theme 1", 174, 248, 219, 255),
    loaderThemeLabel2           = ui.new_label("Lua","A","Loader Theme Color 2"),
    loaderTheme2                = ui.new_color_picker("LUA", "A", "Loader Theme 2", 198, 174, 248, 255),
    loading1                    = ui_new_label("Lua","A", vars.content1),
    loading2                    = ui_new_label("Lua","A", vars.content2),
    displaylabel                = ui_new_label("Lua","A", vars.content3),
    loading3                    = ui_new_label("Lua","A", vars.content4),
}


ui.set(branding.half1,"based")
ui.set(branding.half2,"Security")
ui.set(branding.brand,"basedSecurity")
local t1,h1,n1 = ui.get(branding.theme1)
local t2,h2,n2 = ui.get(branding.theme2)
local LR1, LG1, LB1 = ui.get(branding.loaderTheme1)
local LR2, LG2, LB2 = ui.get(branding.loaderTheme2)

local colors = {
    theme1                      = {t1, h1, n1},
    theme2                      = {t2, h2, n2},
    loaderTheme1                = {LR1, LG1, LB1},
    loaderTheme2                = {LR2, LG2, LB2},
    fail                        = {248, 177, 174},
    success                     = {192, 248, 174},
    pending                     = {248, 241, 174},
    RGB                         = {0  , 0  ,   0}
}

local function rgb_to_hex(r, g, b)
    r                          = r/255
    g                          = g/255
    b                          = b/255
   return string.format("%02x%02x%02x", math.floor(r*255), math.floor(g*255), math.floor(b*255))
end

local hexTable

local function handleVisablity(toggle)  
    ui_set_visible(branding.loading1     , toggle)
    ui_set_visible(branding.loading2     , toggle)
    ui_set_visible(branding.displaylabel , toggle)
    ui_set_visible(branding.loading3     , toggle)
end

local function splitlogo(half1,half2)
    client_color_log(175, 175, 175,"[\0")
    client_color_log(t1,h1,n1, half1 .. "\0")
    client_color_log(t2,h2,n2, half2 .. "\0")
    client_color_log(175, 175, 175,"] \0")
    client_color_log(255,255,255, "Example of split logo")
end

local function logo(brand,msg)
    client_color_log(175, 175, 175,"[\0")
    client_color_log(t1,h1,n1, brand .. "\0")
    client_color_log(175, 175, 175,"] \0")
    if msg ~= nil then
        client_color_log(255,255,255, msg)
    end
end

local function menusplit(half1,half2)
    colors = {
        theme1                      = {t1, h1, n1},
        theme2                      = {t2, h2, n2},
        loaderTheme1                = {LR1, LG1, LB1},
        loaderTheme2                = {LR2, LG2, LB2},
        fail                        = {248, 177, 174},
        success                     = {192, 248, 174},
        pending                     = {248, 241, 174},
        RGB                         = {0  , 0  ,   0}
    }

    hexTable =  {
        themeHex                    = rgb_to_hex(colors.theme1[1],colors.theme1[2],colors.theme1[3]),
        theme2Hex                   = rgb_to_hex(colors.theme2[1],colors.theme2[2],colors.theme2[3]),
        failHex                     = rgb_to_hex(colors.fail[1],colors.fail[2],colors.fail[3]),
        succesHex                   = rgb_to_hex(colors.success[1],colors.success[2],colors.success[3]),
        pendingHex                  = rgb_to_hex(colors.pending[1],colors.pending[2],colors.pending[3]) 
     }
    handleVisablity(false)

    branding.loading1           = ui.new_label("Lua","A", vars.content1)
    branding.loading2           = ui.new_label("Lua","A", vars.content2)
    branding.displaylabel       = ui.new_label("Lua","A", vars.content3)
    branding.loading3           = ui.new_label("Lua","A", vars.content4)

    handleVisablity(true)
    vars.counter = vars.counter + 1
    if vars.counter == 100 then
        vars.content1           = "\a" .. hexTable.themeHex .." ------------------------------------------------------"
        vars.content2           = "            Powered by \a" .. branding.hex .. " : \a".. "  " .. hexTable.themeHex .. ui.get(branding.half1).."\a" .. "  " ..hexTable.theme2Hex .. ui.get(branding.half2)
        vars.content3           = "\a" .. hexTable.theme2Hex .. "  ".. vars.content5
        vars.content4           = "\a" .. hexTable.themeHex .." ------------------------------------------------------"

    elseif vars.counter == 200 then
        vars.content1           = "\a" .. hexTable.theme2Hex .."- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        vars.content2           = "            Powered by \a" .. branding.hex .. " : \a".. "  " .. hexTable.theme2Hex .. ui.get(branding.half1).."\a" .. "  " ..hexTable.themeHex .. ui.get(branding.half2)
        vars.content3           = "\a" .. hexTable.themeHex .. "  ".. vars.content5
        vars.content4           = "\a" .. hexTable.theme2Hex .."- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        vars.counter            = 0
    end
end

logo(ui.get(branding.brand))
client_color_log(255,255,255, "Customizer Loaded")

local function menu(brand)
    colors = {
        theme1                      = {t1, h1, n1},
        theme2                      = {t2, h2, n2},
        loaderTheme1                = {LR1, LG1, LB1},
        loaderTheme2                = {LR2, LG2, LB2},
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
    handleVisablity(false)

    branding.loading1           = ui.new_label("Lua","A", vars.content1)
    branding.loading2           = ui.new_label("Lua","A", vars.content2)
    branding.displaylabel       = ui.new_label("Lua","A", vars.content3)
    branding.loading3           = ui.new_label("Lua","A", vars.content4)

    handleVisablity(true)
    vars.counter = vars.counter + 1
    if vars.counter == 100 then
        vars.content1           = "\a" .. hexTable.loaderThemeHex2 .." ------------------------------------------------------"
        vars.content2           = "            Powered by \a" .. branding.hex .. " : \a".. "  " .. hexTable.loaderThemeHex1 .. brand
        vars.content3           = "\a" .. hexTable.loaderThemeHex2 .. "  ".. vars.content3
        vars.content4           = "\a" .. hexTable.loaderThemeHex2 .." ------------------------------------------------------"

    elseif vars.counter == 200 then
        vars.content1           = "\a" .. hexTable.loaderThemeHex1 .."- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        vars.content2           = "            Powered by \a" .. branding.hex .. " : \a".. "  " .. hexTable.loaderThemeHex2 .. brand
        vars.content3           = "\a" .. hexTable.loaderThemeHex1 .. "  ".. vars.content5
        vars.content4           = "\a" .. hexTable.loaderThemeHex1 .."- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        vars.counter            = 0
    end
end


client.set_event_callback("paint_ui",function()
    t1,h1,n1 = ui.get(branding.theme1)
    t2,h2,n2 = ui.get(branding.theme2)
    LR1, LG1, LB1 = ui.get(branding.loaderTheme1)
    LR2, LG2, LB2 = ui.get(branding.loaderTheme2)
    ui.set_visible(branding.animationStyle,ui.get(branding.enableAnimation))
    if ui.get(branding.enableAnimation) then
        if ui.get(branding.animationStyle) == "Split" then
            menusplit(ui.get(branding.half1),ui.get(branding.half2))
        elseif ui.get(branding.animationStyle) == "Regular" then
            menu(ui.get(branding.brand))
        end
    end
end)

ui.new_button("LUA","A","Regular Logo",function()logo(ui.get(branding.brand),"Example of regular logo")end)
ui.new_button("LUA","A","Split Logo",function()splitlogo(ui.get(branding.half1),ui.get(branding.half2))end)
ui.new_button("LUA","A","Randomize colors",function()ui.set(branding.theme1,math.random(0,255),math.random(0,255),math.random(0,255),math.random(0,255))ui.set(branding.theme2,math.random(0,255),math.random(0,255),math.random(0,255),math.random(0,255))ui.set(branding.loaderTheme1,math.random(0,255),math.random(0,255),math.random(0,255),math.random(0,255))ui.set(branding.loaderTheme2,math.random(0,255),math.random(0,255),math.random(0,255),math.random(0,255))end)
ui.new_button("LUA","A","Reset colors",function()ui.set(branding.theme1,174, 248, 219, 255)ui.set(branding.loaderTheme1,174, 248, 219, 255)ui.set(branding.theme2,198, 174, 248, 255)ui.set(branding.loaderTheme2,198, 174, 248, 255)end)