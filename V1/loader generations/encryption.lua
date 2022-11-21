local info = database.read("SecurityStorage")
--local info = "Continueing to test this encryption system to ensure its integrity"

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
        matrix[i]        = {}
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

local function table_to_string(tbl)
    local result         = ""
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


local function encrypt(msg,key)
    local cipher         = ""

    local msg_len        = #msg
    local msg_lst        = string_to_table(msg)
    local col            = key
    local row            = math.ceil((msg_len/col))
    local fill_null      = (row * col) - msg_len
    local void           = string_to_table(string.rep("_" , fill_null))
    local combined       = string_to_table(combine(msg_lst, void))
    local matrix         = table_to_matrix(combined,col,row)

    for i=1, col do
        for x,r in ipairs(matrix) do

            if matrix[x] == nil then
                print("Error decrypting")
                return nil
            end
        
            cipher       = cipher .. matrix[x][i]
        end
    end
    return cipher
end

local keyTime            = string.sub(client.unix_time(),9,9)
local value              = encrypt(info,keyTime)
print(value)