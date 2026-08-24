---@meta

--- Constants to be used throughout the application.
local constants <const> = {
    -- The name of the mod.
    mod_name = "Achievement Progress Tracker",

    -- The directory path for the mod.
    directory_path = "Achievement_Progress_Tracker",

    -- The default fonts directory path for REFramework
    fonts_path = "fonts",

    -- The standard options to use within a color picker without alpha.
    color_picker_options =
        1 << 1      --[[ No Alpha ]]
        | 1 << 3    --[[ No Options ]]
        | 1 << 20   --[[ Display RGB Value Fields ]]
        | 1 << 22,  --[[ Display Hex Value Field ]]

    -- The standard options to use within a color picker with alpha.
    color_picker_options_with_alpha = 1 << 3  --[[ No Options ]]
        | 1 << 16   --[[ Display Alpha Bar ]]
        | 1 << 18   --[[ Display Alpha Current Preview ]]
        | 1 << 20   --[[ Display RGB Value Fields ]]
        | 1 << 22,  --[[ Display Hex Value Field ]]

    -- The dropdown options for the size of the achievement trackers.
    size_option = {
        -- The tiny size option, this will NOT include the description.
        tiny = 0,

        -- The small size option, this will NOT include the description.
        small = 1,

        -- The medium size option, this will include the description.
        medium = 2,

        -- The large size option, this will include the description.
        large = 3
    },

    -- The sources from where the values for an achievement tracker are pulled to update their value.
    update_source = {
        -- The `app.savedata.cUserSaveParam` update source.
        user_save_data = 1,

        -- The `app.savedata.cBasicParam` update source.
        basic_data = 2,

        -- The `app.savedata.cItemParam` update source.
        item_data = 3,

        -- The `app.savedata.cEquipParam` update source.
        equipment_data = 4,

        -- The `app.savedata.cCampSaveDataParam` update source.
        camp_data = 5,

        -- The `app.savedata.cHunterProfileParam` update source.
        hunter_profile = 6,

        -- The `app.savedata.cEnemyReportParam` update source.
        enemy_report = 7,

        -- The `app.MissionActivator` update source.
        mission_activator = 8
    },

    -- The method used to acquire the update value from the update source.
    acquisition_method = {
        -- The acquisition method that retrieves a field value from an update source.
        get_field = 1,

        -- The acquisition method that retrieves the result of calling a function on an update source.
        call = 2,

        -- The acquisition method that directly uses the update source. This can only be used with additional processing.
        pass_in = 3
    },

    -- The names for types within the game.
    type_name = {
        -- The Save Data Manager type name.
        save_data_manager = "app.SaveDataManager",

        -- The Mission Manager type name.
        mission_manager = "app.MissionManager",

        -- The Player Manager type name.
        player_manager = "app.PlayerManager",

        -- The Chat Manager type name.
        chat_manager = "app.ChatManager",

        -- The Enemy Manager type name.
        enemy_manager = "app.EnemyManager",

        -- The Analysis Log Service type name.
        analysis_log_service = "app.AnalysisLogService",

        -- The Network Context Manager type name.
        network_context_manager = "app.net_context_manager.cContextManager",

        -- The Quest Reward type name.
        quest_reward = "app.cQuestReward",

        -- The GUI Parts Quest Result Item type name.
        gui_quest_result = "app.cGUIPartsQuestResultItem",

        -- The Item Util type name.
        item_util = "app.ItemUtil",

        -- The Artian Util type name.
        artian_util = "app.ArtianUtil",

        -- The Enemy Report Util type name.
        enemy_report_util = "app.EnemyReportUtil",

        -- The Animal Util type name.
        animal_util = "app.AnimalUtil",

        -- The GUI Camp View Data type name.
        gui_camp_view_data = "app.cGUICampViewData",

        -- The Basic Param Save Data type name.
        basic_param = "app.savedata.cBasicParam",

        -- The Equip Param Save Data type name.
        equip_param = "app.savedata.cEquipParam",

        -- The Hunter Profile Param Save Data type name.
        hunter_profile_param = "app.savedata.cHunterProfileParam",

        -- The Gui Message type name.
        gui_message = "via.gui.message",

        -- The Gui Message Info type name.
        gui_message_info = "ace.cGUIMessageInfo",

        -- The Mandrake type name.
        mandrake = "via.rds.Mandrake",

        -- The Weapon Definition type name.
        weapon_def = "app.WeaponDef",

        -- The Armor Definition type name.
        armor_def = "app.ArmorDef",

        -- The Item Definition type name.
        item_def = "app.ItemDef",

        -- The Enemy Definition type name.
        enemy_def = "app.EnemyDef",

        -- The Hunter Profile Definition type name.
        hunter_profile_def = "app.HunterProfileDef"
    },

    -- The names for enums within the game.
    enum_name = {
        -- `via.Language.: The enum that defines the language options in-game (used for localization).
        game_language_option = "via.Language",

        -- `app.EnemyDef.ID`: The enum that defines the id for each large monster, small monster, endemic life, and aquatic life in the game.
        enemy_def_id = "app.EnemyDef.ID",

        -- `app.EnemyDef.ID_Fixed`: The enum that defines the fixed id for each large monster, small monster, endemic life, and aquatic life in the game.
        enemy_def_id_fixed = "app.EnemyDef.ID_Fixed",

        -- `app.EnemyReportState.STATE`: The enum that defines the enemy report state.
        enemy_report_state = "app.EnemyReportState.STATE",

        -- `app.WeaponDef.TYPE`: The enum that defines the weapon types.
        weapon_type = "app.WeaponDef.TYPE",

        -- `app.ItemDef.ID`: The enum that defines the id for each item in the game.
        item_id = "app.ItemDef.ID",

        -- `app.ItemDef.ID_Fixed`: The enum that defines the fixed id for each item in the game.
        item_id_fixed = "app.ItemDef.ID_Fixed",

        -- `app.ItemDef.TYPE`: The enum that defines the type of an item in the game.
        item_type = "app.ItemDef.TYPE",

        -- `app.ItemDef.ITEM_GROUP`: The enum that defines the gropu of an item in the game.
        item_group = "app.ItemDef.ITEM_GROUP",

        -- `app.ItemDef.RARE`: The enum that defines the rarity tier of an item in the game.
        item_rare = "app.ItemDef.RARE",

        -- `app.HunterProfileDef.MEDAL_ID`: The enum that defines the id for each award/medal in the game.
        award_id = "app.HunterProfileDef.MEDAL_ID",

        -- `app.HunterProfileDef.MEDAL_ID_Fixed`: The enum that defines the fixed id for each award/medal in the game.
        award_id_fixed = "app.HunterProfileDef.MEDAL_ID_Fixed",

        -- `app.HunterProfileDef.COUNT_TYPE_Fixed`: The enum that defines what the type of thing being counted by a counter is.
        count_type_fixed = "app.HunterProfileDef.COUNT_TYPE_Fixed",

        -- `app.ChatDef.LOG_ID`: The enum that defines the type of notification displayed through the in-game notification system.
        log_id = "app.ChatDef.LOG_ID"
    },

    -- The ids for the achievements being tracked (id is internal only, and not related to the in-game id).
    achievement = {
        -- The id for the `A True Hunter Is Never Satisfied` achievement.
        a_true_hunter = 1,

        -- The id for the `Hunters United Forever` achievement.
        hunters_united_forever = 2,

        -- The id for the `Someone Worth Following` achievement.
        someone_worth_following = 3,

        -- The id for the `Capture Pro` achievement.
        capture_pro = 4,

        -- The id for the `Monster Slayer` achievement.
        monster_slayer = 5,

        -- The id for the `Seasoned Hunter` achievement.
        seasoned_hunter = 6,

        -- The id for the `Top of the Food Chain` achievement.
        top_of_the_food_chain = 7,

        -- The id for the `East to West, A Hunter Never Rests` achievement.
        east_to_west = 8,

        -- The id for the `A-fish-ionado` achievement.
        a_fish_ionado = 9,

        -- The id for the `Campmaster` achievement.
        campmaster = 10,

        -- The id for the `Bourgeois Hunter` achievement.
        bourgeois_hunter = 11,

        -- The id for the `Gossip Hunter` achievement.
        gossip_hunter = 12,

        -- The id for the `Impregnable Defense` achievement.
        impregnable_defense = 13,

        -- The id for the `Power Is Everything` achievement.
        power_is_everything = 14,

        -- The id for the `Explorer of the Eastlands` achievement.
        explorer_of_the_eastlands = 15,

        -- The id for the `Monster Ph.D.` achievement.
        monster_phd = 16,

        -- The id for the `Miniature Crown Collector` achievement.
        mini_crown_collector = 17,

        -- The id for the `Miniature Crown Master` achievement.
        mini_crown_master = 18,

        -- The id for the `Giant Crown Collector` achievement.
        giant_crown_collector = 19,

        -- The id for the `Giant Crown Master` achievement.
        giant_crown_master = 20,

        -- The id for the `Eastward Wings` achievement.
        eastward_wings = 21

        -- TODO: Add new Ascendance DLC achievements here.
    },

    -- The reference values used for checking against achievements.
    reference = {
        -- The collection of medal fixed ids for award/medals in the base game that were included on release.
        ---@type table<number, boolean>
        base_award = {
            [1] = true,     -- "MEDAL_000", "Eastward Wings"
            [2] = true,     -- "MEDAL_001", "Windward Lands"
            [3] = true,     -- "MEDAL_002", "Shadow in the Downpour"
            [4] = true,     -- "MEDAL_003", "Guardians of the Forge"
            [5] = true,     -- "MEDAL_004", "Bringer of Harmony"
            [6] = true,     -- "MEDAL_005", "New Ecosystems"
            [7] = true,     -- "MEDAL_006", "A Bitter Environment"
            [8] = true,     -- "MEDAL_007", "Beyond the Black Wings"
            [9] = true,     -- "MEDAL_008", "One Corner of the World"
            [10] = true,    -- "MEDAL_009", "A True Hunter Is Never Satisfied"
            [11] = true,    -- "MEDAL_010", "Let the Investigations Begin!"
            [12] = true,    -- "MEDAL_011", "The Hunt Is On!"
            [13] = true,    -- "MEDAL_012", "A Step Toward Mutual Understanding"
            [14] = true,    -- "MEDAL_013", "East to West, A Hunter Never Rests"
            [15] = true,    -- "MEDAL_014", "Angling for a Bite"
            [16] = true,    -- "MEDAL_015", "Mmm, So Tasty!"
            [17] = true,    -- "MEDAL_016", "Was It a Meal to Remember?"
            [18] = true,    -- "MEDAL_017", "The Bigger They Are..."
            [19] = true,    -- "MEDAL_018", "Hunter-Assassin"
            [20] = true,    -- "MEDAL_019", "Hit 'Em Where It Hurts!"
            [21] = true,    -- "MEDAL_020", "A Prize Held High"
            [22] = true,    -- "MEDAL_021", "I Caught a Shooting Star!"
            [23] = true,    -- "MEDAL_022", "Monster (Squid) Hunter"
            [24] = true,    -- "MEDAL_023", "A-fish-ionado"
            [25] = true,    -- "MEDAL_024", "Campmaster"
            [26] = true,    -- "MEDAL_025", "Glamper"
            [27] = true,    -- "MEDAL_026", "A Keen-eyed Observation"
            [28] = true,    -- "MEDAL_027", "Ride-or-die Companion"
            [29] = true,    -- "MEDAL_028", "Established Hunter"
            [30] = true,    -- "MEDAL_029", "Impregnable Defense"
            [31] = true,    -- "MEDAL_030", "Power Is Everything"
            [32] = true,    -- "MEDAL_031", "Someone Worth Following"
            [33] = true,    -- "MEDAL_032", "A Legacy Restored"
            [34] = true,    -- "MEDAL_033", "Bourgeois Hunter"
            [35] = true,    -- "MEDAL_034", "Explorer of the Eastlands"
            [36] = true,    -- "MEDAL_035", "Monster Ph.D."
            [37] = true,    -- "MEDAL_036", "Seasoned Hunter"
            [38] = true,    -- "MEDAL_037", "Miniature Crown"
            [39] = true,    -- "MEDAL_038", "Miniature Crown Collector"
            [40] = true,    -- "MEDAL_039", "Miniature Crown Master"
            [41] = true,    -- "MEDAL_040", "Giant Crown"
            [42] = true,    -- "MEDAL_041", "Giant Crown Collector"
            [43] = true,    -- "MEDAL_042", "Giant Crown Master"
            [44] = true,    -- "MEDAL_043", "Capture Pro"
            [45] = true,    -- "MEDAL_044", "Monster Slayer"
            [46] = true,    -- "MEDAL_045", "Top of the Food Chain"
            [47] = true,    -- "MEDAL_046", "Hunters United"
            [48] = true,    -- "MEDAL_047", "Hunters United Forever"
            [49] = true,    -- "MEDAL_048", "Gossip Hunter"
            [50] = true     -- "MEDAL_049", "Newly Forged Bonds"
        },

        -- The collection of medal fixed ids for award/medals in the Ascendance DLC.
        ---@type table<number, boolean>
        ascendance_award = {},

        -- The collection of enemy fixed ids that are considered apex predators.
        ---@type table<number, boolean>
        apex_predator = {
            [-1547364608] = true,   -- "EM0156_00_0", "Rey Dau"
            [1467998976] = true,    -- "EM0157_00_0", "Uth Duna"
            [1657778432] = true,    -- "EM0158_00_0", "Nu Udra"
            [1553456768] = true     -- "EM0162_00_0", "Jin Dahaad"
        },

        -- The collection of enemy fixed ids that are considered whoppers.
        ---@type table<number, boolean>
        whopper = {
            [-562596928] = true,        -- "EM5304_00_0", "Gastronome Tuna"
            [-1256137216] = true,       -- "EM5305_00_0", "Gajau"
            [1094277632] = true,        -- "EM5315_00_0", "Goliath Squid"
            [1380810112] = true,        -- "EM5312_00_0", "Speartuna"
            [-935735872] = true         -- "EM5316_00_0", "Great Trevally"
        },
        -- ^ For some reason this `isBigFish` function returns incorrect results until fish are actually loaded in the game.
        -- Like going to `Area 17: Great lake Shore` in the `Scarlet Forest`, until the function will return false for ALL fish.
        --[[
        -- Store a local reference to the 'isBigFish' function on the 'app.AnimalUtil' object.
        local is_big_fish_func = sdk.find_type_definition("app.AnimalUtil"):get_method("isBigFish(app.EnemyDef.ID)")

        -- Iterate over each entry in the enemy def ids.
        for string_em_id, id in pairs(sdk.cache.enum.enemy_def_id) do
            -- Call the is big fish function to determine if the current enemy id is considered a big fish.
            local is_big_fish = is_big_fish_func:call(nil, id)

            -- Check if the is big fish flag is true.
            if is_big_fish then
                -- If yes, then get the fixed id for the current string em id.
                local id_fixed = sdk.cache.enum.enemy_def_id_fixed_lookup[string_em_id]

                -- Set the entry for the fixed id that was found as true in the whopper table.
                constants.reference.whopper[id_fixed] = true
            end
        end
        ]]

        -- The collection of item fixed ids that are considered special. This is built dynamically on game start.
        ---@type table<number, boolean>
        special_item = {},

        -- The collection of enemy fixed ids for monsters in the base game that were included on release.
        ---@type table<number, boolean>
        base_monster = {
            [26] = true,                -- "EM0001_00_0", "Rathian"
            [1965232896] = true,        -- "EM0002_00_0", "Rathalos"
            [1411933184] = true,        -- "EM0002_50_0", "Guardian Rathalos"
            [-535078400] = true,        -- "EM0005_00_0", "Gravios"
            [402056736] = true,         -- "EM0008_00_0", "Yian Kut-Ku"
            [1049705664] = true,        -- "EM0009_00_0", "Gypceros"
            [-1440201088] = true,       -- "EM0021_00_0", "Congalala"
            [2129596800] = true,        -- "EM0022_00_0", "Blangonga"
            [-1363370496] = true,       -- "EM0070_00_0", "Nerscylla"
            [-758250816] = true,        -- "EM0071_00_0", "Gore Magala"
            [107194928] = true,         -- "EM0100_51_0", "Guardian Fulgur Anjanath"
            [1663995904] = true,        -- "EM0113_51_0", "Guardian Ebony Odogaron"
            [15] = true,                -- "EM0150_00_0", "Doshaguma"
            [-1916429696] = true,       -- "EM0150_50_0", "Guardian Doshaguma"
            [16] = true,                -- "EM0151_00_0", "Balahara"
            [33] = true,                -- "EM0152_00_0", "Chatacabra"
            [-34937520] = true,         -- "EM0153_00_0", "Quematrice"
            [-1528962176] = true,       -- "EM0154_00_0", "Lala Barina"
            [567628288] = true,         -- "EM0155_00_0", "Rompopolo"
            [-1547364608] = true,       -- "EM0156_00_0", "Rey Dau"
            [1467998976] = true,        -- "EM0157_00_0", "Uth Duna"
            [1657778432] = true,        -- "EM0158_00_0", "Nu Udra"
            [777460864] = true,         -- "EM0159_00_0", "Ajarakan"
            [746996864] = true,         -- "EM0160_00_0", "Arkveld"
            [-283654400] = true,        -- "EM0160_50_0", "Guardian Arkveld"
            [222933952] = true,         -- "EM0161_00_0", "Hirabami"
            [1553456768] = true,        -- "EM0162_00_0", "Jin Dahaad"
            [1401863296] = true,        -- "EM0163_00_0", "Xu Wu"
            [-2003468672] = true        -- "EM0164_50_0", "Zoh Shia"
        },

        -- The collection of enemy fixed ids for monsters that are crown targets. This is built dynamically on game start.
        crown_target = {},

        -- The collection of enemy fixed ids for base game monsters that are crown targets. This is built dynamically on game start.
        base_crown_target = {}
    }
}

-- The language directory path that contains all of the language files.
constants.language_directory_path = constants.directory_path .. "\\languages\\"

constants.debug_directory_path = constants.directory_path .. "\\debug\\"

-- The ids for the base game achievements being tracked.
constants.base_achievement = {
    -- The id for the `A True Hunter Is Never Satisfied` achievement.
    constants.achievement.a_true_hunter,

    -- The id for the `Hunters United Forever` achievement.
    constants.achievement.hunters_united_forever,

    -- The id for the `Someone Worth Following` achievement.
    constants.achievement.someone_worth_following,

    -- The id for the `Capture Pro` achievement.
    constants.achievement.capture_pro,

    -- The id for the `Monster Slayer` achievement.
    constants.achievement.monster_slayer,

    -- The id for the `Seasoned Hunter` achievement.
    constants.achievement.seasoned_hunter,

    -- The id for the `Top of the Food Chain` achievement.
    constants.achievement.top_of_the_food_chain,

    -- The id for the `East to West, A Hunter Never Rests` achievement.
    constants.achievement.east_to_west,

    -- The id for the `A-fish-ionado` achievement.
    constants.achievement.a_fish_ionado,

    -- The id for the `Campmaster` achievement.
    constants.achievement.campmaster,

    -- The id for the `Bourgeois Hunter` achievement.
    constants.achievement.bourgeois_hunter,

    -- The id for the `Gossip Hunter` achievement.
    constants.achievement.gossip_hunter,

    -- The id for the `Impregnable Defense` achievement.
    constants.achievement.impregnable_defense,

    -- The id for the `Power Is Everything` achievement.
    constants.achievement.power_is_everything,

    -- The id for the `Explorer of the Eastlands` achievement.
    constants.achievement.explorer_of_the_eastlands,

    -- The id for the `Monster Ph.D.` achievement.
    constants.achievement.monster_phd,

    -- The id for the `Miniature Crown Collector` achievement.
    constants.achievement.mini_crown_collector,

    -- The id for the `Miniature Crown Master` achievement.
    constants.achievement.mini_crown_master,

    -- The id for the `Giant Crown Collector` achievement.
    constants.achievement.giant_crown_collector,

    -- The id for the `Giant Crown Master` achievement.
    constants.achievement.giant_crown_master,

    -- The id for the `Eastward Wings` achievement.
    constants.achievement.eastward_wings
}

-- The ids for the Ascendance DLC achievements being tracked.
constants.ascendance_achievement = {
    -- TODO: Add new Ascendance DLC achievements here.
}

return constants