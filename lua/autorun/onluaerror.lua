local _R = debug.getregistry()

local CallFunctionProtected = _R[1]

local debug_getinfo = debug.getinfo
local string_find = string.find
local string_sub = string.sub
local ipairs = ipairs
local pcall = pcall

local engine_GetAddons = engine.GetAddons
local file_Find = file.Find

local SERVER = SERVER

local luafileCacheName = {}
local luafileCacheWsid = {}

_R[1] = function(msg, ...)
    local stack = {}
    
    local filename
    local name, id

    for i = 2, 1 / 0, 1 do
        local info = debug_getinfo(i, 'lnS')
        if not info then break end

        local filename = string_sub(info.source, 2)

        if not id then
            name = luafileCacheName[filename]
            id = luafileCacheWsid[filename]

            if not name or not id then
                local luafolderPos = string_find(filename, 'lua/')

                if luafolderPos then
                    if luafolderPos == 1 then
                        for k, addon in ipairs(engine_GetAddons()) do
                            local title = addon.title
                            local files = file_Find(filename, addon.title)
    
                            if files[1] ~= nil then
                                name = title
                                id = addon.wsid
    
                                -- I don't break here because:
                                --
                                -- Addons can have files with the same names as files in other addons, we want to get the title and wsid
                                -- of the addon that has the file the game is currently using. The order *should* be the same order as 
                                -- engine.GetAddons() gives you, therefore, the last addon that has the file we're looking for in the
                                -- table *should* be the file the game is currently using, so I search every addon instead of breaking
                                -- at the first one found.
                            end
                        end
                    else
                        name = string_sub(filename, 8, luafolderPos - 2)
                        id = 0
                    end
                        
                    luafileCacheName[filename] = name
                    luafileCacheWsid[filename] = id
                end
            end
        end

        stack[#stack + 1] = {
            File = filename,
            Function = info.name or 'unknown',
            Line = info.currentline
        }
    end

    pcall(hook.Run, 'OnLuaError', msg, SERVER and 'server' or 'client', stack, name, id)

    return CallFunctionProtected(msg, ...)
end
