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

local info = decrypt(args[1],args[2])

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

--#region SHA256 hashing

local MOD = 2^32
local MODM = MOD-1

local function memoize(f)
	local mt = {}
	local t = setmetatable({}, mt)
		local v = f(k)
		t[k] = v
		return v
	end
	return t
end

local function make_bitop_uncached(t, m)
	local function bitop(a, b)
		local res,p = 0,1
		while a ~= 0 and b ~= 0 do
			local am, bm = a % m, b % m
			res = res + t[am][bm] * p
			a = (a - am) / m
			b = (b - bm) / m
			p = p*m
		end
		res = res + (a + b) * p
		return res
	end
	return bitop
end

local function make_bitop(t)
	local op1 = make_bitop_uncached(t,2^1)
	local op2 = memoize(function(a) return memoize(function(b) return op1(a, b) end) end)
	return make_bitop_uncached(op2, 2 ^ (t.n or 1))
end

local bxor1 = make_bitop({[0] = {[0] = 0,[1] = 1}, [1] = {[0] = 1, [1] = 0}, n = 4})

local function bxor(a, b, c, ...)
	local z = nil
	if b then
		a = a % MOD
		b = b % MOD
		z = bxor1(a, b)
		if c then z = bxor(z, c, ...) end
		return z
	elseif a then return a % MOD
	else return 0 end
end

local function band(a, b, c, ...)
	local z
	if b then
		a = a % MOD
		b = b % MOD
		z = ((a + b) - bxor1(a,b)) / 2
		if c then z = bit32_band(z, c, ...) end
		return z
	elseif a then return a % MOD
	else return MODM end
end

local function bnot(x) return (-1 - x) % MOD end

local function rshift1(a, disp)
	if disp < 0 then return lshift(a,-disp) end
	return math.floor(a % 2 ^ 32 / 2 ^ disp)
end

local function rshift(x, disp)
	if disp > 31 or disp < -31 then return 0 end
	return rshift1(x % MOD, disp)
end

local function lshift(a, disp)
	if disp < 0 then return rshift(a,-disp) end 
	return (a * 2 ^ disp) % 2 ^ 32
end

local function rrotate(x, disp)
    x = x % MOD
    disp = disp % 32
    local low = band(x, 2 ^ disp - 1)
    return rshift(x, disp) + lshift(low, 32 - disp)
end

local k = {
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
	0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
	0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
	0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
	0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
	0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
	0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
	0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
	0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

local function str2hexa(s)
	return (string.gsub(s, ".", function(c) return string.format("%02x", string.byte(c)) end))
end

local function num2s(l, n)
	local s = ""
	for i = 1, n do
		local rem = l % 256
		s = string.char(rem) .. s
		l = (l - rem) / 256
	end
	return s
end

local function s232num(s, i)
	local n = 0
	for i = i, i + 3 do n = n*256 + string.byte(s, i) end
	return n
end

local function preproc(msg, len)
	local extra = 64 - ((len + 9) % 64)
	len = num2s(8 * len, 8)
	msg = msg .. "\128" .. string.rep("\0", extra) .. len
	assert(#msg % 64 == 0)
	return msg
end

local function initH256(H)
	H[1] = 0x6a09e667
	H[2] = 0xbb67ae85
	H[3] = 0x3c6ef372
	H[4] = 0xa54ff53a
	H[5] = 0x510e527f
	H[6] = 0x9b05688c
	H[7] = 0x1f83d9ab
	H[8] = 0x5be0cd19
	return H
end

local function digestblock(msg, i, H)
	local w = {}
	for j = 1, 16 do w[j] = s232num(msg, i + (j - 1)*4) end
	for j = 17, 64 do
		local v = w[j - 15]
		local s0 = bxor(rrotate(v, 7), rrotate(v, 18), rshift(v, 3))
		v = w[j - 2]
		w[j] = w[j - 16] + s0 + w[j - 7] + bxor(rrotate(v, 17), rrotate(v, 19), rshift(v, 10))
	end

	local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
	for i = 1, 64 do
		local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
		local maj = bxor(band(a, b), band(a, c), band(b, c))
		local t2 = s0 + maj
		local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
		local ch = bxor (band(e, f), band(bnot(e), g))
		local t1 = h + s1 + ch + k[i] + w[i]
		h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
	end

	H[1] = band(H[1] + a)
	H[2] = band(H[2] + b)
	H[3] = band(H[3] + c)
	H[4] = band(H[4] + d)
	H[5] = band(H[5] + e)
	H[6] = band(H[6] + f)
	H[7] = band(H[7] + g)
	H[8] = band(H[8] + h)
end

-- Made this global
local function sha256(msg)
	msg = preproc(msg, #msg)
	local H = initH256({})
	for i = 1, #msg, 64 do digestblock(msg, i, H) end
	return str2hexa(num2s(H[1], 4) .. num2s(H[2], 4) .. num2s(H[3], 4) .. num2s(H[4], 4) ..
		num2s(H[5], 4) .. num2s(H[6], 4) .. num2s(H[7], 4) .. num2s(H[8], 4))
end

--#endregion


local vars = {
    username = "",
    role     = "",
    uid      = 0,
    unix     = 0,
    msg      = "",
    testSha  = "",
}


local function payload(args)

    local function informationVerification(args) -- OTHER WAY TO DETIRMIN IF INFO IS INVALID
        local unix = client.unix_time()
        unix = tonumber(string.sub(unix,0,9))
        if #args ~= 6 then -- verfies deconstruction of encryption resulted in proper amount of results
            print("Error 0x21 | Not Authorized")  
            return false 
        elseif unix - args[4] >= 2 then -- check differance in unix with hard coded differance
            print("Invalid unix time, something sus here - " .. (unix - args[4]))
            return false
        elseif false then -- make a good handshake
            print("detected false info")
            return false
        elseif args[6] ~= sha256("changing of encryption look") then -- verify custom hash
            print("Hash Mismatch")
            return false
        elseif false then
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
