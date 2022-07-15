print("Loaded lua")

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
    ['unix']                    = tonumber(string.sub(client.unix_time(),0,9))
  }
  
  local function heartbeat()
    local unix = client.unix_time()
    info['unix'] = tonumber(string.sub(unix,0,9))
    if heartbeatVars.checktime <= info['unix'] then
        info['encryption'] = md5.sumhexa(adapter_info.vendor_id .. adapter_info.device_id .. (info['unix']) .. "basedSecurity1")  
        heartbeatVars.checktime = heartbeatVars.checktime + heartbeatVars.interval
        http.post(heartbeatVars.url,{params = info},function(success, response)
            if success and response.body ~= nil then
                heartbeatVars.key = md5.sumhexa(adapter_info.vendor_id .. adapter_info.device_id .. (info['unix']) .. "basedSecurity2")  
                heartbeatVars.data = json.parse(response.body)
                if heartbeatVars.data.same ~= heartbeatVars.key then
                  print("0x49 - Contact admin.")
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

print("Starting heartbeat")
client.set_event_callback("paint_ui",heartbeat)