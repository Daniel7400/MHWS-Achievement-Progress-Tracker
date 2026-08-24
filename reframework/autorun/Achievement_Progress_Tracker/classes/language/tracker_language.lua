---@meta

---@class (exact) tracker_language That class that represents the localized text to display within the on-screen trackers.
---@field completed string The localized text for a completed on-screen tracker. Defaults to `Completed!`.
local tracker_language = {}

---
--- Creates a new default instance of the tracker language localization data.
---
---@return tracker_language tracker_language The newly created tracker language localization data.
function tracker_language:new()
    self = setmetatable({}, self)

    self.completed = "Completed!"

    return self
end

return tracker_language