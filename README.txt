# Usage Examples

## Exports
```lua
-- Check specific role
local hasRole = exports['donk_api']:checkUserRole(source, 'roleId')

-- Check premium access
local isPremium = exports['donk_api']:validatePremiumAccess(source, 'supporter')

-- Get all roles
local roles = exports['donk_api']:getUserRoleList(source)
```

## Callback
```lua
lib.callback('validatePremiumAccess', source, function(result)
    -- handle result
end, 'supporter')
```