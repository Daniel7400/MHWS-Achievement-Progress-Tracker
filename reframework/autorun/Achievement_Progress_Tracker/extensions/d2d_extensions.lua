---
--- Draws a progress bar on the screen at the specified position.
---
---@param current number The current amount of progress to display. When this reaches or exceeds the max, it will be considered complete.
---@param max number The amount to reach for the progress to be considered complete.
---@param font userdata The font used to write the text in the progress bar.
---@param x number The horizontal position on the screen.
---@param y number The vertical position on the screen.
---@param width number The width (in pixels) of the progress bar.
---@param height number The height (in pixels) of the progress bar.
---@param completed_text? string [OPTIONAL] The text to display inside the completed progress bar. Defaults to "Completed!".
---@param bar_background_color? number [OPTIONAL] The color (in ARGB form) to use for the background progress bar. Defaults to [0xFF3D4450](https://www.colorhexa.com/3D4450).
---@param bar_color? number [OPTIONAL] The color (in ARGB form) to use for the progress bar. Defaults to [0xFF1A9FFF](https://www.colorhexa.com/1A9FFF).
---@param bar_complete_color? number [OPTIONAL] The color (in ARGB form) to use for the completed progress bar. Defaults to [0xFF9DC34C](https://www.colorhexa.com/9DC34C).
---@param text_color? number [OPTIONAL] The color (in ARGB form) to use for the text inside the progress bar. Defaults to [0xFFFFFFFF](https://www.colorhexa.com/FFFFFF).
---@param text_complete_color? number [OPTIONAL] The color (in ARGB form) to use for the text inside the completed progress bar. Defaults to [0xFFFFFFFF](https://www.colorhexa.com/FFFFFF).
function d2d.progress_bar(current, max, font, x, y, width, height, completed_text, bar_background_color, bar_color, bar_complete_color, text_color, text_complete_color)
    -- Set defaults for the optional parameters that didn't have a value provided.
    completed_text = completed_text or "Completed!"
    bar_background_color = bar_background_color or 0xFF3D4450
    bar_color = bar_color or 0xFF1A9FFF
    bar_complete_color = bar_complete_color or 0xFF9DC34C
    text_color = text_color or 0xFFFFFFFF
    text_complete_color = text_complete_color or 0xFFFFFFFF

    -- Assert the provided colors are valid.
    assert(bar_background_color >= 0x00000000 and bar_background_color <= 0xFFFFFFFF,
        "The provided 'bar_background_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")
    assert(bar_color >= 0x00000000 and bar_color <= 0xFFFFFFFF,
        "The provided 'bar_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")
    assert(bar_complete_color >= 0x00000000 and bar_complete_color <= 0xFFFFFFFF,
        "The provided 'bar_complete_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")
    assert(text_color >= 0x00000000 and text_color <= 0xFFFFFFFF,
        "The provided 'text_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")
    assert(text_complete_color >= 0x00000000 and text_complete_color <= 0xFFFFFFFF,
        "The provided 'text_complete_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")
    
    -- Deteremine if the progress is complete (current progress is greater than or equal to the max).
    local is_complete = current >= max

    -- Default the percentage to 1 (100%).
    local percentage = 1

    -- Set the progress bar text using the provided current and max to display the progress as text in the bar.
    local progress_bar_text = string.format("%i / %i", current, max)

    -- Default the progress bar and text color to the provided color values.
    local progress_bar_color = bar_color
    local progress_text_color = text_color

    -- Check if the progress is completed, because this will update certain values.
    if is_complete then
        -- If yes, then update the text to the provided complete text and colors to the provided completed colors.
        progress_bar_text = completed_text
        progress_bar_color = bar_complete_color
        progress_text_color = text_complete_color
    else -- Else, the progress is NOT complete.
        -- Draw the progress bar background since the progress bar isn't complete (in which case it would take the full width
        -- meaning this wouldn't be needed).
        d2d.fill_rect(x, y, width, height, bar_background_color)

        -- Update the percentage to be the result of dividing the current against the max.
        percentage = current / max
    end

    -- Draw the actual progress bar with the width set as the progress percentage amount.
    d2d.fill_rect(x, y, percentage * width, height, progress_bar_color)

    -- Measure the width and height of the progress bar text.
    local progress_bar_text_width, progress_bar_text_height = font:measure(progress_bar_text)

    -- Get the centered origin of the text against the size of the progress bar itself to make sure the text is centered.
    local x_center_offset, y_center_offset = math.get_centered_origin(width, height,
        progress_bar_text_width, progress_bar_text_height)

    -- Draw the progress bar text in the center of the progress bar.
    d2d.text(font, progress_bar_text,
        x + x_center_offset,
        y + y_center_offset + 1,
        progress_text_color)
end

---
--- Calculates the size of the modal using the provided size of the text contents to be displayed inside.
---
---@param header_width number The width of the header text (in pixels).
---@param header_height number The height of the header text (in pixels).
---@param message_width number The width of the message text (in pixels).
---@param message_height number The height of the message text (in pixels).
---@param padding number The amount of padding to be used to separate the modal borders and inner contents.
---
---@private
---
---@return integer
---@return integer
local function calculate_modal_size(header_width, header_height, message_width, message_height, padding)
    -- Calculate the dimensions of the modal.
    local modal_width = math.floor(padding + message_width + padding)
    local modal_height = math.floor(padding + header_height + (padding / 2) + message_height + padding)

    -- Check if the width of the header is larger than the width of the message.
    if header_width > message_width then
        -- If yes, then recalculate the box width using the header width instead.
        modal_width = math.floor(padding + header_width + padding)
    end

    -- Return the tuple of the modal width and height values.
    return modal_width, modal_height
end

---
--- Calculates the size of the modal using the provided text contents and fonts.
---
---@param header_text string The header text to display in the modal.
---@param message_text string The message text to display in the modal.
---@param header_font userdata The font to use when drawing the header text.
---@param message_font userdata The font to use when drawing the message text.
---@param padding number The amount of padding to be used to separate the modal borders and inner contents.
---
---@private
---
---@return integer
---@return integer
local function calculate_modal_size_from_text(header_text, message_text, header_font, message_font, padding)
    -- Measure the width and height of the provided header and message text strings.
    local header_width, header_height = header_font:measure(header_text)
    local message_width, message_height = message_font:measure(message_text)

    -- Return the result of the calculate modal size function that uses the header and message sizes.
    return calculate_modal_size(header_width, header_height, message_width, message_height, padding)
end

---
--- Draws a modal with a header and message body on the screen at the specified position. The size of the modal is determined automatically based on the size of the header and message text.
---
--- *NOTE*: The height returned from `font:measure(text)` is NOT accurate, and will make the measurements be off.
---
---@param header_text string The header text to display in the modal.
---@param message_text string The message text to display in the modal.
---@param header_font userdata The font to use when drawing the header text.
---@param message_font userdata The font to use when drawing the message text.
---@param x number The horizontal position on the screen.
---@param y number The vertical position on the screen.
---@param padding number The amount of padding to be used to separate the modal borders and inner contents.
---@param modal_background_color? number [OPTIONAL] The color (in ARGB form) to use for the background of the modal. Defaults to [0x00000000](https://www.colorhexa.com/000000).
---@param header_text_color? number [OPTIONAL] The color (in ARGB form) to use for the header text inside the modal. Defaults to [0xFFFFFFFF](https://www.colorhexa.com/FFFFFF).
---@param message_text_color? number [OPTIONAL] The color (in ARGB form) to use for the message text inside the modal. Defaults to [0xFFFFFFFF](https://www.colorhexa.com/FFFFFF).
---@param add_outline? boolean [OPTIONAL] The flag used to determine if an outline should be drawn around the modal. Defaults to false.
---@param outline_thickness? number [OPTIONAL] The size (in pixels) of how thick the outline should be. Defaults to 5.
---@param outline_color? number [OPTIONAL] The color (in ARGB form) to use for the outline. Defaults to [0xFFFFFFFF](https://www.colorhexa.com/FFFFFF).
function d2d.modal(header_text, message_text, header_font, message_font, x, y, padding, modal_background_color, header_text_color, message_text_color, add_outline, outline_thickness, outline_color)
    -- Set defaults for the optional parameters that didn't have a value provided.
    modal_background_color = modal_background_color or 0x00000000
    header_text_color = header_text_color or 0xFFFFFFFF
    message_text_color = message_text_color or 0xFFFFFFFF
    if add_outline == nil then
        add_outline = false
    end
    outline_thickness = outline_thickness or 5
    outline_color = outline_color or 0xFFFFFFFF
    
    -- Assert the provided values are valid.
    assert(header_text ~= nil, "The provided 'header_text' must not an nil.")
    assert(header_text ~= "", "The provided 'header_text' must not be an empty string.")
    assert(message_text ~= nil, "The provided 'message_text' must not an nil.")
    assert(message_text ~= "", "The provided 'message_text' must not be an empty string.")
    assert(header_font ~= nil, "The provided 'header_font' must not an nil.")
    assert(message_font ~= nil, "The provided 'message_font' must not an nil.")
    assert(padding > 0, "The provided 'padding' cannot be negative.")
    assert(modal_background_color >= 0x00000000 and modal_background_color <= 0xFFFFFFFF,
        "The provided 'modal_background_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")
    assert(header_text_color >= 0x00000000 and header_text_color <= 0xFFFFFFFF,
        "The provided 'header_text_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")
    assert(message_text_color >= 0x00000000 and message_text_color <= 0xFFFFFFFF,
        "The provided 'message_text_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")
    assert(outline_thickness > 0, "The provided 'outline_thickness' cannot be negative.")
    assert(outline_color >= 0x00000000 and outline_color <= 0xFFFFFFFF,
        "The provided 'outline_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")

    -- Measure the width and heights of the provided header and message text strings.
    local header_width, header_height = header_font:measure(header_text)
    local message_width, message_height = message_font:measure(message_text)

    -- Calculate the width and height of the modal.
    local modal_width, modal_height = calculate_modal_size(header_width, header_height,
        message_width, message_height, padding)

    -- Calculate the x offset for the header text to ensure it sits in the middle of the modal.
    local header_x_offset = math.floor((message_width - header_width) / 2) + padding
    local message_x_offset = padding

    -- Check if the width of the header is larger than the width of the message.
    if header_width > message_width then
        -- If yes, then recalculate the header and message x offsets.
        header_x_offset = padding
        message_x_offset = math.floor((header_width - message_width) / 2) + padding
    end

    -- Draw the box with outline to the screen.
    d2d.fill_rect(x, y, modal_width, modal_height, modal_background_color)

    -- Check if the provided add outline flag is true.
    if add_outline then
        -- If yes, then draw an outline box to the screen.
        d2d.outline_rect(x, y, modal_width, modal_height, outline_thickness, outline_color)
    end

    -- Draw the header text into the modal.
    d2d.text(header_font, header_text, x + header_x_offset,
        y + padding - 5, header_text_color)

    -- Calculate half of the padding to separate the header and message vertically.
    local padding_half = math.floor(padding / 2)

    -- Draw the message text into the modal.
    d2d.text(message_font, message_text, x + message_x_offset,
        y + padding + header_height + padding_half, message_text_color)
end

---
--- Calculates the coordinates (x and y) to use when drawing a modal for a given alignment (based on the `imgui.constants.alignment_option`).
--- Returns a tuple of `x`, `y`.
---
--- *NOTE*: The height returned from `font:measure(text)` is NOT accurate, and will make the measurements be off.
---
---@param alignment number The alignment option to calculate the coordinates for.
---@param screen_width number The width of the screen (in pixels) to draw on.
---@param screen_height number The height of the screen (in pixels) to draw on.
---@param header_text string The header text to display in the modal.
---@param message_text string The message text to display in the modal.
---@param header_font userdata The font to use when drawing the header text.
---@param message_font userdata The font to use when drawing the message text.
---@param padding number The amount of padding to be used to separate the modal borders and inner contents.
---@param x_offset? number [OPTIONAL] The offset to apply to the x position. Defaults to 0.
---@param y_offset? number [OPTIONAL] The offset to apply to the y position. Defaults to 0.
---
---@return integer
---@return integer
function d2d.calculate_modal_coordinates_for_alignment(alignment, screen_width, screen_height, header_text, message_text, header_font, message_font, padding, x_offset, y_offset)
    -- Set defaults for the optional parameters that didn't have a value provided.
    x_offset = x_offset or 0
    y_offset = y_offset or 0

    -- Assert the provided values are valid.
    assert(table.find_key(imgui.constants.alignment_option, alignment) ~= nil, "The provided 'alignment' is not a valid `alignment_option`.")
    assert(screen_width > 0, "The provided 'screen_width' cannot be negative.")
    assert(screen_height > 0, "The provided 'screen_height' cannot be negative.")
    assert(header_text ~= nil, "The provided 'header_text' must not an nil.")
    assert(header_text ~= "", "The provided 'header_text' must not be an empty string.")
    assert(message_text ~= nil, "The provided 'message_text' must not an nil.")
    assert(message_text ~= "", "The provided 'message_text' must not be an empty string.")
    assert(header_font ~= nil, "The provided 'header_font' must not an nil.")
    assert(message_font ~= nil, "The provided 'message_font' must not an nil.")
    assert(padding > 0, "The provided 'padding' cannot be negative.")

    -- Initialize the return values to their default values.
    local x, y = 0, 0

    -- Calculate the dimensions of the modal.
    local modal_width, modal_height = calculate_modal_size_from_text(header_text, message_text,
        header_font, message_font, padding)

    -- Check if the provided alignment is set as top left.
    if alignment == imgui.constants.alignment_option.top_left then
        -- If yes, then set the x and y values as 0.
        x = 0
        y = 0
    -- Else if, check if the provided alignment is set as top right.
    elseif alignment == imgui.constants.alignment_option.top_right then
        -- If yes, then set x as the difference between the provided screen width and calculated modal width, y as 0.
        x = screen_width - modal_width
        y = 0
    -- Else if, check if the provided alignment is set as middle.
    elseif alignment == imgui.constants.alignment_option.middle then
        -- If yes, then set the x and y values as the return values of the get centered origin function.
        x, y = math.get_centered_origin(screen_width, screen_height, modal_width, modal_height)
    -- Else if, check if the provided alignment is set as bottom left.
    elseif alignment == imgui.constants.alignment_option.bottom_left then
        -- If yes, then set x as 0 and y as the difference between the provided screen height and calculated modal height.
        x = 0
        y = screen_height - modal_height
    else -- Bottom Right
        -- Set the x and y as the difference between the provided screen size and modal size.
        x = screen_width - modal_width
        y = screen_height - modal_height
    end

    -- Calculate the x and y as their calculated value added with the provided position offset value.
    x = math.floor(x + x_offset)
    y = math.floor(y + y_offset)

    -- Return the tuple of the x and y position values.
    return x, y
end