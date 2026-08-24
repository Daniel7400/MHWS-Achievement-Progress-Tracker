---@meta

---@enum ResourceType
local resource_type = {
    Award = 1,
    Item = 2,
    Enemy = 3,
}

setmetatable(resource_type, {
    __index = function()
        return nil
    end,
    __newindex = function()
        error("Enums are read-only")
    end
})

return resource_type