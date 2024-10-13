-- Function to check if current time is within peak hour range
-- Function to convert time string (HH:MM) to hours and minutes as numbers
local function parseTime(timeStr)
    local hour, min = timeStr:match("(%d+):(%d+)")
    return tonumber(hour), tonumber(min)
end

local function isWithinPeakHourRange(currentHour, currentMinute, startHour, startMinute, endHour, endMinute)
    local currentTime = currentHour * 60 + currentMinute
    local startTime = startHour * 60 + startMinute
    local endTime = endHour * 60 + endMinute

    -- Handle cases where end time is past midnight
    if endTime < startTime then
        return currentTime >= startTime or currentTime < endTime
    else
        return currentTime >= startTime and currentTime < endTime
    end
end

-- Function to set densities based on time
local function setDensitiesBasedOnTime()
    local density = Config.Density
    if density.time then
        -- Get the current in-game time
        local currentHour = GetClockHours()
        local currentMinute = GetClockMinutes()
        
        -- Parse the peak hour start and end times
        local peakStartHour, peakStartMinute = parseTime(density.peakHourStart)
        local peakEndHour, peakEndMinute = parseTime(density.peakHourEnd)
        
        -- Check if current time is within peak hour range
        if isWithinPeakHourRange(currentHour, currentMinute, peakStartHour, peakStartMinute, peakEndHour, peakEndMinute) then           
            -- Set higher densities during peak hour
            SetParkedVehicleDensityMultiplierThisFrame(density.pparked)
            SetVehicleDensityMultiplierThisFrame(density.pvehicle)
            SetRandomVehicleDensityMultiplierThisFrame(density.pmultiplier)
            SetPedDensityMultiplierThisFrame(density.ppeds)
            SetScenarioPedDensityMultiplierThisFrame(density.pscenario, density.pscenario)
        else
            -- Set default densities outside of peak hour
            SetParkedVehicleDensityMultiplierThisFrame(density.parked)
            SetVehicleDensityMultiplierThisFrame(density.vehicle)
            SetRandomVehicleDensityMultiplierThisFrame(density.multiplier)
            SetPedDensityMultiplierThisFrame(density.peds)
            SetScenarioPedDensityMultiplierThisFrame(density.scenario, density.scenario)
        end
    else
        -- Apply default density settings if time-based is not enabled
        SetParkedVehicleDensityMultiplierThisFrame(density.parked)
        SetVehicleDensityMultiplierThisFrame(density.vehicle)
        SetRandomVehicleDensityMultiplierThisFrame(density.multiplier)
        SetPedDensityMultiplierThisFrame(density.peds)
        SetScenarioPedDensityMultiplierThisFrame(density.scenario, density.scenario)
    end
end

-- Main thread to handle density settings and HUD components/controls
CreateThread(function()
    while true do
        -- Hide HUD Components
        if type(disableHudComponents) == 'table' then
            for _, component in ipairs(disableHudComponents) do
                HideHudComponentThisFrame(component)
            end
        end

        -- Disable Controls
        if type(disableControls) == 'table' then
            for _, control in ipairs(disableControls) do
                DisableControlAction(0, control, true)
            end
        end

        -- Display Ammo
        DisplayAmmoThisFrame(displayAmmo)

        -- Apply Density Settings Based on Time
        setDensitiesBasedOnTime()

        Wait(0) -- Yield to the next frame
    end
end)
