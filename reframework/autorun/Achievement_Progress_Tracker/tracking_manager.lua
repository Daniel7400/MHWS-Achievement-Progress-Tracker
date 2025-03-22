-- IMPORTS
local constants = require("Achievement_Progress_Tracker.constants")
local achievementtracker = require("Achievement_Progress_Tracker.classes.achievement_tracker")
local sdk_manager = require("Achievement_Progress_Tracker.sdk_manager")
local language_manager = require("Achievement_Progress_Tracker.language_manager")
local draw_manager = require("Achievement_Progress_Tracker.draw_manager")
-- END IMPORTS

---
--- Gets the count of crafted weapons of the provided weapon type enum that were rarity 7 or higher.
---
---@param weapon_flag_data userdata The `app.savedata.cWeaponFlagParam` object to extract the value from.
---@param get_bitset_function_name string The name of the function to call on the provided weapon flag data game object to get the bitset to process.
---@param weapon_type_enum number The number that represents which weapon type to check the rarity against.
---
---@return number crafted_count The count of crafted weapons of the provided weapon type enum that were rarity 7 or higher. 
local function get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, get_bitset_function_name, weapon_type_enum)
    -- Create the return value, defaulting to 0.
    local sum = 0

    -- Get the created bitset for the provided weapon type enum by calling the function with the name of the provided get bitset function name on the provided weapon flag data.
    local weapon_bitset =  weapon_flag_data:call(get_bitset_function_name)
    if weapon_bitset then
        -- Get the collection of created weapon ids contained in the bitset.
        local created_weapon_ids = sdk.get_bitset_value(weapon_bitset)

        -- Iterate over each created weapon id.
        for _, weapon_id in ipairs(created_weapon_ids) do
            -- Get the rarity of the current weapon id (have to add by once since the rarity returned is one less for some reason).
            local weapon_rarity = sdk.constants.game_function.get_weapon_rarity:call(nil, weapon_type_enum, weapon_id) + 1
            -- Check if the rarity is greater than or equal to 7.
            if weapon_rarity >= 7 then
                -- If yes, then get the weapon data for the current weapoin id and determine if its an artian weapon.
                local weapon_data = sdk.constants.game_function.get_weapon_data:call(nil, weapon_type_enum, weapon_id)
                local is_artian = sdk.constants.game_function.is_artian_weapon:call(nil, weapon_data)

                -- Check if the is artian flag is NOT true (false).
                if not is_artian then
                    -- If yes, then increment the sum by one.
                    sum = sum + 1
                end
            end
        end
    end

    -- Return the sum of all weapons of the provided weapon type enum that were rarity 7 or higher.
    return sum
end

---
--- Gets the count of crafted armor parts that were rarity 7 or higher.
---
---@param armor_create_data userdata The `app.savedata.cArmorFlagParam` object to extract the value from.
---@param get_bitset_function_name string The name of the function to call on the provided armor create data game object to get the bitset to process.
---
---@return number crafted_count The count of crafted armor parts that were rarity 7 or higher. 
local function get_armor_crafted_rarity_7_or_higher_count(armor_create_data, get_bitset_function_name)
    -- Create the return value, defaulting to 0.
    local sum = 0

    -- Get the created bitset for the provided armor part type enum by calling the function with the name of the provided get bitset function name on the provided armor create data.
    local armor_part_bitset =  armor_create_data:call(get_bitset_function_name)
    if armor_part_bitset then
        -- Get the collection of created armor series ids contained in the bitset.
        local created_armor_series_ids = sdk.get_bitset_value(armor_part_bitset)

        -- Iterate over each created armor series id.
        for _, armor_series_id in ipairs(created_armor_series_ids) do
            -- Get the rarity of the current armor series id (have to add by once since the rarity returned is one less for some reason).
            local armor_part_rarity = sdk.constants.game_function.get_armor_rarity:call(nil, armor_series_id) + 1

            -- Check if the rarity is greater than or equal to 7.
            if armor_part_rarity >= 7 then
                -- If yes, then increment the sum by one.
                sum = sum + 1
            end
        end
    end

    -- Return the sum of all armor parts of the provided armor part type enum that were rarity 7 or higher.
    return sum
end

--- The manager for all things related to achievement tracking.
local tracking_manager = {
    -- The table of achievements being tracked by the tracking manager.
    achievements = {
        [constants.achievement.a_true_hunter] = achievementtracker:new(constants.achievement.a_true_hunter,
            constants.game_award_fixed_id.a_true_hunter,
            language_manager.language.default.achievement.a_true_hunter.name,
            language_manager.language.default.achievement.a_true_hunter.description,
            "ee560f5141c63b678c2a817e950bc9d453228d90.jpg",
            50, 0,
            constants.update_source.hunter_profile,
            constants.acquisition_method.call,
            "get_QuestClearCounter",
            ---@param quest_clear_counter userdata
            ---@return number
            function(quest_clear_counter)
                -- Check if the provided quest clear counter is NOT valid.
                if not quest_clear_counter then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Get the quest clear number per category as a result of the get clear num per category call on provided quest clear counter.
                local clear_num_per_category = quest_clear_counter:call("get_ClearNumPerCategory")

                -- Create the return value, defaulting to 0.
                local sum = 0

                -- Iterate over each clear number per category entry.
                for _, category in pairs(clear_num_per_category) do
                    -- Increment the sum by the num field on the current category.
                    sum = sum + category:get_field("Num")
                end

                -- Return the sum.
                return sum
            end),

        [constants.achievement.hunters_united_forever] = achievementtracker:new(constants.achievement.hunters_united_forever,
            constants.game_award_fixed_id.hunters_united_forever,
            language_manager.language.default.achievement.hunters_united_forever.name,
            language_manager.language.default.achievement.hunters_united_forever.description,
            "c22a0cec096d9a007161db3b3ecd5bc06600b1c6.jpg",
            100, 0,
            constants.update_source.hunter_profile,
            constants.acquisition_method.get_field,
            "Counter",
            ---@param counters userdata
            ---@return number
            function(counters)
                -- Check if the provided collection of counters is NOT valid.
                if not counters then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Get the count of completed multiplayer quests.
                local result = tonumber(counters[constants.counter.multiplayer_quest]:call("ToString"))
                
                -- Check if the resulting number is nil.
                if result == nil then
                    -- If yes, then return 0.
                    return 0
                end

                -- Return the result of getting the count of completed multiplayer quests.
                return result
            end),

        [constants.achievement.someone_worth_following] = achievementtracker:new(constants.achievement.someone_worth_following,
            constants.game_award_fixed_id.someone_worth_following,
            language_manager.language.default.achievement.someone_worth_following.name,
            language_manager.language.default.achievement.someone_worth_following.description,
            "c3823eeb0df771379c01db04da7bec6fb01af7a7.jpg",
            100, 0,
            constants.update_source.hunter_profile,
            constants.acquisition_method.get_field,
            "Counter",
            ---@param counters userdata
            ---@return number
            function(counters)
                -- Check if the provided collection of counters is NOT valid.
                if not counters then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Get the count of completed quests with an accompanying palico.
                local result = tonumber(counters[constants.counter.palico_accompanied_quest]:call("ToString"))

                -- Check if the resulting number is nil.
                if result == nil then
                    -- If yes, then return 0.
                    return 0
                end

                -- Return the result of getting the count of completed quests with an accompanying palico.
                return result
            end),

        [constants.achievement.capture_pro] = achievementtracker:new(constants.achievement.capture_pro,
            constants.game_award_fixed_id.capture_pro,
            language_manager.language.default.achievement.capture_pro.name,
            language_manager.language.default.achievement.capture_pro.description,
            "cd4e28ed9ae42fe93d2e30c7fac88f6fd85c61f6.jpg",
            50, 0,
            constants.update_source.enemy_report,
            constants.acquisition_method.call,
            "get_Boss",
            ---@param boss_report table
            ---@return number
            function(boss_report)
                -- Check if the provided boss report is NOT valid.
                if not boss_report then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Create the return value, defaulting to 0.
                local sum = 0

                -- Iterate over each boss report entry.
                for _, boss in pairs(boss_report) do
                    -- Get the enemy state for the current boss.
                    local boss_state = boss:get_field("EnemyState")

                    -- Check if the boss state does NOT equal the `NONE` (0) report state.
                    if boss_state ~= constants.enemy_report_state.NONE then
                        -- If yes, then increment the sum by the return value of calling the get capture num function on the current boss.
                        sum = sum + boss:call("getCaptureNum")
                    end
                end

                -- Return the sum.
                return sum
            end),

        [constants.achievement.monster_slayer] = achievementtracker:new(constants.achievement.monster_slayer,
            constants.game_award_fixed_id.monster_slayer,
            language_manager.language.default.achievement.monster_slayer.name,
            language_manager.language.default.achievement.monster_slayer.description,
            "10fdc7f671bae8b203d76d728d2ce2d0506fd4cf.jpg",
            100, 0,
            constants.update_source.enemy_report,
            constants.acquisition_method.call,
            "get_Boss",
            ---@param boss_report table
            ---@return number
            function(boss_report)
                -- Check if the provided boss report is NOT valid.
                if not boss_report then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Create the return value, defaulting to 0.
                local sum = 0

                -- Iterate over each boss report entry.
                for _, boss in pairs(boss_report) do
                    -- Get the enemy state for the current boss.
                    local boss_state = boss:get_field("EnemyState")

                    -- Check if the boss state does NOT equal the `NONE` (0) report state.
                    if boss_state ~= constants.enemy_report_state.NONE then
                        -- If yes, then increment the sum by the return value of calling the get hunting num function on the current boss.
                        sum = sum + boss:call("getHuntingNum")
                    end
                end

                -- Return the sum.
                return sum
            end),

        [constants.achievement.seasoned_hunter] = achievementtracker:new(constants.achievement.seasoned_hunter,
            constants.game_award_fixed_id.seasoned_hunter,
            language_manager.language.default.achievement.seasoned_hunter.name,
            language_manager.language.default.achievement.seasoned_hunter.description,
            "bbf15074c8d8d6e21cab3ccbebb62fc43f33b50f.jpg",
            50, 0,
            constants.update_source.hunter_profile,
            constants.acquisition_method.get_field,
            "Counter",
            ---@param counters userdata
            ---@return number
            function(counters)
                -- Check if the provided collection of counters is NOT valid.
                if not counters then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Get the count of hunted tempered monsters.
                local result = tonumber(counters[constants.counter.tempered_monster]:call("ToString"))

                -- Check if the resulting number is nil.
                if result == nil then
                    -- If yes, then return 0.
                    return 0
                end

                -- Return the result of getting the count of hunted tempered monsters.
                return result
            end),

        [constants.achievement.top_of_the_food_chain] = achievementtracker:new(constants.achievement.top_of_the_food_chain,
            constants.game_award_fixed_id.top_of_the_food_chain,
            language_manager.language.default.achievement.top_of_the_food_chain.name,
            language_manager.language.default.achievement.top_of_the_food_chain.description,
            "ba000c3c6d49e99493bc49a64478bd53c043743c.jpg",
            50, 0,
            constants.update_source.enemy_report,
            constants.acquisition_method.call,
            "get_Boss",
            ---@param boss_report table
            ---@return number
            function(boss_report)
                -- Check if the provided boss report is NOT valid.
                if not boss_report then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Create the return value, defaulting to 0.
                local sum = 0

                -- Iterate over each boss report entry.
                for _, boss in pairs(boss_report) do
                    -- Get the fixed id for the current boss.
                    local fixed_id = boss:get_field("FixedId")

                    -- Check if the fixed id for the current boss is that of an apex predator.
                    if constants.apex_predator[fixed_id] then
                        -- If yes, then increment the sum by the return value of calling the get hunting num function on the current boss.
                        sum = sum + boss:call("getHuntingNum")
                    end
                end

                -- Return the sum.
                return sum
            end),

        [constants.achievement.east_to_west] = achievementtracker:new(constants.achievement.east_to_west,
            constants.game_award_fixed_id.east_to_west,
            language_manager.language.default.achievement.east_to_west.name,
            language_manager.language.default.achievement.east_to_west.description,
            "2cdfdb7492d15bcc0918d1cee247e95e7a9273b0.jpg",
            30, 0,
            constants.update_source.mission_activator,
            constants.acquisition_method.call,
            "getAchievedSideMissionIDList",
            ---@param completed_side_mission_id_list userdata
            ---@param tracker_self achievementtracker
            ---@return number
            function(completed_side_mission_id_list, tracker_self)
                -- Check if the provided completed side mission id list is NOT valid.
                if not completed_side_mission_id_list then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Check if the provided completed side mission id list is missing the get size function (is nil).
                if completed_side_mission_id_list["get_size"] == nil then
                    -- If yes, then return the current value for this achievement tracker.
                    return tracker_self.current
                end
                -- Note: For some reason occasionally the provided completed side mission id list will NOT be nil, be
                -- userdata, and be the correct game array type, but will be missing the get_size function. This is a
                -- work around for this to avoid errors and flickering.

                -- Return the size of the provided completed side mission id list.
                return completed_side_mission_id_list:get_size()
            end),

        [constants.achievement.a_fish_ionado] = achievementtracker:new(constants.achievement.a_fish_ionado,
            constants.game_award_fixed_id.a_fish_ionado,
            language_manager.language.default.achievement.a_fish_ionado.name,
            language_manager.language.default.achievement.a_fish_ionado.description,
            "bce9d2d9ec6ab11405634a04ecd0d2a0f6147466.jpg",
            30, 0,
            constants.update_source.enemy_report,
            constants.acquisition_method.call,
            "get_AnimalFishing",
            ---@param fishing_report table
            ---@return number
            function(fishing_report)
                -- Check if the provided fishing report is NOT valid.
                if not fishing_report then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Create the return value, defaulting to 0.
                local sum = 0

                -- Iterate over each fishing report entry.
                for _, fish in pairs(fishing_report) do
                    -- Get the fixed id for the current boss.
                    local fixed_id = fish:get_field("FixedId")

                    -- Check if the fixed id for the current fish is that of a whopper.
                    if constants.whopper[fixed_id] then
                        -- If yes, then increment the sum by the return value of calling the get capture num function on the current fish.
                        sum = sum + fish:call("getCaptureNum")
                    end
                end

                -- Return the sum.
                return sum
            end),

        [constants.achievement.campmaster] = achievementtracker:new(constants.achievement.campmaster,
            constants.game_award_fixed_id.campmaster,
            language_manager.language.default.achievement.campmaster.name,
            language_manager.language.default.achievement.campmaster.description,
            "fedb517d9fc971e72138b220de9df59e049e63b6.jpg",
            10, 0,
            constants.update_source.camp_data,
            constants.acquisition_method.get_field,
            "SetHistoryInfo",
            ---@param set_history_info userdata
            ---@return number
            function(set_history_info)
                -- Check if the provided set history data is NOT valid.
                if not set_history_info then
                    -- Return 0 by default.
                    return 0
                end

                -- Create the return value, defaulting to 0.
                local sum = 0

                -- Get the elements of the provided camp set history info.
                local set_history_info_elements = set_history_info:get_elements()

                -- Check if the camp set history info elements are valid.
                if set_history_info_elements then
                    -- If yes, then iterate over each map entry in the camp set history info elements.
                    for _, value in ipairs(set_history_info_elements) do
                        -- Increment the sum by the amount of entries in the table created from the current pseudo bitset value.
                        sum = sum + #(sdk.get_pseudo_bitset_value(value))
                    end
                end

                -- Return the sum.
                return sum
            end),

        [constants.achievement.bourgeois_hunter] = achievementtracker:new(constants.achievement.bourgeois_hunter,
            constants.game_award_fixed_id.bourgeois_hunter,
            language_manager.language.default.achievement.bourgeois_hunter.name,
            language_manager.language.default.achievement.bourgeois_hunter.description,
            "b7056102c53d59596a8797081cc7c31a39304d51.jpg",
            1000000, 0,
            constants.update_source.basic_data,
            constants.acquisition_method.call,
            "getMoney"),

        [constants.achievement.gossip_hunter] = achievementtracker:new(constants.achievement.gossip_hunter,
            constants.game_award_fixed_id.gossip_hunter,
            language_manager.language.default.achievement.gossip_hunter.name,
            language_manager.language.default.achievement.gossip_hunter.description,
            "6ea636fdce68821645862756f6917bd3099a7233.jpg",
            30, 0,
            constants.update_source.hunter_profile,
            constants.acquisition_method.call,
            "getViewOtherProfileCount"),

        [constants.achievement.impregnable_defense] = achievementtracker:new(constants.achievement.impregnable_defense,
            constants.game_award_fixed_id.impregnable_defense,
            language_manager.language.default.achievement.impregnable_defense.name,
            language_manager.language.default.achievement.impregnable_defense.description,
            "86dac2d987165a8815edaaefecd00edb053bf973.jpg",
            5, 0,
            constants.update_source.equipment_data,
            constants.acquisition_method.pass_in,
            "",
            ---@param equipment_data userdata
            ---@return number
            function(equipment_data)
                -- Check if the provided equipment data count is NOT valid.
                if not equipment_data then
                    -- Return 0 by default.
                    return 0
                end

                -- Create the return value, defaulting to 0.
                local sum = 0

                -- Get the male armor flag data as a result of the get armor male flag param function on the provided equipment data.
                local male_armor_flag_data = equipment_data:call("get_ArmorMaleFlagParam")
                if male_armor_flag_data then
                    -- Get the armor create data by calling the get armor created param function on the male armor flag data.
                    local armor_create_data = male_armor_flag_data:call("get_ArmorCreatedParam")
                    if armor_create_data then

                        -- Increment the sum by the count of crafted male helmets of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_HelmBit")

                        -- Increment the sum by the count of crafted male chest pieces of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_BodyBit")

                        -- Increment the sum by the count of crafted male gloves of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_ArmBit")

                        -- Increment the sum by the count of crafted male waists of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_WaistBit")

                        -- Increment the sum by the count of crafted male boots of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_LegBit")
                    end
                end

                -- Get the female armor flag data as a result of the get armor female flag param function on the provided equipment data.
                local female_armor_flag_data = equipment_data:call("get_ArmorFemaleFlagParam")
                if female_armor_flag_data then
                    -- Get the armor create data by calling the get armor created param function on the female armor flag data.
                    local armor_create_data = female_armor_flag_data:call("get_ArmorCreatedParam")
                    if armor_create_data then

                        -- Increment the sum by the count of crafted female helmets of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_HelmBit")

                        -- Increment the sum by the count of crafted female chest pieces of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_BodyBit")

                        -- Increment the sum by the count of crafted female gloves of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_ArmBit")

                        -- Increment the sum by the count of crafted female waists of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_WaistBit")

                        -- Increment the sum by the count of crafted female boots of rarity 7 or higher, if any.
                        sum = sum + get_armor_crafted_rarity_7_or_higher_count(armor_create_data, "get_LegBit")
                    end
                end

                -- Return the sum.
                return sum
            end),

        [constants.achievement.power_is_everything] = achievementtracker:new(constants.achievement.power_is_everything,
            constants.game_award_fixed_id.power_is_everything,
            language_manager.language.default.achievement.power_is_everything.name,
            language_manager.language.default.achievement.power_is_everything.description,
            "e2a8d70bfd30df982e7766eb39f3e3d2032a9679.jpg",
            5, 0,
            constants.update_source.equipment_data,
            constants.acquisition_method.call,
            "get_WeaponFlagParam",
            ---@param weapon_flag_data userdata
            ---@return number
            function(weapon_flag_data)
                -- Check if the weapon flag data is NOT valid.
                if not weapon_flag_data then
                    -- Return 0 by default.
                    return 0
                end

                -- Create the return value, defaulting to 0.
                local sum = 0

                -- Increment the sum by the count of crafted greatswords of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_LongSwordCreateBit", constants.weapon_type.GREAT_SWORD)

                -- Increment the sum by the count of crafted sword and shields of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_ShortSwordCreateBit", constants.weapon_type.SWORD_AND_SHIELD)

                -- Increment the sum by the count of crafted dual blades of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_TwinSwordCreateBit", constants.weapon_type.DUAL_BLADES)

                -- Increment the sum by the count of crafted longswords of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_TachiCreateBit", constants.weapon_type.LONG_SWORD)

                -- Increment the sum by the count of crafted hammers of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_HammerCreateBit", constants.weapon_type.HAMMER)

                -- Increment the sum by the count of crafted hunting horns of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_WhistleCreateBit", constants.weapon_type.HUNTING_HORN)

                -- Increment the sum by the count of crafted lances of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_LanceCreateBit", constants.weapon_type.LANCE)

                -- Increment the sum by the count of crafted gun lances of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_GunLanceCreateBit", constants.weapon_type.GUN_LANCE)

                -- Increment the sum by the count of crafted switch axes of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_SlashAxeCreateBit", constants.weapon_type.SWITCH_AXE)

                -- Increment the sum by the count of crafted charge blades of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_ChargeAxeCreateBit", constants.weapon_type.CHARGE_BLADE)

                -- Increment the sum by the count of crafted insect glaives of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_RodCreateBit", constants.weapon_type.INSECT_GLAIVE)

                -- Increment the sum by the count of crafted bows of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_BowCreateBit", constants.weapon_type.BOW)

                -- Increment the sum by the count of crafted heavy bowguns of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_HeavyBowgunCreateBit", constants.weapon_type.HEAVY_BOWGUN)

                -- Increment the sum by the count of crafted light bowguns of rarity 7 or higher, if any.
                sum = sum + get_weapon_crafted_rarity_7_or_higher_count(weapon_flag_data, "get_LightBowgunCreateBit", constants.weapon_type.LIGHT_BOWGUN)

                -- Return the sum.
                return sum
            end),

        [constants.achievement.explorer_of_the_eastlands] = achievementtracker:new_with_collection(constants.achievement.explorer_of_the_eastlands,
            constants.game_award_fixed_id.explorer_of_the_eastlands,
            language_manager.language.default.achievement.explorer_of_the_eastlands.name,
            language_manager.language.default.achievement.explorer_of_the_eastlands.description,
            "0f18f43711c4e9da3613d86de9db805bf9441f58.jpg",
            10, 0,
            constants.update_source.item_data,
            constants.acquisition_method.call,
            "get_ItemFoundFlag",
            ---@param item_found_bitset userdata
            ---@param tracker_self achievementtracker
            ---@return number
            function(item_found_bitset, tracker_self)
                -- Check if the provided item found bitset count is NOT valid.
                if not item_found_bitset then
                    -- Return 0 by default.
                    return 0
                end

                -- Reset the contents of the found and missing tables on the collection params.
                tracker_self.collection_params.found = {}
                tracker_self.collection_params.missing = {}

                -- Get the collection of found item fixed ids contained in the provided item found bitset.
                local found_item_fixed_ids = sdk.get_bitset_value(item_found_bitset, nil, true)

                -- Iterate over each special item.
                for special_item_fixed_id, _ in pairs(constants.special_item) do
                    -- Get the corresponding item id for the current special item fixed id.
                    local item_id = constants.item_id[constants.item_id_fixed[special_item_fixed_id]]

                    -- Get the item name guid then use that to get the actual name string for the item id.
                    local item_name_guid = sdk.constants.game_function.get_item_name_guid:call(nil, item_id)
                    local item_name = sdk.get_localized_text(item_name_guid, language_manager.language.current.associated_in_game_language_option)

                    -- Check if the found item name is null (nil) or whitespace.
                    if string.is_null_or_whitespace(item_name) then
                        -- If yes, then just set the item name as the english name.
                        item_name = sdk.get_localized_text(item_name_guid, sdk.constants.enum.game_language_option.English)
                    end

                    -- Check if the current special item fixed id exists in the collection of found item fixed ids from the provided bitset.
                    if found_item_fixed_ids[special_item_fixed_id] then
                        -- If yes, then insert the item name into the found collection.
                        table.insert(tracker_self.collection_params.found, item_name)
                    else
                        -- Insert the item name into the missing collection.
                        table.insert(tracker_self.collection_params.missing, item_name)
                    end
                end

                -- Return the length of the found collection.
                return #tracker_self.collection_params.found
            end,
            constants.special_item
        ),

        [constants.achievement.monster_phd] = achievementtracker:new_with_collection(constants.achievement.monster_phd,
            constants.game_award_fixed_id.monster_phd,
            language_manager.language.default.achievement.monster_phd.name,
            language_manager.language.default.achievement.monster_phd.description,
            "19a29baf3cc204ecbba1b03bbd417fc095a8121e.jpg",
            table.length(constants.base_monster), 0,
            constants.update_source.enemy_report,
            constants.acquisition_method.call,
            "get_Boss",
            ---@param boss_report table
            ---@param tracker_self achievementtracker
            ---@return number
            function(boss_report, tracker_self)
                -- Check if the provided boss report is NOT valid.
                if not boss_report then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Reset the contents of the found and missing tables on the collection params.
                tracker_self.collection_params.found = {}
                tracker_self.collection_params.missing = {}

                -- Iterate over each boss report entry.
                for _, boss in pairs(boss_report) do
                    -- Get the fixed id for the current boss (enemy).
                    local fixed_id = boss:get_field("FixedId")

                    -- Check if the current boss fixed id exists in base monster collection.
                    if constants.base_monster[fixed_id] then
                        -- If yes, then get the corresponding boss (enemy) id for the current boss (enemy) fixed id.
                        local id = constants.enemy_def_id[constants.enemy_def_id_fixed[fixed_id]]

                        -- Get the boss (enemy) name guid then use that to get the actual name string for the boss (enemy).
                        local name_guid = sdk.constants.game_function.get_enemy_name_guid:call(nil, id)
                        local name = sdk.get_localized_text(name_guid, language_manager.language.current.associated_in_game_language_option)

                        -- Check if the found item name is null (nil) or whitespace.
                        if string.is_null_or_whitespace(name) then
                            -- If yes, then just set the boss (enemy) name as the english name.
                            name = sdk.get_localized_text(name_guid, sdk.constants.enum.game_language_option.English)
                        end

                        -- Check if the total hunting number is greater than 0.
                        if boss:call("getHuntingNum") > 0 then
                            -- If yes, then insert the boss (enemy) name into the found collection.
                            table.insert(tracker_self.collection_params.found, name)
                        else
                            -- Insert the boss (enemy) name into the missing collection.
                            table.insert(tracker_self.collection_params.missing, name)
                        end
                    end
                end

                -- Return the length of the found collection.
                return #tracker_self.collection_params.found
            end,
            constants.base_monster
        ),

        [constants.achievement.mini_crown_collector] = achievementtracker:new_with_collection(constants.achievement.mini_crown_collector,
            constants.game_award_fixed_id.mini_crown_collector,
            language_manager.language.default.achievement.mini_crown_collector.name,
            language_manager.language.default.achievement.mini_crown_collector.description,
            "c3b6b63d98ed79d376c8533a090477e763674c56.jpg",
            10, 0,
            constants.update_source.enemy_report,
            constants.acquisition_method.call,
            "get_Boss",
            ---@param boss_report table
            ---@param tracker_self achievementtracker
            ---@return number
            function(boss_report, tracker_self)
                -- Check if the provided boss report is NOT valid.
                if not boss_report then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Reset the contents of the found and missing tables on the collection params.
                tracker_self.collection_params.found = {}
                tracker_self.collection_params.missing = {}

                -- Iterate over each boss report entry.
                for _, boss in pairs(boss_report) do
                    -- Get the fixed id for the current boss (enemy).
                    local fixed_id = boss:get_field("FixedId")

                    -- Get the crown data, if any, for the fixed id for the current boss (enemy).
                    local crown_data = constants.crown_target[fixed_id]

                    -- Check if the crown data is NOT null (nil).
                    if crown_data ~= nil then
                        -- If yes, then get the corresponding boss (enemy) id for the current boss (enemy) fixed id.
                        local id = constants.enemy_def_id[constants.enemy_def_id_fixed[fixed_id]]

                        -- Get the boss (enemy) name guid then use that to get the actual name string for the boss (enemy).
                        local name_guid = sdk.constants.game_function.get_enemy_name_guid:call(nil, id)
                        local name = sdk.get_localized_text(name_guid, language_manager.language.current.associated_in_game_language_option)

                        -- Check if the found item name is null (nil) or whitespace.
                        if string.is_null_or_whitespace(name) then
                            -- If yes, then just set the boss (enemy) name as the english name.
                            name = sdk.get_localized_text(name_guid, sdk.constants.enum.game_language_option.English)
                        end

                        -- Get the minimum hunted size for the current boss (enemy) id.
                        local min_hunted_size = sdk.constants.game_function.get_monster_min_size_record_func:call(nil, id)

                        -- Check if the minimum hunted size is less than or equal to the mini size on the crown data.
                        if min_hunted_size <= crown_data.mini_size then
                            -- If yes, then insert the boss (enemy) name into the found collection.
                            table.insert(tracker_self.collection_params.found, name)
                        else
                            -- Insert the boss (enemy) name into the missing collection.
                            table.insert(tracker_self.collection_params.missing, name)
                        end
                    end
                end

                -- Return the length of the found collection.
                return #tracker_self.collection_params.found
            end,
            constants.crown_target
        ),

        [constants.achievement.mini_crown_master] = achievementtracker:new_with_collection(constants.achievement.mini_crown_master,
            constants.game_award_fixed_id.mini_crown_master,
            language_manager.language.default.achievement.mini_crown_master.name,
            language_manager.language.default.achievement.mini_crown_master.description,
            "e7da4f45efb6e089c2c4da9219d2029c16fa9fd2.jpg",
            table.length(constants.crown_target), 0,
            constants.update_source.enemy_report,
            constants.acquisition_method.call,
            "get_Boss",
            ---@param boss_report table
            ---@param tracker_self achievementtracker
            ---@return number
            function(boss_report, tracker_self)
                -- Check if the provided boss report is NOT valid.
                if not boss_report then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Reset the contents of the found and missing tables on the collection params.
                tracker_self.collection_params.found = {}
                tracker_self.collection_params.missing = {}

                -- Iterate over each boss report entry.
                for _, boss in pairs(boss_report) do
                    -- Get the fixed id for the current boss (enemy).
                    local fixed_id = boss:get_field("FixedId")

                    -- Get the crown data, if any, for the fixed id for the current boss (enemy).
                    local crown_data = constants.crown_target[fixed_id]

                    -- Check if the crown data is NOT null (nil).
                    if crown_data ~= nil then
                        -- If yes, then get the corresponding boss (enemy) id for the current boss (enemy) fixed id.
                        local id = constants.enemy_def_id[constants.enemy_def_id_fixed[fixed_id]]

                        -- Get the boss (enemy) name guid then use that to get the actual name string for the boss (enemy).
                        local name_guid = sdk.constants.game_function.get_enemy_name_guid:call(nil, id)
                        local name = sdk.get_localized_text(name_guid, language_manager.language.current.associated_in_game_language_option)

                        -- Check if the found item name is null (nil) or whitespace.
                        if string.is_null_or_whitespace(name) then
                            -- If yes, then just set the boss (enemy) name as the english name.
                            name = sdk.get_localized_text(name_guid, sdk.constants.enum.game_language_option.English)
                        end

                        -- Get the minimum hunted size for the current boss (enemy) id.
                        local min_hunted_size = sdk.constants.game_function.get_monster_min_size_record_func:call(nil, id)

                        -- Check if the minimum hunted size is less than or equal to the mini size on the crown data.
                        if min_hunted_size <= crown_data.mini_size then
                            -- If yes, then insert the boss (enemy) name into the found collection.
                            table.insert(tracker_self.collection_params.found, name)
                        else
                            -- Insert the boss (enemy) name into the missing collection.
                            table.insert(tracker_self.collection_params.missing, name)
                        end
                    end
                end

                -- Return the length of the found collection.
                return #tracker_self.collection_params.found
            end,
            constants.crown_target
        ),

        [constants.achievement.giant_crown_collector] = achievementtracker:new_with_collection(constants.achievement.giant_crown_collector,
            constants.game_award_fixed_id.giant_crown_collector,
            language_manager.language.default.achievement.giant_crown_collector.name,
            language_manager.language.default.achievement.giant_crown_collector.description,
            "4892108fcf89dec2e32ab155629ab1621c7ecc0d.jpg",
            10, 0,
            constants.update_source.enemy_report,
            constants.acquisition_method.call,
            "get_Boss",
            ---@param boss_report table
            ---@param tracker_self achievementtracker
            ---@return number
            function(boss_report, tracker_self)
                -- Check if the provided boss report is NOT valid.
                if not boss_report then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Reset the contents of the found and missing tables on the collection params.
                tracker_self.collection_params.found = {}
                tracker_self.collection_params.missing = {}

                -- Iterate over each boss report entry.
                for _, boss in pairs(boss_report) do
                    -- Get the fixed id for the current boss (enemy).
                    local fixed_id = boss:get_field("FixedId")

                    -- Get the crown data, if any, for the fixed id for the current boss (enemy).
                    local crown_data = constants.crown_target[fixed_id]

                    -- Check if the crown data is NOT null (nil).
                    if crown_data ~= nil then
                        -- If yes, then get the corresponding boss (enemy) id for the current boss (enemy) fixed id.
                        local id = constants.enemy_def_id[constants.enemy_def_id_fixed[fixed_id]]

                        -- Get the boss (enemy) name guid then use that to get the actual name string for the boss (enemy).
                        local name_guid = sdk.constants.game_function.get_enemy_name_guid:call(nil, id)
                        local name = sdk.get_localized_text(name_guid, language_manager.language.current.associated_in_game_language_option)

                        -- Check if the found item name is null (nil) or whitespace.
                        if string.is_null_or_whitespace(name) then
                            -- If yes, then just set the boss (enemy) name as the english name.
                            name = sdk.get_localized_text(name_guid, sdk.constants.enum.game_language_option.English)
                        end

                        -- Get the maximum hunted size for the current boss (enemy) id.
                        local max_hunted_size = sdk.constants.game_function.get_monster_max_size_record_func:call(nil, id)

                        -- Check if the maximum hunted size is greater than or equal to the gold size on the crown data.
                        if max_hunted_size >= crown_data.gold_size then
                            -- If yes, then insert the boss (enemy) name into the found collection.
                            table.insert(tracker_self.collection_params.found, name)
                        else
                            -- Insert the boss (enemy) name into the missing collection.
                            table.insert(tracker_self.collection_params.missing, name)
                        end
                    end
                end

                -- Return the length of the found collection.
                return #tracker_self.collection_params.found
            end,
            constants.crown_target
        ),

        [constants.achievement.giant_crown_master] = achievementtracker:new_with_collection(constants.achievement.giant_crown_master,
            constants.game_award_fixed_id.giant_crown_master,
            language_manager.language.default.achievement.giant_crown_master.name,
            language_manager.language.default.achievement.giant_crown_master.description,
            "1e9e0612ec6b1e5d5bc155a30c99cb6a578cef5e.jpg",
            table.length(constants.crown_target), 0,
            constants.update_source.enemy_report,
            constants.acquisition_method.call,
            "get_Boss",
            ---@param boss_report table
            ---@param tracker_self achievementtracker
            ---@return number
            function(boss_report, tracker_self)
                -- Check if the provided boss report is NOT valid.
                if not boss_report then
                    -- If yes, then return 0 by default.
                    return 0
                end

                -- Reset the contents of the found and missing tables on the collection params.
                tracker_self.collection_params.found = {}
                tracker_self.collection_params.missing = {}

                -- Iterate over each boss report entry.
                for _, boss in pairs(boss_report) do
                    -- Get the fixed id for the current boss (enemy).
                    local fixed_id = boss:get_field("FixedId")

                    -- Get the crown data, if any, for the fixed id for the current boss (enemy).
                    local crown_data = constants.crown_target[fixed_id]

                    -- Check if the crown data is NOT null (nil).
                    if crown_data ~= nil then
                        -- If yes, then get the corresponding boss (enemy) id for the current boss (enemy) fixed id.
                        local id = constants.enemy_def_id[constants.enemy_def_id_fixed[fixed_id]]

                        -- Get the boss (enemy) name guid then use that to get the actual name string for the boss (enemy).
                        local name_guid = sdk.constants.game_function.get_enemy_name_guid:call(nil, id)
                        local name = sdk.get_localized_text(name_guid, language_manager.language.current.associated_in_game_language_option)

                        -- Check if the found item name is null (nil) or whitespace.
                        if string.is_null_or_whitespace(name) then
                            -- If yes, then just set the boss (enemy) name as the english name.
                            name = sdk.get_localized_text(name_guid, sdk.constants.enum.game_language_option.English)
                        end

                        -- Get the maximum hunted size for the current boss (enemy) id.
                        local max_hunted_size = sdk.constants.game_function.get_monster_max_size_record_func:call(nil, id)

                        -- Check if the maximum hunted size is greater than or equal to the gold size on the crown data.
                        if max_hunted_size >= crown_data.gold_size then
                            -- If yes, then insert the boss (enemy) name into the found collection.
                            table.insert(tracker_self.collection_params.found, name)
                        else
                            -- Insert the boss (enemy) name into the missing collection.
                            table.insert(tracker_self.collection_params.missing, name)
                        end
                    end
                end

                -- Return the length of the found collection.
                return #tracker_self.collection_params.found
            end,
            constants.crown_target
        )
    },

    -- The flag used to determine if the tracking manager initialized or not yet.
    is_initialized = false
}

---
--- Update the value of the provided `achievement_tracker` with the provided `update_source`.
---
---@param achievement_tracker achievementtracker The achievement tracker to update the value for.
---@param update_source userdata The source used to get the update value from.
---@param skip_draw_manager_update? boolean [OPTIONAL] The flag used to determine if the tracker should skip the call into the draw manager to update its values. Defaults to false (doing the draw manager updates).
---
---@return boolean tracker_value_changed The flag that represents whether the value of the provided achievement tracker changed or not.
local function update_tracker_value(achievement_tracker, update_source, skip_draw_manager_update)
    -- Check if the provided skip draw manager update flag is null (nil).
    if skip_draw_manager_update == nil then
        -- If yes, then set it to false.
        skip_draw_manager_update = false
    end

    -- Store the current value of the provided achievement tracker as the previous value.
    local previous_value = achievement_tracker.current

    -- Create a variable to store the acquired value. Default to 0.
    local acquired_value = 0

     -- Check if the acquisition method on the provided achievement tracker is get field.
    if achievement_tracker.update_params.acquisition_method == constants.acquisition_method.get_field then
        -- If yes, then set the acquired value with the result of calling get field on the provided update source.
        acquired_value = update_source:get_field(achievement_tracker.update_params.name)

    -- Else if, check if the acquisition method on the provided achievement tracker is call.
    elseif achievement_tracker.update_params.acquisition_method == constants.acquisition_method.call then
        -- If yes, then set the acquired value with the result of calling call on the provided update source.
        acquired_value = update_source:call(achievement_tracker.update_params.name)

    -- Else if, check if the acquisition method on the provided achievement tracker is pass in AND it doesn't have an additional processing function.
    elseif achievement_tracker.update_params.acquisition_method == constants.acquisition_method.pass_in and
            achievement_tracker.update_params.additional_processing == nil then
        error(string.format("The tracker for the '%s' achievement is setup to use the 'pass_in' acquisition method but does NOT have an additional processing function which is required.", achievement_tracker.name))
    end

    -- If yes, check if the additional processing function on the provided achievement tracker is nil.
    if achievement_tracker.update_params.additional_processing == nil then
        -- If yes, then set the current value on the provided achievement tracker as previously acquired value.
        achievement_tracker.current = acquired_value
    else
        -- Check if the acquisition method on the provided achievement tracker is pass in.
        if achievement_tracker.update_params.acquisition_method == constants.acquisition_method.pass_in then
            -- If yes, then set the current value on the provided achievement tracker as the result of the additional_processing
            -- function after passing in the update source and the tracker itself.
            achievement_tracker.current = achievement_tracker.update_params.additional_processing(update_source, achievement_tracker)
        else
            -- Set the current value on the provided achievement tracker as the result of the additional processing function after
            -- passing in the acquired value (obtained above) and the tracker itself.
            achievement_tracker.current = achievement_tracker.update_params.additional_processing(acquired_value, achievement_tracker)
        end
    end

    -- Determine if the tracker value changed by comparing if the previous value and new current are NOT equal.
    local tracker_value_changed = previous_value ~= achievement_tracker.current

    -- Check if the newly updated current value for the provided achievement tracker is greater than or equal to the amount.
    if achievement_tracker.current >= achievement_tracker.amount then
        -- If yes, then set the award obtained flag on the provided achievementtracker as true.
        achievement_tracker.award_obtained = true
    
    -- Else if, check if the provided achievementtracker has the award obtained flag as true (but doesn't meet the current vs amount requirement).
    elseif achievement_tracker.award_obtained then
        -- If yes, then set the current value for the provided achievement tracker as the amount to make the progress bar show as complete.
        achievement_tracker.current = achievement_tracker.amount
    end

    -- Check if the provided achievement tracker should be displayed and the skip draw manager update flag is NOT true (is false).
    if achievement_tracker:should_display() and not skip_draw_manager_update then
        -- If yes, then call the update values function on the draw manager.
        draw_manager.update_values(achievement_tracker)
    end

    -- Return the tracker value changed flag.
    return tracker_value_changed
end

---
--- Update the language values of the provided `achievement_tracker`.
---
---@param achievement_tracker achievementtracker The achievement tracker to update language values for.
local function update_tracker_language(achievement_tracker)
    -- Set the name and description of the provided achievement tracker as the values set on the current language.
    achievement_tracker.name = language_manager.language.current.achievement[achievement_tracker.key].name
    achievement_tracker.description = language_manager.language.current.achievement[achievement_tracker.key].description

    -- Check if the provided achievement tracker is enabled AND NOT complete AND has collection params defined AND has missing.
    if achievement_tracker:is_enabled() and not achievement_tracker:is_complete() and achievement_tracker.collection_params ~= nil
        and #achievement_tracker.collection_params.missing > 0 then
        -- If yes, then update the tracker so it calls its additional processing function and update the missing entries text.
        tracking_manager.update_tracker(achievement_tracker)
    end

    -- Check if the provided achievement tracker should be displayed.
    if achievement_tracker:should_display() then
        -- If yes, then call the update values function on the draw manager.
        draw_manager.update_values(achievement_tracker)
    end
end

---
--- Update the value of the provided `achievement_tracker`.
---
---@param achievement_tracker achievementtracker The achievement tracker to update the value for.
---@param user_save_data? userdata [OPTIONAL] The user save data to use when updating the value of the achievement tracker. If not provided or nil (and needed) it will be automatically obtained from the sdk manager. Defaults to nil.
---
---@return boolean is_updated 
function tracking_manager.update_tracker(achievement_tracker, user_save_data)
    -- Check if the provided achievement tracker is NOT already completed.
    if not achievement_tracker:is_complete() then

        -- Initialize the update source.
        local update_source = nil

        -- Check if the update source on the provided achievement tracker is the mission activator.
        if achievement_tracker.update_params.source == constants.update_source.mission_activator then
            -- If yes, then set the update source as the result of calling the get mission activator function on the sdk manager.
            update_source = sdk_manager.get_mission_activator()
        else
            -- Check if the provided user save data, if any, is nil.
            if not user_save_data then
                -- If yes, then call the get user save data function on the sdk manager to get the user save data.
                user_save_data = sdk_manager.get_user_save_data()
            end

            -- Check if the update source on the provided achievement tracker is the user basic data.
            if achievement_tracker.update_params.source == constants.update_source.basic_data then
                -- If yes, then set the update source as the result of calling the get basic data function on the sdk manager.
                update_source = sdk_manager.get_basic_data(user_save_data)

            -- Else if, check if the update source on the provided achievement tracker is the item data.
            elseif achievement_tracker.update_params.source == constants.update_source.item_data then
                -- If yes, then set the update source as the result of calling the get item data function on the sdk manager.
                update_source = sdk_manager.get_item_data(user_save_data)

            -- Else if, check if the update source on the provided achievement tracker is the equipment data.
            elseif achievement_tracker.update_params.source == constants.update_source.equipment_data then
                -- If yes, then set the update source as the result of calling the get equipment data function on the sdk manager.
                update_source = sdk_manager.get_equipment_data(user_save_data)

            -- Else if, check if the update source on the provided achievement tracker is the camp data.
            elseif achievement_tracker.update_params.source == constants.update_source.camp_data then
                -- If yes, then set the update source as the result of calling the get camp data function on the sdk manager.
                update_source = sdk_manager.get_camp_data(user_save_data)

            -- Else if, check if the update source on the provided achievement tracker is the hunter profile.
            elseif achievement_tracker.update_params.source == constants.update_source.hunter_profile then
                -- If yes, then set the update source as the result of calling the get hunter profile data function on the sdk manager.
                update_source = sdk_manager.get_hunter_profile(user_save_data)

            -- Else if, check if the update source on the provided achievement tracker is the enemy report.
            elseif achievement_tracker.update_params.source == constants.update_source.enemy_report then
                -- If yes, then set the update source as the result of calling the get enemy report function on the sdk manager.
                update_source = sdk_manager.get_enemy_report(user_save_data)
            end
        end

        -- Check if an update source was successfully found.
        if update_source then
            -- If yes, then return the result of calling the internal update tracker value function passing the provided achievement tracker and found update source.
            return update_tracker_value(achievement_tracker, update_source, true)
        end
    end

    -- Return false by default since completed achievements don't need to do any updates.
    return false
end

---
--- Update the current values for all of the achievements being tracked through the tracking manager.
---
---@param basic_data userdata The basic data to acquire update values from.
---@param item_data userdata The item data to acquire update values from.
---@param equipment_data userdata The equipment data to acquire update values from.
---@param camp_data userdata The camp data to acquire update values from.
---@param hunter_profile userdata The hunter profile to acquire update values from.
---@param mission_activator userdata The mission activator to acquire update values from.
function tracking_manager.update_values(basic_data, item_data, equipment_data, camp_data, hunter_profile, enemy_report, mission_activator)
    -- Call the reset values function on the draw manager.
    draw_manager.reset_values()

    -- Create a flag to track whether all tracked achievements are completed or not. Default to true.
    local all_completed = true

    -- Get the collection of already acquired award/medal fixed ids.
    local acquired_awards_fixed_ids = sdk_manager.get_acquired_award_fixed_ids(hunter_profile)

    -- Iterate over each achievement tracker.
    for _, achievement_tracker in ipairs(tracking_manager.achievements) do
        -- Check if the current achievement tracker has already been acquired as an in-game award/medal but NOT marked as such.
        if acquired_awards_fixed_ids[achievement_tracker.game_award_fixed_id] and not achievement_tracker.award_obtained then
            -- If yes, then set the award obtained flag on the current achievement tracker as true.
            achievement_tracker.award_obtained = true
        end

        -- Set the update source as nil by default.
        local update_source = nil

        -- Check if the update source on the current achievement tracker is the user basic data.
        if achievement_tracker.update_params.source == constants.update_source.basic_data then
            -- If yes, then set the update source as the provided user basic data.
            update_source = basic_data

        -- Else if, check if the update source on the current achievement tracker is the item data.
        elseif achievement_tracker.update_params.source == constants.update_source.item_data then
            -- If yes, then set the update source as the provided item data.
            update_source = item_data

        -- Else if, check if the update source on the current achievement tracker is the equipment data.
        elseif achievement_tracker.update_params.source == constants.update_source.equipment_data then
            -- If yes, then set the update source as the provided equipment data.
            update_source = equipment_data

        -- Else if, check if the update source on the current achievement tracker is the camp data.
        elseif achievement_tracker.update_params.source == constants.update_source.camp_data then
            -- If yes, then set the update source as the provided camp data.
            update_source = camp_data

        -- Else if, check if the update source on the current achievement tracker is the hunter profile.
        elseif achievement_tracker.update_params.source == constants.update_source.hunter_profile then
            -- If yes, then set the update source as the provided hunter profile.
            update_source = hunter_profile

        -- Else if, check if the update source on the current achievement tracker is the enemy report.
        elseif achievement_tracker.update_params.source == constants.update_source.enemy_report then
            -- If yes, then set the update source as the provided enemy report.
            update_source = enemy_report

        -- Else if, check if the update source on the current achievement tracker is the mission activator.
        elseif achievement_tracker.update_params.source == constants.update_source.mission_activator then
            -- If yes, then set the update source as the provided mission activator.
            update_source = mission_activator
        else
            return
        end

        -- Call the update tracker value for the current achievement tracker and update source.
        update_tracker_value(achievement_tracker, update_source)

        -- Update the all completed flag as the and between itself and the is complete function of the current achievement tracker.
        all_completed = all_completed and achievement_tracker:is_complete()
    end

    -- Set the all completed flag on the draw manager as the local all completed flag.
    draw_manager.flags.all_completed = all_completed
end

---
--- Force the draw manager to reset its draw values and then update them to the latest values.
---
function tracking_manager.force_draw_manager_values_reset_and_update()
    -- Reset the draw values.
    draw_manager.reset_values()

    -- Iterate over each achievement tracker.
    for _, achievement_tracker in ipairs(tracking_manager.achievements) do
        -- Check if the current achievement tracker should be displayed.
        if achievement_tracker:should_display() then
            -- If yes, then call the update values function on the draw manager for current achievement tracker.
            draw_manager.update_values(achievement_tracker)
        end
    end
end

---
--- Update the current language for all achievement names and descriptions to match the current language. Also used to
--- get the new potential longest text width with a size change.
---
function tracking_manager.update_language()
    -- Call the reset values function on the draw manager.
    draw_manager.reset_values()

    -- Iterate over each achievement tracker.
    for _, achievement_tracker in ipairs(tracking_manager.achievements) do
        -- Call the update tracker language function for the current achievement tracker.
        update_tracker_language(achievement_tracker)
    end
end

---
--- Initializes the tracking manager module.
---
function tracking_manager.init_module()
    -- Get the user data data.
    local user_save_data = sdk_manager.get_user_save_data()

    -- Get the basic data.
    local basic_data = sdk_manager.get_basic_data(user_save_data)

    -- Get the item data.
    local item_data = sdk_manager.get_item_data(user_save_data)

    -- Get the equipment data.
    local equipment_data = sdk_manager.get_equipment_data(user_save_data)

    -- Get the camp data.
    local camp_data = sdk_manager.get_camp_data(user_save_data)

    -- Get the hunter profile.
    local hunter_profile = sdk_manager.get_hunter_profile(user_save_data)

    -- Get the enemy report.
    local enemy_report = sdk_manager.get_enemy_report(user_save_data)

    -- Get the mission activator.
    local mission_activator = sdk_manager.get_mission_activator()

    -- Check if the basic data, item data, equipment data, camp data, hunter profile, enemy report, and mission activator were found.
    if basic_data and item_data and equipment_data and camp_data and hunter_profile and enemy_report and mission_activator then
        -- If yes, then call the update values on the tracking manager.
        tracking_manager.update_values(basic_data, item_data, equipment_data, camp_data, hunter_profile, enemy_report, mission_activator)
    else
        return
    end

    -- Set the is initialized flag on the tracking manager as true.
    tracking_manager.is_initialized = true
end

return tracking_manager