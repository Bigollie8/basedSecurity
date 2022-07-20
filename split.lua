local function string_to_table(string)
    local storage = {}
    for x in string:gmatch "." do
        table.insert(storage,x) 
    end
    return storage
end


local function split(text)
    local table = string_to_table(text)
    local textLen = #table
    local splitPayload = {
        payload1 = "",
        payload2 = ""
    }

    for x = 1, (textLen/2) do
        splitPayload.payload1 = splitPayload.payload1 .. table[math.floor(x)]
    end
    for y = (textLen/2) + 1, textLen do
        splitPayload.payload2 = splitPayload.payload2 .. table[math.ceil(y)]
    end
    return splitPayload
end

local table = split("this would split text in half")