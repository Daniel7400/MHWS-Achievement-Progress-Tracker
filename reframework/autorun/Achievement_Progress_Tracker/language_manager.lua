-- IMPORTS
local constants = require("Achievement_Progress_Tracker.constants")
local config_manager = require("Achievement_Progress_Tracker.config_manager")
-- END IMPORTS

--- The manager for all things related to languages.
local language_manager = {
    -- The language that are being managed.
    language = {
        -- The current language, which is used as the source of the text content when referencing language strings.
        current = nil,

        -- The default language, which contains the default (en-US) language strings to use. Also used as a validation schema
        -- when loading language files.
        default = {
            font = "NotoSansSC-Bold.otf",
            unicode_glyph_ranges = {},
            associated_in_game_language_option = sdk.constants.enum.game_language_option.English,
            ui = {
                button = {
                    reset_config = "Reset Config",
                    top_left = "Top Left",
                    top_right = "Top Right",
                    middle = "Middle",
                    bottom_left = "Bottom Left",
                    bottom_right = "Bottom Right"
                },
                checkbox = {
                    enabled = "Enabled",
                    render_horizontally = "Render Trackers Horizontally",
                    show_completed_achievements = "Show Completed Achievements",
                    show_images = "Show Achievement Images",
                    display_progress_as_percentage = "Display Progress as Percentage",
                    center_align_text = "Center Align Tracker Text"
                },
                color_picker = {
                    box_background = "Box Background",
                    tracker_background = "Achievement Tracker Background",
                    progress_bar_background = "Progress Bar Background",
                    progress_bar = "Progress Bar",
                    progress_bar_complete = "Completed Progress Bar",
                    tracker_name_text = "Achievement Tracker Name Text",
                    tracker_description_text = "Achievement Tracker Description Text",
                    progress_text = "Progress Bar Text",
                    progress_complete_text = "Completed Progress Bar Text"
                },
                combo_box = {
                    size = "Size"
                },
                dropdown = {
                    size = {
                        tiny = "Tiny",
                        small = "Small",
                        medium = "Medium",
                        large = "Large"
                    }
                },
                header = {
                    color = "Color",
                    display = "Display",
                    language = "Language",
                    settings = "Settings",
                    tracking = "Tracking",
                    missing = "Missing for: %s",
			        base_game = "Base Game"
                },
                misc = {
                    current = "Current",
                    select_achievements = "Select achievements to track",
                    completed = "- COMPLETED"
                },
                selector = {
                    alignment = "Alignment"
                },
                slider = {
                    adjust_position = "Adjust Position"
                },
                tooltip = {
                    manual_input = "CTRL + Left Click to input manually",
                    uncheck_achievement = "Uncheck to hide a specfic achievement tracker"
                }
            },
            tracker = {
                completed = "Completed!"
            },
            modal = {
                header = "Congratulations",
                message = "You have completed all of the achievements this mod tracks!"
            },
            achievement = {
                a_true_hunter = {
                    name = "A True Hunter Is Never Satisfied",
                    description = "Completed 50 quests."
                },
                hunters_united_forever = {
                    name = "Hunters United Forever",
                    description = "Completed 100 quests via multiplayer."
                },
                someone_worth_following = {
                    name = "Someone Worth Following",
                    description = "Completed 100 quests with your Palico deployed."
                },
                capture_pro = {
                    name = "Capture Pro",
                    description = "Captured 50 monsters."
                },
                monster_slayer = {
                    name = "Monster Slayer",
                    description = "Hunted 100 large monsters."
                },
                seasoned_hunter = {
                    name = "Seasoned Hunter",
                    description = "Hunted 50 tempered monsters."
                },
                top_of_the_food_chain = {
                    name = "Top of the Food Chain",
                    description = "Hunted 50 apex predators."
                },
                east_to_west = {
                    name = "East to West, A Hunter Never Rests",
                    description = "Completed 30 different side missions."
                },
                a_fish_ionado = {
                    name = "A-fish-ionado",
                    description = "Reeled in 30 whoppers while fishing."
                },
                campmaster = {
                    name = "Campmaster",
                    description = "Established Pop-up Camps in 10 places."
                },
                bourgeois_hunter = {
                    name = "Bourgeois Hunter",
                    description = "Possessed 1,000,000 zenny."
                },
                gossip_hunter = {
                    name = "Gossip Hunter",
                    description = "Viewed 30 different Hunter Profiles."
                },
                impregnable_defense = {
                    name = "Impregnable Defense",
                    description = "Forged five different pieces of armor with Rarity 7 or higher."
                },
                power_is_everything = {
                    name = "Power Is Everything",
                    description = "Forged five different weapons (NON ARTIAN) with Rarity 7 or higher."
                },
                explorer_of_the_eastlands = {
                    name = "Explorer of the Eastlands",
                    description = "Obtained 10 different special items of Rarity 6."
                },
                monster_phd = {
                    name = "Monster Ph.D.",
                    description = "Hunted many different large monsters."
                },
                mini_crown_collector = {
                    name = "Miniature Crown Collector",
                    description = "Obtained a miniature crown for 10 or more monsters in the Hunting Log."
                },
                mini_crown_master = {
                    name = "Miniature Crown Master",
                    description = "Obtained a miniature crown for many monsters in the Hunting Log."
                },
                giant_crown_collector = {
                    name = "Giant Crown Collector",
                    description = "Obtained a gold crown for 10 or more monsters in the Hunting Log."
                },
                giant_crown_master = {
                    name = "Giant Crown Master",
                    description = "Obtained a gold crown for many monsters in the Hunting Log."
                },
                eastward_wings = {
                    name = "Eastward Wings",
                    description = "Obtained all other awards."
                }
            }
        },

        -- The names of all language files that are loaded.
        names = {
            "default (en-US)"
        },
    },

    -- The range of loaded unicode glyphs.
    unicode_glyph_ranges = {
        0x0020, 0x00FF, -- Basic Latin + Latin Supplement
        0x0100, 0x024F, -- Latin Extended-A, Latin Extended-B,
        0x1E00, 0x1EFF, -- Latin Extended Additional
        0x2000, 0x206F, -- General Punctuation
        0xFF00, 0xFFEF, -- Halfwidth and Fullwidth Forms
        0x0300, 0x036F, -- Combining Diacritical Marks
        0x20D0, 0x20FF, -- Combining Diacritical Marks for Symbols
    }
    --[[ For reference: https://github.com/ocornut/imgui/blob/master/imgui_draw.cpp#L3254 ]]
}

-- The collection of loaded languages, which starts with only the default.
local loaded_languages = {
    language_manager.language.default
}

---
--- Attempts to load the language files from the languages folder. If a file fails to load it will be ignored, if no files exist
--- or are loaded then the default (en-US) language will be used.
---
function language_manager.load()
    -- Use a regex string to find all language files in the languages directory path that are json files.
    local language_files = fs.glob([[Achievement_Progress_Tracker\\languages\\.*json]])

    -- Check if there were no language files that were found.
    if not language_files or not next(language_files) then
        -- If yes, then log a warning saying that no language files were found.
        log.warn(string.format("[%s] - Failed to find any language json files.", constants.mod_name))

        -- Return to exit early since no language files were found.
        return
    end

    -- Iterate over each language file that was found.
    for _, language_file_name in ipairs(language_files) do
        -- Get the name of the language by removing the language directory path and file extension from the file name.
        local language_name = language_file_name:gsub(constants.language_directory_path, ""):gsub(".json", "")

        -- Attempt to load the current language file.
        local loaded_language = json.load_file(language_file_name)

        -- Check if the loaded language was loaded properly and has any entries.
        if loaded_language and next(loaded_language) then
            -- If yes, then insert the language name into the collection of language names so it can be displayed in the dropdown.
            table.insert(language_manager.language.names, language_name)

            -- Check if the loaded language has a unicode glyph ranges field AND it has entries.
            if loaded_language.unicode_glyph_ranges and next(loaded_language.unicode_glyph_ranges) then
                -- If yes, then iterate over each unicode glyph code in the collection.
                for _, unicode_glyph_code_string in ipairs(loaded_language.unicode_glyph_ranges) do
                    -- Attempt to convert the current unicode glyph code string into a unicode glyph code number.
                    -- (i.e. "0x0020" => 32)
                    local unicode_glyph_code = tonumber(unicode_glyph_code_string)

                    -- Check if the unicode glyph code was converted successfully AND doesn't already have an entry in the
                    -- range of unicode glyphs stored in the language manager.
                    if unicode_glyph_code and not table.find_key(language_manager.unicode_glyph_ranges,
                        unicode_glyph_code) then
                        -- If yes, then insert the current unicode glyph code into the range of unicode glyphs stored
                        -- in the language manager.
                        table.insert(language_manager.unicode_glyph_ranges, unicode_glyph_code)
                    end
                end
            end

            -- Merge the loaded language into the default language (to verify the schema, and force it to match the default
            -- language structure, any other values will be ignored).
            local merged_language = table.matched_merge(language_manager.language.default, loaded_language)

            -- Insert the merged language into the collection of loaded languages.
            table.insert(loaded_languages, merged_language)
        else -- Else, the loaded language was invalid.
            -- Log an error saying that this language file failed to load.
            log.error(string.format("[%s] - Failed to load language json file: '%s'", constants.mod_name, language_name))
        end
    end
end

---
--- Update the current language to the language found using the provided index. If the language found using the index doesn't exist
--- then the current language will be set to the default language.
--- 
--- @param key integer The key used to reference into the loaded language collection to attempt to set as the new current language.
--- @param should_update_config boolean The flag used to determine if the config value should be updated as well when the current language is updated.
function language_manager.update(key, should_update_config)
    -- Attempt to get the language that matches the provided key from the collection of loaded languages.
    local selected_language = loaded_languages[key]

    -- Check if the selected language was NOT found OR doesn't have any entries.
    if not selected_language or not next(selected_language) then
        -- If yes, then reset the language manager so the current language is set back to the default.
        language_manager.reset()
    else -- Else, the selected language is valid.
        -- Update the current language to a deep copy of the found selected language.
        language_manager.language.current = table.clone(selected_language)
    end

    if should_update_config then
        -- Set the language on the config as the name of the language selected.
        config_manager.config.current.language = language_manager.language.names[key]
    end
end

---
--- Reset the current language back to the default language.
---
function language_manager.reset()
    -- Reset the current language back to a clone of the default language.
    language_manager.language.current = table.clone(language_manager.language.default)
end

---
--- Initializes the language manager module.
---
function language_manager.init_module()
    -- Load the language files.
    language_manager.load()

    -- Update the current language to the language that matches the language saved in the config.
    language_manager.update(table.find_key(language_manager.language.names,
        config_manager.config.current.language), false)

    -- Insert 0 at the end of the collection of unicode glyph range.
    table.insert(language_manager.unicode_glyph_ranges, 0)

    -- Load the tracking manager (loaded here to avoid cyclic dependency).
    local tracking_manager = require("Achievement_Progress_Tracker.tracking_manager")

    -- Iterate over each achievement tracker.
    for _, achievement_tracker in ipairs(tracking_manager.achievements) do
        -- Update the language for the achievement tracker.
        achievement_tracker.name = language_manager.language.current.achievement[achievement_tracker.key].name
        achievement_tracker.description = language_manager.language.current.achievement[achievement_tracker.key].description
    end
end

return language_manager