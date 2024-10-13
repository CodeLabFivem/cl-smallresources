local QBCore = exports['qb-core']:GetCoreObject()

-- utils.lua

-- Function to notify using QBCore
local function Notify(text)
    QBCore.Functions.Notify(text, "error")
end

-- Function to print a message with a specified color in the console
local function printColoredMessage(message, color)
    -- Color codes: 1=red, 2=green, 3=yellow, 4=blue, etc.
    local colorCode = color or "^0"  -- Default to no color if not specified
    print(colorCode .. message .. "^0")  -- Print colored message
end


-- Example usage
  -- 31 for red

-- Export the functions for use in other scripts
return {
    Notify = Notify,
    printColoredMessage = printColoredMessage
}
