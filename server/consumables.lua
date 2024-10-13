local QBCore = exports['qb-core']:GetCoreObject()

if Config.Consumables.Master then
       -- Adjust hunger
RegisterNetEvent('QBCore:Server:UpdateHunger', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local newHunger = math.min(100, Player.PlayerData.metadata['hunger'] + amount)
        Player.Functions.SetMetaData('hunger', newHunger)
    end
end)

-- Adjust thirst
RegisterNetEvent('QBCore:Server:UpdateThirst', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local newThirst = math.min(100, Player.PlayerData.metadata['thirst'] + amount)
        Player.Functions.SetMetaData('thirst', newThirst)
    end
end)

-- Adjust stress
RegisterNetEvent('QBCore:Server:UpdateStress', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local newStress = math.max(0, Player.PlayerData.metadata['stress'] + amount)
        Player.Functions.SetMetaData('stress', newStress)
    end
end)

-- Register item usage for each consumable on the server
-- Loop through all consumables in the config and create a usable item for each
for itemName, _ in pairs(Config.Consumables.Consumables) do
    QBCore.Functions.CreateUseableItem(itemName, function(source)
        TriggerClientEvent('consumables:client:UseItem', source, itemName)
        print("usear: "..itemName)
    end)
end
else
    local utils = require("client/utils")
    utils.printColoredMessage("^1Not Using Consumables System From cl-smallresources", "^1")
end
