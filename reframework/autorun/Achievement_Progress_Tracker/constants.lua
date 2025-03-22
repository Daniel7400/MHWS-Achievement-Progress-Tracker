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

    -- The dropdown options for the size of the achievement trackers.
    size_option = {
        -- The small size option, this will NOT include the description.
        small = 1,

        -- The medium size option, this will include the description.
        medium = 2,

        -- The large size option, this will include the description.
        large = 3
    },

    -- The names for types within the game.
    type_name = {
        -- The Save Data Manager type name.
        save_data_manager = "app.SaveDataManager",

        -- The Mission Manager type name.
        mission_manager = "app.MissionManager",

        -- The Player Manager type name.
        player_manager = "app.PlayerManager",

        -- The Enemy Manager type name.
        enemy_manager = "app.EnemyManager",

        -- The Network Context Manager type name.
        network_context_manager = "app.net_context_manager.cContextManager",

        -- The Quest Reward type name.
        quest_reward = "app.cQuestReward",

        -- The GUI Parts Quest Result Item type name.
        gui_quest_result = "app.cGUIPartsQuestResultItem",

        -- The Item Util type name.
        item_util = "app.ItemUtil",

        -- The GUI Camp View Data type name.
        gui_camp_view_data = "app.cGUICampViewData",

        -- The Basic Param Save Data type name.
        basic_param = "app.savedata.cBasicParam",

        -- The Equip Param Save Data type name.
        equip_param = "app.savedata.cEquipParam",

        -- The Hunter Profile Param Save Data type name.
        hunter_profile_param = "app.savedata.cHunterProfileParam",
    },

    -- The id for the achievements being tracked.
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
        giant_crown_master = 20
    },

    -- The in-game fixed id for the game award/medal.
    game_award_fixed_id = {
        -- The fixed id for the in-game award/medal `A True Hunter Is Never Satisfied`.
        a_true_hunter = 10,             -- "MEDAL_009", Id: 9

        -- The fixed id for the in-game award/medal `East to West, A Hunter Never Rests`.
        east_to_west = 14,              -- "MEDAL_013", Id: 13

        -- The fixed id for the in-game award/medal `A-fish-ionado`.
        a_fish_ionado = 24,             -- "MEDAL_023", Id: 23

        -- The fixed id for the in-game award/medal `Campmaster`.
        campmaster = 25,                -- "MEDAL_024", Id: 24

        -- The fixed id for the in-game award/medal `Impregnable Defense`.
        impregnable_defense = 30,       -- "MEDAL_029", Id: 29

        -- The fixed id for the in-game award/medal `Power Is Everything`.
        power_is_everything = 31,       -- "MEDAL_030", Id: 30

        -- The fixed id for the in-game award/medal `Someone Worth Following`.
        someone_worth_following = 32,   -- "MEDAL_031", Id: 31

        -- The fixed id for the in-game award/medal `Explorer of the Eastlands`.
        explorer_of_the_eastlands = 35, -- "MEDAL_034", Id: 34

        -- The fixed id for the in-game award/medal `Monster Ph.D.`.
        monster_phd = 36,               -- "MEDAL_035", Id: 35

        -- The fixed id for the in-game award/medal `Seasoned Hunter`.
        seasoned_hunter = 37,           -- "MEDAL_036", Id: 36

        -- The fixed id for the in-game award/medal `Miniature Crown Collector`.
        mini_crown_collector = 39,      -- "MEDAL_038", Id: 38

        -- The fixed id for the in-game award/medal `Miniature Crown Master`.
        mini_crown_master = 40,         -- "MEDAL_039", Id: 39

        -- The fixed id for the in-game award/medal `Giant Crown Collector`.
        giant_crown_collector = 42,     -- "MEDAL_041", Id: 41

        -- The fixed id for the in-game award/medal `Giant Crown Master`.
        giant_crown_master = 43,        -- "MEDAL_042", Id: 42

        -- The fixed id for the in-game award/medal `Capture Pro`.
        capture_pro = 44,               -- "MEDAL_043", Id: 43

        -- The fixed id for the in-game award/medal `Monster Slayer`.
        monster_slayer = 45,            -- "MEDAL_044", Id: 44

        -- The fixed id for the in-game award/medal `Top of the Food Chain`.
        top_of_the_food_chain = 46,      -- "MEDAL_045", Id: 45

        -- The fixed id for the in-game award/medal `Hunters United Forever`.
        hunters_united_forever = 48,    -- "MEDAL_047", Id: 47

        -- The fixed id for the in-game award/medal `Bourgeois Hunter`.
        bourgeois_hunter = 34,          -- "MEDAL_033", Id: 33

        -- The fixed id for the in-game award/medal `Gossip Hunter`.
        gossip_hunter = 49              -- "MEDAL_048", Id: 48
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

    -- The collection of indexes to fetch counter values on the hunter profile.
    counter = {
        -- The counter index that tracks the count of tempered monsters hunted.
        tempered_monster = 0,

        -- The counter index that tracks the count of completed multiplayer quest.
        multiplayer_quest = 2,

        -- The counter index that tracks the count of completed quests with an accompanying palico.
        palico_accompanied_quest = 4
    },
    -- TODO: Replace with the HunterProfileDef?
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

    -- The collection of enemy fixed ids that are considered apex predators.
    apex_predator = {
        [-1547364608] = true,   -- "EM0156_00_0", "Rey Dau"
        [1467998976] = true,    -- "EM0157_00_0", "Uth Duna"
        [1657778432] = true,    -- "EM0158_00_0", "Nu Udra"
        [1553456768] = true     -- "EM0162_00_0", "Jin Dahaad"
    },

    -- The collection of enemy fixed ids that are considered whoppers.
    whopper = {
        [-562596928] = true,        -- "EM5304_00_0", "Gastronome Tuna"
        [-1256137216] = true,       -- "EM5305_00_0", "Gajau"
        [1094277632] = true,        -- "EM5315_00_0", "Goliath Squid"
        [1380810112] = true,        -- "EM5312_00_0", "Speartuna"
        [-935735872] = true         -- "EM5316_00_0", "Great Trevally"
    },

    -- The collection of item fixed ids that are considered special.
    special_item = {
        [233] = true,               -- "ITEM_0259", "Great Windward Aloe"
        [238] = true,               -- "ITEM_0264", "Thundering Fulgurite"
        [241] = true,               -- "ITEM_0267", "Eternal Scarlet Amber"
        [242] = true,               -- "ITEM_0268", "Queensbloom Pollen"
        [245] = true,               -- "ITEM_0271", "Bulky Treasure"
        [249] = true,               -- "ITEM_0275", "Antimite Mass"
        [253] = true,               -- "ITEM_0279", "Large Goldenscale Vase"
        [260] = true,               -- "ITEM_0286", "Time-honed Wylk Gem"
        [266] = true,               -- "ITEM_0292", "Nightflower Pollen"
        [269] = true,               -- "ITEM_0295", "Genesis Opal"
        [270] = true                -- "ITEM_0296", "Wyvernsprout"
    },

    -- The collection of enemy fixed ids for monsters in the base game that were included on release.
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

    -- The collection of enemy fixed ids for monsters that are crown targets.
    crown_target = {},

    -- The enum that defines the id for each large monster, small monster, endemic life, and aquatic life in the game.
    enemy_def_id = sdk.enum_to_table("app.EnemyDef.ID"),

    -- The enum that defines the fixed id for each large monster, small monster, endemic life, and aquatic life in the game. Using the fixed id as the key.
    enemy_def_id_fixed = sdk.enum_to_table("app.EnemyDef.ID_Fixed", true),

    -- The enum that defines the enemy report state.
    enemy_report_state = sdk.enum_to_table("app.EnemyReportState.STATE"),
    --[[ For reference:
        namespace app::EnemyReportState {
            enum STATE {
                NONE = 0,
                UNKNOWN = 1,
                KNOWN = 2,
            };
        }
    ]]

    -- The enum that defines the weapon types.
    weapon_type = sdk.enum_to_table("app.WeaponDef.TYPE"),
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

    -- The enum that defines the id for each item in the game.
    item_id = sdk.enum_to_table("app.ItemDef.ID"),

    -- The enum taht defines the fixed id for each item in the game. Using the fixed id as the key.
    item_id_fixed = sdk.enum_to_table("app.ItemDef.ID_Fixed", true)
}

-- The language directory path that contains all of the language files.
constants.language_directory_path = constants.directory_path .. "\\languages\\"

-- Swap weapon type names to match what they really are in game but keeping the same integer values.
constants.weapon_type["GREAT_SWORD"] = constants.weapon_type.LONG_SWORD
constants.weapon_type.LONG_SWORD = nil

constants.weapon_type["SWORD_AND_SHIELD"] = constants.weapon_type.SHORT_SWORD
constants.weapon_type.SHORT_SWORD = nil

constants.weapon_type["DUAL_BLADES"] = constants.weapon_type.TWIN_SWORD
constants.weapon_type.TWIN_SWORD = nil

constants.weapon_type["LONG_SWORD"] = constants.weapon_type.TACHI
constants.weapon_type.TACHI = nil

constants.weapon_type["HUNTING_HORN"] = constants.weapon_type.WHISTLE
constants.weapon_type.WHISTLE = nil

constants.weapon_type["SWITCH_AXE"] = constants.weapon_type.SLASH_AXE
constants.weapon_type.SLASH_AXE = nil

constants.weapon_type["CHARGE_BLADE"] = constants.weapon_type.CHARGE_AXE
constants.weapon_type.CHARGE_AXE = nil

constants.weapon_type["INSECT_GLAIVE"] = constants.weapon_type.ROD
constants.weapon_type.ROD = nil

-- Get the enemy manager managed singleton.
local enemy_manager = sdk.get_managed_singleton(constants.type_name.enemy_manager)
if enemy_manager then
    -- Get the enemy manager settings.
    local enemy_manager_settings = enemy_manager:call("get_Setting")
    if enemy_manager_settings then
        -- Get the enemy param size from the enemy manager settings.
        local enemy_param_size = enemy_manager_settings:call("get_Size")
        if enemy_param_size then
            -- Iterate over each monster fixed id in the base monster collection.
            for monster_fixed_id, _ in pairs(constants.base_monster) do
                -- Get the corresponding monster id for the current monster fixed id.
                local monster_id = constants.enemy_def_id[constants.enemy_def_id_fixed[monster_fixed_id]]
            
                -- Get the size data for the current monster id.
                local size_data = enemy_param_size:call("getSizeData(app.EnemyDef.ID)", monster_id)
                if size_data then
                    -- Call the get is disable random function on the size data.
                    local is_disable_random = size_data:call("get_IsDisableRandom")
            
                    -- Check if the is disable random flag is NOT true (is false), meaning the size can vary.
                    if not is_disable_random then
                        -- Add a new entry into the crown target table using the monster fixed id as the key and storing the mini and gold crown size requirements.
                        constants.crown_target[monster_fixed_id] = {
                            ["mini_size"] = size_data:call("get_CrownSize_Small"),
                            ["gold_size"] = size_data:call("get_CrownSize_King")
                        }
                    end
                end
            end
        end
    end
end

-- For some reason this `isBigFish` function returns incorrect results until fish are actually loaded in the game.
-- Like going to `Area 17: Great lake Shore` in the `Scarlet Forest`, until then it always returns false.
--[[
-- Store a local reference to the 'isBigFish' function on the 'app.AnimalUtil' object.
local is_big_fish_func = sdk.find_type_definition("app.AnimalUtil"):get_method("isBigFish(app.EnemyDef.ID)")

-- Iterate over each entry in the enemy def ids.
for string_em_id, id in pairs(constants.enemy_def_id) do
    -- Call the is big fish function to determine if the current enemy id is considered a big fish.
    local is_big_fish = is_big_fish_func:call(nil, id)

    -- Check if the is big fish flag is true.
    if is_big_fish then
        -- If yes, then get the fixed id for the current string em id.
        local id_fixed = constants.enemy_def_id_fixed[string_em_id]

        -- Set the entry for the fixed id that was found as true in the whopper table.
        constants.whopper[id_fixed] = true
    end
end
]]

return constants