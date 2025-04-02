--- IMPORTS
local constants = require("Achievement_Progress_Tracker.constants")
--- END IMPORTS

--- The manager for all things related calling into the sdk.
local sdk_manager = {
    -- The save data manager managed singleton from the sdk.
    save_data_manager = nil,

    -- The mission manager managed singleton from the sdk.
    mission_manager = nil,

    -- The player manager managed singleton from the sdk.
    player_manager = nil
}

---
--- Attempt to get the `app.cPlayerManageInfo` object from the game.
---
--- @return userdata? player The `app.cPlayerManageInfo` object obtained from the player manager, otherwise nil.
function sdk_manager.get_player()
    -- Check if the player manager on the sdk manager is NOT already loaded/valid.
    if not sdk_manager.player_manager then
        -- If yes, then call into the sdk to get the player manager managed singleton.
        sdk_manager.player_manager = sdk.get_managed_singleton(constants.type_name.player_manager)
    end

    -- Check if the player manager is stil NOT valid.
    if not sdk_manager.player_manager then
        -- If yes, then return nil since no player can be found.
        return nil
    end

    -- Return the player object ('app.cPlayerManageInfo') as a result of the get master player call on the player manager.
    return sdk_manager.player_manager:call("getMasterPlayer")
end

---
--- Attempt to get the unique id of the character.
---
---@return string? character_unique_id The GUID/UUID string that represents the unique id of the character.
function sdk_manager.get_character_unique_id()
    -- Call the get user save data function on the sdk manager to get the user save data.
    local user_save_data = sdk_manager.get_user_save_data()
    if not user_save_data then
        -- Return to exit early if the user save data was NOT found.
        return nil
    end

    -- Return the hunter id string as a result of the get field call for the hunter id on the user save data.
    return user_save_data:get_field("HunterId")
end

---
--- Attempt to get the `app.savedata.cUserSaveParam` object of the current user from the game.
---
--- @return userdata? user_save_data The `app.savedata.cUserSaveParam` object obtained from the save data manager, otherwise nil.
function sdk_manager.get_user_save_data()
    -- Check if the save data manager on the sdk manager is NOT already loaded/valid.
    if not sdk_manager.save_data_manager then
        -- If yes, then call into the sdk to get the save data manager managed singleton.
        sdk_manager.save_data_manager = sdk.get_managed_singleton(constants.type_name.save_data_manager)
    end

    -- Check if the save data manager is stil NOT valid.
    if not sdk_manager.save_data_manager then
        -- If yes, then return nil since no user save data can be found.
        return nil
    end

    -- Return the user save data object ('app.savedata.cUserSaveParam') as a result of the get current user save data call on the save data manager.
    return sdk_manager.save_data_manager:call("getCurrentUserSaveData")
end

---
--- Attempt to get the `app.savedata.cBasicParam` object from the user save data.
---
---@param user_save_data userdata? [OPTIONAL] The `app.savedata.cUserSaveParam` object to get the basic data from, if not nil.
---
---@return userdata? basic_data The `app.savedata.cBasicParam` object obtained from the user save data, otherwise nil.
function sdk_manager.get_basic_data(user_save_data)
    -- Check if the provided user save data, if any, is nil.
    if not user_save_data then
        -- If yes, then call the get user save data function on the sdk manager to get the user save data.
        user_save_data = sdk_manager.get_user_save_data()
        if not user_save_data then
            -- Return to exit early if the user save data was NOT found.
            return nil
        end
    end

    -- Return the basic data object ('app.savedata.cBasicParam') as a result of the get basic data call on the user save data.
    return user_save_data:call("get_BasicData")
end

---
--- Attempt to get the `app.savedata.cItemParam` object from the user save data.
---
---@param user_save_data userdata? [OPTIONAL] The `app.savedata.cUserSaveParam` object to get the item data from, if not nil.
---
---@return userdata? item_data The `app.savedata.cItemParam` object obtained from the user save data, otherwise nil.
function sdk_manager.get_item_data(user_save_data)
    -- Check if the provided user save data, if any, is nil.
    if not user_save_data then
        -- If yes, then call the get user save data function on the sdk manager to get the user save data.
        user_save_data = sdk_manager.get_user_save_data()
        if not user_save_data then
            -- Return to exit early if the user save data was NOT found.
            return nil
        end
    end

    -- Return the item data object ('app.savedata.cItemParam') as a result of the get item call on the user save data.
    return user_save_data:call("get_Item")
end

---
--- Attempt to get the `app.savedata.cEquipParam` object from the user save data.
---
---@param user_save_data userdata? [OPTIONAL] The `app.savedata.cUserSaveParam` object to get the equipment data from, if not nil.
---
---@return userdata? equipment_data The `app.savedata.cEquipParam` object obtained from the user save data, otherwise nil.
function sdk_manager.get_equipment_data(user_save_data)
    -- Check if the provided user save data, if any, is nil.
    if not user_save_data then
        -- If yes, then call the get user save data function on the sdk manager to get the user save data.
        user_save_data = sdk_manager.get_user_save_data()
        if not user_save_data then
            -- Return to exit early if the user save data was NOT found.
            return nil
        end
    end

    -- Return the equipment data object ('app.savedata.cEquipParam') as a result of the get equip call on the user save data.
    return user_save_data:call("get_Equip")
end

---
--- Attempt to get the `app.savedata.cCampSaveDataParam` object from the user save data.
---
---@param user_save_data userdata? [OPTIONAL] The `app.savedata.cUserSaveParam` object to get the camp data from, if not nil.
---
---@return userdata? camp_data The `app.savedata.cCampSaveDataParam` object obtained from the user save data, otherwise nil.
function sdk_manager.get_camp_data(user_save_data)
    -- Check if the provided user save data, if any, is nil.
    if not user_save_data then
        -- If yes, then call the get user save data function on the sdk manager to get the user save data.
        user_save_data = sdk_manager.get_user_save_data()
        if not user_save_data then
            -- Return to exit early if the user save data was NOT found.
            return nil
        end
    end

    -- Return the camp data object ('app.savedata.cCampSaveDataParam') as a result of the get equip camp on the user save data.
    return user_save_data:call("get_Camp")
end

---
--- Attempt to get the `app.savedata.cHunterProfileParam` object from the user save data.
---
---@param user_save_data userdata? [OPTIONAL] The `app.savedata.cUserSaveParam` object to get the hunter profile from, if not nil.
---
---@return userdata? hunter_profile The `app.savedata.cHunterProfileParam` object obtained from the user save data, otherwise nil.
function sdk_manager.get_hunter_profile(user_save_data)
    -- Check if the provided user save data, if any, is nil.
    if not user_save_data then
        -- If yes, then call the get user save data function on the sdk manager to get the user save data.
        user_save_data = sdk_manager.get_user_save_data()
        if not user_save_data then
            -- Return to exit early if the user save data was NOT found.
            return nil
        end
    end

    -- Return the hunter profile object ('app.savedata.cHunterProfileParam') as a result of the get hunter profile call on the user save data.
    return user_save_data:call("get_HunterProfile")
end

---
--- Attempt to get the `app.savedata.cEnemyReportParam` object from the user save data.
---
---@param user_save_data userdata? [OPTIONAL] The `app.savedata.cUserSaveParam` object to get the enemy report from, if not nil.
---
---@return userdata? hunter_profile The `app.savedata.cEnemyReportParam` object obtained from the user save data, otherwise nil.
function sdk_manager.get_enemy_report(user_save_data)
    -- Check if the provided user save data, if any, is nil.
    if not user_save_data then
        -- If yes, then call the get user save data function on the sdk manager to get the user save data.
        user_save_data = sdk_manager.get_user_save_data()
        if not user_save_data then
            -- Return to exit early if the user save data was NOT found.
            return nil
        end
    end

    -- Return the enemy report object ('app.savedata.cEnemyReportParam') as a result of the get enemy report call on the user save data.
    return user_save_data:call("get_EnemyReport")
end

---
--- Attempt to get the `app.MissionActivator` object.
---
---@return userdata? mission_activator The `app.MissionActivator` object obtained from the mission manager, otherwise nil.
function sdk_manager.get_mission_activator()
    -- Check if the mission manager on the sdk manager is NOT already loaded/valid.
    if not sdk_manager.mission_manager then
        -- If yes, then call into the sdk to get the mission manager managed singleton.
        sdk_manager.mission_manager = sdk.get_managed_singleton(constants.type_name.mission_manager)
    end

    -- Check if the mission manager is stil NOT valid.
    if not sdk_manager.mission_manager then
        -- If yes, then return nil since no mission activator can be found.
        return nil
    end

    -- Return the mission activator object ('app.MissionActivator') as a result of the get inst mission activator call on the mission manager.
    return sdk_manager.mission_manager:call("get_InstMissionActivator")
end

---
--- Attempt to get the collection of fixed ids of any awards the player has acquired.
---
---@param hunter_profile? userdata [OPTIONAL] The `app.savedata.cHunterProfileParam` object to get the acquired awards data from, if not nil.
---
---@return table acquired_awards_fixed_ids The table that represents the collection of fixed ids for acquired awards.
function sdk_manager.get_acquired_award_fixed_ids(hunter_profile)
    -- Check if the provided hunter profile, if any, is nil.
    if not hunter_profile then
        -- If yes, then call the get hunter profile function on the sdk manager to get the hunter profile.
        hunter_profile = sdk_manager.get_hunter_profile()
        if not hunter_profile then
            -- Return to exit early if the hunter profile was NOT found.
            return {}
        end
    end

    -- Get the bitset that contains the acquired award fixed ids as a result of the get medal call on the hunter profile.
    local acquired_awards_bitset = hunter_profile:call("get_Medal")
    if not acquired_awards_bitset then
        -- Return to exit early if the acquired awards bitset was NOT found.
        return {}
    end

    -- Return the table of acquired award fixed ids as a result of the get biset value call using the acquired awards bitset and the id as key flag as true.
    return sdk.get_bitset_value(acquired_awards_bitset, nil, true)
end

---
--- Initializes the sdk manager module.
---
function sdk_manager.init_module()
    sdk_manager.save_data_manager = sdk.get_managed_singleton(constants.type_name.save_data_manager)
    sdk_manager.mission_manager = sdk.get_managed_singleton(constants.type_name.mission_manager)
    sdk_manager.player_manager = sdk.get_managed_singleton(constants.type_name.player_manager)

    local tracking_manager = require("Achievement_Progress_Tracker.tracking_manager")

    local entered_set_hunter_rank_message = false

    sdk.add_hook(constants.type_name.hunter_profile_param, "getMedal(app.HunterProfileDef.MEDAL_ID)", nil, function(retval)
        -- Attempt to update then check if the tracker for the `Eastward Wings` achievement was updated.
        if tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.eastward_wings]) then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.save_data_manager, "systemRequestUserSave", nil, function(retval)
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
        end

        -- Reset the entered set hunter rank message to false.
        entered_set_hunter_rank_message = false

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.network_context_manager, "downloadHunterProfile(System.Guid, System.String, System.Action`2<System.Boolean,app.NETWORK_ERROR_CODE>)", nil, function(retval)
        -- Attempt to update then check if the tracker for the `Gossip Hunter` achievement was updated.
        if tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.gossip_hunter]) then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.hunter_profile_param, "addFishCaptureNum(app.FieldDef.STAGE)", nil, function(retval)
        -- Attempt to update then check if the tracker for the `A-fish-ionado` achievement was updated.
        if tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.a_fish_ionado]) then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.basic_param, "addMoney(System.Int32, System.Boolean)", nil, function(retval)
        -- Attempt to update then check if the tracker for the `Bourgeois Hunter` achievement was updated.
        if tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.bourgeois_hunter]) then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.quest_reward, "enter", nil, function(retval)
        -- Get the user save data.
        local user_save_data = sdk_manager.get_user_save_data()

        -- Attempt to update then capture whether the tracker for the `Capture Pro` achievement was updated.
        local updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.capture_pro], user_save_data)

        -- Attempt to update then capture whether the tracker for the `Monster Slayer` achievement was updated, then OR the result with the updated flag.
        updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.monster_slayer], user_save_data) or updated

        -- Attempt to update then capture whether the tracker for the `Top of the Food Chain` achievement was updated, then OR the result with the updated flag.
        updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.top_of_the_food_chain], user_save_data) or updated

        -- Attempt to update then capture whether the tracker for the `Monster Ph.D.` achievement was updated, then OR the result with the updated flag.
        updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.monster_phd], user_save_data) or updated

        -- Attempt to update then capture whether the tracker for the `Miniature Crown Collector` achievement was updated, then OR the result with the updated flag.
        updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.mini_crown_collector], user_save_data) or updated

        -- Attempt to update then capture whether the tracker for the `Miniature Crown Master` achievement was updated, then OR the result with the updated flag.
        updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.mini_crown_master], user_save_data) or updated

        -- Attempt to update then capture whether the tracker for the `Giant Crown Collector` achievement was updated, then OR the result with the updated flag.
        updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.giant_crown_collector], user_save_data) or updated

        -- Attempt to update then capture whether the tracker for the `Giant Crown Master` achievement was updated, then OR the result with the updated flag.
        updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.giant_crown_master], user_save_data) or updated

        -- Check if the updated flag is true.
        if updated then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.gui_quest_result, "setHunterRankMessage(System.Int32)", nil, function(retval)
        -- Check if the entered set hunter rank message flag is NOT true (is false).
        if not entered_set_hunter_rank_message then
            -- If yes, then set the entered set hunter rank message flag as true to prevent multiple tracker updates.
            entered_set_hunter_rank_message = true

            -- Get the user save data.
            local user_save_data = sdk_manager.get_user_save_data()

            -- Attempt to update then capture whether the tracker for the `A True Hunter Is Never Satisfied` achievement was updated.
            local updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.a_true_hunter], user_save_data)

            -- Attempt to update then capture whether the tracker for the `Hunters United Forever` achievement was updated, then OR the result with the updated flag.
            updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.hunters_united_forever], user_save_data) or updated

            -- Attempt to update then capture whether the tracker for the `Someone Worth Following` achievement was updated, then OR the result with the updated flag.
            updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.someone_worth_following], user_save_data) or updated

            -- Attempt to update then capture whether the tracker for the `Seasoned Hunter` achievement was updated, then OR the result with the updated flag.
            updated = tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.seasoned_hunter], user_save_data) or updated

            -- Check if the updated flag is true.
            if updated then
                -- If yes, then force the draw manager to reset and update its values.
                tracking_manager.force_draw_manager_values_reset_and_update()
            end
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.item_util, "pickupItem(app.ItemDef.ID, System.Int16, app.EnemyDef.ID)", nil, function(retval)
        -- Attempt to update then check if the tracker for the `Explorer of the Eastlands` achievement was updated.
        if tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.explorer_of_the_eastlands]) then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.equip_param, "addEquipBoxWeapon(app.user_data.WeaponData.cData)", nil, function(retval)
        -- Attempt to update then check if the tracker for the `Power Is Everything` achievement was updated.
        if tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.power_is_everything]) then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.equip_param, "upgradeEquipBoxWeapon(app.EquipDef.EquipWorkInfo, app.user_data.WeaponData.cData)", nil, function(retval)
        -- Attempt to update then check if the tracker for the `Power Is Everything` achievement was updated.
        if tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.power_is_everything]) then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.equip_param, "addEquipBoxArmor(app.user_data.ArmorData.cData, app.CharacterDef.GENDER)", nil, function(retval)
        -- Attempt to update then check if the tracker for the `Impregnable Defense` achievement was updated.
        if tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.impregnable_defense]) then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)

    sdk.add_hook(constants.type_name.gui_camp_view_data, "executeSetCamp()", nil, function(retval)
        -- Attempt to update then check if the tracker for the `Campmaster` achievement was updated.
        if tracking_manager.update_tracker(tracking_manager.achievements[constants.achievement.campmaster]) then
            -- If yes, then force the draw manager to reset and update its values.
            tracking_manager.force_draw_manager_values_reset_and_update()
        end

        -- Return the provided return value with no changes.
        return retval
    end)
end

return sdk_manager