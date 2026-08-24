---@meta

--- IMPORTS
local ui_button_language = require("Achievement_Progress_Tracker.classes.language.ui_button_language")
local ui_checkbox_language = require("Achievement_Progress_Tracker.classes.language.ui_checkbox_language")
local ui_color_picker_language = require("Achievement_Progress_Tracker.classes.language.ui_color_picker_language")
local ui_combo_box_language = require("Achievement_Progress_Tracker.classes.language.ui_combo_box_language")
local ui_dropdown_language = require("Achievement_Progress_Tracker.classes.language.ui_dropdown_language")
local ui_header_language = require("Achievement_Progress_Tracker.classes.language.ui_header_language")
local ui_misc_language = require("Achievement_Progress_Tracker.classes.language.ui_misc_language")
local ui_selector_language = require("Achievement_Progress_Tracker.classes.language.ui_selector_language")
local ui_slider_language = require("Achievement_Progress_Tracker.classes.language.ui_slider_language")
local ui_tooltip_language = require("Achievement_Progress_Tracker.classes.language.ui_tooltip_language")
--- END IMPORTS

---@class (exact) ui_language That class that represents the localized text for various elements within the REFramework UI.
---@field button ui_button_language The localized text for buttons in the REFramework UI.
---@field checkbox ui_checkbox_language The localized text for checkboxes in the REFramework UI.
---@field color_picker ui_color_picker_language The localized text for color pickers in the REFramework UI.
---@field combo_box ui_combo_box_language The localized text for combo boxes in the REFramework UI.
---@field dropdown ui_dropdown_language The localized text for dropdowns in the REFramework UI.
---@field header ui_header_language The localized text for headers in the REFramework UI.
---@field misc ui_misc_language The localized text for miscellaneous elements in the REFramework UI.
---@field selector ui_selector_language The localized text for selectors in the REFramework UI.
---@field slider ui_slider_language The localized text for sliders in the REFramework UI.
---@field tooltip ui_tooltip_language The localized text for tooltips in the REFramework UI.
local ui_language = {}

---
--- Creates a new default instance of the UI language localization data.
---
---@return ui_language ui_language The newly created UI language localization data.
function ui_language:new()
    self = setmetatable({}, self)

    self.button = ui_button_language:new()
    self.checkbox = ui_checkbox_language:new()
    self.color_picker = ui_color_picker_language:new()
    self.combo_box = ui_combo_box_language:new()
    self.dropdown = ui_dropdown_language:new()
    self.header = ui_header_language:new()
    self.misc = ui_misc_language:new()
    self.selector = ui_selector_language:new()
    self.slider = ui_slider_language:new()
    self.tooltip = ui_tooltip_language:new()

    return self
end


return ui_language