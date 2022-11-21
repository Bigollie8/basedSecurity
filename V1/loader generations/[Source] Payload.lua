print("Start of payload function")

local args = {...}

print(args[1] .. " args 1")

local payload1 = "This is where payload will be hard coded (Half of the script)"

local function string_to_table(string)
    local storage = {}
    for x in string:gmatch " " do
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
    print(string .. " what the matrix_to_string function is returning")
    return string
end

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
--

local decrypted = decrypt(args[1],5)
print(decrypted .. "Attempted decrypt")
local tabel = string_to_table(decrypted)
print(tabel[1] .. "should be name")

local function integrityCheck(payload2,name,role)
    -- this function will take the payload passed from the loader and combine it in a pcall
    -- if the pcall returns false then we know that the script did not load properly meaning
    -- either someone passed the wrong information or something went wrong in loader process
end


