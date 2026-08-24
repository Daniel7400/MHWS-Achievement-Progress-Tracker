---@meta

---@class (exact) ui_tooltip_language The class that represents the localized text for tooltips in the REFramework UI.
---@field manual_input string The localized text for the manual input tooltip. Defaults to `CTRL + Left Click to input manually`.
---@field uncheck_achievement string The localized text for the uncheck achievement tooltip. Defaults to `Uncheck to hide a specfic achievement tracker`.
local ui_tooltip_language = {}

---
--- Creates a new default instance of the UI tooltip language localization data.
---
---@return ui_tooltip_language ui_tooltip_language The newly created UI tooltip language localization data.
function ui_tooltip_language:new()
    self = setmetatable({}, self)

    self.manual_input = "CTRL + Left Click to input manually"
    self.uncheck_achievement = "Uncheck to hide a specfic achievement tracker"

    return self
end

return ui_tooltip_language