local QBCore = exports['qb-core']:GetCoreObject()

local utils = require("client/utils")  -- Adjust the path as necessary

if Config.Afk.Master then
    Citizen.CreateThread(function()
        local prevPos = GetEntityCoords(PlayerPedId(), true)
        local timeLeft = Config.Afk.secondsUntilKick
        local warningInterval = math.ceil(Config.Afk.Afk.secondsUntilKick / 4)
        local warningSoundPlayed = false

        while true do
            Citizen.Wait(1000) -- Wait for 1 second

            local playerPed = PlayerPedId()
            if playerPed then
                local currentPos = GetEntityCoords(playerPed, true)

                -- Check if the player has moved
                if currentPos == prevPos then
                    if timeLeft > 0 then
                        -- Check if it's time to send a warning notification
                        if Config.Afk.Afk.kickWarning and timeLeft == warningInterval and not warningSoundPlayed then
                            if Config.Afk.EnableWarningSound then
                                PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", 0, 1)
                            end
                            QBCore.Functions.Notify(Config.Afk.KickedSoonMsg .. " " .. timeLeft .. " seconds" .. " (" .. Config.Afk.Notifytreason .. ")", "warning", Config.Afk.Notifytime)
                            warningSoundPlayed = true
                        end

                        timeLeft = timeLeft - 1
                    else
                        TriggerServerEvent("cl-smallresources:AntiAFK:kick")
                        -- Reset timeLeft and warningSoundPlayed after kicking
                        timeLeft = Config.Afk.secondsUntilKick
                        warningSoundPlayed = false
                    end
                else
                    -- Reset timeLeft and warningSoundPlayed if player moves
                    timeLeft = Config.Afk.secondsUntilKick
                    warningSoundPlayed = false
                end

                prevPos = currentPos
            end
        end
    end)
else  
    utils.printColoredMessage("^1Not Using Afk System System From cl-smallresources","^1")
end
