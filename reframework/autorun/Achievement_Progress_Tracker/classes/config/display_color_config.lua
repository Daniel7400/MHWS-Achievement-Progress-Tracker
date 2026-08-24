---@meta

---@class (exact) display_color_config The class that represents the color configuration options for the achievement trackers.
---@field box_background integer The option that controls the background color of the progress tracker box. Defaults to `0xFF0E141B`.
---@field tracker_background integer The option that controls the background color of the achievement tracker itself. Defaults to `0xFF23262E`.
---@field progress_bar_background integer The option that controls the background color of the progress bar. Defaults to `0xFF3D4450`.
---@field progress_bar integer The option that controls the color of the progress bar itself. Defaults to `0xFF1A9FFF`.
---@field progress_bar_complete integer The option that controls the color of the progress bar (when marked as completed). Defaults to `0xFF9DC34C`.
---@field tracker_name_text integer The option that controls the color of the name of the achievement being tracked. Defaults to `0xFFFFFFFF`.
---@field tracker_description_text integer The option that controls the color of the description of the achievement being tracked. Defaults to `0xFFFFFFFF`.
---@field progress_text integer The option that controls the color of the text within the progress bar. Defaults to `0xFFFFFFFF`.
---@field progress_complete_text integer The option that controls the color of the text within the progress bar (when marked as completed). Defaults to `0xFFFFFFFF`.
local display_color_config = {}

---
--- Creates a new default instance of the display color config.
---
---@return display_color_config display_color_config The newly created display color config.
function display_color_config:new()
    self = setmetatable({}, self)

    self.box_background = 0xFF0E141B
    self.tracker_background = 0xFF23262E
    self.progress_bar_background = 0xFF3D4450
    self.progress_bar = 0xFF1A9FFF
    self.progress_bar_complete = 0xFF9DC34C
    self.tracker_name_text = 0xFFFFFFFF
    self.tracker_description_text = 0xFFFFFFFF
    self.progress_text = 0xFFFFFFFF
    self.progress_complete_text = 0xFFFFFFFF

    return self
end

return display_color_config