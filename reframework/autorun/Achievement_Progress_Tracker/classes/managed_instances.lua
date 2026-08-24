---@meta

---@generic T The data object type to be managed.
---@class (exact) managed_instances<T> The class that represents the container that holds the current and default data instances.
---@field current T The active data instance, that is currently in use (will be equivalent to the default before loading occurs).
---@field default T The default data instance, used when no current data instance can be loaded and serves as the validation schema when loading the current data instance.
local managed_instances = {}

---@generic T The data object type to be managed.
---
--- Creates a new instance of the managed instances object.
---
---@param default_instance T The default data instance to set.
---
---@return managed_instances<T> managed_instances The newly created managed instances object.
function managed_instances:new(default_instance)
    self = setmetatable({}, self)

    self.default = default_instance
    self.current = table.clone(default_instance)

    return self
end

return managed_instances