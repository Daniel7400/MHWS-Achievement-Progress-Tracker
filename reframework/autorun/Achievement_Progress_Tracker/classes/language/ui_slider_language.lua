---@meta

---@class (exact) ui_slider_language The class that represents the localized text for sliders in the REFramework UI.
---@field adjust_position string The localized text for the adjust position slider. Defaults to `Adjust Position`.
local ui_slider_language = {}

---
--- Creates a new default instance of the UI slider language localization data.
---
---@return ui_slider_language ui_slider_language The newly created UI slider language localization data.
function ui_slider_language:new()
    self = setmetatable({}, self)

    self.alignment = "Adjust Position"

    return self
end

return ui_slider_language