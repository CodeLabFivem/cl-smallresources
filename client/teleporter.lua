local QBCore = exports['qb-core']:GetCoreObject()
local teleportPoly = {}
local ran = false

local function drawText(text, x, y, scale, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
end

local function playAnimation(animDict, animName, flag)
    ensureAnimDict(animDict)
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, flag, 0, false, false, false)
end

local function teleportMenu(zones, currentZone)
    local menu = {}
    for k, v in pairs(Config.Teleports[zones]) do
        if k ~= currentZone then
            local title = v.label or "Teleport Location"
            menu[#menu + 1] = {
                header = title,
                params = {
                    event = 'teleports:chooseloc',
                    args = {
                        car = Config.Teleports[zones][currentZone].allowVeh,
                        coords = v.poly.coords,
                        heading = v.poly.heading
                    }
                }
            }
        end
    end
    exports['qb-menu']:showHeader(menu)
end

Citizen.CreateThread(function()
    for i = 1, #Config.Teleports do
        for u = 1, #Config.Teleports[i] do
            local portal = Config.Teleports[i][u].poly
            teleportPoly[#teleportPoly + 1] = BoxZone:Create(vector3(portal.coords.x, portal.coords.y, portal.coords.z), portal.length, portal.width, {
                heading = portal.heading,
                name = tostring(i),
                debugPoly = false,
                minZ = portal.coords.z - 5,
                maxZ = portal.coords.z + 5,
                data = {pad = u}
            })
        end
    end

    local teleportCombo = ComboZone:Create(teleportPoly, {name = 'teleportPoly'})
    teleportCombo:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            if not ran then
                ran = true
                teleportMenu(tonumber(zone.name), zone.data.pad)
            end
        else
            ran = false
        end
    end)
end)

RegisterNetEvent('teleports:chooseloc', function(data)
    local ped = PlayerPedId()

    -- Fade out
    DoScreenFadeOut(500)
    Wait(500)
    
    -- Teleport player
    if data.car then
        SetPedCoordsKeepVehicle(ped, data.coords.x, data.coords.y, data.coords.z)
    else
        SetEntityCoords(ped, data.coords.x, data.coords.y, data.coords.z)
    end
    SetEntityHeading(ped, data.heading)

    -- Wait for animation to finish (adjust wait time as needed)
    Wait(2000) -- You may need to adjust this to fit the length of your animation

    -- Fade in
    DoScreenFadeIn(500)
end)
