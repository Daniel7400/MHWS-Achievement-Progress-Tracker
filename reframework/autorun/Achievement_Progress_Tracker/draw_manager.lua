-- IMPORTS
require("Achievement_Progress_Tracker.extensions.d2d_extensions")
local constants = require("Achievement_Progress_Tracker.constants")
local config_manager = require("Achievement_Progress_Tracker.config_manager")
local language_manager = require("Achievement_Progress_Tracker.language_manager")
-- END IMPORTS

--- The manager for all things related to drawing on the screen.
local draw_manager = {
    -- The font used by d2d to display the text.
    font = nil,

    -- The fonts used by d2d to display text.
    fonts = {
        -- The font used to display all text besides the description text.
        default = nil,

        -- The font used to display all text besides the description text, tiny size.
        tiny_default = nil,

        -- The font used to display the description text for achievement trackers.
        description = nil,

        -- The font used to display the header text in the congrats modal.
        congrats_header = nil,

        -- The font used to display the message text in the congrats modal.
        congrats_message = nil
    },

    -- The images for the achievements being tracked.
    images = {},

    -- The flags that influence what (if anything) gets drawn on the screen.
    flags = {
        -- The flag that determines if all achievement trackers are completed or not.
        all_completed = false,

        -- The flag that determines whether anything should be drawn on the screen or not.
        draw = false
    },

    -- The values used in the drawing process.
    values = {
        -- The value used to store the amount of achievement trackers to display.
        amount_to_display = 0,

        -- The value used to store the length of the longest text that will displayed.
        longest_text_width = 0,

        -- The value used to store the total combined horizontal width of all visibile trackers. Only relevant in horizontal rendering mode.
        horizontal_combined_width = 0
    }
}

-- Constants to be used throughout the draw manager.
local draw_constants <const> = {
    -- The size values used to determine the size and padding of the content to draw on screen. 
    size = {
        [constants.size_option.tiny] = {
            -- The width of the achievement image to display.
            image_width = 26,

            -- The height of the achievement image to display.
            image_height = 26,

            -- The height of the progress bar to display.
            progress_bar_height = 14,

            -- The padding to use between drawn elements.
            padding = 2,

            -- The minimum width for an achievement tracker.
            minimum_width = 0,

            -- The flag used to determine if the description of an achievement should be displayed on the tracker or not.
            include_description = false
        },
        [constants.size_option.small] = {
            -- The width of the achievement image to display.
            image_width = 32,

            -- The height of the achievement image to display.
            image_height = 32,

            -- The height of the progress bar to display.
            progress_bar_height = 18,

            -- The padding to use between drawn elements.
            padding = 3,

            -- The minimum width for an achievement tracker.
            minimum_width = 75,

            -- The flag used to determine if the description of an achievement should be displayed on the tracker or not.
            include_description = false
        },
        [constants.size_option.medium] = {
            -- The width of the achievement image to display.
            image_width = 48,

            -- The height of the achievement image to display.
            image_height = 48,

            -- The height of the progress bar to display.
            progress_bar_height = 20,

            -- The padding to use between drawn elements.
            padding = 6,

            -- The minimum width for an achievement tracker.
            minimum_width = 100,

            -- The flag used to determine if the description of an achievement should be displayed on the tracker or not.
            include_description = true
        },
        [constants.size_option.large] = {
            -- The width of the achievement image to display.
            image_width = 64,

            -- The height of the achievement image to display.
            image_height = 64,

            -- The height of the progress bar to display.
            progress_bar_height = 30,

            -- The padding to use between drawn elements.
            padding = 9,

            -- The minimum width for an achievement tracker.
            minimum_width = 100,

            -- The flag used to determine if the description of an achievement should be displayed on the tracker or not.
            include_description = true
        }
    }
}

---
--- Return the parameters that will be used in the drawing process based on the provided screen size and saved config values.
---
---@param screen_width number The width of the screen to draw on.
---@param screen_height number The height of the screen to draw on.
---
---@return number padding The padding to be used to separate all of the drawn elements.
---@return number x The x coordinate where the tracker window will be drawn.
---@return number y The y coordinate where the tracker window will be drawn.
---@return number background_width The width of the tracker window that will be drawn.
---@return number background_height The height of the tracker window that will be drawn.
---@return number tracker_width The width of the individual achievement trackers that will be drawn.
---@return number tracker_height The height of the individual achievement trackers that will be drawn.
---@return number progress_bar_height The height of the progress bar for an individual tracker that will be drawn.
---@return number image_width The width of the image for an individual tracker that will be drawn.
---@return number image_height The height of the image for an individual tracker that will be drawn.
---@return number image_plus_padding_width The combined with of the image width and padding afterwards. This will be 0 if the show images flag is false.
local function get_draw_params(screen_width, screen_height)
    -- Initialize the x and y position values.
    local x, y = 0, 0

    -- Set the image width, image height, progress bar height, and padding using the display size on the config.
    local image_width = draw_constants.size[config_manager.config.current.display.size].image_width
    local image_height = draw_constants.size[config_manager.config.current.display.size].image_height
    local progress_bar_height = draw_constants.size[config_manager.config.current.display.size].progress_bar_height
    local padding = draw_constants.size[config_manager.config.current.display.size].padding

    -- Initialize the width and height of the background box that will hold the achievement trackers.
    local background_width, background_height = 0, 0

    -- Calculate the width of the achievement image and the padding afterwards.
    local image_plus_padding_width = image_width + padding -- [[ Image Width + Inner Padding ]]

    -- Calculate the height of the achievement trackers using the set image height (regardless of if the image is shown or not).
    local tracker_height = padding + image_plus_padding_width --[[ Inner Padding + Image Width with Padding ]]

    -- Check if the show images flag on the config is NOT true (is false).
    if not config_manager.config.current.display.show_images then
        -- If yes, then set the image width and height both to 0.
        image_width, image_height = 0, 0

        -- Set the image plus padding width as 0 since no image will be displayed.
        image_plus_padding_width = 0
    end

    -- Calculate the width of the achievement trackers (not considering inner text content).
    local tracker_width = padding + --[[ Left Inner Padding ]]
        image_plus_padding_width + --[[ Image Width with Padding (if any) ]]
        padding --[[ Right Inner Padding ]]

    -- Check if the amount to display value on the draw manager is larger than 0.
    if draw_manager.values.amount_to_display > 0 then
        -- If yes, then check if the render horizontally flag on the config is true.
        if config_manager.config.current.display.render_horizontally then
            -- If yes, then calculate the width of all of the empty trackers with the padding between them.
            local total_empty_trackers_with_padding_width = ((tracker_width + padding) * draw_manager.values.amount_to_display) - padding
            -- ^ Subtract padding once since it will add padding after the last tracker as well.

            -- Calculate the width of the background (which will contain all trackers).
            background_width = padding + --[[ Outside Box Padding ]]
                draw_manager.values.horizontal_combined_width + --[[ Combined total horizontal width of all text the trackers will display ]]
                total_empty_trackers_with_padding_width + -- [[ Combined total width of all of the no content (empty) trackers with padding between them ]]
                padding --[[ Outside Box Padding ]]

            -- Calculate the height of background (which will contain all trackers).
            background_height = math.ceil(
                padding + --[[ Top Padding ]]
                (tracker_height + padding)) --[[ Tracker Height + Inbetween/Outer Bottom Padding ]]

        else -- Else, render the trackers vertically.
            -- Update the width of the achievement trackers using the longest text width.
            tracker_width = tracker_width + --[[ Tracker with no inner text content width ]]
                math.ceil(draw_manager.values.longest_text_width) --[[ Width of the longest text that needs to be displayed ]]

            -- Calculate the width of the background box that holds the achievement trackers.
            background_width = math.ceil(padding + --[[ Outside Box Padding ]]
                tracker_width + --[[ Tracker Width ]]
                padding) --[[ Outside Box Padding ]]

            -- Calculate the height of the background box that holds the achievement trackers.
            background_height = math.ceil(
                padding + --[[ Top Padding ]]
                (tracker_height + padding) --[[ Tracker Height + Inbetween/Outer Bottom Padding ]]
                * draw_manager.values.amount_to_display) -- ^ times the amount of trackers to display.
        end
    end

    -- Check if the alignment anchor on the config is set as top left.
    if config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.top_left then
        -- If yes, then set the x and y values as 0.
        x = 0
        y = 0

    -- Else if, check if the alignment anchor on the config is set as top right.
    elseif config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.top_right then
        -- If yes, then set x as the difference between the provided screen width and calculated background width, y as 0.
        x = screen_width - background_width
        y = 0

    -- Else if, check if the alignment anchor on the config is set as middle.
    elseif config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.middle then
        -- If yes, then set the x and y values as the return values of the get centered origin function.
        x, y = math.get_centered_origin(screen_width, screen_height, math.min(background_width, screen_width), math.min(background_height, screen_height))
        -- ^ Use a math.min on the background width & height because in certain sizes it would be off of the screen.

    -- Else if, check if the alignment anchor on the config is set as bottom left.
    elseif config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.bottom_left then
        -- If yes, then set x as 0 and y as the difference between the provided screen height and calculated background height.
        x = 0
        y = screen_height - background_height

    else -- Bottom Right
        -- Set the x and y as the difference between the provided screen size and background size.
        x = screen_width - background_width
        y = screen_height - background_height
    end

    -- Calculate the x and y as their calculated value added with the position adjust value set on the config.
    x = math.ceil(x + config_manager.config.current.display.x_position_adjust)
    y = math.ceil(y + config_manager.config.current.display.y_position_adjust)

    -- Return the values.
    return padding, x, y, background_width, background_height, tracker_width, tracker_height, progress_bar_height,
        image_width, image_height, image_plus_padding_width
end

---
--- Initializes the draw manager module.
---
function draw_manager.init_module()
    -- Load the tracking manager (loaded here to avoid cyclic dependency).
    local tracking_manager = require("Achievement_Progress_Tracker.tracking_manager")

    d2d.register(function()
        -- Set the fonts to use.
        draw_manager.fonts.default = d2d.Font.new("Noto Sans", 13, true)
        draw_manager.fonts.tiny_default = d2d.Font.new("Noto Sans", 10, true)
        draw_manager.fonts.description = d2d.Font.new("Noto Sans", 12)
        draw_manager.fonts.congrats_header = d2d.Font.new("Noto Sans", 20, true)
        draw_manager.fonts.congrats_message = d2d.Font.new("Noto Sans", 16)

        -- Check if the display size on the config is set as tiny.
        if config_manager.config.current.display.size == constants.size_option.tiny then
            -- If yes, then set the font the draw manager will use by default as the tiny default one.
            draw_manager.font = draw_manager.fonts.tiny_default
        else
            -- Set the font on the draw manager will use by default as the default one.
            draw_manager.font = draw_manager.fonts.default
        end

        -- Iterate over each achievement tracker,
        for _, achievement_tracker in ipairs(tracking_manager.achievements) do
            -- Build the path to the achievement image for the current achievement tracker.
            local full_image_path = string.format("%s/%s", constants.directory_path, achievement_tracker.image_path)

            -- Load the image and store it in the images table using the image path as the key.
            draw_manager.images[achievement_tracker.image_path] = d2d.Image.new(full_image_path)
        end
    end,
    function()
        -- Check if the draw flag is set as true, otherwise do NOT draw anything on the screen.
        if draw_manager.flags.draw then
            -- Get the width and height of the screen.
            local screen_w, screen_h = d2d.surface_size()

            -- Check if the all completed is set as true.
            if draw_manager.flags.all_completed then
                -- If yes, then get the header and message text.
                local header_text = string.format("🎉 %s 🎉", language_manager.language.current.modal.header)
                local message_text = language_manager.language.current.modal.message
                local padding = 10

                -- Get the x and y coordinate for the modal for the header and message text using the alignment stored in the config.
                local x, y = d2d.calculate_modal_coordinates_for_alignment(
                    config_manager.config.current.display.alignment_anchor,
                    screen_w, screen_h,
                    header_text, message_text,
                    draw_manager.fonts.congrats_header,
                    draw_manager.fonts.congrats_message,
                    padding,
                    config_manager.config.current.display.x_position_adjust,
                    config_manager.config.current.display.y_position_adjust)

                -- Draw the completed modal.
                d2d.modal(header_text, message_text,
                    draw_manager.fonts.congrats_header,
                    draw_manager.fonts.congrats_message,
                    x,
                    y,
                    padding,
                    config_manager.config.current.display.color.box_background,
                    config_manager.config.current.display.color.tracker_name_text,
                    config_manager.config.current.display.color.tracker_description_text)
            else
                -- Use the screen width and height to get the draw params to use for drawing on the screen.
                local padding,
                    x, y,
                    background_width, background_height,
                    tracker_width, tracker_height,
                    progress_bar_height,
                    image_width, image_height,
                    image_plus_padding_width = get_draw_params(screen_w, screen_h)

                -- Draw the background box to the screen.
                d2d.fill_rect(x, y, background_width, background_height,
                    config_manager.config.current.display.color.box_background)

                -- Create a number to track the current number of the achievement tracker being displayed.
                local display_number = 1

                -- Create a number to track the current total combined width of all visible achievement trackers.
                -- Only relevant in horizontal rendering mode.
                local current_combined_width = 0

                -- Iterate over each achievement tracker.
                for _, achievement_tracker in ipairs(tracking_manager.achievements) do
                    -- Check if the current achievement tracker should be displayed.
                    if achievement_tracker:should_display() then
                        -- Calculate the local x and y for the current achievement tracker.
                        local local_x = x + padding
                        local local_y = y + padding + (tracker_height + padding) * (display_number - 1)

                        -- Set the progress bar width as the longest text width stored on the draw manager.
                        local progress_bar_width = math.ceil(draw_manager.values.longest_text_width)

                        -- Check if the render horizontally flag on the config is true.
                        if config_manager.config.current.display.render_horizontally then
                            -- If yes, then recalculate the tracker width using its internal content display width.
                            tracker_width = math.ceil(
                                padding + image_plus_padding_width + --[[ Inner Padding + Image Width with Padding (if any) ]]
                                math.ceil(achievement_tracker.content_display_width) + --[[ Width of the content to be displayed ]]
                                padding) --[[ Inner Padding ]]

                            -- Recalculate the local x and y to account for horizontal rendering mode.
                            local_x = local_x + (current_combined_width)
                            local_y = y + padding

                            -- Increase the current total combined width by the newly calculated tracker width.
                            current_combined_width = current_combined_width + tracker_width + padding

                            -- Set the progress bar width as the content display width for the current achievement tracker.
                            progress_bar_width = math.ceil(achievement_tracker.content_display_width)
                        end

                        -- Draw the achievement tracker background.
                        d2d.fill_rect(local_x, local_y,
                            tracker_width, tracker_height,
                            config_manager.config.current.display.color.tracker_background)

                        -- Calculate the x offset to use when displaying content in the tracker.
                        local x_offest = padding

                        -- Check if the show images flag on the config is true.
                        if config_manager.config.current.display.show_images then
                            -- If yes, then draw the achievement image.
                            d2d.image(draw_manager.images[achievement_tracker.image_path],
                                local_x + padding,
                                local_y + padding,
                                image_width, image_height)

                            -- Update the x offset to account for the displayed image.
                            x_offest = x_offest + image_plus_padding_width
                        end

                        -- Initialize the x offset to center align the achievement name text. Defaults to 0, no offset or alignment changes.
                        local name_x_center_align_offset = 0

                        -- Check if the center align text flag on the config is true.
                        if config_manager.config.current.display.center_align_text then
                            -- If yes, then get the width of the current achievement name text.
                            local name_text_width, _ = draw_manager.font:measure(achievement_tracker.name)

                            -- Update the name x center align offset to the centered origin of the progress bar width and name text width.
                            name_x_center_align_offset, _ = math.get_centered_origin(progress_bar_width, 1,
                                math.ceil(name_text_width), 1)
                        end

                        -- Draw the name of the current achievement using the default font.
                        d2d.text(draw_manager.font, achievement_tracker.name,
                            local_x + x_offest + name_x_center_align_offset,
                            local_y + padding - 2,
                            config_manager.config.current.display.color.tracker_name_text)

                        -- Check if the include description flag for the current size is true.
                        if draw_constants.size[config_manager.config.current.display.size].include_description then
                            -- If yes, then set the description text y padding.
                            local description_text_y_padding = padding + padding

                            -- Check if the display size on the config is set as medium.
                            if config_manager.config.current.display.size == constants.size_option.medium then
                                -- If yes, then add 2 to the description text y padding.
                                description_text_y_padding = description_text_y_padding + 2
                            end

                            -- Initialize the x offset to center align the achievement description text. Defaults to 0, no offset or alignment changes.
                            local description_x_center_align_offset = 0

                            -- Check if the center align text flag on the config is true.
                            if config_manager.config.current.display.center_align_text then
                                -- If yes, then get the width of the current achievement description text.
                                local description_text_width, _ = draw_manager.fonts.description:measure(achievement_tracker.description)

                                -- Update the name x center align offset to the centered origin of the progress bar width and description text width.
                                description_x_center_align_offset, _ = math.get_centered_origin(progress_bar_width, 1,
                                    math.ceil(description_text_width), 1)
                            end

                            -- Draw the description text of the current achievement using the description font.
                            d2d.text(draw_manager.fonts.description, achievement_tracker.description,
                                local_x + x_offest + description_x_center_align_offset,
                                local_y + padding - 2 + description_text_y_padding,
                                config_manager.config.current.display.color.tracker_description_text)
                        end

                        -- Draw the progress bar of the current achievement tracker.
                        d2d.progress_bar(achievement_tracker.current, achievement_tracker.amount,
                            draw_manager.font,
                            local_x + x_offest,
                            local_y + tracker_height - padding - progress_bar_height,
                            progress_bar_width, progress_bar_height,
                            language_manager.language.current.tracker.completed,
                            config_manager.config.current.display.color.progress_bar_background,
                            config_manager.config.current.display.color.progress_bar,
                            config_manager.config.current.display.color.progress_bar_complete,
                            config_manager.config.current.display.color.progress_text,
                            config_manager.config.current.display.color.progress_complete_text,
                            config_manager.config.current.display.display_progress_as_percentage
                        )

                        -- Increment the display number since a new achievement tracker was drawn.
                        display_number = display_number + 1
                    end
                end
            end
        end
    end)
end

---
--- Reset the amount to display, longest text width, and horizontal combined width values back to the default value.
---
function draw_manager.reset_values()
    -- Reset all of the draw manager values to their default values.
    draw_manager.values.amount_to_display = 0
    draw_manager.values.longest_text_width = 0
    draw_manager.values.horizontal_combined_width = 0

    -- Check if the display size on the config is set as tiny.
    if config_manager.config.current.display.size == constants.size_option.tiny then
        -- If yes, then set the font the draw manager will use by default as the tiny default one.
        draw_manager.font = draw_manager.fonts.tiny_default
    else
        -- Set the font on the draw manager will use by default as the default one.
        draw_manager.font = draw_manager.fonts.default
    end
end

---
--- Update the values stored on the draw manager (amount to display and longest text width) using the provided the provided achievement data.
---
---@param achievement_tracker achievementtracker The achievement tracker to update the draw values for.
function draw_manager.update_values(achievement_tracker)
    -- Increment the amount to display by 1.
    draw_manager.values.amount_to_display = draw_manager.values.amount_to_display + 1

    -- Get the width of the name of the provided achievement tracker.
    local name_text_width, _ = draw_manager.font:measure(achievement_tracker.name)

    -- Set the progress bar text as the completed text.
    local progress_bar_text = language_manager.language.current.tracker.completed

    -- Check if the provided achievement is NOT marked as complete.
    if not achievement_tracker:is_complete() then
        -- If yes, then check if the display progress as percentage flag on the config is true.
        if config_manager.config.current.display.display_progress_as_percentage then
            -- If yes, then set the progress bar text as the percentage value.
            progress_bar_text = string.format("%.2f%%", (achievement_tracker.current / achievement_tracker.amount) * 100)
        else
            -- Build the text that will display in the progress bar.
            progress_bar_text = string.format("%i / %i", achievement_tracker.current, achievement_tracker.amount)
        end
    end

    -- Get the width of the progres bar text generated for the provided achievement tracker.
    local progress_bar_text_width, _ = draw_manager.font:measure(progress_bar_text)

    -- Initialize the description text width as 0 since its only relevant if the display size is NOT small.
    local description_text_width = 0

    -- Check if the include description flag for the current size is true.
    if draw_constants.size[config_manager.config.current.display.size].include_description then
        -- If yes, then get the width of the provided achievement description.
        description_text_width, _ = draw_manager.fonts.description:measure(achievement_tracker.description)
    end

    -- Find the longest width as the max between the various calculated widths and minimum width for the current size.
    local longest_text_width = math.max(name_text_width, progress_bar_text_width, description_text_width,
        draw_constants.size[config_manager.config.current.display.size].minimum_width)

    -- Check if the longest text width is the text width for the progress bar text.
    if longest_text_width == progress_bar_text_width then
        -- If yes, then add the padding that matches the size selected on the config twice (to account for padding on both sides).
        longest_text_width = math.ceil(longest_text_width + (2 * draw_constants.size[config_manager.config.current.display.size].padding))
    end

    -- Set the content display length for the provided achievement tracker as the longest text width.
    achievement_tracker.content_display_width = longest_text_width

    -- Increase the horizontal combined width stored on the draw manager by the calculated content display width for the current achievement tracker.
    draw_manager.values.horizontal_combined_width = math.ceil(draw_manager.values.horizontal_combined_width + achievement_tracker.content_display_width)

    -- Check if the content display with is greater than the stored longest text width.
    if achievement_tracker.content_display_width > draw_manager.values.longest_text_width then
        -- If yes, then update the longest text width to the calculated description text width.
        draw_manager.values.longest_text_width = achievement_tracker.content_display_width
    end
end

---
--- Reset the draw manager flag back to the default value.
---
function draw_manager.reset()
    -- Reset the draw flag to the default value.
    draw_manager.flags.draw = false
end

return draw_manager