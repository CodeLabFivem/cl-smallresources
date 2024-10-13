local QBCore = exports['qb-core']:GetCoreObject()

-- Binocular settings
local fov_max = 70.0
local fov_min = 10.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0
local binoculars = false
local index = 0
local prop_binoc = nil
local instructions = true
local cam, scaleform_bin, scaleform_instructions

-- Utility functions
local function Notify(text)
    QBCore.Functions.Notify(text, "error")
end

local function getModelHash(model)
    return GetHashKey(model)
end

local function SetupButtons(buttons)
    local scaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(10)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    
    for i, btn in pairs(buttons) do
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(i - 1)
        ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, btn.key, true))
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(btn.text)
        EndTextCommandScaleformString()
        PopScaleformMovieFunctionVoid()
    end
    
    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    
    return scaleform
end

local function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(19) -- Weapon wheel
    HideHudComponentThisFrame(1)  -- Wanted Stars
    HideHudComponentThisFrame(2)  -- Weapon icon
    HideHudComponentThisFrame(3)  -- Cash
    HideHudComponentThisFrame(4)  -- MP CASH
    HideHudComponentThisFrame(13) -- Cash Change
    HideHudComponentThisFrame(11) -- Floating Help Text
    HideHudComponentThisFrame(12) -- More floating help text
    HideHudComponentThisFrame(15) -- Subtitle Text
    HideHudComponentThisFrame(18) -- Game Stream
end

local function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local new_z = rotation.z + rightAxisX * -1.0 * speed_ud * (zoomvalue + 0.1)
        local new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * speed_lr * (zoomvalue + 0.1)), -29.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end

local function HandleZoom(cam)
    local lPed = PlayerPedId()
    if not IsPedSittingInAnyVehicle(lPed) then
        if IsControlJustPressed(0, 241) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0, 242) then -- ScrollDown
            fov = math.min(fov + zoomspeed, fov_max)
        end
    else
        if IsControlJustPressed(0, 17) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0, 16) then -- ScrollDown
            fov = math.min(fov + zoomspeed, fov_max)
        end
    end
    local current_fov = GetCamFov(cam)
    if math.abs(fov - current_fov) < 0.1 then
        fov = current_fov
    end
    SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
end

-- Binoculars usage function
local function UseBinocular()
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        return
    end

    binoculars = not binoculars
    if not binoculars then
        -- Reset everything
        ClearPedTasks(PlayerPedId())
        ClearTimecycleModifier()
        RenderScriptCams(false, false, 0, 1, 0)
        if cam then
            DestroyCam(cam, false)
        end
        if prop_binoc then
            DeleteEntity(prop_binoc)
            prop_binoc = nil
        end
        if scaleform_bin then
            SetScaleformMovieAsNoLongerNeeded(scaleform_bin)
        end
        if scaleform_instructions then
            SetScaleformMovieAsNoLongerNeeded(scaleform_instructions)
        end
        SetNightvision(false)
        SetSeethrough(false)
        fov = (fov_max + fov_min) * 0.5
        return
    end

    Citizen.CreateThread(function()
        if prop_binoc then
            DeleteEntity(prop_binoc)
            prop_binoc = nil
        end
        ClearPedTasks(PlayerPedId())
        RequestAnimDict("amb@world_human_binoculars@male@idle_a")
        while not HasAnimDictLoaded("amb@world_human_binoculars@male@idle_a") do
            Citizen.Wait(5)
        end

        -- Attach prop to player
        local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
        RequestModel("prop_binoc_01")
        while not HasModelLoaded("prop_binoc_01") do
            Citizen.Wait(5)
        end
        prop_binoc = CreateObject(getModelHash("prop_binoc_01"), x, y, z + 0.2, true, true, true)
        AttachEntityToEntity(prop_binoc, PlayerPedId(), boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

        TaskPlayAnim(PlayerPedId(), "amb@world_human_binoculars@male@idle_a", "idle_c", 5.0, 5.0, -1, 51, 0, 0, 0, 0)
        PlayAmbientSpeech1(PlayerPedId(), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
        SetCurrentPedWeapon(PlayerPedId(), getModelHash("WEAPON_UNARMED"), true)
        RemoveAnimDict("amb@world_human_binoculars@male@idle_a")
        SetModelAsNoLongerNeeded("prop_binoc_01")
    end)

    Wait(200)
    SetTimecycleModifier("default")
    SetTimecycleModifierStrength(0.3)
    scaleform_bin = RequestScaleformMovie("BINOCULARS")
    while not HasScaleformMovieLoaded(scaleform_bin) do
        Wait(10)
    end

    cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
    AttachCamToEntity(cam, PlayerPedId(), 0.0, 0.0, 1.2, true)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(PlayerPedId()))
    SetCamFov(cam, fov)
    RenderScriptCams(true, false, 0, 1, 0)

    local keyList = Config.Binocaular.EnableBinocularVisions and
        {
            { key = 177, text = 'Exit the binoculars' },
            { key = 19,  text = 'Toggle the vision in the binoculars' },
            { key = 47,  text = 'Toggle the instructions' }
        } or
        {
            { key = 177, text = 'Exit the binoculars' },
            { key = 47,  text = 'Toggle the instructions' }
        }
    
    scaleform_instructions = SetupButtons(keyList)

    -- Main loop
    while binoculars and not IsEntityDead(PlayerPedId()) and not IsPedSittingInAnyVehicle(PlayerPedId()) do
        if IsControlJustPressed(0, 177) then
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
            binoculars = false
        end

        local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
        CheckInputRotation(cam, zoomvalue)
        HandleZoom(cam)
        HideHUDThisFrame()
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 44, true)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 24, true)
        DisablePlayerFiring(PlayerPedId(), true)

        if IsControlJustPressed(0, 19) and Config.Binocaular.EnableBinocularVisions then
            if index == 0 then
                SetNightvision(true)
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                index = 1
            elseif index == 1 then
                SetSeethrough(true)
                SetNightvision(false)
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                index = 2
            else
                SetNightvision(false)
                SetSeethrough(false)
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                index = 0
            end
        end

        if IsControlJustPressed(0, 47) then
            instructions = not instructions
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end

        DrawScaleformMovieFullscreen(scaleform_bin, 255, 255, 255, 255)
        if instructions then
            DrawScaleformMovieFullscreen(scaleform_instructions, 255, 255, 255, 255)
        end

        Wait(1)
    end

    -- Cleanup
    UseBinocular() -- Reset everything
end

-- Commands and exports
if Config.Binocaular.MasterBinocaular and Config.Binocaular.EnableBinocularcommand then
    RegisterCommand("binoculars", function()
        UseBinocular()
    end)
    TriggerEvent('chat:addSuggestion', '/binoculars', 'Use binoculars', {})
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if binoculars then
            UseBinocular() -- Reset everything
        end
    end
end)

exports('toggleBinoculars', UseBinocular)
