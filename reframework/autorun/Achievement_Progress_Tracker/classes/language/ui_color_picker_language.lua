---@meta

---@class (exact) ui_color_picker_language The class that represents the localized text for color pickers in the REFramework UI.
---@field box_background string The localized text for the box background color picker. Defaults to `Box Background`.
---@field tracker_background string The localized text for the tracker background color picker. Defaults to `Achievement Tracker Background`.
---@field progress_bar_background string The localized text for the progress bar background color picker. Defaults to `Progress Bar Background`.
---@field progress_bar string The localized text for the progress bar color picker. Defaults to `Progress Bar`.
---@field progress_bar_complete string The localized text for the progress bar complete color picker. Defaults to `Completed Progress Bar`.
---@field tracker_name_text string The localized text for the tracker name text color picker. Defaults to `Achievement Tracker Name Text`.
---@field tracker_description_text string The localized text for the tracker description text color picker. Defaults to `Achievement Tracker Description Text`.
---@field progress_text string The localized text for the progress text color picker. Defaults to `Progress Bar Text`.
---@field progress_complete_text string The localized text for the progress complete text color picker. Defaults to `Completed Progress Bar Text`.
local ui_color_picker_language = {}

---
--- Creates a new default instance of the UI color picker language localization data.
---
---@return ui_color_picker_language ui_color_picker_language The newly created UI color picker language localization data.
function ui_color_picker_language:new()
    self = setmetatable({}, self)

    self.box_background = "Box Background"
    self.tracker_background = "Achievement Tracker Background"
    self.progress_bar_background = "Progress Bar Background"
    self.progress_bar = "Progress Bar"
    self.progress_bar_complete = "Completed Progress Bar"
    self.tracker_name_text = "Achievement Tracker Name Text"
    self.tracker_description_text = "Achievement Tracker Description Text"
    self.progress_text = "Progress Bar Text"
    self.progress_complete_text = "Completed Progress Bar Text"

    return self
end

return ui_color_picker_language