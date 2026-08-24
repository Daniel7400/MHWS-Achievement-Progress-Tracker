---@meta

-- IMPORTS
local achievement_tracking_config = require("Achievement_Progress_Tracker.classes.config.achievement_tracking_config")
local display_config = require("Achievement_Progress_Tracker.classes.config.display_config")
-- END IMPORTS

---@class (exact) config_data The class that represents the instance of the configuration data object.
---@field enabled boolean The flag used to determine if the mod is enabled or not. Defaults to `true`.
---@field debug_enabled boolean The flag used to determine if the debug menu should display in the REFramework UI or not. Defaults to `false`.
---@field display display_config The config options that control the display settings.
---@field achievement_tracking achievement_tracking_config The config options that control whether a specific achievement should be tracked or not.
---@field language string The selected language option. Defaults to `default (en-US)`.
local config_data = {}

---
--- Creates a new default instance of the configuration data object.
---
---@return config_data config_data The newly created configuration data object.
function config_data:new()
    self = setmetatable({}, self)

    self.enabled = true
    self.debug_enabled = false
    self.display = display_config:new()
    self.achievement_tracking = achievement_tracking_config:new()
    self.language = "default (en-US)"

    return self
end

return config_data