---@meta

---@class (exact) ui_button_language The class that represents the localized text for buttons in the REFramework UI.
---@field reset_config string The localized text for the reset config button. Defaults to `Reset Config`.
---@field top_left string The localized text for the top left alignment anchor button. Defaults to `Top Left`.
---@field top_right string The localized text for the top right alignment anchor button. Defaults to `Top Right`.
---@field middle string The localized text for the middle alignment anchor button. Defaults to `Middle`.
---@field bottom_left string The localized text for the bottom left alignment anchor button. Defaults to `Bottom Left`.
---@field bottom_right string The localized text for the bottom right alignment anchor button. Defaults to `Bottom Right`.
---@field dump_award_data string The localized text for the dump award (achievement) data button. Defaults to `Dump Award (Achievement) Data`.
---@field dump_monster_data string The localized text for the monster data button. Defaults to `Dump Monster Data`.
---@field dump_user_save_data string The localized text for the dump user save data button. Defaults to `Dump User Save Data`.
local ui_button_language = {}

---
--- Creates a new default instance of the UI button language localization data.
---
---@return ui_button_language ui_button_language The newly created UI button language localization data.
function ui_button_language:new()
    self = setmetatable({}, self)

    self.reset_config = "Reset Config"
    self.top_left = "Top Left"
    self.top_right = "Top Right"
    self.middle = "Middle"
    self.bottom_left = "Bottom Left"
    self.bottom_right = "Bottom Right"
    self.dump_award_data = "Dump Award (Achievement) Data"
    self.dump_monster_data = "Dump Monster Data"
    self.dump_user_save_data = "Dump User Save Data"

    return self
end

return ui_button_language