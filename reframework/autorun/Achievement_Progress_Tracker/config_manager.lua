-- IMPORTS
local constants = require("Achievement_Progress_Tracker.constants")
-- END IMPORTS

--- The manager for all things related to the configuration file.
local config_manager = {
    -- The configs that are being managed.
    config = {
        -- The current config, which is what is saved/loaded and determines the state of the mod.
        current = nil,

        -- The default config, used is the basis of the config and used as the validation schema when loading config data.
        default = {
            -- The flag used to determine if the mod is enabled or not.
            enabled = true,

            -- The config options that control the display settings.
            display = {
                -- The option that controls the size of the achievement trackers when displayed on-screen.
                size = constants.size_option.small,

                -- The option that controls what alignment anchor is used as the base for where the achievement trackers are located.
                alignment_anchor = imgui.constants.alignment_option.bottom_left,

                -- The option that controls whether achievements that are completed will be shown or not.
                show_completed = true,

                -- The option that controls whether the achievement trackers will be rendered horizontally or not. Defaults to false, rendering vertically.
                render_horizontally = false,

                -- The option that controls whether the image for an achievement will be displayed in the achievement tracker. Defaults to true.
                show_images = true,

                -- The option that controls whether the progress text in a progress bar will display as a percentage or not. Defaults to false.
                display_progress_as_percentage = false,

                -- The option that controls whether the text that will display in the tracker will be centered or not. Does not effect the progress bar text. Defaults to false.
                center_align_text = false,

                -- The option that controls whether progress on achievement trackers will be displayed using the in-game notifications system.
                show_progress_notifications = true,

                -- The color options for the achievement trackers.
                color = {
                    -- The option that controls the background color of the progress tracker box.
                    box_background = 0xFF0E141B,

                    -- The option that controls the background color of the achievement tracker itself.
                    tracker_background = 0xFF23262E,

                    -- The option that controls the background color of the progress bar.
                    progress_bar_background = 0xFF3D4450,

                    -- The option that controls the color of the progress bar itself.
                    progress_bar = 0xFF1A9FFF,

                    -- The option that controls the color of the progress bar (when marked as completed).
                    progress_bar_complete = 0xFF9DC34C,

                    -- The option that controls the color of the name of the achievement being tracked.
                    tracker_name_text = 0xFFFFFFFF,

                    -- The option that controls the color of the description of the achievement being tracked.
                    tracker_description_text = 0xFFFFFFFF,

                    -- The option that controls the color of the text within the progress bar.
                    progress_text = 0xFFFFFFFF,

                    -- The option that controls the color of the text within the progress bar (when marked as completed).
                    progress_complete_text = 0xFFFFFFFF,
                },

                -- The option that controls the adjustment to the x position at which the notification box is drawn on the screen.
                x_position_adjust = 0,

                -- The option that controls the adjustment to the y position at which the notification box is drawn on the screen.
                y_position_adjust = 0
            },

            -- The config options that control whether a specific achievement should be tracked or not.
            achievement_tracking = {
                -- The option that controls whether the `A True Hunter Is Never Satisfied` achievement should be tracked or not.
                a_true_hunter = true,

                -- The option that controls whether the `Hunters United Forever` achievement should be tracked or not.
                hunters_united_forever = true,

                -- The option that controls whether the `Someone Worth Following` achievement should be tracked or not.
                someone_worth_following = true,

                -- The option that controls whether the `Capture Pro` achievement should be tracked or not.
                capture_pro = true,

                -- The option that controls whether the `Monster Slayer` achievement should be tracked or not.
                monster_slayer = true,

                -- The option that controls whether the `Seasoned Hunter` achievement should be tracked or not.
                seasoned_hunter = true,

                -- The option that controls whether the `Top of the Food Chain` achievement should be tracked or not.
                top_of_the_food_chain = true,

                -- The option that controls whether the `East to West, A Hunter Never Rests` achievement should be tracked or not.
                east_to_west = true,

                -- The option that controls whether the `A-fish-ionado` achievement should be tracked or not.
                a_fish_ionado = true,

                -- The option that controls whether the `Campmaster` achievement should be tracked or not.
                campmaster = true,

                -- The option that controls whether the `Bourgeois Hunter` achievement should be tracked or not.
                bourgeois_hunter = true,

                -- The option that controls whether the `Gossip Hunter` achievement should be tracked or not.
                gossip_hunter = true,

                -- The option that controls whether the `Impregnable Defense` achievement should be tracked or not.
                impregnable_defense = true,

                -- The option that controls whether the `Power Is Everything` achievement should be tracked or not.
                power_is_everything = true,

                -- The option that controls whether the `Explorer of the Eastlands` achievement should be tracked or not.
                explorer_of_the_eastlands = true,

                -- The option that controls whether the `Monster Ph.D.` achievement should be tracked or not.
                monster_phd = true,

                -- The option that controls whether the `Miniature Crown Collector` achievement should be tracked or not.
                mini_crown_collector = true,

                -- The option that controls whether the `Miniature Crown Master` achievement should be tracked or not.
                mini_crown_master = true,

                -- The option that controls whether the `Giant Crown Collector` achievement should be tracked or not.
                giant_crown_collector = true,

                -- The option that controls whether the `Giant Crown Master` achievement should be tracked or not.
                giant_crown_master = true,

                -- The option that controls whether the `Eastward Wings` achievement should be tracked or not.
                eastward_wings = true
            },

            -- The selected language option.
            language = "default (en-us)"
        },
    }
}

-- The name and path of the config file that stores the settings of the user.
local file_name = constants.directory_path .. "/config.json"

---
--- Validates the values in the config and fixes any that are invalid.
---
local function validate_and_fix_config()
    -- Create a flag to track whether any fixes were applied or not.
    local fix_applied = false

    -- Get the value of the alignment anchor key from the config and match against the alignment option constants.
    local alignment_anchor_key = table.find_key(imgui.constants.alignment_option,
        config_manager.config.current.display.alignment_anchor)

    -- Check if the alignment anchor key is nil (config value was invalid).
    if alignment_anchor_key == nil then
        -- If yes, then set the current config value to the default value.
        config_manager.config.current.display.alignment_anchor = config_manager.config.default.display.alignment_anchor

        -- Set the fix applied flag to true.
        fix_applied = true

        -- Log that an invalid config value was found and that the default value was loaded.
        log.warn(string.format("[%s] - Invalid config value for '%s'. Loading default value.", constants.mod_name, "alignment_anchor"))
    end

    -- Get the value of the size option key from the config and match against the size option constants.
    local size_key = table.find_key(constants.size_option, config_manager.config.current.display.size)

    -- Check if the size key is nil (config value was invalid).
    if size_key == nil then
        -- If yes, then set the current config value to the default value.
        config_manager.config.current.display.size = config_manager.config.default.display.size

         -- Set the fix applied flag to true.
        fix_applied = true

        -- Log that an invalid config value was found and that the default value was loaded.
        log.warn(string.format("[%s] - Invalid config value for '%s'. Loading default value.", constants.mod_name, "size"))
    end

    -- Check if the fix applied flag is true.
    if fix_applied then
        -- If yes, then save the config so the fixed values are saved.
        config_manager.save()
    end
end

---
--- Attempts to load the configuration data from the config file. If the file fails to load it will use the defaults instead.
---
function config_manager.load()
    -- Attempt to load the json config file.
    local loaded_config = json.load_file(file_name)

    -- Check if the config file failed to load.
    if not loaded_config then
        -- If yes, then log that the config file failed to load.
        log.error(string.format("[%s] - Failed to load config file, switching to default.", constants.mod_name))

        -- Set the current config as a clone of the default config.
        config_manager.config.current = table.clone(config_manager.config.default)

        -- Save so a config file is created.
        config_manager.save()
    else -- Else, the config file was loaded without issue.
        -- Set the current config as the matched merge of the default config and loaded config.
        config_manager.config.current = table.matched_merge(config_manager.config.default, loaded_config)

        -- Call the validate and fix config to make sure any invalid values are fixed and saved.
        validate_and_fix_config()
    end
end

---
--- Attempts to save the configuration data from the config file to disk.
---
function config_manager.save()
    -- Attempt to save the json config file.
    local saved = json.dump_file(file_name, config_manager.config.current)

    -- Check if the saved flag is set as true.
    if saved then
        -- If yes, then the file was saved successfully and it will be logged as doing so.
        log.info(string.format("[%s] - Config file saved successfully.", constants.mod_name))
    else -- Else, the config file failed to be saved.
        -- Log that the config file failed to save.
        log.error(string.format("[%s] - Failed to save config file.", constants.mod_name))
    end
end

---
--- Reset the current config values back to the default values.
---
function config_manager.reset()
    -- Reset the current config to a clone of the default config.
    config_manager.config.current = table.clone(config_manager.config.default)
end

---
--- Initializes the config manager module.
---
function config_manager.init_module()
    -- Load the config.
    config_manager.load()
end

return config_manager