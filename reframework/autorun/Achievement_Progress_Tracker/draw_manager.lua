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
    },
}

-- The minimum width for an achievement tracker.
local minimum_width <const> = 120

---
--- Return the parameters that will be used in the drawing process based on the provided screen size and saved config values.
---
---@param screen_width integer The width of the screen to draw on.
---@param screen_height integer The height of the screen to draw on.
---
---@return integer x The x coordinate where the tracker window will be drawn.
---@return integer y The y coordinate where the tracker window will be drawn.
---@return integer tracker_width The width of the tracker window that will be drawn.
---@return integer tracker_height The height of the tracker window that will be drawn.
---@return integer image_width The width of the image for an individual tracker that will be drawn.
---@return integer image_height The height of the image for an individual tracker that will be drawn.
---@return integer progress_bar_height The height of the progress bar for an individual tracker that will be drawn.
---@return integer padding The padding to be used to separate all of the drawn elements.
local function get_draw_params(screen_width, screen_height)
    -- Initialize the return values to their default (small display size) values.
    local x, y = 0, 0
    local image_width, image_height = 32, 32
    local progress_bar_height = 18
    local padding = 3

    -- Check if the display size on the config is set as large.
    if config_manager.config.current.display.size == constants.size_option.large then
        -- If yes, then set the image width, image height, progress bar height, and padding to their large values.
        image_width, image_height = 64, 64
        progress_bar_height = 30
        padding = 9
    -- Else if, check if the display size on the config is set as medium.
    elseif config_manager.config.current.display.size == constants.size_option.medium then
        -- If yes, then set the image width, image height, progress bar height, and padding to their medium values.
        image_width, image_height = 48, 48
        progress_bar_height = 20
        padding = 6
    end

    -- Initialize the height and width of the trackers box.
    local tracker_height, tracker_width = 0, 0

    -- Check if the render horizontally flag on the config is true.
    if config_manager.config.current.display.render_horizontally then
        -- Calculate the height of the achievement tracker.
        tracker_width = math.floor(draw_manager.values.horizontal_combined_width) + --[[ Combined total horizontal width of all trackers to display ]]
            math.floor(padding + --[[ Outside Box Padding ]]
            padding + image_width + padding + --[[ Inner Padding + Image Width + Inner Padding ]]
            padding + --[[ Inner Padding ]]
            padding) --[[ Outside Box Padding ]]
            * draw_manager.values.amount_to_display -- ^ times the amount of trackers to display.

        -- Calculate the width of the achievement tracker.
        tracker_height = math.floor(
            padding + --[[ Top Padding ]]
            (padding + image_height + padding + padding)) --[[ Inner Top Padding + Image Heignt + Inner Bottom Padding + Inbetween/Outer Bottom Padding ]]
    
    else -- Else, render the trackers vertically.
        -- Calculate the height of the achievement tracker.
        tracker_height = math.floor(
            padding + --[[ Top Padding ]]
            (padding + image_height + padding + padding) --[[ Inner Top Padding + Image Heignt + Inner Bottom Padding + Inbetween/Outer Bottom Padding ]]
            * draw_manager.values.amount_to_display) -- ^ times the amount of trackers to display.

        -- Calculate the width of the achievement tracker.
        tracker_width = math.floor(
            padding + --[[ Outside Box Padding ]]
            padding + image_width + padding + --[[ Inner Padding + Image Width + Inner Padding ]]
            math.floor(draw_manager.values.longest_text_width) + --[[ Longest width that needs to be displayed ]]
            padding + --[[ Inner Padding ]]
            padding) --[[ Outside Box Padding ]]
    end

    -- Check if the alignment anchor on the config is set as top left.
    if config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.top_left then
        -- If yes, then set the x and y values as 0.
        x = 0
        y = 0
    
    -- Else if, check if the alignment anchor on the config is set as top right.
    elseif config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.top_right then
        -- If yes, then set x as the difference between the provided screen width and calculated tracker width, y as 0.
        x = screen_width - tracker_width
        y = 0
    
    -- Else if, check if the alignment anchor on the config is set as middle.
    elseif config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.middle then
        -- If yes, then set the x and y values as the return values of the get centered origin function.
        x, y = math.get_centered_origin(screen_width, screen_height, math.min(tracker_width, screen_width), math.min(tracker_height, screen_height))
        -- ^ Use a math.min on the tracker width & height because in certain sizes it would be off of the screen.
    
    -- Else if, check if the alignment anchor on the config is set as bottom left.
    elseif config_manager.config.current.display.alignment_anchor == imgui.constants.alignment_option.bottom_left then
        -- If yes, then set x as 0 and y as the difference between the provided screen height and calculated tracker height.
        x = 0
        y = screen_height - tracker_height
    
    else -- Bottom Right
        -- Set the x and y as the difference between the provided screen size and tracker size.
        x = screen_width - tracker_width
        y = screen_height - tracker_height
    end

    -- Calculate the x and y as their calculated value added with the position adjust value set on the config.
    x = math.floor(x + config_manager.config.current.display.x_position_adjust)
    y = math.floor(y + config_manager.config.current.display.y_position_adjust)

    -- Return the values.
    return x, y, tracker_width, tracker_height, image_width, image_height, progress_bar_height, padding
end

---
--- Initializes the draw manager module.
---
function draw_manager.init_module()
    -- Load the tracking manager (loaded here to avoid cyclic dependency).
    local tracking_manager = require("Achievement_Progress_Tracker.tracking_manager")

    d2d.register(function()
        -- Set the fonts to use.
        draw_manager.fonts.default = d2d.Font.new("Trebuchet MS", 13, true)
        draw_manager.fonts.description = d2d.Font.new("Trebuchet MS", 12)
        draw_manager.fonts.congrats_header = d2d.Font.new("Trebuchet MS", 20, true)
        draw_manager.fonts.congrats_message = d2d.Font.new("Trebuchet MS", 16)

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
                local x, y,
                    width, height,
                    image_width, image_height,
                    progress_bar_height,
                    padding = get_draw_params(screen_w, screen_h)
                
                -- Draw the background box to the screen.
                d2d.fill_rect(x, y, width, height, config_manager.config.current.display.color.box_background)

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
                        local local_y = y + padding + (padding + image_height + padding + padding) * (display_number - 1)

                        -- Set the achievement tracker width as the width returned by the get draw params function.
                        local tracker_width = width

                        -- Set the progress bar width as the longest text width stored on the draw manager.
                        local progress_bar_width = math.floor(draw_manager.values.longest_text_width)

                        -- Check if the render horizontally flag on the config is true.
                        if config_manager.config.current.display.render_horizontally then
                            -- If yes, then recalculate the tracker width using its internal content display width.
                            tracker_width = math.floor(
                                padding + --[[ Outside Box Padding ]]
                                padding + image_width + padding + --[[ Inner Padding + Image Width + Inner Padding ]]
                                math.floor(achievement_tracker.content_display_width) + --[[ Width of the content to be displayed ]]
                                padding + --[[ Inner Padding ]]
                                padding) --[[ Outside Box Padding ]]
                            
                            -- Recalculate the local x and y to account for horizontal rendering mode.
                            local_x = local_x + (current_combined_width)
                            local_y = y + padding

                            -- Increase the current total combined width by the newly calculated tracker width.
                            current_combined_width = current_combined_width + tracker_width

                            -- Set the progress bar width as the content display width for the current achievement tracker.
                            progress_bar_width = math.floor(achievement_tracker.content_display_width)
                        end
                        
                        -- Draw the achievement tracker background.
                        d2d.fill_rect(local_x, local_y,
                            tracker_width - (2 * padding),
                            image_height + (2 * padding),
                            config_manager.config.current.display.color.tracker_background)
                        
                        -- Draw the achievement image.
                        d2d.image(draw_manager.images[achievement_tracker.image_path],
                            local_x + padding,
                            local_y + padding,
                            image_width, image_height)
                        
                        -- Calculate the after image x offset so the rest of the content is drawn to the right of the image.
                        local after_image_x_offest = padding + image_width + padding

                        -- Draw the name of the current achievement using the default font.
                        d2d.text(draw_manager.fonts.default, achievement_tracker.name,
                            local_x + after_image_x_offest,
                            local_y + padding - 2,
                            config_manager.config.current.display.color.tracker_name_text)

                        -- Check if the display size on the config is NOT set as small.
                        if config_manager.config.current.display.size ~= constants.size_option.small then
                            -- If yes, then set the description text y padding.
                            local description_text_y_padding = padding + padding

                            -- Check if the display size on the config is set as medium.
                            if config_manager.config.current.display.size == constants.size_option.medium then
                                -- If yes, then add 2 to the description text y padding.
                                description_text_y_padding = description_text_y_padding + 2
                            end

                            -- Draw the description text of the current achievement using the description font.
                            d2d.text(draw_manager.fonts.description, achievement_tracker.description,
                                local_x + after_image_x_offest,
                                local_y + padding - 2 + description_text_y_padding,
                                config_manager.config.current.display.color.tracker_description_text)
                        end

                        -- Draw the progress bar of the current achievement tracker.
                        d2d.progress_bar(achievement_tracker.current, achievement_tracker.amount,
                            draw_manager.fonts.default,
                            local_x + after_image_x_offest,
                            local_y + image_height + padding - progress_bar_height,
                            progress_bar_width, progress_bar_height,
                            language_manager.language.current.tracker.completed,
                            config_manager.config.current.display.color.progress_bar_background,
                            config_manager.config.current.display.color.progress_bar,
                            config_manager.config.current.display.color.progress_bar_complete,
                            config_manager.config.current.display.color.progress_text,
                            config_manager.config.current.display.color.progress_complete_text
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
end

---
--- Update the values stored on the draw manager (amount to display and longest text width) using the provided the provided achievement data.
---
---@param achievement_tracker achievementtracker The achievement tracker to update the draw values for.
function draw_manager.update_values(achievement_tracker)
    -- Increment the amount to display by 1.
    draw_manager.values.amount_to_display = draw_manager.values.amount_to_display + 1

    -- Get the width of the name of the provided achievement tracker.
    local name_text_width, _ = draw_manager.fonts.default:measure(achievement_tracker.name)

    -- Set the progress bar text as the completed text.
    local progress_bar_text = language_manager.language.current.tracker.completed

    -- Check if the provided achievement is NOT marked as complete.
    if not achievement_tracker:is_complete() then
        -- If yes, then build the text that will display in the progress bar.
        progress_bar_text = string.format("%i / %i", achievement_tracker.current, achievement_tracker.amount)
    end

    -- Get the width of the progres bar text generated for the provided achievement tracker.
    local progress_bar_text_width, _ = draw_manager.fonts.default:measure(progress_bar_text)

    -- Initialize the description text width as 0 since its only relevant if the display size is NOT small.
    local description_text_width = 0

    -- Check if the display size on the config is NOT set as small.
    if config_manager.config.current.display.size ~= constants.size_option.small then
        -- If yes, then get the width of the provided achievement description.
        description_text_width, _ = draw_manager.fonts.description:measure(achievement_tracker.description)
    end

    -- Set the content display with for the provided achievement_tracker as the max between the calculated widths and minimum width.
    achievement_tracker.content_display_width = math.max(name_text_width, progress_bar_text_width, description_text_width, minimum_width)

    -- Increase the horizontal combined width stored on the draw manager by the calculated content display width for the current achievement tracker.
    draw_manager.values.horizontal_combined_width = draw_manager.values.horizontal_combined_width + achievement_tracker.content_display_width

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