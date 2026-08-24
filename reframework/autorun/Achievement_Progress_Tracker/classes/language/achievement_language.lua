---@meta

-- IMPORTS
local achievement_detail_language = require("Achievement_Progress_Tracker.classes.language.achievement_detail_language")
-- END IMPORTS

---@class (exact) achievement_language That class that represents the localized text for the achievement being tracked.
---@field a_true_hunter achievement_detail_language The base game `A True Hunter` achievement.
---@field hunters_united_forever achievement_detail_language The base game `Hunters United Forever` achievement.
---@field someone_worth_following achievement_detail_language The base game `Someone Worth Following` achievement.
---@field capture_pro achievement_detail_language The base game `Capture Pro` achievement.
---@field monster_slayer achievement_detail_language The base game `Monster Slayer` achievement.
---@field seasoned_hunter achievement_detail_language The base game `Seasoned Hunter` achievement.
---@field top_of_the_food_chain achievement_detail_language The base game `Top of the Food Chain` achievement.
---@field east_to_west achievement_detail_language The base game `East to West, A Hunter Never Rests` achievement.
---@field a_fish_ionado achievement_detail_language The base game `A-fish-ionado` achievement.
---@field campmaster achievement_detail_language The base game `Campmaster` achievement.
---@field bourgeois_hunter achievement_detail_language The base game `Bourgeois Hunter` achievement.
---@field gossip_hunter achievement_detail_language The base game `Gossip Hunter` achievement.
---@field impregnable_defense achievement_detail_language The base game `Impregnable Defense` achievement.
---@field power_is_everything achievement_detail_language The base game `Power Is Everything` achievement.
---@field explorer_of_the_eastlands achievement_detail_language The base game `Explorer of the Eastlands` achievement.
---@field monster_phd achievement_detail_language The base game `Monster Ph.D.` achievement.
---@field mini_crown_collector achievement_detail_language The base game `Miniature Crown Collector` achievement.
---@field mini_crown_master achievement_detail_language The base game `Miniature Crown Master` achievement.
---@field giant_crown_collector achievement_detail_language The base game `Giant Crown Collector` achievement.
---@field giant_crown_master achievement_detail_language The base game `Giant Crown Master` achievement.
---@field eastward_wings achievement_detail_language The base game `Eastward Wings` achievement.
local achievement_language = {}

---
--- Creates a new default instance of the achievement language localization data.
---
---@return achievement_language achievement_language The newly created achievement language localization data.
function achievement_language:new()
    self = setmetatable({}, self)

    -- Base Game
    self.a_true_hunter = achievement_detail_language:new("A True Hunter Is Never Satisfied", "Completed 50 quests.")
    self.hunters_united_forever = achievement_detail_language:new("Hunters United Forever", "Completed 100 quests via multiplayer.")
    self.someone_worth_following = achievement_detail_language:new("Someone Worth Following", "Completed 100 quests with your Palico deployed.")
    self.capture_pro = achievement_detail_language:new("Capture Pro", "Captured 50 monsters.")
    self.monster_slayer = achievement_detail_language:new("Monster Slayer", "Hunted 100 large monsters.")
    self.seasoned_hunter = achievement_detail_language:new("Seasoned Hunter", "Hunted 50 tempered monsters.")
    self.top_of_the_food_chain = achievement_detail_language:new("Top of the Food Chain", "Hunted 50 apex predators.")
    self.east_to_west = achievement_detail_language:new("East to West, A Hunter Never Rests", "Completed 30 different side missions.")
    self.a_fish_ionado = achievement_detail_language:new("A-fish-ionado", "Reeled in 30 whoppers while fishing.")
    self.campmaster = achievement_detail_language:new("Campmaster", "Established Pop-up Camps in 10 places.")
    self.bourgeois_hunter = achievement_detail_language:new("Bourgeois Hunter", "Possessed 1,000,000 zenny.")
    self.gossip_hunter = achievement_detail_language:new("Gossip Hunter", "Viewed 30 different Hunter Profiles.")
    self.impregnable_defense = achievement_detail_language:new("Impregnable Defense", "Forged five different pieces of armor with Rarity 7 or higher.")
    self.power_is_everything = achievement_detail_language:new("Power Is Everything", "Forged five different weapons (NON ARTIAN) with Rarity 7 or higher.")
    self.explorer_of_the_eastlands = achievement_detail_language:new("Explorer of the Eastlands", "Obtained 10 different special items of Rarity 6.")
    self.monster_phd = achievement_detail_language:new("Monster Ph.D.", "Hunted many different large monsters.")
    self.mini_crown_collector = achievement_detail_language:new("Miniature Crown Collector", "Obtained a miniature crown for 10 or more monsters in the Hunting Log.")
    self.mini_crown_master = achievement_detail_language:new("Miniature Crown Master", "Obtained a miniature crown for many monsters in the Hunting Log.")
    self.giant_crown_collector = achievement_detail_language:new("Giant Crown Collector", "Obtained a gold crown for 10 or more monsters in the Hunting Log.")
    self.giant_crown_master = achievement_detail_language:new("Giant Crown Master", "Obtained a gold crown for many monsters in the Hunting Log.")
    self.eastward_wings = achievement_detail_language:new("Eastward Wings", "Obtained all other awards.")

    -- Ascendance DLC
    -- TODO: Add new Ascendance DLC achievements here and in json files.

    return self
end

return achievement_language