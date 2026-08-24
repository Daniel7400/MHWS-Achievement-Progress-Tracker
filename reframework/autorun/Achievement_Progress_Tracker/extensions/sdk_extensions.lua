-- IMPORTS
local resource_type = require("Achievement_Progress_Tracker.enums.resource_type")
local constants = require("Achievement_Progress_Tracker.constants")
-- END IMPORTS

---
--- Returns the method definition for the provided type name and method name. If none is found an error is thrown.
---
---@param type_name string The name of the type to check for the provided `method_name`.
---@param method_name string The name of the method to hook into.
---@param error_message_prefix? string [OPTIONAL] The prefix to add to the no method definition found error message. If not nil or whitespace it will automatically append a space to the end. Defaults to an empty string (no prefix).
---
---@return userdata method_definition The userdata that represents the `REMethodDefinition` for the provided type name and method name.
function sdk.get_method(type_name, method_name, error_message_prefix)
    assert(not string.is_null_or_whitespace(type_name), "The provided 'type_name' cannot be nil or whitespace.")
    assert(not string.is_null_or_whitespace(method_name), "The provided 'method_name' cannot be nil or whitespace.")

    -- Check if the provided error message prefix is null (nil) or whitespace.
    if string.is_null_or_whitespace(error_message_prefix) then
        -- If yes, then set the error message prefix to an empty string (no prefix).
        error_message_prefix = ""

    -- Else, the error message has content.
    else
        -- Append a space to the provided error message prefix to help separate it from the default error message.
        error_message_prefix = string.format("%s ", error_message_prefix)
    end

    -- Get the method definition for the provided type name and method name.
    local method_definition = sdk.find_type_definition(type_name):get_method(method_name)

    -- Check if there was NO method definition found.
    if not method_definition then
        -- If yes, then throw a hard error saying the method definition could not be found.
        error(string.format("\n\n%sNo method definition found for: '%s.%s'\n",
            error_message_prefix, type_name, method_name))
    end

    -- Return the found method definition for the provided type name and method name.
    return method_definition
end

---
--- Adds a hook into the method described by the provided method name on the type described by the provided type name.
--- The provided pre function will execute before the hooked method does, and the post function executes after.
---
--- @param type_name string The name of the type to check for the provided `method_name`.
--- @param method_name string The name of the method to hook into.
--- @param pre_function? function [OPTIONAL] The function to execute before the method is hooked.
--- @param post_function? function [OPTIONAL] The function to execute after the method is hooked.
function sdk.add_hook(type_name, method_name, pre_function, post_function)
    assert(not string.is_null_or_whitespace(type_name), "The provided 'type_name' cannot be nil or whitespace.")
    assert(not string.is_null_or_whitespace(method_name), "The provided 'method_name' cannot be nil or whitespace.")
    assert(pre_function or post_function, "Either the provided 'pre_function' or 'post_function' must not be nil.")

    -- Get the method definition for the provided type name and method name.
    local method_definition = sdk.get_method(type_name, method_name, "Hook could NOT be created.")

    -- Create an sdk hook using the found method definition and provided pre + post functions.
    sdk.hook(method_definition, pre_function, post_function)
end

sdk.cache = {
    -- Cached game functions from static types or classes. Invoked via `:call(nil, <args>)`
    game_function = {
        -- `via.rds.Mandrake.op_Implicit(via.rds.Mandrake)`
        get_mandrake_value = sdk.get_method(constants.type_name.mandrake, "op_Implicit(via.rds.Mandrake)"),

        -- `via.gui.message.get(System.Guid)`
        get_message = sdk.get_method(constants.type_name.gui_message, "get(System.Guid)"),

        -- `via.gui.message.get(System.Guid, via.Language)`
        get_message_with_lang = sdk.get_method(constants.type_name.gui_message, "get(System.Guid, via.Language)"),

        -- `app.WeaponDef.Rare(app.WeaponDef.TYPE, System.Int32)`
        get_weapon_rarity = sdk.get_method(constants.type_name.weapon_def, "Rare(app.WeaponDef.TYPE, System.Int32)"),

        -- `app.WeaponDef.Data(app.WeaponDef.TYPE, System.Int32)`
        get_weapon_data = sdk.get_method(constants.type_name.weapon_def, "Data(app.WeaponDef.TYPE, System.Int32)"),

        -- `app.ArtianUtil.isArtianWeapon(app.user_data.WeaponData.cData)`
        is_artian_weapon = sdk.get_method(constants.type_name.artian_util, "isArtianWeapon(app.user_data.WeaponData.cData)"),

        -- `app.ArmorDef.Rare(app.ArmorDef.SERIES)`
        get_armor_rarity = sdk.get_method(constants.type_name.armor_def, "Rare(app.ArmorDef.SERIES)"),

        -- `app.ItemDef.Name(app.ItemDef.ID)`
        get_item_name_guid = sdk.get_method(constants.type_name.item_def, "Name(app.ItemDef.ID)"),

        -- `app.EnemyDef.EnemyName(app.EnemyDef.ID)`
        get_enemy_name_guid = sdk.get_method(constants.type_name.enemy_def, "EnemyName(app.EnemyDef.ID)"),

        -- `app.HunterProfileDef.Name(app.HunterProfileDef.MEDAL_ID)`
        get_award_name_guid = sdk.get_method(constants.type_name.hunter_profile_def, "Name(app.HunterProfileDef.MEDAL_ID)"),

        -- `app.HunterProfileDef.Explain(app.HunterProfileDef.MEDAL_ID)`
        get_award_description_guid = sdk.get_method(constants.type_name.hunter_profile_def, "Explain(app.HunterProfileDef.MEDAL_ID)"),

        -- `app.EnemyReportUtil.getMinSize(app.EnemyDef.ID)`
        get_monster_min_size_record = sdk.get_method(constants.type_name.enemy_report_util, "getMinSize(app.EnemyDef.ID)"),

        -- `app.EnemyReportUtil.getMaxSize(app.EnemyDef.ID)`
        get_monster_max_size_record = sdk.get_method(constants.type_name.enemy_report_util, "getMaxSize(app.EnemyDef.ID)"),

        -- `app.AnimalUtil.isAnimal(app.EnemyDef.ID)`
        is_animal = sdk.get_method(constants.type_name.animal_util, "isAnimal(app.EnemyDef.ID)"),

        -- `app.AnimalUtil.isFish(app.EnemyDef.ID)`
        is_fish = sdk.get_method(constants.type_name.animal_util, "isFish(app.EnemyDef.ID)"),

        -- `app.ItemDef.Type(app.ItemDef.ID)`
        item_get_type = sdk.get_method(constants.type_name.item_def, "Type(app.ItemDef.ID)"),

        -- `app.ItemDef.Rare(app.ItemDef.ID)`
        item_rare = sdk.get_method(constants.type_name.item_def, "Rare(app.ItemDef.ID)")
    },

    -- Cached enums.
    enum = {},

    -- Cached localized names.
    name = {
        -- Cached localized award names.
        award = {},

        -- Cached localized enemy names.
        enemy = {},

        -- Cached localized item names.
        item = {}
    },

    -- Cached debug information. These are only populated when the enable debug flag is set as true in the config.
    debug = {
        -- Cached monster debug information.
        monster = {},

        -- Cached item debug information.
        item = {},

        -- Cached award (achievement) debug information.
        award = {}
    }
}

--- Constants used within `sdk` functions.
local sdk_constants <const> = {
    spacing = "    ",
    game_number_types = {
        "System.Byte",
        "System.Single",
        "System.Double",
        "System.Float",
        "System.Decimal",
        "System.Int16",
        "System.UInt16",
        "System.Int32",
        "System.UInt32",
        "System.Int64",
        "System.UInt64"
    },
    parent_type_and_field_name_to_enum_type_name_lookup = {
        ["app.savedata.cWeaponFlagParam"] = {
            ["_LongSwordCreateBit"] = "app.WeaponDef.LongSwordId",
            ["_LongSwordCheckedBit"] = "app.WeaponDef.LongSwordId",

            ["_ShortSwordCreateBit"] = "app.WeaponDef.ShortSwordId",
            ["_ShortSwordCheckedBit"] = "app.WeaponDef.ShortSwordId",

            ["_TwinSwordCreateBit"] = "app.WeaponDef.TwinSwordId",
            ["_TwinSwordCheckedBit"] = "app.WeaponDef.TwinSwordId",

            ["_TachiCreateBit"] = "app.WeaponDef.TachiId",
            ["_TachiCheckedBit"] = "app.WeaponDef.TachiId",

            ["_HammerCreateBit"] = "app.WeaponDef.HammerId",
            ["_HammerCheckedBit"] = "app.WeaponDef.HammerId",

            ["_WhistleCreateBit"] = "app.WeaponDef.WhistleId",
            ["_WhistleCheckedBit"] = "app.WeaponDef.WhistleId",

            ["_LanceCreateBit"] = "app.WeaponDef.LanceId",
            ["_LanceCheckedBit"] = "app.WeaponDef.LanceId",

            ["_GunLanceCreateBit"] = "app.WeaponDef.GunLanceId",
            ["_GunLanceCheckedBit"] = "app.WeaponDef.GunLanceId",

            ["_SlashAxeCreateBit"] = "app.WeaponDef.SlashAxeId",
            ["_SlashAxeCheckedBit"] = "app.WeaponDef.SlashAxeId",

            ["_ChargeAxeCreateBit"] = "app.WeaponDef.ChargeAxeId",
            ["_ChargeAxeCheckedBit"] = "app.WeaponDef.ChargeAxeId",

            ["_RodCreateBit"] = "app.WeaponDef.RodId",
            ["_RodCheckedBit"] = "app.WeaponDef.RodId",

            ["_BowCreateBit"] = "app.WeaponDef.BowId",
            ["_BowCheckedBit"] = "app.WeaponDef.BowId",

            ["_HeavyBowgunCreateBit"] = "app.WeaponDef.HeavyBowgunId",
            ["_HeavyBowgunCheckedBit"] = "app.WeaponDef.HeavyBowgunId",

            ["_LightBowgunCreateBit"] = "app.WeaponDef.LightBowgunId",
            ["_LightBowgunCheckedBit"] = "app.WeaponDef.LightBowgunId"
        },
        ["app.savedata.cArmorFlagParam"] = {
            ["_HelmBit"] = "app.ArmorDef.SERIES",
            ["_BodyBit"] = "app.ArmorDef.SERIES",
            ["_ArmBit"] = "app.ArmorDef.SERIES",
            ["_WaistBit"] = "app.ArmorDef.SERIES",
            ["_LegBit"] = "app.ArmorDef.SERIES",
        },
        ["app.savedata.cItemParam"] = {
            ["_ItemFoundFlag"] = "app.ItemDef.ID_Fixed",
            ["_ItemCheckedFlag"] = "app.ItemDef.ID_Fixed"
        }
    },
    resource_type_config = {
        [resource_type.Award] = {
            cache = sdk.cache.name.award,
            get_guid_func = sdk.cache.game_function.get_award_name_guid,
            ---@param fixed_id number
            ---@return number
            get_id_func = function(fixed_id)
                return sdk.cache.enum.award_id[sdk.cache.enum.award_id_fixed_lookup[fixed_id]]
            end
        },
        [resource_type.Enemy] = {
            cache = sdk.cache.name.enemy,
            get_guid_func = sdk.cache.game_function.get_enemy_name_guid,
            ---@param fixed_id number
            ---@return number
            get_id_func = function(fixed_id)
                return sdk.cache.enum.enemy_def_id[sdk.cache.enum.enemy_def_id_fixed_lookup[fixed_id]]
            end
        },
        [resource_type.Item] = {
            cache = sdk.cache.name.item,
            get_guid_func = sdk.cache.game_function.get_item_name_guid,
            ---@param fixed_id number
            ---@return number
            get_id_func = function(fixed_id)
                return sdk.cache.enum.item_id[sdk.cache.enum.item_id_fixed_lookup[fixed_id]]
            end
        }
    },
    name_maps = {
        award_fixed_id = {
            eastward_wings              = "MEDAL_000",
            a_true_hunter               = "MEDAL_009",
            east_to_west                = "MEDAL_013",
            a_fish_ionado               = "MEDAL_023",
            campmaster                  = "MEDAL_024",
            impregnable_defense         = "MEDAL_029",
            power_is_everything         = "MEDAL_030",
            someone_worth_following     = "MEDAL_031",
            bourgeois_hunter            = "MEDAL_033",
            explorer_of_the_eastlands   = "MEDAL_034",
            monster_phd                 = "MEDAL_035",
            seasoned_hunter             = "MEDAL_036",
            mini_crown_collector        = "MEDAL_038",
            mini_crown_master           = "MEDAL_039",
            giant_crown_collector       = "MEDAL_041",
            giant_crown_master          = "MEDAL_042",
            capture_pro                 = "MEDAL_043",
            monster_slayer              = "MEDAL_044",
            top_of_the_food_chain       = "MEDAL_045",
            hunters_united_forever      = "MEDAL_047",
            gossip_hunter               = "MEDAL_048"
            -- TODO: Add new Ascendance DLC achievements here.
        },
        weapon_type = {
            GREAT_SWORD         = "LONG_SWORD",
            SWORD_AND_SHIELD    = "SHORT_SWORD",
            DUAL_BLADES         = "TWIN_SWORD",
            LONG_SWORD          = "TACHI",
            HUNTING_HORN        = "WHISTLE",
            SWITCH_AXE          = "SLASH_AXE",
            CHARGE_BLADE        = "CHARGE_AXE",
            INSECT_GLAIVE       = "ROD"
        },
        log_id = {
            AWARD_UNLOCK    = "LOG_0132",
        },
        count_type_fixed = {
            TEMPERED_MONSTER = "VETERAN_HUNT",
            MULTIPLAYER_QUEST = "MULTI_QUEST_CLEAR",
            PALICO_ACCOMPANIED_QUEST = "OTOMO_ACCOMPANY_QUEST_CLEAR"
        }
    },
    special_item_required_rarity_tier = 5 -- This is actually 6, but the number is one lower.
}

---
--- Converts the in-game enum that matches the provided `type_name` as a table. If the provided `value_as_key` flag is true the name of the
--- enum field will be the key in the table and the enum value as the table value, otherwise these are reversed.
---
---@param type_name string The type name of the enum to make as a table.
---@param value_as_key? boolean [OPTIONAL] The flag used to determine if the generated table should use the enum value as the key. Defaults to false.
---@param should_cache? boolean [OPTIONAL] The flag used to determine if the generated table should be cached under the `sdk.cache.enum` table. Defaults to false.
---
---@return table enum_table The table that represents the converted in-game enum.
function sdk.enum_to_table(type_name, value_as_key, should_cache)
    -- Call the find type definition from the sdk with the provided type name to get the type definition.
    local type_def = sdk.find_type_definition(type_name)
    if not type_def then
        -- Return an empty table if the type definition was not found.
        return {}
    end

    -- Check if the provided optional value as key flag is nil.
    if value_as_key == nil then
        -- If yes, then set the value as key flag as false by default.
        value_as_key = false
    end

    -- Check if the provided optional should cache flag is nil.
    if should_cache == nil then
        -- If yes, then set the should cache flag as false by default.
        should_cache = false
    end

    -- Get the fields from the type definition.
    local fields = type_def:get_fields()

    -- Create an empty table to build the enum.
    local enum_table = {}

    -- Iterate over each ipair for the fields, discarding the index.
    for _, field in ipairs(fields) do
        -- Check if the current field is static.
        if field:is_static() then
            -- If yes, then get the name and data (use nil since it is static) of the current field.
            local name = field:get_name()
            local data = field:get_data(nil)

            -- Check if the provided value as key flag is true.
            if value_as_key then
                -- If yes, then use the field value (data) as the key in the table and set the table value as the field name.
                enum_table[data] = name
            else
                -- Use the field name as the key in the table and set the table value as the field value (data).
                enum_table[name] = data
            end
        end
    end

    -- Check if the should cache flag is true AND this type is not already cached.
    if should_cache and not sdk.cache.enum[type_name] then
        -- If yes, then cache the generated enum table under the `sdk.cache.enum` table.
        sdk.cache.enum[type_name] = enum_table
    end

    -- Return the populated enum table.
    return enum_table
end

sdk.cache.enum = {
    -- `via.Language`: The enum that defines the language options in-game (used for localization).
    ---@type table<string, number>
    game_language_option = sdk.enum_to_table(constants.enum_name.game_language_option),

    -- `app.EnemyDef.ID`: The enum that defines the id for each large monster, small monster, endemic life, and aquatic life in the game.
    ---@type table<string, number>
    enemy_def_id = sdk.enum_to_table(constants.enum_name.enemy_def_id),

    -- `app.EnemyDef.ID_Fixed`: The enum that defines the fixed id for each large monster, small monster, endemic life, and aquatic life in the game. Using the fixed id as the key.
    ---@type table<number, string>
    enemy_def_id_fixed_lookup = sdk.enum_to_table(constants.enum_name.enemy_def_id_fixed, true),

    -- `app.EnemyReportState.STATE`: The enum that defines the enemy report state.
    ---@type table<string, number>
    enemy_report_state = sdk.enum_to_table(constants.enum_name.enemy_report_state),
    --[[ For reference:
        namespace app::EnemyReportState {
            enum STATE {
                NONE = 0,
                UNKNOWN = 1,
                KNOWN = 2,
            };
        }
    ]]

    -- `app.WeaponDef.TYPE`: The enum that defines the weapon types.
    ---@type table<string, number>
    weapon_type = sdk.enum_to_table(constants.enum_name.weapon_type),
    --[[ For reference:
        namespace app::WeaponDef {
            enum TYPE {
                INVALID = -1,
                LONG_SWORD = 0, -- Greatsword
                SHORT_SWORD = 1,-- Sword & Shield
                TWIN_SWORD = 2, -- Dual Blades
                TACHI = 3,      -- Longsword
                HAMMER = 4,
                WHISTLE = 5,    -- Hunting Horn
                LANCE = 6,
                GUN_LANCE = 7,
                SLASH_AXE = 8,  -- Switch axe
                CHARGE_AXE = 9, -- Charge Blade
                ROD = 10,       -- Insect Glaive
                BOW = 11,
                HEAVY_BOWGUN = 12,
                LIGHT_BOWGUN = 13,
                MAX = 14,
            };
        }
    ]]

    -- `app.ItemDef.ID`: The enum that defines the id for each item in the game.
    ---@type table<string, number>
    item_id = sdk.enum_to_table(constants.enum_name.item_id),

    -- `app.ItemDef.ID_Fixed`: The enum that defines the fixed id for each item in the game. Using the fixed id as the key.
    ---@type table<number, string>
    item_id_fixed_lookup = sdk.enum_to_table(constants.enum_name.item_id_fixed, true),

    -- `app.ItemDef.TYPE`: The enum that defines the type of an item in the game.
    ---@type table<string, number>
    item_type = sdk.enum_to_table(constants.enum_name.item_type),

    -- `app.ItemDef.TYPE`: The enum that defines the type of an item in the game. Using the fixed id as the key.
    ---@type table<number, string>
    item_type_lookup = sdk.enum_to_table(constants.enum_name.item_type, true),

    -- `app.ItemDef.ITEM_GROUP`: The enum that defines the group of an item in the game. Using the fixed id as the key.
    ---@type table<number, string>
    item_group_lookup = sdk.enum_to_table(constants.enum_name.item_group, true),

    -- `app.ItemDef.RARE`: The enum that defines the rarity tier of an item in the game. Using the fixed id as the key.
    ---@type table<number, string>
    item_rare_lookup = sdk.enum_to_table(constants.enum_name.item_rare, true),

    -- `app.HunterProfileDef.MEDAL_ID`: The enum that defines the id for each award/medal in the game.
    ---@type table<string, number>
    award_id = sdk.enum_to_table(constants.enum_name.award_id),

    -- `app.HunterProfileDef.MEDAL_ID_Fixed`: The enum that defines the fixed id for each award/medal in the game.
    ---@type table<string, number>
    award_fixed_id = sdk.enum_to_table(constants.enum_name.award_id_fixed),

    -- `app.HunterProfileDef.MEDAL_ID_Fixed`: The enum that defines the fixed id for each award/medal in the game. Using the fixed id as the key.
    ---@type table<number, string>
    award_id_fixed_lookup = sdk.enum_to_table(constants.enum_name.award_id_fixed, true),

    -- `app.HunterProfileDef.COUNT_TYPE_Fixed`: The enum that defines what the type of thing being counted by a counter is.
    ---@type table<string, number>
    count_type_fixed = sdk.enum_to_table(constants.enum_name.count_type_fixed),
    --[[ For reference:
        namespace app::HunterProfileDef {
            enum COUNT_TYPE_Fixed {
                VETERAN_HUNT = 0,
                GUEST_SOS_QUEST_CLEAR = 1,
                MULTI_QUEST_CLEAR = 2,
                FOLLOW = 3,
                OTOMO_ACCOMPANY_QUEST_CLEAR = 4,
                CIRCLE = 5,
                FISHING = 6,
                GRILL = 7,
                CAMPFIRE_COOKING = 8,
                RIDE = 9,
                STEALTH = 10,
                WEAK_ATTACK = 11,
                TENT_CUSTOMIZE = 12,
                LOOK_GOLD_CROWN = 13,
                SEIKRET_CUSTOMIZE = 15,
                SUPPORT_CAT_LEADER = 16,
                MORIVER_GRILL = 17,
                ACTIVITY_BOARD = 18,
                ONLINE_LOBBY = 19,
                BOWLING_CLEAR = 20,
                BOWLING_S_CLEAR = 21,
                MAX = 14,
            }
        }
    ]]

    -- `app.ChatDef.LOG_ID`: The enum that defines the type of notification displayed through the in-game notification system.
    ---@type table<string, number>
    log_id = sdk.enum_to_table(constants.enum_name.log_id)
}

---
--- Iterates through the provided name map and re-names certain entries from the provided enum table to have more friendly names.
--- 
---@param enum_table table The enum table to have entries re-named in.
---@param name_map table<string, string> The map of friendly and enum names to go through.
local function rename_enum_entries(enum_table, name_map)
    for friendly_name, enum_name in pairs(name_map) do
        enum_table[friendly_name] = enum_table[enum_name]
        enum_table[enum_name] = nil
    end
end
rename_enum_entries(sdk.cache.enum.award_fixed_id, sdk_constants.name_maps.award_fixed_id)
rename_enum_entries(sdk.cache.enum.weapon_type, sdk_constants.name_maps.weapon_type)
rename_enum_entries(sdk.cache.enum.log_id, sdk_constants.name_maps.log_id)
rename_enum_entries(sdk.cache.enum.count_type_fixed, sdk_constants.name_maps.count_type_fixed)

--- Populates the `sdk.cache.debug.award` with award information.
local function build_award_debug_info()
    for award_id_fixed, award_id_enum in pairs(sdk.cache.enum.award_id_fixed_lookup) do
        local award = {
            id = sdk.get_id_from_fixed(resource_type.Award, award_id_fixed),
            id_fixed = award_id_fixed,
            id_enum = award_id_enum,
            localization = {}
        }

        for language, language_id in pairs(sdk.cache.enum.game_language_option) do
            local description_guid = sdk.cache.game_function.get_award_description_guid:call(nil, award.id)

            award.localization[language] = {
                name = sdk.get_name(resource_type.Award, award.id, language_id),
                description = sdk.get_localized_text(description_guid, language_id)
            }
        end

        table.insert(sdk.cache.debug.award, award)
    end
end

--- Populates the `sdk.cache.debug.monster` with monster information.
local function build_monster_debug_info()
    local enemy_manager = sdk.get_managed_singleton(constants.type_name.enemy_manager)

    if enemy_manager then
        local enemy_manager_settings = enemy_manager:call("get_Setting")
        if enemy_manager_settings then
            local enemy_param_size = enemy_manager_settings:call("get_Size")

            for enemy_fixed_id, enemy_enum_id in pairs(sdk.cache.enum.enemy_def_id_fixed_lookup) do
                local enemy_id = sdk.get_id_from_fixed(resource_type.Enemy, enemy_fixed_id)
                local enemy_name = sdk.get_name(resource_type.Enemy, enemy_id)

                ---@type table
                local monster = nil

                if not string.is_null_or_whitespace(enemy_name) then
                    local is_animal = sdk.cache.game_function.is_animal:call(nil, enemy_id)
                    local is_fish = sdk.cache.game_function.is_fish:call(nil, enemy_id)

                    if not is_animal and not is_fish then
                        local size_data = enemy_param_size:call("getSizeData(app.EnemyDef.ID)", enemy_id)
                        if size_data then
                            local is_disable_random = size_data:call("get_IsDisableRandom")

                            monster = {
                                id = enemy_id,
                                id_fixed = enemy_fixed_id,
                                id_enum = enemy_enum_id,
                                name = enemy_name,
                                is_disable_random = is_disable_random,
                                size_mini = "N/A",
                                size_gold = "N/A"
                            }

                            if not is_disable_random then
                                local mini_size = size_data:call("get_CrownSize_Small")
                                local gold_size = size_data:call("get_CrownSize_King")

                                monster.size_mini = mini_size
                                monster.size_gold = gold_size
                            end
                        end
                    end
                end

                if monster then
                    table.insert(sdk.cache.debug.monster, monster)
                end
            end
        end
    end
end

--- Populates the `sdk.cache.debug` table with debug information.
function sdk.populate_debug_info()
    build_award_debug_info()
    build_monster_debug_info()
end

--- Populates certain tables in the `constants.reference` table.
function sdk.populate_constants_reference_values()
    for item_id_fixed, _ in pairs(sdk.cache.enum.item_id_fixed_lookup) do
        local id = sdk.get_id_from_fixed(resource_type.Item, item_id_fixed)
        local type = sdk.cache.game_function.item_get_type:call(nil, id)
        local rarity_tier = sdk.cache.game_function.item_rare:call(nil, id)

        if type == sdk.cache.enum.item_type.POINT and rarity_tier >= sdk_constants.special_item_required_rarity_tier then
            constants.reference.special_item[id] = true
        end
    end

    -- Get the enemy manager managed singleton.
    local enemy_manager = sdk.get_managed_singleton(constants.type_name.enemy_manager)
    if enemy_manager then
        -- Get the enemy manager settings.
        local enemy_manager_settings = enemy_manager:call("get_Setting")
        if enemy_manager_settings then
            -- Get the enemy param size from the enemy manager settings.
            local enemy_param_size = enemy_manager_settings:call("get_Size")
            if enemy_param_size then
                -- Iterate over each enemy fixed id in the enemy def id table.
                for enemy_fixed_id, _ in pairs(sdk.cache.enum.enemy_def_id_fixed_lookup) do
                    -- Get the corresponding enemy id and localized name for the current enemy fixed id.
                    local enemy_id = sdk.get_id_from_fixed(resource_type.Enemy, enemy_fixed_id)
                    local enemy_name = sdk.get_name(resource_type.Enemy, enemy_id)

                    -- Check if the localized enemy name is NOT null or whitespace (meaning its a enemy not fuly implemented yet).
                    if not string.is_null_or_whitespace(enemy_name) then
                        local is_animal = sdk.cache.game_function.is_animal:call(nil, enemy_id)
                        local is_fish = sdk.cache.game_function.is_fish:call(nil, enemy_id)

                        -- Check if the current enemy id is NOT an animal AND NOT a fish.
                        if not is_animal and not is_fish then
                            -- Get the size data for the current enemy id.
                            local size_data = enemy_param_size:call("getSizeData(app.EnemyDef.ID)", enemy_id)
                            if size_data then
                                -- Call the get is disable random function on the size data.
                                local is_disable_random = size_data:call("get_IsDisableRandom")

                                -- Check if the is disable random flag is NOT true (is false), meaning the size can vary.
                                if not is_disable_random then
                                    local mini_size = size_data:call("get_CrownSize_Small")
                                    local gold_size = size_data:call("get_CrownSize_King")

                                    -- Add a new entry into the crown target table using the enemy fixed id as the key and storing the mini and gold crown size requirements.
                                    constants.reference.crown_target[enemy_fixed_id] = {
                                        ["mini_size"] = mini_size,
                                        ["gold_size"] = gold_size
                                    }

                                    if constants.reference.base_monster[enemy_fixed_id] then
                                        constants.reference.base_crown_target[enemy_fixed_id] = {
                                            ["mini_size"] = mini_size,
                                            ["gold_size"] = gold_size
                                        }
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

---
--- Get the corresponding id to the provided fixed id.
---
---@param game_resource_type ResourceType The type of resource the id is associated with.
---@param fixed_id number The fixed id to get the id for.
---
---@return number id The id that corresponds to the provided fixed id.
function sdk.get_id_from_fixed(game_resource_type, fixed_id)
    local config = sdk_constants.resource_type_config[game_resource_type]
    assert(config, string.format("The provided 'game_resource_type' (value = '%i'), does not have a matching resource_type_config.", game_resource_type))

    return config.get_id_func(fixed_id)
end

---
--- Gets the localized text for the provided language resource guid, if the guid is not found an empty string is returned.
--- It will localize to the provided language option if given and valid, otherwise using the system language.
---
---@param resource_guid userdata The language resource `System.Guid` to get the localized text for.
---@param language_option? number [OPTIONAL] The language to get the localized text in. If not provided or invalid (doesn't exist in `via.Language`) it will default to trying to get the language of the system.
---
---@return string localized_text The string that represents the localized text for the provided resource guid (if any).
function sdk.get_localized_text(resource_guid, language_option)
    -- Check if the provided resource guid is null (nil).
    if not resource_guid then
        -- If yes, then return an empty string since no text can be found.
        return ""
    end

    -- Assert the provided resource guid is a userdata (lua type).
    assert(type(resource_guid) == "userdata", "The provided 'resource_guid' must be a Lua `userdata` object.")

    -- Get the game type and full name from the provided resource guid.
    local game_type = resource_guid:get_type_definition()
    local game_type_full_name = game_type:get_full_name()

    -- Assert the provided resource guid is a `System.Guid` game object.
    assert(game_type_full_name == "System.Guid", "The provided 'resource_guid' must be a `System.Guid` game object.")

    -- Check if the provided language option is null (nil) OR is not found in the game language option enum.
    if language_option == nil or not table.find_key(sdk.cache.enum.game_language_option, language_option) then
        -- If yes, then get the gui manager managed singleton.
        local gui_manager = sdk.get_managed_singleton("app.GUIManager")

        -- Check if the gui manager was NOT found.
        if not gui_manager then
            -- If yes, then return the result of calling the get message function (with no language).
            return sdk.cache.game_function.get_message:call(nil, resource_guid)
        end

        -- Get the language option by calling the get system language to app function on the gui manager.
        language_option = gui_manager:call("getSystemLanguageToApp")

        -- Check AGAIN if the provided language option is null (nil) OR is not found in the game language option enum.
        if language_option == nil or not table.find_key(sdk.cache.enum.game_language_option, language_option) then
            -- If yes, then return the result of calling the get message function (with no language).
            return sdk.cache.game_function.get_message:call(nil, resource_guid)
        end
    end

    -- Return the result of calling the get message with language function.
    return sdk.cache.game_function.get_message_with_lang:call(nil, resource_guid, language_option)
end

---
--- Get the localized name of the game resource type associated with the provided id.
--- Defaults to English if none or an invalid language option is selected.
---
---@param game_resource_type ResourceType The type of resource the id is associated with.
---@param id number The id of game resource to get the name for.
---@param language_option? number [OPTIONAL] The language to get the localized text in. If not provided or invalid (doesn't exist in `via.Language`) it will default to trying to get the language of the system.
---
---@return string name The localized name of the game resource associated with the provided id.
function sdk.get_name(game_resource_type, id, language_option)
    local config = sdk_constants.resource_type_config[game_resource_type]
    assert(config, string.format("The provided 'game_resource_type' (value = '%i'), does not have a matching resource_type_config.", game_resource_type))

    if language_option == nil then
        language_option = sdk.cache.enum.game_language_option.English
    end

    local name_cache = config.cache[id]
    if not name_cache then
        name_cache = {}
        config.cache[id] = name_cache
    elseif name_cache[language_option] then
        return name_cache[language_option]
    end

    local name_guid = config.get_guid_func:call(nil, id)
    local name = sdk.get_localized_text(name_guid, language_option)

    -- Check if the found item name is null (nil) or whitespace.
    if string.is_null_or_whitespace(name) then
        -- If yes, then just set the award name as the english name.
        name = sdk.get_localized_text(name_guid, sdk.cache.enum.game_language_option.English)
    end

    config.cache[id][language_option] = name

    return name
end

---
--- Gets the internal number value from the provide `via.rds.Mandrake` object.
---
---@param mandrake userdata The `via.rds.Mandrake` object to extract the value from.
---
---@return number mandrake_value The number that represents the inner value of the provided mandrake.
function sdk.get_mandrake_value(mandrake)
    -- Check if the provided mandrake is null (nil).
    if not mandrake then
        -- If yes, then return 0.
        return 0
    end

    -- Assert the provided mandrake is a userdata (lua type).
    assert(type(mandrake) == "userdata", "The provided 'mandrake' must be a Lua `userdata` object.")

    -- Get the game type and full name from the provided mandrake.
    local game_type = mandrake:get_type_definition()
    local game_type_full_name = game_type:get_full_name()

    -- Assert the provided mandrake is a `via.rds.Mandrake` game object.
    assert(game_type_full_name == constants.type_name.mandrake, "The provided 'mandrake' must be a `" .. constants.type_name.mandrake .. "` game object.")

    -- Return the result of calling the get mandrake value function using the provided mandrake.
    return sdk.cache.game_function.get_mandrake_value:call(nil, mandrake)
end

---
--- Gets the value of the provided bitset as a table of ids (which can be mapped to their associated enum with the provided enum type name).
---
---@param bitset userdata|table The `ace.Bitset` object to extract the values from. Can also be a special wrapped pseudo bitset.
---@param enum_type_name string? [OPTIONAL] The type name of the associated enum (if any). When provided and valid, the ids will be instead returned as the enum name. Defaults to an empty string.
---@param id_as_key boolean? [OPTIONAL] The flag used to determine if the id entries in the final table will use the id itself as the key (and value). Has no effect if a valid enum type name is provided or found. Defaults to false.
---
---@return table bitset_value The table that represents the collection of ids (or enum names if a valid enum type name was found) that were added in the bitset.
function sdk.get_bitset_value(bitset, enum_type_name, id_as_key)
    -- Check if the provided bitset is null (nil).
    if not bitset then
        -- If yes, then return an empty table.
        return {}
    end

    -- Determine if the provided bitset is a wrapped pseudo bitset.
    local is_pseudo_bitset = type(bitset) == "table" and bitset.pseudo_bitset

    -- Assert the provided pseudo bitset is a userdata (lua type).
    assert(type(bitset) == "userdata" or is_pseudo_bitset,
        "The provided 'bitset' must be a Lua `userdata` object OR a formatted pseudo bitset Lua `table` object.")

    -- Check if the is pseudo bitset flag is false.
    if not is_pseudo_bitset then
        -- If yes, then get the game type and full name from the provided bitset.
        local game_type = bitset:get_type_definition()
        local game_type_full_name = game_type:get_full_name()

        -- Assert the provided bitset is a `ace.Bitset` game object.
        assert(string.start_with(game_type_full_name, "ace.Bitset"), "The provided 'bitset' must be some form of `ace.Bitset` game object.")

        -- Check if the provided enum type name is null (nil) or whitespace AND the game type full name is NOT just `ace.BitSet` (meaning it contains an inner enum type like `ace.Bitset`1<app.MyEnum>`).
        if string.is_null_or_whitespace(enum_type_name) and game_type_full_name ~= "ace.Bitset" then
            -- If yes, then attempt to extract the inner enum type from the game type full name.
            local extracted_enum_type_name = string.match(game_type_full_name, "^ace%.Bitset`1%<(.-)%>$")

            -- Check if the extracted enum type name is NOT null (nil) or whitespace.
            if not string.is_null_or_whitespace(extracted_enum_type_name) then
                -- If yes, then overwrite the provided enum type name to the extracted enum type name.
                enum_type_name = extracted_enum_type_name
            end
        end
    end

    -- Check if the provided id as key flag is nil.
    if id_as_key == nil then
        -- If yes, then set it as false by default.
        id_as_key = false
    end

    -- Get the value and max element fields from the provided bitset.
    local values = bitset:get_field("_Value")
    local max_element = bitset:get_field("_MaxElement")

    -- Create a new table to store all matching positions (ids of things added into the bitset).
    local positions = {}

    -- Iterate over each of the values.
    for index, re_managed_value in pairs(values) do
        -- Convert the RE managed value (`REManagedObject`) into a lua number.
        local value = tonumber(re_managed_value:call("ToString"))

        -- Check if this is for a pseudo bitset.
        if is_pseudo_bitset then
            -- If yes, then decrement the index by 1 since Lua starts at 1 instead of 0.
            index = index - 1
        end

        -- Calculate the bit position using the current index.
        local bit_position = index * 32

        -- Continue to loop while the value is larger than 0.
        while value > 0 do
            -- Check if the value bit and-ed with 1 is NOT 0.
            if value & 1 ~= 0 then
                if id_as_key then
                    positions[bit_position] = bit_position
                else
                    -- If yes, then insert the current bit position.
                    table.insert(positions, bit_position)
                end
            end

            -- Bit shift the value right by 1.
            value = value >> 1

            -- Increment the bit position by 1.
            bit_position = bit_position + 1
        end
    end

    -- Check if there were no positions found.
    if table.length(positions) < 1 then
        -- If yes, then return an empty table.
        return {}
    end

    --if math.max(table.unpack(positions)) >= max_element then
        -- TODO: Handle any values going over the max element.
    --end

    -- Check if the provided (or overwritten) enum type name is NOT null (nil) or whitespace.
    if not string.is_null_or_whitespace(enum_type_name) then
        -- If yes, then attempt to get the enum table from the `sdk.cache.enum` table for the enum type name.
        local enum_table = sdk.cache.enum[enum_type_name]

        -- Check if there was no existing enum table with that type name.
        if not enum_table then
            -- If yes, then generate and cache the enum table for this enum type name.
            enum_table = sdk.enum_to_table(enum_type_name, true, true)

            -- Check if there is still no associated enum table. 
            if not enum_table then
                -- If yes, then just return the table of positions.
                return positions
            end
        end

        -- Create a new table to store the final result of mapping the id to their enum name.
        local result = {}

        -- Iterate over each of the ids in the found positions.
        for _, id in pairs(positions) do
            -- Insert the enum name for the current id into the result table.
            table.insert(result, enum_table[id])
        end

        -- Return the populated results table.
        return result
    end

    -- Return the table of positions.
    return positions
end

---
--- Gets the value of the provided pseudo bitset as a table of ids (which can be mapped to their associated enum with the provided enum type name).
---
---@param pseudo_bitset userdata The game object (acting as a pseudo `ace.Bitset`) to attempt to extract the inner value from.
---@param enum_type_name string? [OPTIONAL] The type name of the associated enum (if any). When provided and valid, the ids will be instead returned as the enum name. Defaults to an empty string.
---@param id_as_key boolean? [OPTIONAL] The flag used to determine if the id entries in the final table will use the id itself as the key (and value). Has no effect if a valid enum type name is provided or found. Defaults to false.
---
---@return table pseudo_bitset_value The table that represents the collection of ids (or enum names if a valid enum type name was found) that were added in the pseudo bitset.
function sdk.get_pseudo_bitset_value(pseudo_bitset, enum_type_name, id_as_key)
    -- Check if the provided pseudo bitset is null (nil).
    if not pseudo_bitset then
        -- If yes, then return an empty table.
        return {}
    end

    -- Assert the provided pseudo bitset is a userdata (lua type).
    assert(type(pseudo_bitset) == "userdata", "The provided 'pseudo_bitset' must be a Lua `userdata` object.")

    -- Get the game type and full name from the provided pseudo bitset.
    local game_type = pseudo_bitset:get_type_definition()
    local game_type_full_name = game_type:get_full_name()

    -- Assert the game type full name of the provided pseudo bitset is one of the game number types.
    assert(table.find_key(sdk_constants.game_number_types, game_type_full_name) ~= nil,
        string.format("The provided 'pseudo_bitset' must be a game number type (%s) object.", table.concat(sdk_constants.game_number_types, ", ")))

    -- Create a wrapper for the pseudo_bitset so it will work in the get bitset value function.
    local bitset_wrapper = {
        pseudo_bitset = true,
        value = pseudo_bitset
    }
    -- TODO: Make this into a custom class?

    -- Add the get field colon function that will be called in the get bitset value function.
    function bitset_wrapper:get_field(field_name)
        if field_name == "_Value" then
            return { self.value }
        else
            return math.maxinteger
        end
    end

    -- Return the result of the get bitset value function using the created bitset wrapper.
    return sdk.get_bitset_value(bitset_wrapper, enum_type_name, id_as_key)
end

---
--- Creates an `ace.cGUIMessageInfo` managed object containing the provided message text.
---
---@param message_text string The text to create as an `ace.cGUIMessageInfo` managed object.
---
---@return userdata gui_message The created `ace.cGUIMessageInfo` managed object.
function sdk.create_gui_message(message_text)
    -- Create a new instance of a gui message info managed object.
    local gui_message = sdk.create_instance(constants.type_name.gui_message_info):add_ref()
    if not gui_message then
        -- Throw an error if it was not created properly.
        error("`" .. constants.type_name.gui_message_info .. "` failed to be created.")
    end

    -- Call the set message info function on the gui message info and use the provided message text as the parameter.
    gui_message:call("setMessageInfo(System.String)", message_text)

    -- Return the gui message info managed object.
    return gui_message
end

local function vector_tostring(vector, vector_type, indent_level)
    -- Assert the provided vector is a userdata (lua type).
    assert(type(vector) == "userdata", "The provided 'vector' must be a Lua `userdata` object.")

    -- Assert the provided mandrake is a `via.vec2`, `via.vec3`, or `via.vec4` game object.
    assert(vector_type == "via.vec2" or vector_type == "via.vec3" or vector_type == "via.vec4",
        "The provided 'vector' must be a `via.vec2`, `via.vec3`, or `via.vec4` game object.")

    -- Create a table to store each string part to be concat'ed at the end.
    local string_parts = {}

    -- Setup the indentation (spacing) for fields/values based on the provided indent level.
    local entry_indentation = string.format("%s%s", string.rep(sdk_constants.spacing, indent_level),
        sdk_constants.spacing)

    -- Insert the `x` and `y` fields and values. All vector types have these.
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"x": %s', vector.x))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"y": %s', vector.y))

    -- Check if the provided vector type is a `via.vec3` or `via.vec4`.
    if vector_type == "via.vec3" or vector_type == "via.vec4" then
        -- If yes, then insert the `z` fields and values since both types have them.
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"z": %s', vector.z))

        -- Check if the provided vector type is `via.vec4`.
        if vector_type == "via.vec4" then
            -- If yes, then insert the `w` fields that only it has.
            table.insert(string_parts, ",\n")
            table.insert(string_parts, entry_indentation)
            table.insert(string_parts, string.format('"w": %s', vector.w))
        end
    end

    -- Return the result of doing a concat on the string parts table.
    return table.concat(string_parts)
end

local function quaternion_tostring(quaternion, quaternion_type, indent_level)
    -- Assert the provided quaternion is a userdata (lua type).
    assert(type(quaternion) == "userdata", "The provided 'quaternion' must be a Lua `userdata` object.")

    -- Assert the provided quaternion is a `via.Quaternion` game object.
    assert(quaternion_type == "via.Quaternion", "The provided 'quaternion' must be a `via.Quaternion` object.")

    -- Create a table to store each string part to be concat'ed at the end.
    local string_parts = {}

    -- Setup the indentation (spacing) for fields/values based on the provided indent level.
    local entry_indentation = string.format("%s%s", string.rep(sdk_constants.spacing, indent_level), sdk_constants.spacing)

    -- Insert the `x`, `y`, `z`, and `w` fields and values.
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"x": %s', quaternion.x))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"y": %s', quaternion.y))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"z": %s', quaternion.z))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"w": %s', quaternion.w))

    -- Return the result of doing a concat on the string parts table.
    return table.concat(string_parts)
end

local function matrix_tostring(matrix, matrix_type, indent_level)
    -- Assert the provided matrix is a userdata (lua type).
    assert(type(matrix) == "userdata", "The provided 'matrix' must be a Lua `userdata` object.")

    -- Assert the provided mandrake is a `via.mat3`, or `via.mat4` game object.
    assert(matrix_type == "via.mat3" or matrix_type == "via.mat4", "The provided 'matrix' must be a `via.mat3`, or `via.mat4` object.")

    -- Create a table to store each string part to be concat'ed at the end.
    local string_parts = {}

    -- Setup the indentation (spacing) for fields/values based on the provided indent level.
    local entry_indentation = string.format("%s%s", string.rep(sdk_constants.spacing, indent_level), sdk_constants.spacing)

    -- Check if the provided matrix type is a `via.mat3`.
    if matrix_type == "via.mat3" then
        -- If yes, then insert all of the fields and values into the string parts table.
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m00": %s', matrix.m00))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m01": %s', matrix.m01))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m02": %s', matrix.m02))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"_pad0": %s', matrix._pad0))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m10": %s', matrix.m10))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m11": %s', matrix.m11))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m12": %s', matrix.m12))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"_pad1": %s', matrix._pad1))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m20": %s', matrix.m20))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m21": %s', matrix.m21))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m22": %s', matrix.m22))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"_pad2": %s', matrix._pad2))
    else -- matrix_type == "via.mat4"
        -- Insert all of the fields and values into the string parts table.
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m00": %s', matrix.m00))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m01": %s', matrix.m01))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m02": %s', matrix.m02))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m03": %s', matrix.m03))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m10": %s', matrix.m10))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m11": %s', matrix.m11))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m12": %s', matrix.m12))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m13": %s', matrix.m13))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m20": %s', matrix.m20))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m21": %s', matrix.m21))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m22": %s', matrix.m22))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m23": %s', matrix.m23))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m30": %s', matrix.m30))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m31": %s', matrix.m31))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m32": %s', matrix.m32))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m33": %s', matrix.m33))
    end

    -- Return the result of doing a concat on the string parts table.
    return table.concat(string_parts)
end

local function via_uint_tostring(via_uint, via_uint_type, indent_level)
    -- Assert the provided via uint is a userdata (lua type).
    assert(type(via_uint) == "userdata", "The provided 'via_uint' must be a Lua `userdata` object.")

    -- Assert the provided via uint is a `via.Uint2`, `via.Uint3`, or `via.Uint4` game object.
    assert(via_uint_type == "via.Uint2" or via_uint_type == "via.Uint3" or via_uint_type == "via.Uint4",
        "The provided 'vector' must be a `via.Uint2`, `via.Uint3`, or `via.Uint4` game object.")

    -- Create a table to store each string part to be concat'ed at the end.
    local string_parts = {}

    -- Setup the indentation (spacing) for fields/values based on the provided indent level.
    local entry_indentation = string.format("%s%s", string.rep(sdk_constants.spacing, indent_level),
        sdk_constants.spacing)

    -- Insert the `x` and `y` fields and values. All via uint types have these.
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"x": %s', via_uint.x))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"y": %s', via_uint.y))

    -- Check if the provided vector type is a `via.Uint3` or `via.Uint4`.
    if via_uint_type == "via.Uint3" or via_uint_type == "via.Uint4" then
        -- If yes, then insert the `z` fields and values since both types have them.
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"z": %s', via_uint.z))

        -- Check if the provided vector type is `via.Uint4`.
        if via_uint_type == "via.Uint4" then
            -- If yes, then insert the `w` fields that only it has.
            table.insert(string_parts, ",\n")
            table.insert(string_parts, entry_indentation)
            table.insert(string_parts, string.format('"w": %s', via_uint.w))
        end
    end

    -- Return the result of doing a concat on the string parts table.
    return table.concat(string_parts)
end

local function via_float_tostring(via_float, via_float_type, indent_level)
    -- Assert the provided via float is a userdata (lua type).
    assert(type(via_float) == "userdata", "The provided 'via_uint' must be a Lua `userdata` object.")

    -- Assert the provided via float is a `via.Float2`, `via.Float3`, or `via.Float4` game object.
    assert(via_float_type == "via.Float2" or via_float_type == "via.Float3" or via_float_type == "via.Float4",
        "The provided 'vector' must be a `via.Float2`, `via.Float3`, or `via.Float4` game object.")

    -- Create a table to store each string part to be concat'ed at the end.
    local string_parts = {}

    -- Setup the indentation (spacing) for fields/values based on the provided indent level.
    local entry_indentation = string.format("%s%s", string.rep(sdk_constants.spacing, indent_level),
        sdk_constants.spacing)

    -- Insert the `x` and `y` fields and values. All via uint types have these.
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"x": %s', via_float.x))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"y": %s', via_float.y))

    -- Check if the provided vector type is a `via.Float3` or `via.Float4`.
    if via_float_type == "via.Float3" or via_float_type == "via.Float4" then
        -- If yes, then insert the `z` fields and values since both types have them.
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"z": %s', via_float.z))

        -- Check if the provided vector type is `via.Float4`.
        if via_float_type == "via.Float4" then
            -- If yes, then insert the `w` fields that only it has.
            table.insert(string_parts, ",\n")
            table.insert(string_parts, entry_indentation)
            table.insert(string_parts, string.format('"w": %s', via_float.w))
        end
    end

    -- Return the result of doing a concat on the string parts table.
    return table.concat(string_parts)
end

local function via_float_matrix_tostring(via_float_matrix, via_float_matrix_type, indent_level)
    -- Assert the provided via float matrix is a userdata (lua type).
    assert(type(via_float_matrix) == "userdata", "The provided 'matrix' must be a Lua `userdata` object.")

    -- Assert the provided mandrake is a `via.Float3x3`, `via.Float3x4`, `via.Float4x3` or `via.Float4x4` game object.
    assert(via_float_matrix_type == "via.Float3x3" or via_float_matrix_type == "via.Float3x4" or via_float_matrix_type == "via.Float4x3" or via_float_matrix_type == "via.Float4x4",
        "The provided 'matrix' must be a `via.Float3x3`, `via.Float3x4`, `via.Float4x3` or `via.Float4x4` object.")

    -- Create a table to store each string part to be concat'ed at the end.
    local string_parts = {}

    -- Setup the indentation (spacing) for fields/values based on the provided indent level.
    local entry_indentation = string.format("%s%s", string.rep(sdk_constants.spacing, indent_level), sdk_constants.spacing)

    -- Insert the `m00`, `m01`, `m02` fields and values. All via float matrix types have these.
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"m00": %s', via_float_matrix.m00))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"m01": %s', via_float_matrix.m01))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"m02": %s', via_float_matrix.m02))
    table.insert(string_parts, ",\n")

    -- Check if the via float matrix type is either 3x4 or 4x4.
    if via_float_matrix_type == "via.Float3x4" or via_float_matrix_type == "via.Float4x4" then
        -- If yes, then insert the field and value for `m03`.
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m03": %s', via_float_matrix.m03))
        table.insert(string_parts, ",\n")
    end

    -- Insert the `m10`, `m11`, `m12` fields and values. All via float matrix types have these.
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"m10": %s', via_float_matrix.m10))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"m11": %s', via_float_matrix.m11))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"m12": %s', via_float_matrix.m12))
    table.insert(string_parts, ",\n")

    -- Check if the via float matrix type is either 3x4 or 4x4.
    if via_float_matrix_type == "via.Float3x4" or via_float_matrix_type == "via.Float4x4" then
        -- If yes, then insert the field and value for `m13`.
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m13": %s', via_float_matrix.m13))
        table.insert(string_parts, ",\n")
    end

    -- Insert the `m20`, `m21` and `m22` fields and values. All via float matrix types have these.
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"m20": %s', via_float_matrix.m20))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"m21": %s', via_float_matrix.m21))
    table.insert(string_parts, ",\n")
    table.insert(string_parts, entry_indentation)
    table.insert(string_parts, string.format('"m22": %s', via_float_matrix.m22))

    -- Check if the via float matrix type is either 3x4 or 4x4.
    if via_float_matrix_type == "via.Float3x4" or via_float_matrix_type == "via.Float4x4" then
        -- If yes, then insert the field and value for `m23`.
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m23": %s', via_float_matrix.m23))
        table.insert(string_parts, ",\n")
    end

    -- Check if the via float matrix type is either 4x3 or 4x4.
    if via_float_matrix_type == "via.Float4x3" or via_float_matrix_type == "via.Float4x4" then
        -- If yes, then insert the `m30`, `m31`, `m32` fields and values. All 4xN via float matrix types have these.
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m30": %s', via_float_matrix.m30))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m31": %s', via_float_matrix.m31))
        table.insert(string_parts, ",\n")
        table.insert(string_parts, entry_indentation)
        table.insert(string_parts, string.format('"m32": %s', via_float_matrix.m32))
        table.insert(string_parts, ",\n")

        -- Check if the via float matrix type is 4x4.
        if via_float_matrix_type == "via.Float4x4" then
            -- If yes, then insert the field and value for `m33`.
            table.insert(string_parts, entry_indentation)
            table.insert(string_parts, string.format('"m33": %s', via_float_matrix.m33))
        end
    end

    -- Return the result of doing a concat on the string parts table.
    return table.concat(string_parts)
end

local function managed_object_to_string_core(managed_object, indent_level, history)
    -- Create a table to store each string part to be concat'ed at the end.
    local string_parts = {}

    -- Setup the indentation (spacing) for the brackets and table entries based on the provided indent level.
    local bracket_indentation = string.rep(sdk_constants.spacing, indent_level)
    local entry_indentation = string.format("%s%s", bracket_indentation, sdk_constants.spacing)

    -- Define the opening and closing bracket as the ones used for an object.
    local opening_bracket = "{\n"
    local closing_bracket = "}"

    -- Get the type definition and full type name of the provided managed object.
    local managed_object_type = managed_object:get_type_definition()
    local managed_object_type_name = managed_object_type:get_full_name()

    -- Check if the provided list is contained within the provided history table.
    --if history[managed_object_type_name] then
    --    log.debug(string.format("Cycle detected for '%s', returning an empty string. History: %s", managed_object_type_name, table.tostring(history)))
    --    return ""
    --end

    -- Set the entry in the history table for the provided list as true.
    --history[managed_object_type_name] = true
    -- ^ This is not working correctly.

    -- Determine if the provided managed object game type is an array or not.
    local is_array = string.ends_with(managed_object_type_name, "[]")

    -- Check if the is array flag is true.
    if is_array then
        -- If yes, then update the opening and closing bracket as the ones used for an array.
        opening_bracket = "[\n"
        closing_bracket = "]"
    end

    -- Add the opening bracket into the string parts table.
    table.insert(string_parts, opening_bracket)

    -- Create a flag to track the first iteration.
    local is_first = true

    if is_array then
        local elements = managed_object:get_elements()

        for _, element in ipairs(elements) do
            -- Check if this is NOT the first iteration.
            if not is_first then
                -- If yes, then append the comma and new line character to prepare for the next entry.
                table.insert(string_parts, ",\n")
            else
                -- Set the is first flag to false.
                is_first = false
            end

            -- Add the indentation for the entry into the string parts table.
            table.insert(string_parts, entry_indentation)

            local lua_value_type = type(element)
            local game_type = element:get_type_definition()
            local game_type_full_name = game_type:get_full_name()

            if lua_value_type == "userdata" then
                if table.find_key(sdk_constants.game_number_types, game_type_full_name) ~= nil then
                    --log.debug(string.format('%s', tonumber(element:call("ToString"))))
                    table.insert(string_parts, string.format('%s', tonumber(element:call("ToString"))))
                elseif game_type_full_name == "System.Char" then
                    --log.debug(string.format('%s', element:call("ToString")))
                    table.insert(string_parts, string.format('%s', element:call("ToString")))
                elseif game_type_full_name == "System.String" then
                    --log.debug(string.format('"%s"', element:call("ToString")))
                    table.insert(string_parts, string.format('"%s"', element:call("ToString")))
                elseif game_type_full_name == constants.type_name.mandrake then
                    --log.debug(string.format('%s', sdk.get_mandrake_value(element)))
                    table.insert(string_parts, string.format('%s', sdk.get_mandrake_value(element)))
                elseif string.start_with(game_type_full_name, "ace.Bitset") then
                    --log.debug("array bitset")
                    table.insert(string_parts, table.tostring(sdk.get_bitset_value(element), indent_level + 1))
                else
                    --log.debug(string.format("Array entry is userdata, needs to recurse. Game Type = %s", game_type_full_name))
                    table.insert(string_parts, managed_object_to_string_core(element, indent_level + 1, history))
                end
            elseif lua_value_type == "string" then
                --log.debug(string.format('%s', element))
                table.insert(string_parts, string.format('"%s"', element))
            else
                --log.debug(string.format('%s', element))
                table.insert(string_parts, string.format('%s', element))
            end
        end
    else
        local managed_object_fields = managed_object_type:get_fields()

        for _, field in ipairs(managed_object_fields) do
            if not field:is_static() then
                -- Check if this is NOT the first iteration.
                if not is_first then
                    -- If yes, then append the comma and new line character to prepare for the next entry.
                    table.insert(string_parts, ",\n")
                else
                    -- Set the is first flag to false.
                    is_first = false
                end

                -- Add the indentation for the entry into the string parts table.
                table.insert(string_parts, entry_indentation)

                local name = field:get_name()
                local value = field:get_data(managed_object)
                local lua_value_type = type(value)
                local game_type = field:get_type()
                local game_type_full_name = game_type:get_full_name()

                --if game_type_full_name == "app.cNpcContext" then
                    --log.debug("------------------------")
                    --log.debug(string.format("Name = %s, Value = %s, Lua Type = %s, Game Type = %s, Game Type Full Name = %s", name, value, lua_value_type, game_type, game_type_full_name))
                --end

                -- Check if the provided list was NOT an array.
                if not is_array then
                    -- If yes, then add the key name into the string parts table.
                    table.insert(string_parts, string.format('"%s (%s)": ', name, game_type_full_name))
                end

                if lua_value_type == "userdata" then
                    if game_type_full_name == constants.type_name.mandrake then
                        --log.debug(string.format('"%s (%s)": %s', name, game_type_full_name, sdk.get_mandrake_value(value)))
                        table.insert(string_parts, string.format('%s', sdk.get_mandrake_value(value)))
                    elseif string.start_with(game_type_full_name, "ace.Bitset") then
                        local bitset_enum_type = ""
                        if sdk_constants.parent_type_and_field_name_to_enum_type_name_lookup[managed_object_type_name] then
                            bitset_enum_type = sdk_constants.parent_type_and_field_name_to_enum_type_name_lookup[managed_object_type_name][name]
                        end
                        --log.debug(string.format("       bitset field name = %s", name))
                        table.insert(string_parts, table.tostring(sdk.get_bitset_value(value, bitset_enum_type), indent_level + 1))
                    elseif game_type_full_name == "System.Guid" then
                        --log.debug(string.format('"%s (%s)": %s', name, game_type_full_name, value:call("ToString")))
                        table.insert(string_parts, string.format('"%s"', value:call("ToString")))
                    elseif game_type_full_name == "via.vec2" or game_type_full_name == "via.vec3" or game_type_full_name == "via.vec4" then
                        table.insert(string_parts, opening_bracket)
                        table.insert(string_parts, vector_tostring(value, game_type_full_name, indent_level + 1))
                        table.insert(string_parts, string.format("%s%s%s", "\n", entry_indentation, closing_bracket))
                    elseif game_type_full_name == "via.Quaternion" then
                        table.insert(string_parts, opening_bracket)
                        table.insert(string_parts, quaternion_tostring(value, game_type_full_name, indent_level + 1))
                        table.insert(string_parts, string.format("%s%s%s", "\n", entry_indentation, closing_bracket))
                    elseif game_type_full_name == "via.mat3" or game_type_full_name == "via.mat4" then
                        table.insert(string_parts, opening_bracket)
                        table.insert(string_parts, matrix_tostring(value, game_type_full_name, indent_level + 1))
                        table.insert(string_parts, string.format("%s%s%s", "\n", entry_indentation, closing_bracket))
                    elseif game_type_full_name == "via.Uint2" or game_type_full_name == "via.Uint3" or game_type_full_name == "via.Uint4" then
                        table.insert(string_parts, opening_bracket)
                        table.insert(string_parts, via_uint_tostring(value, game_type_full_name, indent_level + 1))
                        table.insert(string_parts, string.format("%s%s%s", "\n", entry_indentation, closing_bracket))
                    elseif game_type_full_name == "via.Float2" or game_type_full_name == "via.Float3" or game_type_full_name == "via.Float4" then
                        table.insert(string_parts, opening_bracket)
                        table.insert(string_parts, via_float_tostring(value, game_type_full_name, indent_level + 1))
                        table.insert(string_parts, string.format("%s%s%s", "\n", entry_indentation, closing_bracket))
                    elseif game_type_full_name == "via.Float3x3" or game_type_full_name == "via.Float3x4" or game_type_full_name == "via.Float4x3" or game_type_full_name == "via.Float4x4" then
                        table.insert(string_parts, opening_bracket)
                        table.insert(string_parts, via_float_matrix_tostring(value, game_type_full_name, indent_level + 1))
                        table.insert(string_parts, string.format("%s%s%s", "\n", entry_indentation, closing_bracket))
                    else
                        --log.debug(string.format("Is userdata, needs to recurse. Parent Type = %s, Game Type = %s", managed_object_type_name, game_type_full_name))
                        table.insert(string_parts, managed_object_to_string_core(value, indent_level + 1, history))
                    end
                elseif lua_value_type == "string" then
                    --log.debug(string.format('"%s (%s)": %s', name, game_type_full_name, value))
                    table.insert(string_parts, string.format('"%s"', value))
                else
                    --log.debug(string.format('"%s (%s)": %s', name, game_type_full_name, value))
                    table.insert(string_parts, string.format('%s', value))
                end

                -- if game type is userdata, recurively call this function
                --type_table[name] = raw_value
            end
        end
    end

    -- Add the newline character, indention for the bracket, and closing bracket into the string parts table.
    table.insert(string_parts, string.format("%s%s", "\n", bracket_indentation))
    table.insert(string_parts, closing_bracket)

    -- Return the result of doint a concat on the string parts table.
    return table.concat(string_parts)
end

function sdk.managed_object_to_string(managed_object)
    -- Assert the provided managed object is NOT null (nil).
    assert(managed_object ~= nil, "The provided 'managed_object' must NOT be nil.")

    -- Assert the provided managed object is a userdata object.
    assert(type(managed_object) == "userdata", "The provided 'managed_object' must be a Lua `userdata` object.")

    -- Return the result of the private internal to string core function with 0 indent and an empty history.
    return managed_object_to_string_core(managed_object, 0, {}) --, {})
    -- add history check somehow?
end
-- ^ Mainly used for testing and debugging purposes.