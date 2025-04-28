--- Constants used within `imgui` functions.
imgui.constants = {
    --- The constants that define the options for the alignment selector.
    alignment_option = {
        --- The top left alignment option.
        top_left = 1,

        --- The top right alignment option.
        top_right = 2,
        
        --- The middle alignment option.
        middle = 3,

        --- The bottom left alignment option.
        bottom_left = 4,

        --- The bottom right alignment option.
        bottom_right = 5
    }
}

---
--- Draws a help icon that displays a tooltip when hovered.
---
---@param text string The text to display as the on-hover tooltip.
---@param same_line? boolean [OPTIONAL] The flag used to determine if the help icon should be drawn on the same line as the previous element. Defaults to true.
---@param color? number [OPTIONAL] The color (in ARGB form) to use for the help icon. Defaults to [0xF00FFFFF](https://www.colorhexa.com/00FFFF).
function imgui.help_tooltip(text, same_line, color)
    -- Set defaults for the optional parameters that didn't have a value provided.
    color = color or 0xF00FFFFF
    if same_line == nil then
        same_line = true
    end
    
    -- Check if the provided same line flag is true.
    if same_line then
        -- If yes, then call the same line function under imgui to make it be in-line with the previous element.
        imgui.same_line()
    end

    -- Draws the ? with the unicode combining enclosing circle (https://symbl.cc/en/20DD) with the provided color converted to ABGR.
    imgui.text_colored("? \xe2\x83\x9d", math.argb_to_abgr(color))

    -- Check if the newly drawn text is being hovered over (since that is when we want to display the tooltip).
    if imgui.is_item_hovered() then
        -- If yes, then set the tooltip text and display it while the item stays hovered.
        imgui.set_tooltip(text)
        imgui.begin_tooltip()
        imgui.end_tooltip()
    end
end

---
--- Draws a 3x3 table to select an alignment for something to be displayed on-screen, with the selected option having an asterisk next to it.
--- Returns a tuple of `changed`, `value`.
---
---@param selected_alignment number The already selected alignment option.
---@param label_text? string [OPTIONAL] The text to display above the alignment selector table. Defaults to "Alignment".
---@param top_left_text? string [OPTIONAL] The text to display in the top left button. Defaults to "Top Left".
---@param top_right_text? string [OPTIONAL] The text to display in the top right button. Defaults to "Top Right".
---@param middle_text? string [OPTIONAL] The text to display in the middle button. Defaults to "Middle".
---@param bottom_left_text? string [OPTIONAL] The text to display in the bottom left button. Defaults to "Bottom Left".
---@param bottom_right_text? string [OPTIONAL] The text to display in the bottom right button. Defaults to "Bottom Right".
---@param append_new_line? boolean [OPTIONAL] The flag used to determine if a new line should be appended after drawing this element. Defaults to false.
---
---@return boolean changed The boolean that represents whether any values were changed.
---@return number selected_alignment The number that represents the enum value for the selected alignment.
function imgui.alignment_selector(selected_alignment, label_text, top_left_text, top_right_text, middle_text, bottom_left_text, bottom_right_text, append_new_line)
    -- Assert the provided selected assignment is valid.
    assert(table.find_key(imgui.constants.alignment_option, selected_alignment),
        "The provided 'selected_alignment' is not a valid alignment option.")

    -- Set defaults for the optional parameters that didn't have a value provided.
    label_text = label_text or "Alignment"
    top_left_text = top_left_text or "Top Left"
    top_right_text = top_right_text or "Top Right"
    middle_text = middle_text or "Middle"
    bottom_left_text = bottom_left_text or "Bottom Left"
    bottom_right_text = bottom_right_text or "Bottom Right"
    if append_new_line == nil then
        append_new_line = false
    end

    -- Initialize the return values. Changed as false by default and alignment as the provided selected alignment.
    local changed = false
    local alignment = selected_alignment

    -- Store the data for each alignment option so they can be iterated over and build the table.
    local alignment_options = {
        {
            text = top_left_text,
            value = imgui.constants.alignment_option.top_left,
            is_selected = selected_alignment == imgui.constants.alignment_option.top_left,
            table_funcs = { imgui.table_next_column, imgui.table_next_column }
        },
        {
            text = top_right_text,
            value = imgui.constants.alignment_option.top_right,
            is_selected = selected_alignment == imgui.constants.alignment_option.top_right,
            table_funcs = { imgui.table_next_row, imgui.table_next_column, imgui.table_next_column }
        },
        {
            text = middle_text,
            value = imgui.constants.alignment_option.middle,
            is_selected = selected_alignment == imgui.constants.alignment_option.middle,
            table_funcs = { imgui.table_next_column, imgui.table_next_row, imgui.table_next_column }
        },
        {
            text = bottom_left_text,
            value = imgui.constants.alignment_option.bottom_left,
            is_selected = selected_alignment == imgui.constants.alignment_option.bottom_left,
            table_funcs = { imgui.table_next_column, imgui.table_next_column }
        },
        {
            text = bottom_right_text,
            value = imgui.constants.alignment_option.bottom_right,
            is_selected = selected_alignment == imgui.constants.alignment_option.bottom_right,
            table_funcs = {}
        }
    }

    -- Draw the label text to display above the table.
    imgui.text(label_text)

    -- Draw the table.
    if imgui.begin_table("Alignment", 3,  1 << 7  --[[ Draw horizontal borders between rows ]]
                                        | 1 << 8  --[[ Draw horizontal borders at the top and bottom ]]
                                        | 1 << 9  --[[ Draw vertical borders between columns ]]
                                        | 1 << 10 --[[ Draw vertical borders on the left and right sides ]]
                                        | 1 << 13 --[[ Column size is fixed to fit the contents ]]
                                        | 1 << 16 --[[ Auto fit columns and don't resize ]]
                                    ) then
        imgui.table_next_row()
        imgui.table_next_column()

        -- Iterate over each alignment option to build the table cell for it.
        for _, alignment_option in ipairs(alignment_options) do
            -- Check if the current alignment option is selected.
            if alignment_option.is_selected then
                -- If yes, then display an asterisk to denote this is the selected option.
                imgui.text("*")
                imgui.same_line()
            end

            -- Draw the button for the current alignment option, then enter the if when the button is pressed AND the
            -- option isn't already selected.
            if imgui.button(alignment_option.text) and not alignment_option.is_selected then
                -- Update the alignment to the value of the current alignment option and mark the changed flag as true.
                alignment = alignment_option.value
                changed = true
            end

            -- Iterate over reach table function (if any).
            for _, table_func in ipairs(alignment_option.table_funcs) do
                -- Run the table functions on the current alignment option build the table and get to the table cell for
                -- the next alignment option.
                table_func()
            end
        end

        imgui.end_table()
    end

    -- Check if the provided append new line flag is true.
    if append_new_line then
        -- If yes, append a new line to the ui after this element is drawn.
        imgui.new_line()
    end

    -- Return the tuple of the changed flag and alignment value.
    return changed, alignment
end

---
--- Draws a pair of integer sliders for adjusting the x and y position of something to be displayed on-screen.
--- Returns a tuple of `changed`, `x_position`, `y_position`.
---
---@param current_x number The current x value.
---@param current_y number The current y value.
---@param min_x number The minimum allowed value for the x position.
---@param max_x number The maximum allowed value for the x position.
---@param min_y number The minimum allowed value for the y position.
---@param max_y number The maximum allowed value for the y position.
---@param label_text? string [OPTIONAL] The text to display above the xy position sliders. Defaults to "Position".
---@param tooltip_text? string [OPTIONAL] The text to display as the on-hover tooltip about being able to manually edit the slider. Defaults to "CTRL + Left Click to input manually".
---@param append_new_line? boolean [OPTIONAL] The flag used to determine if a new line should be appended after drawing this element. Defaults to false.
---
---@return boolean changed The boolean that represents whether any values were changed.
---@return number x_position The number that represents the x position of the slider.
---@return number y_position The number that represents the y position of the slider.
function imgui.xy_position_sliders(current_x, current_y, min_x, max_x, min_y, max_y, label_text, tooltip_text, append_new_line)
    -- Assert the provided min and max x, y values are valid.
    assert(max_x >= min_x, "The provided 'max_x' must greater than or equal to the provided 'min_x'.")
    assert(max_y >= min_y, "The provided 'max_y' must greater than or equal to the provided 'min_y'.")

    -- Set defaults for the optional parameters that didn't have a value provided.
    label_text = label_text or "Position"
    tooltip_text = tooltip_text or "CTRL + Left Click to input manually"
    if append_new_line == nil then
        append_new_line = false
    end

    -- Initialize the x changed and y changed values as false.
    local x_changed, y_changed = false, false

    -- Initialize the x and y position return values as the provided current x and y values.
    local x = current_x
    local y = current_y

    -- Draw the label text to display above the position sliders.
    imgui.text(label_text)

    -- Display the 'X' to denote the slider being for the x position and make sure it ends up on the same line as the slider.
    imgui.text("X")
    imgui.same_line()

    -- Create the slider that is used to adjust the x position value.
    x_changed, x = imgui.slider_int("\xe2\x80\x82", current_x, min_x, max_x)
    -- ^ I prefer the 'X' on the left side and since duplicate labels tie the fields to together I use an EN SPACE to not conflict with any other labels and still not being visible.

    -- Check if the user is hovering over the X position slider and is NOT interacting with it.
    if imgui.is_item_hovered() and not imgui.is_item_active() then
        -- If yes, then create a tooltip that will display to inform the user of a way to input a value manually (with a keyboard).
        imgui.set_tooltip(tooltip_text)
        imgui.begin_tooltip()
        imgui.end_tooltip()
    end
    
    -- Create a slider that the user can use to adjust the Y position of the notification.
    -- Display the 'Y' to denote the slider being for the y position and make sure it ends up on the same line as the slider.
    imgui.text("Y")
    imgui.same_line()

    -- Create the slider that is used to adjust the y position value.
    y_changed, y = imgui.slider_int("\xe2\x80\x83", current_y, min_y, max_y)
    -- ^ I prefer the 'Y' on the left side and since duplicate labels tie the fields to together I use an EM SPACE to not conflict with any other labels and still not being visible.

    -- Check if the user is hovering over the Y position slider and is NOT interacting with it.
    if imgui.is_item_hovered() and not imgui.is_item_active() then
        -- If yes, then create a tooltip that will display to inform the user of a way to input a value manually (with a keyboard).
        imgui.set_tooltip(tooltip_text)
        imgui.begin_tooltip()
        imgui.end_tooltip()
    end

    -- Check if the provided append new line flag is true.
    if append_new_line then
        -- If yes, append a new line to the ui after this element is drawn.
        imgui.new_line()
    end

    -- Initialize the changed return value, as the or between the x changed and y changed flags.
    local changed = x_changed or y_changed

    -- Fix the x and y value by clamping between the provided min and max, then taking the floor to ensure only whole numbers.
    x = math.ceil(math.clamp(x, min_x, max_x))
    y = math.ceil(math.clamp(y, min_y, max_y))

    -- Check if either the x or y value is different compared to the provided current x and y values.
    if x ~= current_x or y ~= current_y then
        -- If yes, then mark the changed flag as true.
        changed = true
    end

    -- Return the tuple of the changed flag, x value, and y value.
    return changed, x, y
end

---
--- Draws a ARGB color picker with the label displayed above the color picker.
--- Returns a tuple of `changed`, `color`, `counter`.
---
---@param selected_color number The already selected ARGB color value.
---@param label_text string The text to display above the color picker.
---@param counter number The counter used to track how many top label color picker argb elements have been created in the same section. This is incremented internally and returned to be passed into the next.
---@param current_preview_text? string [OPTIONAL] The text to display above the preview window. Defaults to "Current".
---@param flags? number [OPTIONAL] The flags used to configure a color picker, see [ImGuiColorEditFlags](https://github.com/praydog/REFramework/blob/b6309842527a5f143063213c7d39f5791f58a8f7/dependencies/imguizmo/example/imgui.h#L1536). Defaults to 0.
---@param append_new_line? boolean [OPTIONAL] The flag used to determine if a new line should be appended after drawing this element. Defaults to false.
---
---@return boolean changed The boolean that represents whether any values were changed.
---@return number color The number that represents the argb color value.
---@return number counter The number that represents the number of color pickers that have been created, including this one.
function imgui.color_picker_argb_top_label(selected_color, label_text, counter, current_preview_text, flags, append_new_line)
    -- Assert the provided selected color and counter values are valid.
    assert(selected_color >= 0x00000000 and selected_color <= 0xFFFFFFFF,
        "The provided 'selected_color' but be a valid 32-bit number between 0x00000000 (0) and 0xFFFFFFFF (4294967295).")
    assert(counter >= 0, "The provided 'counter' cannot be less than 0.")

    -- Set defaults for the optional parameters that didn't have a value provided.
    current_preview_text = current_preview_text or "Current"
    if not flags or flags < 0 then
        flags = 0
    end
    if append_new_line == nil then
        append_new_line = false
    end

    -- Check if the provided counter is greater than 0.
    if counter > 0 then
        -- If yes, then append that many number of spaces to the provided current preview text. This is done
        -- because the current preview text is actually treated as the label internally in imgui, so to properly translate
        -- and use the provided current preview text spaces must be appended afterwards to make them all unique. Otherwise
        -- the fields are tied together, such that if one changes the others will also change.
        current_preview_text = string.format("%s%s", current_preview_text, string.rep(" ", counter))
    end

    -- Increment the counter by 1.
    counter = counter + 1

    -- Draw the label text for the color picker field.
    imgui.text(label_text)

    -- Draw the actual color picker and capture the changed flag and color value.
    local changed, color = imgui.color_picker_argb(current_preview_text, selected_color, flags)

    -- Check if the provided append new line flag is true.
    if append_new_line then
        -- If yes, append a new line to the ui after this element is drawn.
        imgui.new_line()
    end
    
    -- Return the tuple of the changed flag, color value, and counter value.
    return changed, color, counter
end

---
--- Draws a combo box to allow for the selection and ability to switch between different language options.
--- Returns a tuple of `changed`, `language_index`.
---
---@param selected_language string The already selected language option.
---@param languages table The table array that contains all of the language options.
---
---@return boolean changed The boolean that represents whether any values were changed.
---@return number selected_language The number that represents the id/index of the selected language.
function imgui.language_picker(selected_language, languages)
    -- Assert the provided selected language and languages table are valid.
    assert(selected_language ~= nil, "The provided 'selected_language' must not an nil.")
    assert(selected_language ~= "", "The provided 'selected_language' must not be an empty string.")
    assert(languages ~= nil, "The provided 'languages' table must not an nil.")
    assert(not table.is_empty(languages), "The provided 'languages' table must not be empty.")
    assert(table.is_array(languages), "The provided 'languages' table must be an array (a sequential list of elements starting from index 1).")

    -- Create a combo box (with no label) using the provided selected language and languages array.
    local changed, language_index = imgui.combo(" ", table.find_key(languages, selected_language), languages)

    -- Return the tuple of the changed flag and language index.
    return changed, language_index
end