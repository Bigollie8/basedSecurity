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
  
        --#endregion
    
    end

    local function driver()
        lua()
    end

    driver()
end

payload(args)
