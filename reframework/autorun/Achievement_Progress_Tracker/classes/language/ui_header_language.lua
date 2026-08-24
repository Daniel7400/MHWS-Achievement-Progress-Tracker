---@meta

---@class (exact) ui_header_language The class that represents the localized text for headers in the REFramework UI.
---@field color string The localized text for the color header. Defaults to `Color`.
---@field display string The localized text for the display header. Defaults to `Display`.
---@field language string The localized text for the language header. Defaults to `Language`.
---@field settings string The localized text for the settings header. Defaults to `Settings`.
---@field tracking string The localized text for the tracking header. Defaults to `Tracking`.
---@field missing string The localized text for the missing header. Defaults to `Missing for: %s`.
---@field base_game string The localized text for the base game header. Defaults to `Base Game`.
---@field ascendance_dlc string The localized text for the ascendance dlc header. Defaults to `Ascendance`.
---@field debug string The localized text for the debug header. Defaults to `Debug`.
local ui_header_language = {}

---
--- Creates a new default instance of the UI header language localization data.
---
---@return ui_header_language ui_header_language The newly created UI header language localization data.
function ui_header_language:new()
    self = setmetatable({}, self)

    self.color = "Color"
    self.display = "Display"
    self.language = "Language"
    self.settings = "Settings"
    self.tracking = "Tracking"
    self.missing = "Missing for: %s"
    self.base_game = "Base Game"
    self.ascendance_dlc = "Ascendance"
    self.debug = "Debug"

    return self
end

return ui_header_language