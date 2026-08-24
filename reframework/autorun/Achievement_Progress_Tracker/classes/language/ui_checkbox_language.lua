---@meta

---@class (exact) ui_checkbox_language The class that represents the localized text for checkboxes in the REFramework UI.
---@field enabled string The localized text for the enabled checkbox. Defaults to `Enabled`.
---@field render_horizontally string The localized text for the render horizontally checkbox. Defaults to `Render Trackers Horizontally`.
---@field show_completed_achievements string The localized text for the show completed achievements checkbox. Defaults to `Show Completed Achievements`.
---@field show_images string The localized text for the show images checkbox. Defaults to `Show Achievement Images`.
---@field display_progress_as_percentage string The localized text for the display progress as percentage checkbox. Defaults to `Display Progress as Percentage`.
---@field center_align_text string The localized text for the center align text checkbox. Defaults to `Center Align Tracker Text`.
---@field show_progress_notifications string The localized text for the show progress notifications checkbox. Defaults to `Show In-Game Progress Notifications`.
local ui_checkbox_language = {}

---
--- Creates a new default instance of the UI checkbox language localization data.
---
---@return ui_checkbox_language ui_checkbox_language The newly created UI checkbox language localization data.
function ui_checkbox_language:new()
    self = setmetatable({}, self)

    self.enabled = "Enabled"
    self.render_horizontally = "Render Trackers Horizontally"
    self.show_completed_achievements = "Show Completed Achievements"
    self.show_images = "Show Achievement Images"
    self.display_progress_as_percentage = "Display Progress as Percentage"
    self.center_align_text = "Center Align Tracker Text"
    self.show_progress_notifications = "Show In-Game Progress Notifications"

    return self
end

return ui_checkbox_language