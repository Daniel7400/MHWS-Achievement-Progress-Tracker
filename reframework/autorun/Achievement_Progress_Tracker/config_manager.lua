-- IMPORTS
local managed_instances = require("Achievement_Progress_Tracker.classes.managed_instances")
local constants = require("Achievement_Progress_Tracker.constants")
local config_data = require("Achievement_Progress_Tracker.classes.config.config_data")
-- END IMPORTS

---@class config_manager The class that represents the manager responsible for handling all operations related to the configuration of the mod.
---@field config managed_instances<config_data> The configs that are being managed.
local config_manager = {
    config = managed_instances:new(config_data:new())
}

-- The name and path of the config file that stores the settings of the user.
local file_name = constants.directory_path .. "\\config.json"

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
--- Attempts to load the configuration data from the config file.
---
function config_manager.load()
    -- Attempt to load the json config file.
    ---@type config_data|nil
    local loaded_config = json.load_file(file_name)

    -- Check if the config file failed to load.
    if not loaded_config then
        -- If yes, then log that the config file failed to load.
        log.error(string.format("[%s] - Failed to load config file, switching to default.", constants.mod_name))

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
    local config = table.clone(config_manager.config.current)

    if not config.debug_enabled then
        config.debug_enabled = nil
    end

    -- Attempt to save the json config file.
    local saved = json.dump_file(file_name, config)

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