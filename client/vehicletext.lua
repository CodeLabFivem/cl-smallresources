local QBCore = exports['qb-core']:GetCoreObject()

if Config.Usevehicletext then
    CreateThread(function()
        local vehicles = QBCore.Shared.Vehicles

        for _, v in pairs(vehicles) do
            local text = (v.brand and v.brand .. ' ' or '') .. v.name
            local hash = v.hash
            if hash and hash ~= 0 then
                AddTextEntryByHash(hash, text)
            end
        end
    end)
end
