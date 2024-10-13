# cl-smallresources - Highly Optimized FiveM Script for QBCore Framework

A highly optimized FiveM script, built for the QBCore framework, offering a variety of features like Discord Rich Presence, configurable world density settings, vehicle name display, forced first-person view options, and an advanced webhook logging system. This script ensures minimal resource usage while delivering rich functionality and customization options for server administrators.

---

Table of Contents
1. Features
2. Requirements
3. Installation
4. Configuration
   - Discord Rich Presence
   - World Density Settings
   - Forced First-Person Options
   - Car Names Display
   - Disable HUD/Controls
   - Logging and Webhooks
   - Anti-AFK System
5. Optimization
6. Contributing
7. License

---

1. Features

- Highly Optimized: Runs at an impressive 0.04-0.05 ms, minimizing impact on server performance.
- Discord Rich Presence: Configurable Rich Presence for showcasing server information and custom buttons in players' Discord profiles.
- World Density Control: Adjust traffic, pedestrians, and scenario densities dynamically, including peak hour settings.
- Forced First-Person View: Enforce first-person view when aiming or shooting on foot, in vehicles, or on bikes.
- Vehicle Name Display: Display vehicle names on the HUD.
- Logging and Webhooks: Customizable webhook logging for various in-game events like money changes, robberies, and more.
- Anti-AFK System: Automatically kick AFK players after a set time with customizable warning messages.

---

2. Requirements

- QBCore Framework (latest version)
- Discord Developer Application (for Discord Rich Presence)
- A FiveM server with build 2060 or higher.

---

3. Installation

1. Download or clone this repository to your FiveM resources folder.
2. Add start cl-smallresources to your server.cfg.
3. Customize the config.lua file to fit your preferences.

---

4. Configuration

4.1 Discord Rich Presence
Enable or disable Discord Rich Presence, set your Discord application ID, and customize the icons and buttons shown in players' profiles.

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

4.2 World Density Settings
Control traffic, pedestrians, and scenario density dynamically, with optional peak hour settings.

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

4.3 Forced First-Person Options
Force players into first-person view while aiming or shooting, whether on foot, in vehicles, or on bikes.

```
Config.Options = {
    ForcedFirst = true,
    Vehicle = true,
    Bike = true
}
```

4.4 Car Names Display
Enable or disable vehicle name display on the HUD.

```
Config.Usevehicletext = true
```

4.5 Disable HUD/Controls
Disable certain HUD components and player controls as needed.

```
Config.Disable = {
    hudComponents = true,
    controls = true
}
```

4.6 Logging and Webhooks
Customizable webhooks for various in-game events.

```
Config.Webhooks = {
    ['default'] = 'https://discord.com/api/webhooks/yourwebhook',
    ['robbing'] = 'https://discord.com/api/webhooks/robbingwebhook'
}
```

4.7 Anti-AFK System
Automatically kick AFK players after a set time, with warning messages.

```
Config.Afk = {
    Master = true,
    secondsUntilKick = 600, -- 10 minutes
    kickWarning = true
}
```

---

5. Optimization

This script is highly optimized, running at only 0.04-0.05 ms to ensure minimal resource usage, even with all features enabled, maintaining a fast and responsive server.

---

6. Contributing

Contributions are welcome! Feel free to fork this project, submit issues, or create pull requests for improvements or bug fixes.

---

7. License

This project is licensed under the MIT License. See the LICENSE file for more details.
