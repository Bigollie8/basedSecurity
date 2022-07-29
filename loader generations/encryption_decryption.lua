local info = ""

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

local function table_to_matrix(table,col,row)
    local matrix = {}
    local f,location = 1,1
    for i=1, row do
        matrix[i] = {}
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


local function encrypt(msg,key)
    local cipher = ""

    local msg_len = #msg
    local msg_lst = string_to_table(msg)
    local col = key
    local row = math.ceil((msg_len/col))
    local fill_null = (row * col) - msg_len
    local void = string_to_table(string.rep("_" , fill_null))
    local combined = string_to_table(combine(msg_lst, void))
    local matrix = table_to_matrix(combined,col,row)

    for i=1, col do
        for x,r in ipairs(matrix) do

        
            cipher = cipher .. matrix[x][i]
        end
    end
    return cipher
end

local function string_to_table(string)
    local storage = {}
    for x in string:gmatch " " do
        table.insert(storage,x) 
    end
    return storage
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
local value = encrypt(info,5)
print(value)
print("^ Encrypted value above ^")
print(decrypt(value,5))
print("^ Decrypt value above ^")

print("Finished")