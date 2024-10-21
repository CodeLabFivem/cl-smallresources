Config = {}

---- Discord RPC ----
-- Configuration for Discord Rich Presence.
-- Customize your Discord application's rich presence by setting up an Application ID, icons, buttons, and more.

Config.Discord = {
    isEnabled = false,                                     -- If true, Discord Rich Presence will be enabled.
    applicationId = '00000000000000000',                   -- The Discord application ID from the Discord Developer Portal.
    iconLarge = 'logo_name',                               -- Large icon name for the rich presence (must be uploaded to your Discord App).
    iconLargeHoverText = 'This is a Large icon with text', -- Hover text when the large icon is displayed.
    iconSmall = 'small_logo_name',                         -- Small icon name for the rich presence (must be uploaded to your Discord App).
    iconSmallHoverText = 'This is a Small icon with text', -- Hover text when the small icon is displayed.
    updateRate = 60000,                                    -- How often the player count should be updated (in milliseconds).
    showPlayerCount = true,                                -- Display the current player count in rich presence if true.
    maxPlayers = 48,                                       -- Maximum number of players shown in the presence.
    buttons = {                                            -- Buttons to display in the Discord Rich Presence.
        {
            text = 'First Button!',                        -- Text displayed on the first button.
            url = 'fivem://connect/localhost:30120'        -- URL the first button redirects to (change to your server's URL).
        },
        {
            text = 'Second Button!',                       -- Text displayed on the second button.
            url = 'fivem://connect/localhost:30120'        -- URL the second button redirects to (change to your server's URL).
        }
    }
}

---- Shooting/Aiming Options ----
-- Controls the forced first-person view when shooting/aiming in different situations.

Config.Options = {
    Master = true,           -- Master switch to enable or disable all other options.
    Vehicle = true,          -- Force first-person view while aiming inside a vehicle.
    ForcedFirst = true,     -- Force first-person view while aiming/shooting on foot.
    Bike = true,             -- Force first-person view when aiming/shooting on a bike.
    EnteringVehicle = false  -- Force first-person view while driving (for drivers only).
}

---- Car Names Display ----
-- Shows the vehicle name in the bottom right of the screen.

Config.Usevehicletext = true -- If false, the vehicle name will not be displayed on the HUD.

---- World Density Settings ----
-- Controls the density of vehicles, pedestrians, and parked cars.

Config.Density = {
    vehicle = 0.0,         -- Traffic density. 0.0 means no traffic.
    peds = 0.0,            -- Pedestrian density. 0.0 means no pedestrians.
    parked = 0.0,          -- Parked vehicle density. 0.0 means no parked cars.
    multiplier = 0.0,      -- Global multiplier for densities.
    scenario = 0.0,        -- Scenario density. 0.0 means no ambient scenarios.
    time = true,           -- Toggle to enable time-based density adjustment.
    peakHourStart = "22:00", -- Start of peak hours in HH:MM format.
    peakHourEnd = "23:00",   -- End of peak hours in HH:MM format.
    
    -- Traffic density during peak hours
    pvehicle = 1.0,        -- Traffic density during peak hours. 0.0 means no traffic.
    ppeds = 1.0,           -- Pedestrian density during peak hours. 0.0 means no pedestrians.
    pparked = 1.0,         -- Parked vehicle density during peak hours. 0.0 means no parked cars.
    pmultiplier = 1.0,     -- Global multiplier for densities during peak hours.
    pscenario = 1.0        -- Scenario density during peak hours. 0.0 means no ambient scenarios.
}

---- Logging Configuration ----
-- Choose between 'discord' or 'fivemanage' for logging activities.

Config.Logging = 'discord'  -- Logging method used to report server activity.

---- Discord Webhooks ----
-- Set up different webhooks to track various in-game events.

Config.Webhooks = {
    ['default'] = '',         -- Default webhook URL.
    ['testwebhook'] = '',     -- Webhook URL for test events.
    ['playermoney'] = '',     -- Webhook URL for player money logs.
    ['playerinventory'] = '', -- Webhook URL for player inventory logs.
    ['robbing'] = '',         -- Webhook URL for robbing events.
    ['cuffing'] = '',         -- Webhook URL for cuffing events.
    ['drop'] = '',            -- Webhook URL for dropped items.
    ['trunk'] = '',           -- Webhook URL for trunk events.
    ['stash'] = '',           -- Webhook URL for stash events.
    ['glovebox'] = '',        -- Webhook URL for glovebox interactions.
    ['banking'] = '',         -- Webhook URL for banking transactions.
    ['vehicleshop'] = '',     -- Webhook URL for vehicle shop transactions.
    ['vehicleupgrades'] = '', -- Webhook URL for vehicle upgrades.
    ['shops'] = '',           -- Webhook URL for shop purchases.
    ['dealers'] = '',         -- Webhook URL for dealer interactions.
    ['storerobbery'] = '',    -- Webhook URL for store robbery events.
    ['bankrobbery'] = '',     -- Webhook URL for bank robbery events.
    ['powerplants'] = '',     -- Webhook URL for power plant events.
    ['death'] = '',           -- Webhook URL for player deaths.
    ['joinleave'] = '',       -- Webhook URL for player join/leave logs.
    ['ooc'] = '',             -- Webhook URL for out-of-character (OOC) events.
    ['report'] = '',          -- Webhook URL for player reports.
    ['me'] = '',              -- Webhook URL for /me events.
    ['pmelding'] = '',        -- Webhook URL for /pmelding events.
    ['112'] = '',             -- Webhook URL for emergency calls (112).
    ['bans'] = '',            -- Webhook URL for player bans.
    ['anticheat'] = '',       -- Webhook URL for anti-cheat logs.
    ['weather'] = '',         -- Webhook URL for weather changes.
    ['moneysafes'] = '',      -- Webhook URL for money safes.
    ['bennys'] = '',          -- Webhook URL for Benny's garage interactions.
    ['bossmenu'] = '',        -- Webhook URL for boss menu interactions.
    ['robbery'] = '',         -- Webhook URL for general robbery events.
    ['casino'] = '',          -- Webhook URL for casino events.
    ['traphouse'] = '',       -- Webhook URL for trap house events.
    ['911'] = '',             -- Webhook URL for 911 calls.
    ['palert'] = '',          -- Webhook URL for police alerts.
    ['house'] = '',           -- Webhook URL for house interactions.
    ['qbjobs'] = '',          -- Webhook URL for QB-Core job-related logs.
}

---- Embed Colors ----
-- Define colors used in Discord embed messages.

Config.Colors = { 
    ['default'] = 14423100, -- Default embed color (a shade of green).
    ['blue'] = 255,         -- Blue color.
    ['red'] = 16711680,     -- Red color.
    ['green'] = 65280,      -- Green color.
    ['white'] = 16777215,   -- White color.
    ['black'] = 0,          -- Black color.
    ['orange'] = 16744192,  -- Orange color.
    ['yellow'] = 16776960,  -- Yellow color.
    ['pink'] = 16761035,    -- Pink color.
    ['lightgreen'] = 65309  -- Light green color.
}

---- Log Post Interval ----
-- Defines how often the queued logs are posted (in seconds).

Config.LogPostInterval = 60 -- Time interval between posting logs in seconds.

---- Anti-AFK System ----
-- Configurations to prevent players from being AFK for too long.

Config.Afk = {
    Master = false,                -- Master switch for the AFK system.
    kickWarning = true,            -- Notifies the player before kicking them for being AFK.
    secondsUntilKick = 120,        -- Time in seconds before an AFK player gets kicked.
    KickedSoonMsg = "You're being kicked in", -- Message warning the player about the upcoming kick.
    Notifytreason = "For being afk too long", -- Reason displayed for the AFK warning.
    Notifytime = 5000,             -- Duration the warning notification will stay on the screen (in milliseconds).
    PlayerDroppedmsg = "You were kicked for being afk too long!", -- Message shown after the player is kicked.
    EnableWarningSound = true,     -- Enables a warning sound when the AFK timer is active.
}

---- Teleport Locations ----
-- Configuration for teleportation points on the map.

Config.Teleports = {
    [1] = {
        [1] = {
            poly = {
                coords = vector3(-998.36, -722.46, 21.53), -- First teleport location coordinates (X, Y, Z).
                heading = 90.0,                           -- Direction the player faces when teleporting.
                length = 2.0,                             -- Polygon length.
                width = 2.0                               -- Polygon width.
            },
            label = "Teleport Location 1",               -- Label for the teleport location.
            allowVeh = false                             -- Whether vehicles can teleport to this location.
        },
        [2] = {
            poly = {
                coords = vector3(-1000.74, -724.76, 21.53), -- Second teleport location coordinates (X, Y, Z).
                heading = 180.0,                            -- Direction the player faces when teleporting.
                length = 2.0,                               -- Polygon length.
                width = 2.0                                 -- Polygon width.
            },
            label = "Teleport Location 2",                 -- Label for the teleport location.
            allowVeh = true                                -- Whether vehicles can teleport to this location.
        }
    }
}

---- Binocular Configuration ----
-- Controls the settings for binoculars and news cameras.

Config.Binocaular = {
    MasterBinocaular = false,       -- Master switch for binoculars.
    EnableBinocularVisions = true,  -- Enable night vision or thermal vision through binoculars.
    EnableBinocularcommand = true,  -- Enable the binocular command.
    EnableNewscamcommand = true,    -- Enable the news camera command.
    MasterNewscamon = false,        -- Master switch for the news camera system.
    Newscam = true,                 -- Enable news camera system.
    Newscamjob = false,             -- Restrict news camera to specific job.
    NewscamjobName = "xxx",         -- The job allowed to use the news camera (replace "xxx" with actual job name).
}

---- Blacklist Config ----
-- Controls blacklisted vehicles, weapons, and player models (peds).

Config.Blacklist = {
    Master = true,                          -- Master switch for the blacklist system.
    disableAllWeapons = false,              -- Disable all weapons entirely if true.
    
    vehicleBlacklist = true,                -- Enable vehicle blacklist.
    weaponBlacklist = true,                 -- Enable weapon blacklist.
    BlacklistedVehicles = {
        "RHINO" -- Vehicle spawn code for blacklisted vehicles.
    },
    BlacklistedWeapons = {
        "WEAPON_MINIGUN", -- Weapon spawn code for blacklisted weapons.
        "WEAPON_TEARGAS"
    }
}

---- Blips System ----
-- Adds blips on the map for specific locations.

Config.BlipsSystem = {
    Master = true,  -- Master switch for the blips system.
    Addonblips = {
        [1] = {        
            coords = vector3(-1000.74, -724.76, 21.53), -- Coordinates for the blip.
            blipid = 109,                              -- Blip icon ID.
            blipcolorid = 5,                           -- Blip color ID.
            Blipsize = 0.6,                            -- Size of the blip.
            SetBlipAsShortRange = true,                -- Blip will disappear when zoomed out if true.
            label = "Teleport Location 2",             -- Label displayed for the blip.
        },
    }
}

---- Tracker System ----
-- Tracks vehicles or players based on their jobs and assigns them blips.

Config.tracker = {
    Master = false,      -- Master switch for the tracker system.
    vehclass = true,     -- Track vehicles by class.
    walkingblip = 126,   -- Blip icon for walking players.
    updatewait = 1000,   -- Update interval in milliseconds.
    jobs = {
        police = 38,     -- Blip color for police job.
        ambulance = 3,   -- Blip color for ambulance job.
    },
    vehclassblip = {
        boats = 43,          -- Blip icon for boats.
        boats2 = 427,        -- Another blip icon for boats.
        planeheli = 307,     -- Blip icon for planes and helicopters.
        bikes = 226,         -- Blip icon for bikes.
        othervehicles = 225, -- Blip icon for other vehicles.
        emergencyVehicle = 56, -- Blip icon for emergency vehicles.
    },
    emergencyVehicle = {   
        "police",           -- Police vehicles.
        "ambulance"         -- Ambulance vehicles.
    }
}

---- Prop Spawner ----
-- Configuration for spawning props in the game world.

Config.propspawner = {
    Master = false, -- Master switch for the prop spawner.
    Props = {
        [1] = {     -- Example prop configuration. Delete or modify as needed.
            model = "prop_tool_bench02_ld",                        -- Model name of the prop to spawn.
            coords = vector4(3817.12, 4442.12, 2.81, 8.18),        -- Coordinates to spawn the prop (X, Y, Z, Heading).
        },
        -- Add more props as needed.
    }
}

---- Consumables ----
-- Configuration for various consumable items like food, drinks, and items that affect player stats.

Config.Consumables = {
    Master = true, -- Master switch to enable or disable consumables.
    Progressbar = {
        disableMovement = false,    -- Disable player movement during the consumable usage progress bar.
        disableCarMovement = false, -- Disable vehicle movement during the consumable usage progress bar.
        disableMouse = false,       -- Disable mouse controls during the consumable usage progress bar.
        disableCombat = false,      -- Disable combat actions during the consumable usage progress bar.
    },
    Consumables = {
        ['burger'] = {
            time = 5000, -- Time to eat in milliseconds.
            prop = 'prop_cs_burger_01', -- Prop model for the burger.
            emote = 'mp_player_inteat@burger', -- Emote name for eating the burger.
            animDict = 'mp_player_inteat@burger', -- Animation dictionary for eating the burger.
            animName = 'mp_player_int_eat_burger_fp', -- Animation name for eating the burger.
            itemType = 'eat', -- Type of item action ('eat').
            hunger = 40, -- How much hunger it restores.
        },
        ['water'] = {
            time = 3000, -- Time to drink in milliseconds.
            prop = 'prop_ld_flow_bottle', -- Prop model for water.
            emote = 'mp_player_intdrink', -- Emote name for drinking.
            animDict = 'mp_player_intdrink', -- Animation dictionary for drinking.
            animName = 'loop_bottle', -- Animation name for drinking.
            itemType = 'drink', -- Type of item action ('drink').
            thirst = 35, -- How much thirst it restores.
        },
        ['cigarette'] = {
            time = 4000, -- Time to smoke in milliseconds.
            prop = 'prop_amb_ciggy_01', -- Prop model for smoking.
            emote = 'mp_player_inteat@burger', -- Emote name for smoking (reuse for now).
            animDict = 'amb@world_human_smoking@male@male_a@idle_a', -- Animation dictionary for smoking.
            animName = 'idle_a', -- Animation name for smoking.
            itemType = 'smoke', -- Type of item action ('smoke').
            stress = -15, -- How much stress it reduces (negative to reduce stress).
        }, 
        ['armor'] = {
            time = 4000, -- Time to apply armor in milliseconds.
            prop = '', -- Prop model for armor (empty string means no prop).
            emote = 'adjust', -- Emote name (custom).
            animDict = 'missmic4', -- Animation dictionary for "Adjust" emote.
            animName = 'michael_tux_fidget', -- Animation name for "Adjust" emote.
            itemType = 'apply', -- Type of item action ('apply').
            armor = 100, -- How much armor it adds.
            AnimationOptions = {
                EmoteMoving = true,      -- Allow movement during the emote.
                EmoteDuration = 4000     -- Duration of the emote in milliseconds.
            }
        }        
        --[[
        Example of adding another consumable item (commented out):
        ['joint'] = {
            time = 4000, -- Time to smoke in milliseconds.
            prop = 'prop_amb_ciggy_01', -- Prop model for smoking.
            emote = 'mp_player_inteat@burger', -- Emote name for smoking (reuse for now).
            animDict = 'amb@world_human_smoking@male@male_a@idle_a', -- Animation dictionary for smoking.
            animName = 'idle_a', -- Animation name for smoking.
            itemType = 'smoke', -- Type of item action ('smoke').
            armor = 15, -- How much stress it reduces (negative to reduce stress).
        },
        ]]
    }
}
