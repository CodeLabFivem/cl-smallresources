-- Configuration checks
if Config.Binocaular.MasterNewscamon then
    local QBCore = exports['qb-core']:GetCoreObject()

    if Config.Binocaular.EnableNewscamcommand then
        RegisterCommand("newscam", function()    
            local function hasRequiredJob(requiredJob)
                local playerData = QBCore.Functions.GetPlayerData()
                return playerData.job.name == requiredJob
            end     
            
            if not Config.Binocaular.Newscamonjob or hasRequiredJob(Config.Binocaular.Newscamjob) then            
                UseNewscam()  
            end
        end)
        TriggerEvent('chat:addSuggestion', '/newscam', 'Use newscam', {})
    end

    -- Constants
    local FOV_MAX = 70.0
    local FOV_MIN = 10.0
    local ZOOM_SPEED = 10.0
    local PAN_SPEED_LR = 8.0
    local PAN_SPEED_UD = 8.0
    local DEFAULT_FOV = (FOV_MAX + FOV_MIN) * 0.5
    local NEWSCAM_MODEL = "prop_v_cam_01"
    local ANIM_DICT = "missfinale_c2mcs_1"

    -- Variables
    local fov = DEFAULT_FOV
    local newscam = false
    local index = 0
    local prop_newscam = nil
    local breaking_news = nil
    local scaleform_news = nil
    local scaleform_instructions = nil
    local instructions = true
    local msg, bottom, title = "YOUR TEXT HERE", "YOUR TEXT HERE", "YOUR TEXT HERE"

    -- Utility functions
    local function loadModel(modelName)
        RequestModel(modelName)
        while not HasModelLoaded(modelName) do
            Citizen.Wait(5)
        end
    end

    local function setupInstructions(buttons)
        local scaleform = RequestScaleformMovie("instructional_buttons")
        while not HasScaleformMovieLoaded(scaleform) do
            Citizen.Wait(10)
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

    local function setupBreakingNews()
        breaking_news = RequestScaleformMovie("breaking_news")
        while not HasScaleformMovieLoaded(breaking_news) do
            Citizen.Wait(10)
        end

        PushScaleformMovieFunction(breaking_news, "breaking_news")
        PopScaleformMovieFunctionVoid()

        BeginScaleformMovieMethod(breaking_news, 'SET_TEXT')
        PushScaleformMovieMethodParameterString(msg)
        PushScaleformMovieMethodParameterString(bottom)
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(breaking_news, 'SET_SCROLL_TEXT')
        PushScaleformMovieMethodParameterInt(0)
        PushScaleformMovieMethodParameterInt(0)
        PushScaleformMovieMethodParameterString(title)
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(breaking_news, 'DISPLAY_SCROLL_TEXT')
        PushScaleformMovieMethodParameterInt(0)
        PushScaleformMovieMethodParameterInt(0)
        EndScaleformMovieMethod()

        return breaking_news
    end

    local function cleanUp()
        if prop_newscam then
            DeleteEntity(prop_newscam)
            prop_newscam = nil
        end
        if breaking_news then
            SetScaleformMovieAsNoLongerNeeded(breaking_news)
            breaking_news = nil
        end
        if scaleform_instructions then
            SetScaleformMovieAsNoLongerNeeded(scaleform_instructions)
            scaleform_instructions = nil
        end
        if scaleform_news then
            SetScaleformMovieAsNoLongerNeeded(scaleform_news)
            scaleform_news = nil
        end
        if cam then
            DestroyCam(cam, false)
            cam = nil
        end
        ClearPedTasks(PlayerPedId())
        ClearTimecycleModifier()
        RenderScriptCams(false, false, 0, 1, 0)
        SetNightvision(false)
        SetSeethrough(false)
    end

    local function handleZoom(cam)
        local zoomvalue = (1.0 / (FOV_MAX - FOV_MIN)) * (fov - FOV_MIN)
        if IsControlJustPressed(0, 241) then
            fov = math.max(fov - ZOOM_SPEED, FOV_MIN)
        elseif IsControlJustPressed(0, 242) then
            fov = math.min(fov + ZOOM_SPEED, FOV_MAX)
        end

        local current_fov = GetCamFov(cam)
        if math.abs(fov - current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
    end

    local function checkInputRotation(cam, zoomvalue)
        local rightAxisX = GetDisabledControlNormal(0, 220)
        local rightAxisY = GetDisabledControlNormal(0, 221)
        local rotation = GetCamRot(cam, 2)
        if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
            local new_z = rotation.z + rightAxisX * -1.0 * (PAN_SPEED_UD) * (zoomvalue + 0.1)
            local new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (PAN_SPEED_LR) * (zoomvalue + 0.1)), -29.5)
            SetCamRot(cam, new_x, 0.0, new_z, 2)
        end
    end

    -- Main function
    function UseNewscam()
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            return
        end

        newscam = not newscam

        if newscam then
            Citizen.CreateThread(function()
                cleanUp()
                ClearPedTasks(PlayerPedId())
                loadModel(NEWSCAM_MODEL)
                RequestAnimDict(ANIM_DICT)
                while not HasAnimDictLoaded(ANIM_DICT) do
                    Citizen.Wait(5)
                end

                local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)
                local coords = GetEntityCoords(PlayerPedId(), true)
                prop_newscam = CreateObject(GetHashKey(NEWSCAM_MODEL), coords.x, coords.y, coords.z + 0.2, true, true, true)
                AttachEntityToEntity(prop_newscam, PlayerPedId(), boneIndex, 0.0, 0.03, 0.01, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

                TaskPlayAnim(PlayerPedId(), ANIM_DICT, "fin_c2_mcs_1_camman", 5.0, 5.0, -1, 51, 0, 0, 0, 0)
                PlayAmbientSpeech1(PlayerPedId(), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
                SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
                RemoveAnimDict(ANIM_DICT)

                SetTimecycleModifier("default")
                SetTimecycleModifierStrength(0.3)
                scaleform_news = setupBreakingNews()

                local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                AttachCamToEntity(cam, PlayerPedId(), 0.0, 0.0, 1.2, true)
                SetCamRot(cam, 0.0, 0.0, GetEntityHeading(PlayerPedId()))
                SetCamFov(cam, fov)
                RenderScriptCams(true, false, 0, 1, 0)

                scaleform_instructions = setupInstructions({
                    { key = 177, text = 'Exit the newscam' },
                    { key = 19, text = 'Toggle the camera mode' },
                    { key = 74, text = 'Edit the text' },
                    { key = 47, text = 'Toggle instructions' }
                })

                -- Main loop
                while newscam and not IsEntityDead(PlayerPedId()) and not IsPedSittingInAnyVehicle(PlayerPedId()) do
                    if IsControlJustPressed(0, 177) then
                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        newscam = false
                    end

                    local zoomvalue = (1.0 / (FOV_MAX - FOV_MIN)) * (fov - FOV_MIN)
                    checkInputRotation(cam, zoomvalue)
                    handleZoom(cam)
                    HideHUDThisFrame()

                    DisableControlAction(0, 25, true)  -- disable aim
                    DisableControlAction(0, 44, true)  -- INPUT_COVER
                    DisableControlAction(0, 37, true)  -- INPUT_SELECT_WEAPON
                    DisableControlAction(0, 24, true)  -- Attack
                    DisablePlayerFiring(PlayerPedId(), true)  -- Disable weapon firing

                    if IsControlJustPressed(0, 19) then
                        if index == 0 then
                            index = 1
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            scaleform_news = nil
                            Citizen.CreateThread(function()
                                while index == 1 do
                                    DrawRect(0.0, 0.0, 2.0, 0.2, 0, 0, 0, 255)
                                    DrawRect(0.0, 1.0, 2.0, 0.2, 0, 0, 0, 255)
                                    Citizen.Wait(1)
                                end
                            end)
                        else
                            index = 0
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            scaleform_news = setupBreakingNews()
                        end
                    end

                    if IsControlJustPressed(0, 74) then
                        SetMsgBottomTitle()
                    end

                    if IsControlJustPressed(0, 47) then
                        instructions = not instructions
                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    end

                    if scaleform_news then
                        DrawScaleformMovieFullscreen(scaleform_news, 255, 255, 255, 255)
                    end
                    if instructions and scaleform_instructions then
                        DrawScaleformMovieFullscreen(scaleform_instructions, 255, 255, 255, 255)
                    end
                    Citizen.Wait(1)
                end

                cleanUp()
            end)
        end
    end

    function SetMsgBottomTitle()
        -- Input for setting messages
        AddTextEntry("top", "Enter the top message of the news")
        DisplayOnscreenKeyboard(1, "top", "", "", "", "", "", 200)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0)
            Citizen.Wait(0)
        end
        title = GetOnscreenKeyboardResult() or title

        AddTextEntry("bottom", "Enter the bottom title of the news")
        DisplayOnscreenKeyboard(1, "bottom", "", "", "", "", "", 200)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0)
            Citizen.Wait(0)
        end
        bottom = GetOnscreenKeyboardResult() or bottom

        AddTextEntry("title", "Enter the title of the news")
        DisplayOnscreenKeyboard(1, "title", "", "", "", "", "", 200)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0)
            Citizen.Wait(0)
        end
        msg = GetOnscreenKeyboardResult() or msg

        -- Update breaking news scaleform
        scaleform_news = setupBreakingNews()
    end

    function HideHUDThisFrame()
        HideHelpTextThisFrame()
        HideHudAndRadarThisFrame()
        HideHudComponentThisFrame(19) -- weapon wheel
        HideHudComponentThisFrame(1) -- Wanted Stars
        HideHudComponentThisFrame(2) -- Weapon icon
        HideHudComponentThisFrame(3) -- Cash
        HideHudComponentThisFrame(4) -- MP CASH
        HideHudComponentThisFrame(13) -- Cash Change
        HideHudComponentThisFrame(11) -- Floating Help Text
        HideHudComponentThisFrame(12) -- more floating help text
        HideHudComponentThisFrame(15) -- Subtitle Text
        HideHudComponentThisFrame(18) -- Game Stream
    end

    -- Cleanup on resource stop
    AddEventHandler('onResourceStop', function(resource)
        if resource == GetCurrentResourceName() then
            cleanUp()
        end
    end)

    -- Export function
    exports('toggleNewscam', function()
        UseNewscam()
    end)
end
