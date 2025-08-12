local GUILD_CONFIG = {
    serverId = '', -- Server ID
    botToken = '' -- Token goes here
}

local PREMIUM_ROLES = {
    ['supporter'] = '', -- Role IDs
    ['gunplug'] = '', -- Role ID (Gunplug)
}

local ROLE_CACHE = {}

function fetchUserRoles(playerId)
    local asyncPromise = promise.new()
    local discordIdentifier = nil
    for index, identifier in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(identifier, "discord:") then
            discordIdentifier = string.gsub(identifier, "discord:", "")
            break
        end
    end
    if not discordIdentifier then
        asyncPromise:resolve({})
        return table.unpack(Citizen.Await(asyncPromise))
    end
    local apiEndpoint = ('https://discord.com/api/v10/guilds/%s/members/%s'):format(GUILD_CONFIG.serverId, discordIdentifier)
    PerformHttpRequest(apiEndpoint, function(statusCode, responseBody, headers)
        local memberData = json.decode(responseBody)
        local userRoles = {}
        if memberData and memberData.roles then
            for i = 1, #memberData.roles do
                userRoles[i] = tonumber(memberData.roles[i])
            end
        end
        asyncPromise:resolve(userRoles)
    end, 'GET', '', {
        ['Content-Type'] = 'application/json', 
        ['Authorization'] = ('Bot %s'):format(GUILD_CONFIG.botToken)
    })
    return table.unpack(Citizen.Await(asyncPromise))
end
  
function checkUserRole(playerId, targetRoleId)
    local playerKey = tostring(playerId)
    local cachedRoles = ROLE_CACHE[playerKey]
    if not cachedRoles then
        cachedRoles = fetchUserRoles(playerId)
        ROLE_CACHE[playerKey] = cachedRoles
        SetTimeout(120000, function()
            ROLE_CACHE[playerKey] = nil
        end)
    end
    for i = 1, #cachedRoles do
        if cachedRoles[i] == tonumber(targetRoleId) then
            return true
        end
    end
    return false
end

function validatePremiumAccess(playerId, premiumTier)
    if type(premiumTier) == 'table' then
        for i = 1, #premiumTier do
            if validatePremiumAccess(playerId, premiumTier[i]) then
                return true
            end
        end
        return false
    else
        local requiredRole = PREMIUM_ROLES[premiumTier]
        if not requiredRole then 
            return false 
        end
        return checkUserRole(playerId, requiredRole)
    end
end

exports('checkUserRole', checkUserRole)
exports('validatePremiumAccess', validatePremiumAccess)

lib.callback.register('validatePremiumAccess', function(source, premiumTier)
    return validatePremiumAccess(source, premiumTier)
end)

function getUserRoleList(playerId)
    local playerKey = tostring(playerId)
    local cachedRoles = ROLE_CACHE[playerKey]
    if not cachedRoles then
        cachedRoles = fetchUserRoles(playerId)
        ROLE_CACHE[playerKey] = cachedRoles
        SetTimeout(120000, function()
            ROLE_CACHE[playerKey] = nil
        end)
    end
    return cachedRoles
end

exports('getUserRoleList', getUserRoleList)