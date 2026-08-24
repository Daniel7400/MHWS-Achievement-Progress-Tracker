---@meta

---@class (exact) achievement_detail_language That class that represents the localized name and description for an achievement.
---@field name string The localized text for the name of the achievement.
---@field description string The localized text for the description of the achievement.
local achievement_detail_language = {}

---
--- Creates a new instance of the achievement detail language localization data.
---
---@param name string The name of the achievement.
---@param description string The description of the achievement.
---
---@return achievement_detail_language achievement_detail_language The newly created achievement detail language localization data.
function achievement_detail_language:new(name, description)
    self = setmetatable({}, self)

    self.name = name
    self.description = description

    return self
end

return achievement_detail_language