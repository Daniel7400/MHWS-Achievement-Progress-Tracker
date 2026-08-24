---@meta

--- IMPORTS
local achievement_language = require("Achievement_Progress_Tracker.classes.language.achievement_language")
local modal_language = require("Achievement_Progress_Tracker.classes.language.modal_language")
local tracker_language = require("Achievement_Progress_Tracker.classes.language.tracker_language")
local ui_language = require("Achievement_Progress_Tracker.classes.language.ui_language")
--- END IMPORTS

---@class (exact) language_data The class that represents the instance of the language data object.
---@field font string The font used to display any localized text. Defaults to `NotoSansSC-Bold.otf`.
---@field unicode_glyph_ranges number[] The collection of unicode glyph ranges required to properly display localized text with the associated font.
---@field associated_in_game_language_option number The number that links this language data to the associated in-game language.
---@field ui ui_language The object that contains the localized text for various elements within the REFramework UI.
---@field tracker tracker_language The object that contains the localized text to display within the on-screen trackers.
---@field modal modal_language The The object that contains the localized text for modals.
---@field achievement achievement_language The The object that contains the localized text for the achievement being tracked.
local language_data = {}

---
--- Creates a new default instance of the language data object.
---
---@return language_data language_data The newly created language data object.
function language_data:new()
    self = setmetatable({}, self)

    self.font = "NotoSansSC-Bold.otf"
    self.unicode_glyph_ranges = {}
    self.associated_in_game_language_option = sdk.cache.enum.game_language_option.English
    self.ui = ui_language:new()
    self.tracker = tracker_language:new()
    self.modal = modal_language:new()
    self.achievement = achievement_language:new()

    return self
end

return language_data