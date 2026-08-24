---@meta

---@class (exact) ui_dropdown_size_language The class that represents the localized text for size dropdown options in the REFramework UI.
---@field tiny string The localized text for the tiny size dropdown option. Defaults to `Tiny`.
---@field small string The localized text for the small size dropdown option. Defaults to `Small`.
---@field medium string The localized text for the medium size dropdown option. Defaults to `Medium`.
---@field large string The localized text for the large size dropdown option. Defaults to `Large`.
local ui_dropdown_size_language = {}

---
--- Creates a new default instance of the UI dropdown size options language localization data.
---
---@return ui_dropdown_size_language ui_dropdown_size_language The newly created UI dropdown size options language localization data.
function ui_dropdown_size_language:new()
    self = setmetatable({}, self)

    self.tiny = "Tiny"
    self.small = "Small"
    self.medium = "Medium"
    self.large = "Large"

    return self
end

return ui_dropdown_size_language