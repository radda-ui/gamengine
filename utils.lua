function newFile(filename, content)
    -- Open the file in write mode, create if it doesn't exist, clear existing content
    -- Extract directory path from filename
    local directoryPath, fileName = filename:match("(.-)([^\\/]-%.?([^%.\\/]*))$")

    -- Create directory if it doesn't exist

    if directoryPath ~= "" and not love.filesystem.getInfo(directoryPath) then
        local success, errorMsg = os.execute("mkdir \"" .. directoryPath .. "\"")
        if not success then
            print("Error creating directory: " .. errorMsg)
            return
        end
    end

    -- Open the file in write mode, create if it doesn't exist, clear existing content
    local file = io.open(filename, "w")

    if not file then
        --print("Error: Unable to open file for writing")
        return
    end
    -- Write content to the file
    file:write(content)

    -- Close the file handle
    file:close()
    -- print("File '" .. filename .. "' has been written successfully.")
end

-- Function to join two tables into one table
function table.join(table1, table2)
    local result = {}

    for k, value in ipairs(table1) do
        result[k] = value
    end
    for k, value in ipairs(table2) do
        result[k] = value
    end

    return result
end

-- Function to save window properties to a Lua file
function save(path, tbl)

    local props = {}
    props.width, props.height, props.flags = love.window.getMode()
    props.x, props.y = love.window.getPosition()
    --print(path)
    local file = love.filesystem.newFile(path)
    if tbl and type(tbl) == "table" then table.join(props, tbl)() end
    file:open("w")

    file:write(table.to_string(props))

    file:close()
end

-- Function to load window properties from a Lua file
function loadData(file)
    local data = love.filesystem.load(file)()
    if type(data) == "table" then
        return data
    else return false end

end

function table.to_string(data)
    local serializedData = ""

    -- Function to serialize a table
    local function serializeTable(tbl)
        local str = "{\n"
        for k, v in pairs(tbl) do
            if type(k) == "number" then
                str = str .. "[" .. k .. "]="
            elseif type(k) == "string" then
                str = str .. k .. "="
            else
                -- Ignore non-string and non-numeric keys
                -- print("Ignoring key of type " .. type(k))
            end
            if type(v) == "table" then
                str = str .. serializeTable(v)
            elseif type(v) == "number" then
                str = str .. v
            elseif type(v) == "string" then
                str = str .. string.format("%q", v)
            elseif type(v) == "boolean" then
                v = v and " true" or " false"
                str = str .. v
            elseif type(v) == "function" then
                str = str .. "nil -- [[Function]]"
            elseif type(v) == "userdata" then
                str = str .. "nil -- [[userdata]]"
            else
                str = str .. "nil --[[unkown data type]]"
                -- Ignore non-serializable types
                -- print("Ignoring value of type " .. type(v))
            end
            str = str .. ",\n"
        end
        str = str .. "}"
        return str
    end

    local serializedData = ""
    -- Serialize data
    if type(data) == "table" then
        serializedData = serializeTable(data)
    elseif type(data) == "number" then
        serializedData = tostring(data)
    elseif type(data) == "string" then
        serializedData = string.format("%q", data)
    else
        print("Unable to serialize" .. type(data))
    end

    return "return " .. serializedData
end
