---
--- Returns the number `x` clamped between `min` and `max`.
---
---@param x number The number to clamp.
---@param min number The minimum possible value.
---@param max number The maximum possible value.
---
---@return number
function math.clamp(x, min, max)
    return math.max(math.min(x, max), min)
end

---
--- Returns the top-left coordinates (`x` and `y`) to center a target within a specified area
--- (as defined by `total_width` and `total_height`).
---
---@param total_width number The width of the area in which the target is to be centered.
---@param total_height number The height of the area in which the target is to be centered.
---@param target_width number The width of the target to be centered.
---@param target_height number The height of the target to be centered.
---
---@return number
---@return number
function math.get_centered_origin(total_width, total_height, target_width, target_height)
    -- Assert the provided values are valid.
    assert(total_width >= target_width, "Total width must be greater than or equal to the target width.")
    assert(total_height >= target_height, "Total height must be greater than or equal to the target height.")
    
    -- Calculate the x and y coordinate by taking the difference between the provided total and target, then dividing by 2.
    local x = math.floor((total_width - target_width) / 2)
    local y = math.floor((total_height - target_height) / 2)

    -- Return the tuple of the x and y coordinates.
    return x, y
end

---
--- Returns the `ABGR` color from the provided `ARGB` color.
---
---@param argb_color number The color (in ARGB form) to convert to ABGR form.
---
---@return number
function math.argb_to_abgr(argb_color)
    -- Assert the provided ARGB color value is valid.
    assert(argb_color >= 0x00000000 and argb_color <= 0xFFFFFFFF,
        "The provided 'argb_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")

    -- Extract the values for each specific channel from the provided ARGB color.
    local alpha = (argb_color >> 24) & 0xFF
    local red = (argb_color >> 16) & 0xFF
    local green = (argb_color >> 8) & 0xFF
    local blue = argb_color & 0xFF

    -- Return the ABGR color by bit shifting the channels to their correct positions.
    return (alpha << 24) | (blue << 16) | (green << 8) | red
end

---
--- Returns the `ARGB` color from the provided `ABGR` color.
---
---@param abgr_color number The color (in ABGR form) to convert to ARGB form.
---
---@return number
function math.abgr_to_argb(abgr_color)
    -- Assert the provided ABGR color value is valid.
    assert(abgr_color >= 0x00000000 and abgr_color <= 0xFFFFFFFF,
        "The provided 'abgr_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")

    -- Extract the values for each specific channel from the provided ABGR color.
    local alpha = (abgr_color >> 24) & 0xFF
    local blue = (abgr_color >> 16) & 0xFF
    local green = (abgr_color >> 8) & 0xFF
    local red = abgr_color & 0xFF

    -- Return the ARGB color by bit shifting the channels to their correct positions.
    return (alpha << 24) | (red << 16) | (green << 8) | blue
end