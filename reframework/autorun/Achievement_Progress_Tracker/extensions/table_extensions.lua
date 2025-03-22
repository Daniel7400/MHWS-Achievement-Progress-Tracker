---
--- Returns the recursively cloned table, detecting cyclic references.
---
---@param list table The table to be cloned.
---@param history table The table that keeps track of tables that have already been cloned to detect cyclic references.
---
---@private
---
---@return table
local function clone_core(list, history)
    -- Assert the provided list is of type table.
    assert(type(list) == "table", "The provided 'list' must be a table.")

    -- Check if the provided list is contained within the provided history table.
    if history[list] then
        -- If yes, then throw an error because a cyclic reference was detected.
        error("Cannot 'clone' a table that contains a cyclic reference.")
    end

    -- Set the entry in the history table for the provided list as true.
    history[list] = true

    -- Create a new blank table to store the clone.
    local clone = {}

    -- Iterate over the provided list.
    for key, value in pairs(list) do
        -- Set the cloned key as the current key.
        local cloned_key = key

        -- Check if the type of the key is a table.
        if type(key) == "table" then
            -- If yes, then set the cloned key as the result of recursively calling the clone core function with the key and provided history.
            cloned_key = clone_core(key, history)
        end

        -- Set the cloned value as the current value.
        local cloned_value = value

        -- Check if the type of the value is a table.
        if type(value) == "table" then
            -- If yes, then set the cloned value as the result of recursively calling the clone core function with the key and provided history.
            cloned_value = clone_core(value, history)
        end

        -- Set the entry in the clone table at the cloned key with the value of the cloned value.
        clone[cloned_key] = cloned_value
    end

    -- Get the metatable of the provided list.
    local metatable = getmetatable(list)

    -- Check if the metatable exists (is not nil).
    if metatable then
        -- Set the metatable of the clone as the result of recursively calling the clone core function with the metatable and provided history.
        setmetatable(clone, clone_core(metatable, history))
    end

    -- Remove the entry from the history table for the provided table.
    history[list] = nil

    -- Return the cloned table.
    return clone
end

---
--- Returns a clone (deep copy) of the provided table.
---
---@param list table The table to be cloned.
---
---@return table
function table.clone(list)
    -- Return the result of the private internal clone core function with an empty history.
    return clone_core(list, {})
end

---
--- Returns a table that is the result of merging all provided tables. The first table is used as a reference/schema such that only
--- keys that match into the first table are considered when merging, otherwise they are ignored.
---
---@param ... table The tables to merge.
---
---@return table
function table.matched_merge(...)
    -- Pack the provided values into a collection of tables.
    local tables = { ... }

    -- Assert that there are at least two tables and the first param is a table.
    assert(#tables > 1, "At least two tables are required to do a merge.")
    assert(type(tables[1]) == "table", "The first provided parameter must be a table.")

    -- Create the base result value by cloning the first table. Since this is a matched merge
    -- this is used as the base/schema for the rest of the tables have merged in.
    local result = table.clone(tables[1])

    -- Iterate over each pair in the provided list, discarding the value.
    for key, _ in pairs(result) do
        -- Set a variable to track the value to set (if any from the tables that are being merged in).
        local value_to_set = nil

        -- Iterate over the remaining tables.
        for i = 2, #tables do
            -- Get the current table to merge.
            local table_to_merge = tables[i]

            -- Assert the current table to merge is actually of type table.
            assert(type(table_to_merge) == "table", string.format("Provided parameter in position %i must be a table.", i))

            -- Check if the table to merge has the current key from the schema table.
            if table_to_merge[key] ~= nil then
                -- If yes, then set the value to set as the value of the current table to merge using the current key.
                value_to_set = table_to_merge[key]
            end
        end

        -- Check if the value to set is NOT nil (meaning a match was found from one of the tables to merge)
        if value_to_set ~= nil then
            -- Check if the type of the value to set is a table.
            if type(value_to_set) == "table" then
                -- If yes, then set the value to set as the clone of itself.
                value_to_set = table.clone(value_to_set)
            end

            -- Update the value in the result at the current key to that of the value to set.
            result[key] = value_to_set
        end
    end

    -- Return the result table.
    return result
end

---
--- Returns the first key (or index) in the table that matches the provided value. If no key is found, `nil` is returned.
---
---@param list table The table to search for the key.
---@param value_to_find any The value to match against to find the associated key.
---
---@return any|nil
function table.find_key(list, value_to_find)
    -- Assert the provided value for list is a table.
    assert(type(list) == "table", "The provided 'list' must be a table.")
    
    -- Iterate over each pair in the provided list.
    for key, value in pairs(list) do
        -- Check if the provided value to find matches the value at the current key.
        if value_to_find == value then
            -- If yes, then return the key.
            return key
        end
    end
    
    -- Return nil when no matching value was found against the provided value to find.
    return nil
end

---
--- Returns the boolean that represents whether the provided `list` is empty.
---
---@param list table The table to check whether it is empty or not.
---
---@return boolean
function table.is_empty(list)
    -- Assert the provided value for list is a table.
    assert(type(list) == "table", "The provided 'list' must be a table.")

    -- Returns the bool that represents whether the result of the `next` function call with the provided list
    -- equals nil (i.e. has no next elements, is empty)
    return next(list) == nil
end

---
--- Returns the boolean that represents whether the provided `list` is an array (a sequential list of elements starting from index 1).
---
---@param list table The table to to check whether it is an array or not.
---
---@return boolean
function table.is_array(list)
    -- Assert the provided value for list is a table.
    assert(type(list) == "table", "The provided 'list' must be a table.")

    -- Define an index, starting at 1, that will be used to check each sequential spot in the potential array.
    local index = 1

    -- Iterate over each pair in the provided list, discarding the key and value.
    for _ in pairs(list) do
        -- Check if the value at the current index is nil (meaning it doesn't exist).
        if list[index] == nil then
            -- If yes, then return false since there are more pairs than indexes.
            return false
        end

        -- Increment the index by 1 so it can be used to check the next value.
        index = index + 1
    end

    -- Return true since all indexes matched against a pair, giving a full sequential list.
    return true
end

---
--- Returns the number that represents the number of elements in the provided `list`. This should only be used when it is known ahead of time to be a dictionary type table, otherwise `#list` should be used.
---
---@param list table The table to to check the length of.
---
---@return number length The number that represents the number of elements in the provided list.
function table.length(list)
    -- Assert the provided value for list is a table.
    assert(type(list) == "table", "The provided 'list' must be a table.")

    -- Check if the provided list is nil.
    if list == nil then
        -- If yes, then return 0.
        return 0
    end

    -- Initialize the length value that will be returned.
    local length = 0

    -- Iterate over each pair in the provided list, discarding the key and value.
    for _ in pairs(list) do
        -- Increment the length by 1.
        length = length + 1
    end

    -- Return the length value.
    return length
end

local spacing <const> = "    "

---
--- Returns the provided `list` table as a json structured string, with potential recursion and detecting cyclic references.
---
---@param list table The table to express as a string.
---@param indent_level number The indention level used to determine the indentation whitespace before each line in the string.
---@param history table The table that keeps track of tables that have already been cloned to detect cyclic references.
---
---@private
---
---@return string
local function tostring_core(list, indent_level, history)
    -- Check if the provided list is empty.
    if table.is_empty(list) then
        -- If yes, then return an empty table string.
        return "{}"
    end

    -- Check if the provided list is contained within the provided history table.
    if history[list] then
        -- If yes, then throw an error because a cyclic reference was detected.
        error("Cannot 'tostring' a table that contains a cyclic reference.")
    end

    -- Set the entry in the history table for the provided list as true.
    history[list] = true
    
    -- Create a table to store each string part to be concat'ed at the end.
    local string_parts = {}

    -- Setup the indentation (spacing) for the brackets and table entries based on the provided indent level.
    local bracket_indentation = string.rep(spacing, indent_level)
    local entry_indentation = string.format("%s%s", bracket_indentation, spacing)

    -- Define the opening and closing bracket as the ones used for an object.
    local opening_bracket = "{\n"
    local closing_bracket = "}"

    -- Determine if the provided list is an array or not.
    local is_array = table.is_array(list)

    -- Check if the is array flag is true.
    if is_array then
        -- If yes, then update the opening and closing bracket as the ones used for an array.
        opening_bracket = "[\n"
        closing_bracket = "]"
    end

    -- Add the opening bracket into the string parts table.
    table.insert(string_parts, opening_bracket)

    -- Create a flag to track the first iteration.
    local is_first = true

    -- Iterate over the provided list.
    for key, value in pairs(list) do
        -- Check if this is NOT the first iteration.
        if not is_first then
            -- If yes, then append the comma and new line character to prepare for the next entry.
            table.insert(string_parts, ",\n")
        else
            -- Set the is first flag to false.
            is_first = false
        end

        -- Add the indentation for the entry into the string parts table.
        table.insert(string_parts, entry_indentation)

        -- Check if the provided list was NOT an array.
        if not is_array then
            -- If yes, then add the key name into the string parts table.
            table.insert(string_parts, string.format('"%s": ', tostring(key)))
        end

        -- Get the type of the current value.
        local value_type = type(value)

        if value_type == "table" then
            -- If the type is a table, then add the result of the tostring_core for the value and an extra level of indention into the string parts table.
            table.insert(string_parts, tostring_core(value, indent_level + 1, history))
        elseif value_type == "string" then
            -- If the type is a string, then add the value between double quotes into the string parts table.
            table.insert(string_parts, string.format('"%s"', value))
        elseif value_type == "function" or value_type == "userdata" then
            -- If the type is a function or userdata, then add the to string of the value between double quotes into the string parts table.
            table.insert(string_parts, string.format('"%s"', tostring(value)))
        else
            -- For everything else, add the to string of the value into the string parts table.
            table.insert(string_parts, tostring(value))
        end
    end

    -- Add the newline character, indention for the bracket, and closing bracket into the string parts table.
    table.insert(string_parts, string.format("%s%s", "\n", bracket_indentation))
    table.insert(string_parts, closing_bracket)

    -- Remove the entry from the history table for the provided table.
    history[list] = nil

    -- Return the result of doing a concat on the string parts table.
    return table.concat(string_parts)
end

---
--- Converts the provided `list` table into a `json` structured string in a human-readable format.
---
---@param list table The table to express as a string.
---
---@return string
function table.tostring(list, indent_level)
    -- Assert the provided list is of type table.
    assert(type(list) == "table", "The provided 'list' must be a table.")

    -- Check if the provided optional indent level is nil.
    if indent_level == nil then
        -- If yes, then set the value as key flag as false by default.
        indent_level = 0
    end

    -- Return the result of the private internal to string core function.
    return tostring_core(list, indent_level, {})
end