---@meta

-- IMPORTS
local constants = require("Achievement_Progress_Tracker.constants")
local display_color_config = require("Achievement_Progress_Tracker.classes.config.display_color_config")
-- END IMPORTS

---@class (exact) display_config The class that represents the display configuration options that control the display settings.
---@field size integer The option that controls the size of the achievement trackers when displayed on-screen. Defaults to `constants.size_option.small`.
---@field alignment_anchor integer The option that controls what alignment anchor is used as the base for where the achievement trackers are located. Defaults to `imgui.constants.alignment_option.bottom_left`.
---@field show_completed boolean The option that controls whether achievements that are completed will be shown or not. Defaults to `true`.
---@field render_horizontally boolean The option that controls whether the achievement trackers will be rendered horizontally or not. Defaults to `false`, rendering vertically.
---@field show_images boolean The option that controls whether the image for an achievement will be displayed in the achievement tracker. Defaults to `true`.
---@field display_progress_as_percentage boolean The option that controls whether the progress text in a progress bar will display as a percentage or not. Defaults to `false`.
---@field center_align_text boolean The option that controls whether the text that will display in the tracker will be centered or not. Does not effect the progress bar text. Defaults to `false`.
---@field show_progress_notifications boolean The option that controls whether progress on achievement trackers will be displayed using the in-game notifications system.
---@field color display_color_config The color options for the achievement trackers.
---@field x_position_adjust number The option that controls the adjustment to the x position at which the notification box is drawn on the screen.
---@field y_position_adjust number The option that controls the adjustment to the y position at which the notification box is drawn on the screen.
local display_config = {}

---
--- Creates a new default instance of the display config.
---
---@return display_config display_config The newly created display config.
function display_config:new()
    self = setmetatable({}, self)

    self.size = constants.size_option.small
    self.alignment_anchor = imgui.constants.alignment_option.bottom_left
    self.show_completed = true
    self.render_horizontally = false
    self.show_images = true
    self.display_progress_as_percentage = false
    self.center_align_text = false
    self.show_progress_notifications = true
    self.color = display_color_config:new()
    self.x_position_adjust = 0
    self.y_position_adjust = 0

    return self
end

return display_config