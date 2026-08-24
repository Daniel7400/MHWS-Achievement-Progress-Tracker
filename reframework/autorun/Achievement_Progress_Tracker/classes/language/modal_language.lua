---@meta

---@class (exact) modal_language That class that represents the localized text for modals.
---@field header string The localized text for the modal header. Defaults to `Congratulations`.
---@field message string The localized text for the modal message. Defaults to `You have completed all of the achievements this mod tracks!`.
local modal_language = {}

---
--- Creates a new default instance of the modal language localization data.
---
---@return modal_language modal_language The newly created modal language localization data.
function modal_language:new()
    self = setmetatable({}, self)

    self.header = "Congratulations"
    self.message = "You have completed all of the achievements this mod tracks!"

    return self
end

return modal_language