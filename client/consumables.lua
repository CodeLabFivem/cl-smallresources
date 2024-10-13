local QBCore = exports['qb-core']:GetCoreObject()

if Config.Consumables.Master then 
    function UseConsumable(item)  -- Function to use a consumable
        local playerPed = PlayerPedId()
        local consumable = Config.Consumables.Consumables[item] -- Access the right config level
    
        if consumable then
            QBCore.Functions.Progressbar("use_"..item, "Using "..item, consumable.time, false, true, {
                disableMovement = Config.Consumables.Progressbar.disableMovement,
                disableCarMovement = Config.Consumables.Progressbar.disableCarMovement,
                disableMouse = Config.Consumables.Progressbar.disableMouse,
                disableCombat = Config.Consumables.Progressbar.disableCombat,
            }, {}, {}, {}, function() -- onFinish
                -- Apply effects based on the consumable type
                if consumable.hunger then
                    TriggerServerEvent('QBCore:Server:UpdateHunger', consumable.hunger) -- Adjust hunger
                end
    
                if consumable.thirst then
                    TriggerServerEvent('QBCore:Server:UpdateThirst', consumable.thirst) -- Adjust thirst
                end
    
                if consumable.stress then
                    TriggerServerEvent('QBCore:Server:UpdateStress', consumable.stress) -- Adjust stress
                end
    
                if consumable.armor then
                    local newArmor = math.min(100, GetPedArmour(playerPed) + consumable.armor) -- Adjust armor
                    SetPedArmour(playerPed, newArmor)
                end
    
            end, function() -- onCancel
                -- Cancel action
            end, consumable.prop) -- Pass the prop to be used
    
            -- Play the emote/animation
            if consumable.emote then
                RequestAnimDict(consumable.animDict)
                while not HasAnimDictLoaded(consumable.animDict) do
                    Citizen.Wait(0)
                end
                TaskPlayAnim(playerPed, consumable.animDict, consumable.animName, 8.0, -8.0, consumable.time, 49, 0, false, false, false)
            end
    
            -- Attach prop to hand if a prop is specified
            if consumable.prop then
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local prop = CreateObject(GetHashKey(consumable.prop), x, y, z + 0.2, true, true, true)
                AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 60309), 0.1, 0.0, 0.0, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
    
                -- Remove the prop after the action
                Citizen.Wait(consumable.time)
                DeleteObject(prop)
            end
        end
    end
    
    -- Register item usage for each consumable
    RegisterNetEvent('consumables:client:UseItem', function(itemName)
        UseConsumable(itemName)
    end)    
else 
    local utils = require("client/utils")
    utils.printColoredMessage("^1Not Using Consumables System From cl-smallresources", "^1")
end  