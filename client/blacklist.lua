local utils = require("client/utils")  -- Adjust the path as necessary

local     function getModelHash(model)
    return model and GetHashKey(model) or nil
end

local function isCarBlacklisted(model)
    -- Ensure model is a string
    if type(model) ~= "string" then
        return false
    end

    local modelHash = getModelHash(model)
    for _, blacklistedCar in pairs(Config.Blacklist.BlacklistedVehicles) do
        if modelHash == getModelHash(blacklistedCar) then
            return true
        end
    end
    return false
end



if Config.Blacklist.Master then
    -------------------------vehicle--------------------------
    if Config.Blacklist.vehicleBlacklist then

        local function _DeleteEntity(entity)
            Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(entity))
        end

        local function checkCar(car)
            if car and DoesEntityExist(car) then
                local carModel = GetEntityModel(car)
                local carName = GetDisplayNameFromVehicleModel(carModel)
                if isCarBlacklisted(carName) then
                    _DeleteEntity(car)
                    utils.Notify("You are unable to drive this vehicle! It is blacklisted!")
                end
            end
        end    

        Citizen.CreateThread(function()
            while true do
                Wait(1000) -- Reduced frequency to every second

                local playerPed = PlayerPedId()
                if playerPed then
                    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
                    local vehicle = GetVehiclePedIsIn(playerPed, true)
                    if vehicle and DoesEntityExist(vehicle) then
                        checkCar(vehicle)
                    end

                    -- Check nearby vehicles
                    local nearbyVehicles = GetVehiclesInRange(x, y, z, 100.0)
                    for _, veh in ipairs(nearbyVehicles) do
                        checkCar(veh)
                    end
                end
            end
        end)

        function GetVehiclesInRange(x, y, z, range)
            local vehicles = {}
            local allVehicles = GetGamePool('CVehicle') -- Get all vehicles in the game pool

            for _, vehicle in ipairs(allVehicles) do
                if vehicle ~= 0 and DoesEntityExist(vehicle) then
                    local vx, vy, vz = table.unpack(GetEntityCoords(vehicle, true))
                    if Vdist2(x, y, z, vx, vy, vz) <= (range * range) then
                        table.insert(vehicles, vehicle)
                    end
                end
            end

            return vehicles
        end
    else
        utils.printColoredMessage("Not Using VehicleBlacklist System From cl-smallresources", "^1")
    end

    -------------------------weapon--------------------------
    if Config.Blacklist.weaponBlacklist then
        function isWeaponBlacklisted(weapon)
            for _, blacklistedWeapon in ipairs(Config.Blacklist.BlacklistedWeapons) do
                if weapon == GetHashKey(blacklistedWeapon) then
                    return true
                end
            end
            return false
        end

        Citizen.CreateThread(function()
            while true do
                Wait(1000) -- Reduced frequency to every second
    
                local playerPed = PlayerPedId()
                if playerPed then
                    local _, weapon = GetCurrentPedWeapon(playerPed, true)
    
                    -- Check if all weapons should be disabled
                    if Config.Blacklist.disableAllWeapons then
                        RemoveAllPedWeapons(playerPed, true)
                    -- Check if the weapon is blacklisted
                    elseif isWeaponBlacklisted(weapon) then
                        RemoveWeaponFromPed(playerPed, weapon)
                        utils.Notify("This weapon has been blacklisted!")
                    end
                end
            end
        end)
    else
        utils.printColoredMessage("Not Using WeaponBlacklist System From cl-smallresources", "^1")
    end   
end
