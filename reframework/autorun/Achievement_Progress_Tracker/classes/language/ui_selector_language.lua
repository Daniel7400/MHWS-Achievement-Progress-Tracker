---@meta

---@class (exact) ui_selector_language The class that represents the localized text for selectors in the REFramework UI.
---@field alignment string The localized text for the alignment selector. Defaults to `Alignment`.
local ui_selector_language = {}

---
--- Creates a new default instance of the UI selector language localization data.
---
---@return ui_selector_language ui_selector_language The newly created UI selector language localization data.
function ui_selector_language:new()
    self = setmetatable({}, self)

    self.alignment = "Alignment"

    return self
end

return ui_selector_language