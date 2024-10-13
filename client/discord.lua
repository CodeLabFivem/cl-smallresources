local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    while Config.Discord.isEnabled do
        -- Set up Discord Rich Presence
        SetDiscordAppId(Config.Discord.applicationId)
        SetDiscordRichPresenceAsset(Config.Discord.iconLarge)
        SetDiscordRichPresenceAssetText(Config.Discord.iconLargeHoverText)
        SetDiscordRichPresenceAssetSmall(Config.Discord.iconSmall)
        SetDiscordRichPresenceAssetSmallText(Config.Discord.iconSmallHoverText)

        -- Show player count if enabled
        if Config.Discord.showPlayerCount then
            QBCore.Functions.TriggerCallback('smallresources:server:GetCurrentPlayers', function(result)
                if result then
                    SetRichPresence('Players: ' .. result .. '/' .. Config.Discord.maxPlayers)
                end
            end)
        end

        -- Set up buttons if provided
        if Config.Discord.buttons and type(Config.Discord.buttons) == "table" then
            for i, v in ipairs(Config.Discord.buttons) do
                if v.text and v.url then
                    SetDiscordRichPresenceAction(i - 1, v.text, v.url)
                end
            end
        end

        -- Wait for the update rate duration before updating again
        Wait(Config.Discord.updateRate)
    end
end)
