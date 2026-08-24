---@meta

---@class (exact) ui_combo_box_language The class that represents the localized text for combo boxes in the REFramework UI.
---@field size string The localized text for the size combo box. Defaults to `Size`.
local ui_combo_box_language = {}

---
--- Creates a new default instance of the UI combo box language localization data.
---
---@return ui_combo_box_language ui_combo_box_language The newly created UI combo box language localization data.
function ui_combo_box_language:new()
    self = setmetatable({}, self)

    self.size = "Size"

    return self
end

return ui_combo_box_language