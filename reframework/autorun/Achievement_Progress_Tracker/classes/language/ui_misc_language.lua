---@meta

---@class (exact) ui_misc_language The class that represents the localized text for miscellaneous elements in the REFramework UI.
---@field current string The localized text for the miscellaneous current text label. Defaults to `Current`.
---@field select_achievements string The localized text for the select achievements text label. Defaults to `Select achievements to track`.
---@field completed string The localized text for the miscellaneous completed text label. Defaults to `- COMPLETED`.
local ui_misc_language = {}

---
--- Creates a new default instance of the UI miscellaneous language localization data.
---
---@return ui_misc_language ui_misc_language The newly created UI miscellaneous language localization data.
function ui_misc_language:new()
    self = setmetatable({}, self)

    self.current = "Current"
    self.select_achievements = "Select achievements to track"
    self.completed = "- COMPLETED"

    return self
end

return ui_misc_language