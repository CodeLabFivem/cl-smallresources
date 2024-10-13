cl-smallresources - Highly Optimized (0.04-0.05 ms)

A highly optimized FiveM script, built for the QBCore framework, featuring Discord Rich Presence, configurable world density settings, vehicle names display, forced first-person views for aiming, and an advanced webhook logging system. This script ensures low resource usage while providing rich functionality and customization.

==========================
Table of Contents
==========================

1. Features
2. Requirements
3. Installation
4. Configuration
   4.1. Discord Rich Presence
   4.2. World Density Settings
   4.3. Forced First-Person Options
   4.4. Car Names Display
   4.5. Disable HUD/Controls
   4.6. Logging and Webhooks
   4.7. Anti-AFK System
5. Optimization
6. Contributing
7. License

==========================
1. Features
==========================

- **Highly Optimized**: Script runs at an impressive 0.04-0.05 ms, ensuring minimal performance impact on your server.
- **Discord Rich Presence**: Fully configurable Rich Presence integration to showcase server information and custom buttons in the player’s Discord profile.
- **World Density Control**: Adjust traffic, pedestrian, and scenario densities dynamically, with optional peak hour settings.
- **Forced First-Person View**: Force first-person view when shooting or aiming, both on foot, in vehicles, or while riding bikes.
- **Vehicle Name Display**: Display the name of the vehicle on the HUD.
- **Logging and Webhooks**: A detailed logging system with customizable webhooks for various in-game activities (money changes, robberies, stash, trunk, glovebox events, and more).
- **Anti-AFK System**: Automatically kicks AFK players after a configurable amount of time with warning messages.

==========================
2. Requirements
==========================

- QBCore Framework (latest version)
- Discord Developer Application (for Discord Rich Presence)
- A FiveM server with at least build 2060 or higher.

==========================
3. Installation
==========================

1. Download or clone this repository to your FiveM resources folder.
2. Add `start cl-smallresources` to your `server.cfg`.
3. Customize the `config.lua` file to your preferences.

==========================
4. Configuration
==========================

### 4.1. Discord Rich Presence

In the `config.lua`, you can enable/disable Discord Rich Presence, set your application ID, and customize the icons and buttons shown in the player's Discord profile.

Example configuration:

```
Config.Discord = {
    isEnabled = true,
    applicationId = 'YourAppID',
    iconLarge = 'your_large_icon',
    iconSmall = 'your_small_icon',
    buttons = {
        {text = 'Join Our Server', url = 'fivem://connect/yourserverip'},
        {text = 'Visit Website', url = 'https://yourwebsite.com'}
    }
}
```

### 4.2. World Density Settings

Control the density of traffic, pedestrians, and ambient scenarios dynamically, with settings for peak hours:

```
Config.Density = {
    vehicle = 0.5,
    peds = 0.5,
    parked = 0.5,
    peakHourStart = "18:00",
    peakHourEnd = "21:00",
    pvehicle = 1.0,
    ppeds = 1.0
}
```

### 4.3. Forced First-Person Options

You can force players into first-person view while aiming or shooting on foot, in vehicles, or on bikes.

Example:

```
Config.Options = {
    ForcedFirst = true,
    Vehicle = true,
    Bike = true
}
```

### 4.4. Car Names Display

Enable or disable the display of vehicle names on the HUD:

```
Config.Usevehicletext = true
```

### 4.5. Disable HUD/Controls

You can disable default HUD components and certain player controls as needed.

Example:

```
Config.Disable = {
    hudComponents = true,
    controls = true
}
```

### 4.6. Logging and Webhooks

Customizable webhooks for various in-game events:

```
Config.Webhooks = {
    ['default'] = 'https://discord.com/api/webhooks/yourwebhook',
    ['robbing'] = 'https://discord.com/api/webhooks/robbingwebhook'
}
```

### 4.7. Anti-AFK System

An anti-AFK system to automatically kick players after a defined time period:

```
Config.Afk = {
    Master = true,
    secondsUntilKick = 600, -- 10 minutes
    kickWarning = true
}
```

==========================
5. Optimization
==========================

This script is highly optimized, running at only **0.04-0.05 ms**. It ensures minimal server resource usage, even with all features enabled, keeping your server fast and responsive.

==========================
6. Contributing
==========================

Feel free to fork this project, submit issues, or create pull requests for improvements or bug fixes.

==========================
7. License
==========================

This project is licensed under the MIT License. See the LICENSE file for more details.
