# Creating the README content based on the user's request, including the updated Table of Contents format.
readme_content = """
# cl-smallresources - Highly Optimized FiveM Script for QBCore Framework

A highly optimized FiveM script, built for the QBCore framework, offering a variety of features like Discord Rich Presence, configurable world density settings, vehicle name display, forced first-person view options, and an advanced webhook logging system. This script ensures minimal resource usage while delivering rich functionality and customization options for server administrators.

---

## Table of Contents
- [Features](#Features)
- [Requirements](#Requirements)
- [Installation](#Installation)
- [Configuration](#Configuration)
   - [Discord Rich Presence](#Discord-rich-presence)
   - [World Density Settings](#World-density-settings)
   - [Forced First-Person Options](#Forced-first-person-options)
   - [Car Names Display](#Car-names-display)
   - [Disable HUD/Controls](#Disable-hudcontrols)
   - [Logging and Webhooks](#Logging-and-webhooks)
   - [Anti-AFK System](#Anti-afk-system)
- [Optimization](#Optimization)
- [Contributing](#Contributing)
- [License](#License)

---

1. ##Features

- Highly Optimized: Runs at an impressive 0.04-0.05 ms, minimizing impact on server performance.
- Discord Rich Presence: Configurable Rich Presence for showcasing server information and custom buttons in players' Discord profiles.
- World Density Control: Adjust traffic, pedestrians, and scenario densities dynamically, including peak hour settings.
- Forced First-Person View: Enforce first-person view when aiming or shooting on foot, in vehicles, or on bikes.
- Vehicle Name Display: Display vehicle names on the HUD.
- Logging and Webhooks: Customizable webhook logging for various in-game events like money changes, robberies, and more.
- Anti-AFK System: Automatically kick AFK players after a set time with customizable warning messages.

---

2. ##Requirements

- QBCore Framework (latest version)
- Discord Developer Application (for Discord Rich Presence)
- A FiveM server with build 2060 or higher.

---

3. ##Installation

1. Download or clone this repository to your FiveM resources folder.
2. Add `start cl-smallresources` to your `server.cfg`.
3. Customize the `config.lua` file to fit your preferences.

---

4. ##Configuration

4.1 Discord Rich Presence
Enable or disable Discord Rich Presence, set your Discord application ID, and customize the icons and buttons shown in players' profiles.

```lua
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
