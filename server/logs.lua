local QBCore = exports['qb-core']:GetCoreObject()

local logQueue = {}

RegisterNetEvent('qb-log:server:CreateLog', function(name, title, color, message, tagEveryone, imageUrl)
    if Config.Logging == 'discord' then
        local webhook = Config.Webhooks[name] ~= '' and Config.Webhooks[name] or Config.Webhooks['default']
        if not webhook or webhook == '' then
            print('Tried to call a log that isn\'t configured with the name of ' .. name)
            return
        end

        local embedColor = Config.Colors[color] or Config.Colors['default']
        local embedData = {
            {
                title = title,
                color = embedColor,
                footer = { text = os.date('%c') },
                description = message,
                author = {
                    name = 'QBCore Logs',
                    icon_url = 'https://raw.githubusercontent.com/GhzGarage/qb-media-kit/main/Display%20Pictures/Logo%20-%20Display%20Picture%20-%20Stylized%20-%20Red.png',
                },
                image = imageUrl and imageUrl ~= '' and { url = imageUrl } or nil,
            }
        }

        logQueue[name] = logQueue[name] or {}
        table.insert(logQueue[name], { webhook = webhook, data = embedData })

        if #logQueue[name] >= 10 then
            local postData = { username = 'QB Logs', embeds = {} }
            if tagEveryone then postData.content = '@everyone' end

            for _, log in ipairs(logQueue[name]) do
                table.insert(postData.embeds, log.data[1])
            end

            PerformHttpRequest(logQueue[name][1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
            logQueue[name] = {}
        end
    elseif Config.Logging == 'fivemanage' then
        local FiveManageAPIKey = GetConvar('FIVEMANAGE_LOGS_API_KEY', 'false')
        if FiveManageAPIKey == 'false' then
            print('You need to set the FiveManage API key in your server.cfg')
            return
        end
        local extraData = {
            level = tagEveryone and 'warn' or 'info', -- info, warn, error or debug
            message = title, -- any string
            metadata = {
                description = message,
                playerId = source,
                playerLicense = GetPlayerIdentifierByType(source, 'license'),
                playerDiscord = GetPlayerIdentifierByType(source, 'discord')
            },
            resource = GetInvokingResource(),
        }
        PerformHttpRequest('https://api.fivemanage.com/api/logs', function(statusCode, response, headers)
            -- Uncomment for debugging: print(statusCode, response, json.encode(headers))
        end, 'POST', json.encode(extraData), {
            ['Authorization'] = FiveManageAPIKey,
            ['Content-Type'] = 'application/json',
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(Config.LogPostInterval * 1000)
        for name, queue in pairs(logQueue) do
            if #queue > 0 then
                local postData = { username = 'QB Logs', embeds = {} }
                for _, log in ipairs(queue) do
                    table.insert(postData.embeds, log.data[1])
                end
                PerformHttpRequest(queue[1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
                logQueue[name] = {}
            end
        end
    end
end)

QBCore.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function()
    TriggerEvent('qb-log:server:CreateLog', 'testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')
