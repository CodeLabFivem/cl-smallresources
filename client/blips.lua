if Config.BlipsSystem.Master then
    -- Function to create addon blips on the map
    function CreateAddonBlips()
        for _, blipData in pairs(Config.BlipsSystem.Addonblips) do      
            local blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)
            SetBlipSprite(blip, blipData.blipid)
            SetBlipColour(blip, blipData.blipcolorid)
            SetBlipScale(blip, blipData.Blipsize)
            SetBlipAsShortRange(blip, blipData.SetBlipAsShortRange)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipData.label)
            EndTextCommandSetBlipName(blip)
        end
    end    

    AddEventHandler('onResourceStart', function(resource)
       if resource == GetCurrentResourceName() then
         CreateAddonBlips()
       end
    end)
end