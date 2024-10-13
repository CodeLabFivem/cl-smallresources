local unarmed = `WEAPON_UNARMED`

if Config.Options.Master then
    -- Forced First-Person Aim
    if Config.Options.ForcedFirst then
        CreateThread(function()
            while true do
                local sleep = 1000
                local ped = PlayerPedId()
                local _, weapon = GetCurrentPedWeapon(ped)
                
                if weapon ~= unarmed then
                    sleep = 1
                    if IsPlayerFreeAiming(PlayerId()) then
                        SetFollowPedCamViewMode(3)
                    else
                        SetFollowPedCamViewMode(0)
                    end
                end
                
                Wait(sleep)
            end
        end)
    end

    -- Vehicle Camera Mode (Aiming Inside Vehicle)
    if Config.Options.Vehicle then
        CreateThread(function()
            while true do
                local ped = PlayerPedId()
                local sleep = 1000
                local _, weapon = GetCurrentPedWeapon(ped)
                local inVeh = GetVehiclePedIsIn(ped, false)
                
                if inVeh ~= 0 and weapon ~= unarmed then
                    sleep = 1
                    if IsControlJustPressed(0, 25) then
                        SetFollowVehicleCamViewMode(3)
                    elseif IsControlJustReleased(0, 25) then
                        SetFollowVehicleCamViewMode(0)
                    end
                end
                
                Wait(sleep)
            end
        end)
    end

    -- Bike Camera Mode (Aiming on Bike)
    if Config.Options.Bike then
        CreateThread(function()
            while true do
                local sleep = 1000
                local ped = PlayerPedId()
                local _, weapon = GetCurrentPedWeapon(ped)
                
                if IsPedOnAnyBike(ped) and weapon ~= unarmed then
                    sleep = 1
                    if IsControlJustPressed(0, 25) then
                        SetCamViewModeForContext(2, 3)
                    elseif IsControlJustReleased(0, 25) then
                        SetCamViewModeForContext(2, 0)
                    end
                end
                
                Wait(sleep)
            end
        end)
    end

    -- Forced First-Person when Driving (Only the Driver)
    if Config.Options.EnteringVehicle then
        CreateThread(function()
            while true do
                local sleep = 1000
                local ped = PlayerPedId()
                local inVeh = GetVehiclePedIsIn(ped, false)
                
                if inVeh ~= 0 and GetPedInVehicleSeat(inVeh, -1) == ped then
                    sleep = 1
                    SetFollowVehicleCamViewMode(3)
                end
                
                Wait(sleep)
            end
        end)
    end
end
