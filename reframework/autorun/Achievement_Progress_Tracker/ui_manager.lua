--- IMPORTS
local constants = require("Achievement_Progress_Tracker.constants")
local config_manager = require("Achievement_Progress_Tracker.config_manager")
local language_manager = require("Achievement_Progress_Tracker.language_manager")
local tracking_manager = require("Achievement_Progress_Tracker.tracking_manager")
local draw_manager = require("Achievement_Progress_Tracker.draw_manager")
--- END IMPORTS

--- The manager for the REFramework UI section of the mod.
local ui_manager = {
    -- The loaded fonts to hot swap between when certain languages require a new font to display properly.
    fonts = {},

    -- The language strings used in the the dropdown options for the size options.
    size_options = {}
}

-- The font size used in the REFramework UI.
local ui_font_size <const> = 18

---
--- Gets the maximum and minimum adjustment values for the x and y boundaries.
---
---@return number min_x_adjust The minimum value of x that is allowed for adjustments in the x direction.
---@return number max_x_adjust The maximum value of x that is allowed for adjustments in the x direction.
---@return number min_y_adjust The minimum value of y that is allowed for adjustments in the y direction.
---@return number max_y_adjust The maximum value of y that is allowed for adjustments in the y direction.
local function get_adjustment_boundaries()
    -- Get the display size.
    local display_size = imgui.get_display_size()

    -- Set the max as the display size value, and min as the negative version of the value.
    local max_x_adjust = display_size.x
    local min_x_adjust = max_x_adjust * -1
    local max_y_adjust = display_size.y
    local min_y_adjust = max_y_adjust * -1

    -- Check if the alignment anchor on the config is set as top left.
    if config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.top_left then
        -- If yes, then set the x and y min adjust values as 0.
        min_x_adjust = 0
        min_y_adjust = 0

    -- Else if, check if the alignment anchor on the config is set as top right.
    elseif config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.top_right then
        -- If yes, then set the max x adjust as 0 and min y adjust as 0.
        max_x_adjust = 0
        min_y_adjust = 0

    -- Else if, check if the alignment anchor on the config is set as middle.
    elseif config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.middle then
        -- If yes, then set the x and y max adjust values as half the display size. Set the min as the negative version of the values.
        max_x_adjust = math.floor(display_size.x / 2)
        min_x_adjust = max_x_adjust * -1
        max_y_adjust = math.floor(display_size.y / 2)
        min_y_adjust = max_y_adjust * -1

    -- Else if, check if the alignment anchor on the config is set as bottom left.
    elseif config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.bottom_left then
        -- If yes, then set the min x adjust as 0 and max y adjust as 0.
        min_x_adjust = 0
        max_y_adjust = 0

    else -- Bottom Right
        -- Set the x and y max adjust values as 0.
        max_x_adjust = 0
        max_y_adjust = 0
    end

    -- Return the tuple of the min x adjust, max x adjust, min y adjust, and max y adjust values.
    return min_x_adjust, max_x_adjust, min_y_adjust, max_y_adjust
end

---
--- Checks whether the font on the current language is NOT already loaded in the fonts collection. If it is
--- not, then the font will be loaded via imgui and added into the fonts collection.
---
function ui_manager.load_font_if_missing()
    -- Check if the font assigned to the current language does NOT already have an entry in the fonts table.
    if not ui_manager.fonts[language_manager.language.current.font] then
        -- If yes, then load the font associated with the current language font name and store it in the fonts table.
        ui_manager.fonts[language_manager.language.current.font] =
            imgui.load_font(language_manager.language.current.font, ui_font_size, language_manager.unicode_glyph_ranges)
    end
end

---
--- Initializes the ui manager module.
---
function ui_manager.init_module()
    -- Load the font associated with default language and store it in the fonts table.
    ui_manager.fonts[language_manager.language.default.font] =
        imgui.load_font(language_manager.language.default.font, ui_font_size, language_manager.unicode_glyph_ranges)

    -- Load the font on the current language if its not already loaded.
    ui_manager.load_font_if_missing()

    -- Set the size dropdown options text with the associated keys from the current language.
    ui_manager.size_options = {
        language_manager.language.current.ui.dropdown.size.small,
        language_manager.language.current.ui.dropdown.size.medium,
        language_manager.language.current.ui.dropdown.size.large,
    }

    re.on_draw_ui(function()
        --[[ For reference: https://cursey.github.io/reframework-book/api/imgui.html ]]
    
        -- Define the flags that will track when values in the UI are changed.
        local config_changed,
            language_changed,
            tracking_size_changed,
            tracking_changed,
            changed = false, false, false, false, false
        
        -- Define the flags that will track when something is reset (when the reset button is pressed).
        local tracking_reset,
            language_reset = false, false

        -- Set the language index to default to 1 (default).
        local language_index = 1

        -- Create a new tree node using the mod name from constants.
        if imgui.tree_node(constants.mod_name) then

            -- Push the font to ImGUI associated with the font name associated with the current language.
            imgui.push_font(ui_manager.fonts[language_manager.language.current.font])

            -- Create a button that can be used to reset the config.
            if imgui.button(language_manager.language.current.ui.button.reset_config) then
                -- If pressed, then reset the config to the default values.
                config_manager.reset()

                -- Mark the config changed flag as true.
                config_changed = true

                -- Mark the tracking and language reset flags as true.
                tracking_reset = true
                language_reset = true
            end
    
            -- Create a checkbox that a user can use to enable/disable the functionality of the mod.
            changed, config_manager.config.current.enabled = imgui.checkbox(language_manager.language.current.ui.checkbox.enabled,
                config_manager.config.current.enabled)
            config_changed = config_changed or changed
    
            -- Create a new tree node for all of the mod settings.
            if imgui.tree_node(language_manager.language.current.ui.header.settings) then

                -- Create a new tree node for all settings relating to the display.
                if imgui.tree_node(language_manager.language.current.ui.header.display) then

                    -- Create a combo box that the user can use to change size option for the trackers.
                    imgui.text(language_manager.language.current.ui.combo_box.size)
                    changed, config_manager.config.current.display.size =
                        imgui.combo(" ", config_manager.config.current.display.size, ui_manager.size_options)
                    tracking_size_changed = tracking_size_changed or changed
                    config_changed = config_changed or changed
                    imgui.new_line()

                    -- Create an alignment selector that the user can use to select which alignment everything being
                    -- displayed should be anchored at.
                    changed, config_manager.config.current.display.alignment_anchor = imgui.alignment_selector(
                        config_manager.config.current.display.alignment_anchor,
                        language_manager.language.current.ui.selector.alignment,
                        language_manager.language.current.ui.button.top_left,
                        language_manager.language.current.ui.button.top_right,
                        language_manager.language.current.ui.button.middle,
                        language_manager.language.current.ui.button.bottom_left,
                        language_manager.language.current.ui.button.bottom_right, true)
                    config_changed = config_changed or changed

                    -- Get the min and max values for the x and y boundaries.
                    local min_x_adjust, max_x_adjust, min_y_adjust, max_y_adjust = get_adjustment_boundaries()

                    -- Create a xy position slider that the user can use to adjust the position of things drawn on screen.
                    changed, config_manager.config.current.display.x_position_adjust,
                        config_manager.config.current.display.y_position_adjust = imgui.xy_position_sliders(
                            config_manager.config.current.display.x_position_adjust,
                            config_manager.config.current.display.y_position_adjust,
                            min_x_adjust, max_x_adjust, min_y_adjust, max_y_adjust,
                            language_manager.language.current.ui.slider.adjust_position,
                            language_manager.language.current.ui.tooltip.manual_input, true)
                    config_changed = config_changed or changed

                    -- Create a checkbox that a user can use to enable/disable whether trackers should be rendered horizontally or not.
                    tracking_changed, config_manager.config.current.display.render_horizontally = imgui.checkbox(
                        language_manager.language.current.ui.checkbox.render_horizontally,
                        config_manager.config.current.display.render_horizontally)
                    changed = changed or tracking_changed
                    config_changed = config_changed or changed
                    imgui.new_line()

                    -- Create a new tree node for all settings relating to the color selections.
                    if imgui.tree_node(language_manager.language.current.ui.header.color) then
                    
                        -- Create a new counter that will track how many color pickers have been added.
                        local color_counter = 0

                        -- Create a color picker that the user can use to change the color of the overall box background.
                        changed, config_manager.config.current.display.color.box_background, color_counter =
                            imgui.color_picker_argb_top_label(config_manager.config.current.display.color.box_background,
                            language_manager.language.current.ui.color_picker.box_background, color_counter,
                            language_manager.language.current.ui.misc.current, constants.color_picker_options, true)
                        config_changed = config_changed or changed

                        -- Create a color picker that the user can use to change the color of the background of the trackers.
                        changed, config_manager.config.current.display.color.tracker_background, color_counter =
                            imgui.color_picker_argb_top_label(config_manager.config.current.display.color.tracker_background,
                            language_manager.language.current.ui.color_picker.tracker_background, color_counter,
                            language_manager.language.current.ui.misc.current, constants.color_picker_options, true)
                        config_changed = config_changed or changed

                        -- Create a color picker that the user can use to change the color of the background of the progress bar.
                        changed, config_manager.config.current.display.color.progress_bar_background, color_counter =
                            imgui.color_picker_argb_top_label(config_manager.config.current.display.color.progress_bar_background,
                            language_manager.language.current.ui.color_picker.progress_bar_background, color_counter,
                            language_manager.language.current.ui.misc.current, constants.color_picker_options, true)
                        config_changed = config_changed or changed

                        -- Create a color picker that the user can use to change the color of the progres bar.
                        changed, config_manager.config.current.display.color.progress_bar, color_counter =
                            imgui.color_picker_argb_top_label(config_manager.config.current.display.color.progress_bar,
                            language_manager.language.current.ui.color_picker.progress_bar, color_counter,
                            language_manager.language.current.ui.misc.current, constants.color_picker_options, true)
                        config_changed = config_changed or changed

                        -- Create a color picker that the user can use to change the color of the completed progres bar.
                        changed, config_manager.config.current.display.color.progress_bar_complete, color_counter =
                            imgui.color_picker_argb_top_label(config_manager.config.current.display.color.progress_bar_complete,
                            language_manager.language.current.ui.color_picker.progress_bar_complete, color_counter,
                            language_manager.language.current.ui.misc.current, constants.color_picker_options, true)
                        config_changed = config_changed or changed

                        -- Create a color picker that the user can use to change the color of the text used to display name of the
                        -- achievement being tracked.
                        changed, config_manager.config.current.display.color.tracker_name_text, color_counter =
                            imgui.color_picker_argb_top_label(config_manager.config.current.display.color.tracker_name_text,
                            language_manager.language.current.ui.color_picker.tracker_name_text, color_counter,
                            language_manager.language.current.ui.misc.current, constants.color_picker_options, true)
                        config_changed = config_changed or changed

                        -- Create a color picker that the user can use to change the color of the text used to display description of
                        -- the achievement being tracked.
                        changed, config_manager.config.current.display.color.tracker_description_text, color_counter =
                            imgui.color_picker_argb_top_label(config_manager.config.current.display.color.tracker_description_text,
                            language_manager.language.current.ui.color_picker.tracker_description_text, color_counter,
                            language_manager.language.current.ui.misc.current, constants.color_picker_options, true)
                        config_changed = config_changed or changed

                        -- Create a color picker that the user can use to change the color of the text used to display the progress
                        -- in the progress bar.
                        changed, config_manager.config.current.display.color.progress_text, color_counter =
                            imgui.color_picker_argb_top_label(config_manager.config.current.display.color.progress_text,
                            language_manager.language.current.ui.color_picker.progress_text, color_counter,
                            language_manager.language.current.ui.misc.current, constants.color_picker_options, true)
                        config_changed = config_changed or changed

                        -- Create a color picker that the user can use to change the color of the text used to display the completed
                        -- text in the progress bar.
                        changed, config_manager.config.current.display.color.progress_complete_text, color_counter =
                            imgui.color_picker_argb_top_label(config_manager.config.current.display.color.progress_complete_text,
                            language_manager.language.current.ui.color_picker.progress_complete_text, color_counter,
                            language_manager.language.current.ui.misc.current, constants.color_picker_options, true)
                        config_changed = config_changed or changed

                        -- Close the Color tree node.
                        imgui.tree_pop()
                    end

                    -- Close the Display tree node.
                    imgui.tree_pop()
                end

                -- Create a new tree node for all settings relating to the achievement tracking.
                if imgui.tree_node(language_manager.language.current.ui.header.tracking) then
                    
                    -- Create a checkbox that a user can use to enable/disable whether completed achievements should be displayed or not.
                    tracking_changed, config_manager.config.current.display.show_completed = imgui.checkbox(
                        language_manager.language.current.ui.checkbox.show_completed_achievements,
                        config_manager.config.current.display.show_completed)
                    changed = changed or tracking_changed
                    config_changed = config_changed or changed
                    imgui.new_line()

                    -- Draw some text and a tooltip to describe what the checkboxes below do.
                    imgui.text(language_manager.language.current.ui.misc.select_achievements)
                    imgui.help_tooltip(language_manager.language.current.ui.tooltip.uncheck_achievement)

                    -- Iterate over each achievement tracker.
                    for _, achievement_tracker in ipairs(tracking_manager.achievements) do
                        -- Create a flag to track if the current tracker was changed.
                        local tracker_changed = false

                        -- Create a checkbox that a user can use to enable/disable whether this current achievement should be displayed or not.
                        tracker_changed, config_manager.config.current.achievement_tracking[achievement_tracker.key] = imgui.checkbox(
                            achievement_tracker.name, achievement_tracker:is_enabled())
                        tracking_changed = tracking_changed or tracker_changed
                        changed = changed or tracker_changed
                        config_changed = config_changed or changed

                        -- Create a new tree node to list any missing entries the current tracker may have. This is done by checking if the current achievement tracker
                        -- is enabled AND NOT complete AND has collection params defined AND has missing.
                        if achievement_tracker:is_enabled() and not achievement_tracker:is_complete() and achievement_tracker.collection_params ~= nil
                            and #achievement_tracker.collection_params.missing > 0 and imgui.tree_node(string.format(language_manager.language.current.ui.header.missing, achievement_tracker.name)) then
                            
                            -- If yes, then iterate over each missing entry.
                            for _, missing_entry in ipairs(achievement_tracker.collection_params.missing) do
                                -- Draw some text with the value of the missing entry.
                                imgui.text(string.format("• %s", missing_entry))
                            end

                            -- Close the missing entries tree node.
                            imgui.tree_pop()
                        end
                    end

                    -- Insert a new line for spacing.
                    imgui.new_line()

                    -- Close the Tracking tree node.
                    imgui.tree_pop()
                end

                -- Create a new tree node for the language settings.
                if imgui.tree_node(language_manager.language.current.ui.header.language) then

                    local language_selected = false

                    -- Create a language picker that allows the user to switch between different language options.
                    language_selected, language_index = imgui.language_picker(
                        config_manager.config.current.language, language_manager.language.names)
                    language_changed = language_changed or language_selected
                    config_changed = language_changed or config_changed
                    
                    -- Close the Language tree node.
                    imgui.tree_pop()
                end
    
                -- Close the Settings tree node.
                imgui.tree_pop()
            end

            -- Pop the font that was pushed earlier to return to the last used (default) REFramework font.
            imgui.pop_font()

            -- Close the tree node for the mod.
            imgui.tree_pop()
        end

        -- Check if the language was reset or the option was changed.
        if language_reset or language_changed then
            -- If yes, then update the selected language using the selected language.
            language_manager.update(language_index, true)

            -- Update the name and description texts for each achievement in the tracking manager.
            tracking_manager.update_language()

            -- Mark the config as being changed since the language was updated.
            config_changed = true

            -- Load the font on the current language if its not already loaded.
            ui_manager.load_font_if_missing()

            -- Set the size dropdown options text with the associated keys from the new current language.
            ui_manager.size_options[constants.size_option.small] =
                language_manager.language.current.ui.dropdown.size.small
            ui_manager.size_options[constants.size_option.medium] =
                language_manager.language.current.ui.dropdown.size.medium
            ui_manager.size_options[constants.size_option.large] =
                language_manager.language.current.ui.dropdown.size.large
        end
    
        -- Check if the config was changed.
        if config_changed then
            -- If yes, then save the current config into the config file.
            config_manager.save()
    
            -- Check if the mod enabled option was turned off (disabled).
            if not config_manager.config.current.enabled then
                -- If yes, then reset the values on the draw manager since it will not be drawing anything anymore.
                draw_manager.reset()
            end
        end

        -- Check if the tracking was reset, had its sized changed, or any tracker visibility was toggled.
        if tracking_reset or tracking_size_changed or tracking_changed then
            -- If yes, then call the update language function on the tracking manager to recalculate the longest text
            -- width and amount to display.
            tracking_manager.update_language()
        end
    end)
end

return ui_manager