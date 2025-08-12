# Discord Role Manager for FiveM

A lightweight Discord integration script for FiveM servers that provides role-based permission checking and premium access validation.

## Features

- ✅ Discord role verification for players
- ✅ Premium tier access management
- ✅ Automatic role caching (2-minute cache)
- ✅ Multiple role checking support
- ✅ ox_lib callback integration
- ✅ Easy export functions
- ✅ Optimized API requests

## Installation

1. Download the latest release
2. Extract to your `resources` folder
3. Add `ensure discord-roles` to your `server.cfg`
4. Configure your Discord settings

## Configuration

Edit the configuration in the main script file:

```lua
local GUILD_CONFIG = {
    serverId = 'YOUR_DISCORD_SERVER_ID',
    botToken = 'YOUR_BOT_TOKEN'
}

local PREMIUM_ROLES = {
    ['supporter'] = 'ROLE_ID_1',
    ['patron'] = 'ROLE_ID_2',
    ['elite'] = 'ROLE_ID_3',
}
```

### Discord Bot Setup

1. Create a Discord application at https://discord.com/developers/applications
2. Create a bot and copy the token
3. Invite bot to your server with these permissions:
   - Read Messages
   - View Server Members
   - Read Message History

## Usage

### Check Specific Role
```lua
local hasRole = exports['donk_api']:checkUserRole(source, 'roleId')
```

### Check Premium Access
```lua
local isPremium = exports['donk_api']:validatePremiumAccess(source, 'supporter')
```

### Get All Player Roles
```lua
local roles = exports['donk_api']:getUserRoleList(source)
```

### Using Callbacks
```lua
lib.callback('validatePremiumAccess', source, function(result)
    -- handle result
end, 'supporter')
```

## Example Implementations

### Command Restriction
```lua
RegisterCommand('vip', function(source)
    local isVip = exports['donk_api']:validatePremiumAccess(source, 'supporter')
    if isVip then
        -- Grant VIP features
    end
end)
```

### Vehicle Spawning
```lua
RegisterNetEvent('spawnPremiumCar')
AddEventHandler('spawnPremiumCar', function()
    local hasAccess = exports['donk_api']:validatePremiumAccess(source, 'elite')
    if hasAccess then
        -- Spawn premium vehicle
    end
end)
```

## API Reference

| Function | Parameters | Returns | Description |
|----------|------------|---------|-------------|
| `checkUserRole` | `playerId, roleId` | `boolean` | Check if player has specific role |
| `validatePremiumAccess` | `playerId, tier(s)` | `boolean` | Check premium access level |
| `getUserRoleList` | `playerId` | `table` | Get all player roles |

## Requirements

- FiveM server
- ox_lib (for callbacks)
- Discord bot with proper permissions
- Players must have Discord identifiers linked

## Performance

- Built-in caching system reduces API calls
- 2-minute cache per player
- Handles Discord API rate limits
- Optimized for high-traffic servers

## Support
- 💬 [Discord Support](https://discord.gg/donkdev)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Credits

- Created by Donk
- Discord API integration
- Community feedback and testing

---

⭐ **Star this repo if you find it useful!**
