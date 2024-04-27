Assets = {}
Assets.__index = Assets

function Assets:new(path)
    local self = {
        path=path,
        image = {},
        sound = {},
        file = {}
    }
    setmetatable(self, Assets)
    return self
end

function Assets:loadAll()
    local function scanDirectory(path)
        local items = love.filesystem.getDirectoryItems(path)
        for _, item in ipairs(items) do
            local itemPath = path .. "/" .. item
            local info = love.filesystem.getInfo(itemPath)
            if info.type == "file" then
                local ext = string.match(item, "%.([^%.]+)$")
                if ext == "lua" then
                    -- Skip Lua files
                elseif ext == "png" or ext == "jpg" or ext == "jpeg" or ext == "gif" then
                    local name = string.gsub(item, "%..+$", "")
                    self.image[name] = itemPath
                elseif ext == "wav" or ext == "amr" or ext == "ogg" or ext == "mp3" then
                    local name = string.gsub(item, "%..+$", "")
                    self.sound[name] = itemPath
                else
                    local file = love.filesystem.newFile(itemPath, "r")
                    if file then
                        self.file[name] = file:read()
                        file:close()
                    end
                end
            elseif info.type == "directory" then
                scanDirectory(itemPath)
            end
        end
    end

    scanDirectory(self.path)
end

function Assets:getImage(name)
    if not self.image[name] then
        error("Image not loaded: " .. name)
    end
    return love.graphics.newImage(self.image[name])
end

function Assets:getSound(name)
    if not self.sound[name] then
        error("Sound not loaded: " .. name)
    end
    return love.audio.newSource(self.sound[name])
end

function Assets:getFile(name)
    if not self.file[name] then
        error("File not loaded: " .. name)
    end
    return self.file[name]
end

return Asset