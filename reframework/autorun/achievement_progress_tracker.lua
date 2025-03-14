log.info("[achievement_progress_tracker.lua] loaded")

-- Check if the d2d table is NOT found.
if not d2d then
    -- If yes, then throw an error letting the user know that d2d is required for this mod.
    error("ERROR: REFramework Direct2D (reframework-d2d) is required for this mod to function. Please install it and try again.")
end

--- IMPORTS
require("Achievement_Progress_Tracker.extensions.imgui_extensions")
require("Achievement_Progress_Tracker.extensions.math_extensions")
require("Achievement_Progress_Tracker.extensions.sdk_extensions")
require("Achievement_Progress_Tracker.extensions.string_extensions")
require("Achievement_Progress_Tracker.extensions.table_extensions")
local sdk_manager = require("Achievement_Progress_Tracker.sdk_manager")
local config_manager = require("Achievement_Progress_Tracker.config_manager")
local language_manager = require("Achievement_Progress_Tracker.language_manager")
local tracking_manager = require("Achievement_Progress_Tracker.tracking_manager")
local draw_manager = require("Achievement_Progress_Tracker.draw_manager")
local ui_manager = require("Achievement_Progress_Tracker.ui_manager")
--- END IMPORTS

--- MODULE INIT
sdk_manager.init_module()
config_manager.init_module()
language_manager.init_module()
draw_manager.init_module()
ui_manager.init_module()
--- END MODULE INIT

-- Create a string to store the character unique id of the character being tracked. So if a new character is created or selected it will force
-- the tracking manager to get the new values.
local tracked_character_unique_id = ""

re.on_frame(function()
    -- Check if the enabled flag on the config is NOT true (meaning the user marked it as disabled).
    if not config_manager.config.current.enabled then
        -- Return to exit early.
        return
    end
    
    -- Call the reset function on the draw manager to reset the values for the new frame.
    draw_manager.reset()

    -- Call the get player function on the sdk manager to get the player object.
    if not sdk_manager.get_player() then
        -- Return to exit early if the player object was NOT found.
        return
    end

    -- Call the get character unique id function on the sdk manager to get the character unique id.
    local current_character_unique_id = sdk_manager.get_character_unique_id()
    if not current_character_unique_id then
        -- Return to exit early if the character unique id was NOT found.
        return
    end

    -- Check if the tracked character unique id is an empty string (no character being tracked).
    if tracked_character_unique_id == "" then
        -- If yes, then set the tracked character unique id to the one found earlier.
        tracked_character_unique_id = current_character_unique_id
    
    -- Else if, check if the tracked character unique id does NOT match the one found earlier.
    elseif tracked_character_unique_id ~= current_character_unique_id then
        -- If yes, then update the tracked character unique id to the one found earlier.
        tracked_character_unique_id = current_character_unique_id

        -- Set the tracking manager as not initialized to force an update since a new/different character was loaded.
        tracking_manager.is_initialized = false
    end

    -- Check if the tracking manager is NOT intialized.
    if not tracking_manager.is_initialized then
        -- If yes, then initialize the tracking manager module.
        tracking_manager.init_module()
    end

    -- Set the draw flag on the draw manager as true.
    draw_manager.flags.draw = true
end)