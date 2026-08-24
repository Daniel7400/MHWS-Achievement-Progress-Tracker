---@meta

-- IMPORTS
local ui_dropdown_size_language = require("Achievement_Progress_Tracker.classes.language.ui_dropdown_size_language")
-- END IMPORTS

---@class (exact) ui_dropdown_language The class that represents the localized text for dropdowns in the REFramework UI.
---@field size ui_dropdown_size_language The size options text for the size dropdown box.
local ui_dropdown_language = {}

---
--- Creates a new default instance of the UI dropdown language localization data.
---
---@return ui_dropdown_language ui_dropdown_language The newly created UI dropdown language localization data.
function ui_dropdown_language:new()
    self = setmetatable({}, self)

    self.size = ui_dropdown_size_language:new()

    return self
end

return ui_dropdown_language