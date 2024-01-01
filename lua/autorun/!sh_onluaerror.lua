local _R = debug.getregistry()
local CallFunctionProtected = _R[1]

local string_sub = string.sub

local getAddonData do
    local wsids = {}
    local names = {}

    local engine_GetAddons = engine.GetAddons
    local file_Exists = file.Exists
    local string_find = string.find

    function getAddonData(filename)
        if names[filename] then
            return names[filename], wsids[filename]
        end

        local luafolderPos = string_find(filename, 'lua/')
        if not luafolderPos then return nil, nil end

        local id, name

        if luafolderPos ~= 1 then
            name = string_sub(filename, 8, luafolderPos - 2)
            id = '0'
        else
            local addons = engine_GetAddons()

            for i = #addons, 1, -1 do
                local addon = addons[i]
                local title = addon.title

                if file_Exists(filename, title) then
                    name = title
                    id = addon.wsid
                    
                    break
                end
            end
        end

        wsids[filename] = id
        names[filename] = name

        return name, id
    end
end

local inf = 1/0

local debug_getinfo = debug.getinfo
local gmod_GetGamemode = gmod.GetGamemode

_R[1] = function(msg, ...)
    local stack, n = {}, 1
    local name, id = nil, nil

    for i = 2, inf, 1 do
        local info = debug_getinfo(i, 'lnS')
        if not info then break end

        local filename = string_sub(info.source, 2)
        local _name, _id = getAddonData(filename)

        if _name then
            name, id = _name, _id
        end

        stack[n] = {
            File = filename,
            Line = info.currentline,
            Function = info.name or 'unknown'
        }

        n = n + 1
    end

    pcall(hook.Call, 'OnLuaError', gmod_GetGamemode and gmod_GetGamemode() or nil, msg, SERVER and 'server' or 'client', stack, name, id)

    return CallFunctionProtected(msg, ...)
end
