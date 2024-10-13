local utils = require("client/utils")  -- Adjust the path as necessary

if Config.tracker.Master then
    local QBCore = exports['qb-core']:GetCoreObject()
    
    local DutyBlips = {} -- To keep track of created blips
    
    function updateBlips()
        local playerId = PlayerId() -- Get the player's ID
        local ped = GetPlayerPed(playerId)
        local coords = GetEntityCoords(ped)       
        local playerData = QBCore.Functions.GetPlayerData() -- Fetch player data
        local jobName = playerData and playerData.job and playerData.job.name
        local callsign = playerData and playerData.metadata and playerData.metadata.callsign
    
        -- Check if the player's job is in the configuration
        if not Config.tracker.jobs[jobName] then
            -- Job not in config; do not show blip
            return
        end
    
        -- Check if a blip already exists for this player
        local existingBlip = GetBlipFromEntity(ped)
    
        -- Remove the existing blip if it's there
        if DoesBlipExist(existingBlip) then
            RemoveBlip(existingBlip)
        end
    
        -- Create a new blip for the player
        local blip = AddBlipForEntity(ped)
        SetBlipSprite(blip, 1)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipRotation(blip, math.ceil(GetGameplayCamRot(0).z)) -- Use camera rotation for direction
        SetBlipScale(blip, 1.0)
    
        if Config.tracker.vehclass then
            local veh = GetVehiclePedIsIn(ped, false)
            local vehClass = veh and GetVehicleClass(veh) or 0
            local vehModel = GetEntityModel(veh)
            local isEmergencyVehicle = false
    
            -- Check if the vehicle model is in the emergencyVehicle list
            for _, model in ipairs(Config.tracker.emergencyVehicle) do
                if vehModel == GetHashKey(model) then
                    isEmergencyVehicle = true
                    break
                end
            end
    
            if vehClass == 15 then
                SetBlipSprite(blip, Config.tracker.vehclassblip.boats) -- Boats
            elseif vehClass == 14 then
                SetBlipSprite(blip, Config.tracker.vehclassblip.boats2) -- Boats
            elseif vehClass == 16 then
                SetBlipSprite(blip, Config.tracker.vehclassblip.planeheli) -- Planes
            elseif vehClass == 8 then
                SetBlipSprite(blip, Config.tracker.vehclassblip.bikes) -- Motorbikes
            elseif isEmergencyVehicle then
                SetBlipSprite(blip, Config.tracker.vehclassblip.emergencyVehicle) -- Emergency Vehicle
            elseif vehClass == 0 then
                SetBlipSprite(blip, Config.tracker.walkingblip) -- Walking
            else
                SetBlipSprite(blip, Config.tracker.vehclassblip.othervehicles) -- All other vehicles
            end
        else
            SetBlipSprite(blip, Config.tracker.walkingblip) -- Walking
        end
    
        local blipColor = Config.tracker.jobs[jobName] -- Get color from config
        SetBlipColour(blip, blipColor)
        
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(callsign or "Unknown") -- Use callsign or a default value
        EndTextCommandSetBlipName(blip)
        
        -- Track the blip
        DutyBlips[#DutyBlips + 1] = blip
    end
    
    -- Example to update blips every 60 seconds
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.tracker.updatewait) -- Update every 60 seconds
            updateBlips()
        end
    end)
    
    -- Remove all blips when the player disconnects
    AddEventHandler('playerDropped', function()
        local playerId = PlayerId()
        local ped = GetPlayerPed(playerId)
        local blip = GetBlipFromEntity(ped)
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end)
else 
 utils.printColoredMessage("Not Using Trackers System From cl-smallresources", "^1")
end