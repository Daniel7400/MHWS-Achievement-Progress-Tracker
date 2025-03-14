---
--- Determines if the provided string ends with the provided ending string.
--- 
---@param s string The string to check.
---@param ending string The string to check if it it exists at the end of the provided string.
---
---@return boolean ends_with The boolean that represents whether the provided string ends with the provided end string.
function string.ends_with(s, ending)
    return ending == "" or s:sub(-#ending) == ending
end

---
--- Determines if the provided string starts with the provided start string.
---
---@param s string The string to check.
---@param start string The string to check if it it exists at the start of the provided string.
---
---@return boolean starts_with The boolean that represents whether the provided string starts with the provided start string.
function string.start_with(s, start)
    return s:sub(1, #start) == start
end

---
--- Determines if the provided string is null (nil) or whitespace.
---
---@param s? string The string to check.
---
---@return boolean is_null_or_whitespace The boolean that represents whether the provided string is null (nil) or whitespace.
function string.is_null_or_whitespace(s)
    return s == nil or string.match(s, "^%s*$") ~= nil
end

---
--- Determines if the provided string is null (nil) or empty.
---
---@param s string The string to check.
---
---@return boolean is_null_or_empty The boolean that represents whether the provided string is null (nil) or empty.
function string.is_null_or_empty(s)
    return s == nil or s == ""
end