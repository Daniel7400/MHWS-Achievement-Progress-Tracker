---@meta

-- IMPORTS
local resource_type = require("Achievement_Progress_Tracker.enums.resource_type")
local constants = require("Achievement_Progress_Tracker.constants")
local config_manager = require("Achievement_Progress_Tracker.config_manager")
-- END IMPORTS

---@class (exact) achievement_tracker
---@field private __index achievement_tracker
---@field id number The id of the achievement to track.
---@field game_award_id number The id of the in-game award/medal that corresponds to this achievement tracker.
---@field game_award_fixed_id number The fixed id of the in-game award/medal that corresponds to this achievement tracker.
---@field key string The look up key of the achievement to reference the config and language entries.
---@field name string The name of the achievement to track.
---@field description string The description of the achievement to track.
---@field image_path string The image of the achievement to track.
---@field award_obtained boolean The flag used to determine if the award/medal has already been obtained in-game.
---@field amount number The amount to reach for the achievement to track to be considered complete.
---@field current number The current amount of progress for the achievement to track tracked. When this reaches or exceeds the amount, it will be considered complete.
---@field content_display_width number The length in pixels for the content that will be displayed by this tracker.
---@field update_params achievement_tracker.updateparams The parameters to use when updating the current value on an update request.
---@field collection_params achievement_tracker.collectionparams The parameters to use when determining the found and missing collections for this tracker.
local achievement_tracker = {}
achievement_tracker.__index = achievement_tracker

---@class (exact) achievement_tracker.updateparams
---@field source number The source from which the data to use when updating will come from.
---@field acquisition_method number The method to acquire the data from the source.
---@field name string The name of the field/function used to acquire the data from the source via the acquisition method.
---@field additional_processing function [OPTIONAL] The function that will take in the acquired value and do any additional processing on it. Needs to return the value that will be set as current. Defaults to nil.

---@class (exact) achievement_tracker.collectionparams
---@field target_collection table The target collection of entries needed by the tracker.
---@field found table The table that contains any entries found in the target collection.
---@field missing table The table that contains any entries that were missing in the target collection.

---
--- Create a new achievement tracker.
---
---@param id number The id of the achievement to track.
---@param game_award_fixed_id number The fixed id of the in-game award/medal that corresponds to this achievement tracker.
---@param name string The name of the achievement to track.
---@param description string The description of the achievement to track.
---@param image_path string The image of the achievement to track.
---@param amount number The amount to reach for the achievement to track to be considered complete.
---@param current number The current amount of progress for the achievement to track tracked. When this reaches or exceeds the amount, it will be considered complete.
---@param update_params_source number The source from which the data to use when updating will come from.
---@param update_params_acquisition_method number The method to acquire the data from the source.
---@param update_params_name string The name of the field/function used to acquire the data from the source via the acquisition method.
---@param update_params_additional_processing? function [OPTIONAL] The function that will take in the acquired value and do any additional processing on it. Needs to return the value that will be set as current. Defaults to nil.
---
---@return achievement_tracker
function achievement_tracker:new(id, game_award_fixed_id, name, description, image_path, amount, current, update_params_source, update_params_acquisition_method, update_params_name, update_params_additional_processing)
    -- Find the achievement key that matches the provided id.
    local achievement_key = table.find_key(constants.achievement, id)

    -- Assert the achievement key was found (not nil).
    assert(achievement_key, string.format("The provided 'id' (value = '%i'), does not correlate to any trackable achievements.", id))

    self = setmetatable({}, self)
    self.update_params = setmetatable({}, self.update_params)

    self.id = id
    self.game_award_fixed_id = game_award_fixed_id
    self.game_award_id = sdk.get_id_from_fixed(resource_type.Award, self.game_award_fixed_id)
    self.key = achievement_key
    self.name = name
    self.description = description
    self.image_path = image_path
    self.award_obtained = false
    self.amount = amount
    self.current = current
    self.content_display_width = 0
    self.update_params.source = update_params_source
    self.update_params.acquisition_method = update_params_acquisition_method
    self.update_params.name = update_params_name
    if update_params_additional_processing ~= nil then
        self.update_params.additional_processing = update_params_additional_processing
    end

    return self
end

---
--- Create a new achievement tracker that has a target collection of entries it needs to be considered complete.
---
---@param id number The id of the achievement to track.
---@param game_award_fixed_id number The fixed id of the in-game award/medal that corresponds to this achievement tracker.
---@param name string The name of the achievement to track.
---@param description string The description of the achievement to track.
---@param image_path string The image of the achievement to track.
---@param amount number The amount to reach for the achievement to track to be considered complete.
---@param current number The current amount of progress for the achievement to track tracked. When this reaches or exceeds the amount, it will be considered complete.
---@param update_params_source number The source from which the data to use when updating will come from.
---@param update_params_acquisition_method number The method to acquire the data from the source.
---@param update_params_name string The name of the field/function used to acquire the data from the source via the acquisition method.
---@param update_params_additional_processing? function [OPTIONAL] The function that will take in the acquired value and do any additional processing on it. Needs to return the value that will be set as current. Defaults to nil.
---@param collection_params_target_collection table The target collection of entries needed by the tracker.
---
---@return achievement_tracker
function achievement_tracker:new_with_collection(id, game_award_fixed_id, name, description, image_path, amount, current,
    update_params_source, update_params_acquisition_method, update_params_name, update_params_additional_processing, collection_params_target_collection)
    self = achievement_tracker:new(id, game_award_fixed_id, name, description, image_path, amount, current, update_params_source, update_params_acquisition_method, update_params_name, update_params_additional_processing)

    self.collection_params = setmetatable({}, self.collection_params)

    self.collection_params.target_collection = collection_params_target_collection
    self.collection_params.found = {}
    self.collection_params.missing = table.clone(collection_params_target_collection)

    return self
end

---
--- Determines if the achievement being tracked is considered complete or not.
---
---@return boolean
function achievement_tracker:is_complete()
    return self.award_obtained or self.current >= self.amount
end

---
--- Determines if the achievement being tracked is enabled (in the config) or not.
---
---@return boolean
function achievement_tracker:is_enabled()
    return config_manager.config.current.achievement_tracking[self.key]
end

---
--- Determines if the achievement being tracked should be displayed on-screen or not.
---
---@return boolean
function achievement_tracker:should_display()
    return (not self:is_complete() or config_manager.config.current.display.show_completed) and self:is_enabled()
end

---
--- Reset all of the changeable values for the achievement tracker. Changeable values include:
--- - `current` - Reset back to `0`.
--- - `content_display_width` - Reset back to `0`.
--- - `award_obtained` - Reset back to `false`.
--- - `collection_params.found` - Reset back to an empty table if applicable.
--- - `collection_params.missing` - Reset back to the target collection if applicable.
---
function achievement_tracker:reset()
    self.current = 0
    self.content_display_width = 0
    self.award_obtained = false

    if self.collection_params ~= nil then
        self.collection_params.found = {}
        self.collection_params.missing = table.clone(self.collection_params.target_collection)
    end
end

--- Clears the `found` and `missing` collections on `collection_params`. Does NOT touch the `target_collection` property.
function achievement_tracker:clear_collection_params()
    if self.collection_params ~= nil then
        self.collection_params.found = {}
        self.collection_params.missing = {}
    end
end

---
--- Adds the provided `entry_to_add` into either the found or missing collection depending on the provided `is_found_entry` flag.
---
---@param is_found_entry boolean The flag used to determine if the entry to add should be added to the `found` collection or not. If not, then it will be added to the `missing` collection.
---@param entry_to_add string The entry to add into one of the `collection_params` collections.
function achievement_tracker:add_collection_entry(is_found_entry, entry_to_add)
    if self.collection_params ~= nil then
        if is_found_entry then
            table.insert(self.collection_params.found, entry_to_add)
        else
            table.insert(self.collection_params.missing, entry_to_add)
        end
    end
end

---
--- Gets the current progress of the achievement tracker as a percentage and returns it as a string.
---
---@param previous_value number? [OPTIONAL] The optional previous value to use in the percentage calculation instead of the current. Defaults to nil (using current value).
---
---@return string progress_string The string that represents the current progress as a percentage of the achievement tracker.
function achievement_tracker:get_percentage_progress_string(previous_value)
    local numerator = self.current

    if previous_value ~= nil and previous_value >= 0 then
        numerator = previous_value
    end

    return string.format("%.2f%%", (numerator / self.amount) * 100)
end

---
--- Gets the current progress of the achievement tracker as a fraction and returns it as a string.
---
---@param previous_value number? [OPTIONAL] The optional previous value to use in the progress string instead of the current. Defaults to nil (using current value).
---
---@return string progress_string The string that represents the current progress as a fraction of the achievement tracker.
function achievement_tracker:get_fraction_progress_string(previous_value)
    local numerator = self.current

    if previous_value ~= nil and previous_value >= 0 then
        numerator = previous_value
    end

    return string.format("%i / %i", numerator, self.amount)
end

---
--- Gets the current progress of the achievement tracker and returns it as a string. Either as a percentage or as `0 / 100` format based on the the `display_progress_as_percentage` config option.
---
---@return string progress_string The string that represents the current progress of the achievement tracker.
function achievement_tracker:get_progress_string()
    if config_manager.config.current.display.display_progress_as_percentage then
        return self:get_percentage_progress_string()
    end

    return self:get_fraction_progress_string()
end

return achievement_tracker