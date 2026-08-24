---@meta

---@class (exact) achievement_tracking_config The class that represents the configuration options that control whether a specific achievement should be tracked or not.
---@field a_true_hunter boolean The option that controls whether the `A True Hunter Is Never Satisfied` base game achievement should be tracked or not. Defaults to `true`.
---@field hunters_united_forever boolean The option that controls whether the `Hunters United Forever` base game achievement should be tracked or not. Defaults to `true`.
---@field someone_worth_following boolean The option that controls whether the `Someone Worth Following` base game achievement should be tracked or not. Defaults to `true`.
---@field capture_pro boolean The option that controls whether the `Capture Pro` base game achievement should be tracked or not. Defaults to `true`.
---@field monster_slayer boolean The option that controls whether the `Monster Slayer` base game achievement should be tracked or not. Defaults to `true`.
---@field seasoned_hunter boolean The option that controls whether the `Seasoned Hunter` base game achievement should be tracked or not. Defaults to `true`.
---@field top_of_the_food_chain boolean The option that controls whether the `Top of the Food Chain` base game achievement should be tracked or not. Defaults to `true`.
---@field east_to_west boolean The option that controls whether the `East to West, A Hunter Never Rests` base game achievement should be tracked or not. Defaults to `true`.
---@field a_fish_ionado boolean The option that controls whether the `A-fish-ionado` base game achievement should be tracked or not. Defaults to `true`.
---@field campmaster boolean The option that controls whether the `Campmaster` base game achievement should be tracked or not. Defaults to `true`.
---@field bourgeois_hunter boolean The option that controls whether the `Bourgeois Hunter` base game achievement should be tracked or not. Defaults to `true`.
---@field gossip_hunter boolean The option that controls whether the `Gossip Hunter` base game achievement should be tracked or not. Defaults to `true`.
---@field impregnable_defense boolean The option that controls whether the `Impregnable Defense` base game achievement should be tracked or not. Defaults to `true`.
---@field power_is_everything boolean The option that controls whether the `Power Is Everything` base game achievement should be tracked or not. Defaults to `true`.
---@field explorer_of_the_eastlands boolean The option that controls whether the `Explorer of the Eastlands` base game achievement should be tracked or not. Defaults to `true`.
---@field monster_phd boolean The option that controls whether the `Monster Ph.D.` base game achievement should be tracked or not. Defaults to `true`.
---@field mini_crown_collector boolean The option that controls whether the `Miniature Crown Collector` base game achievement should be tracked or not. Defaults to `true`.
---@field mini_crown_master boolean The option that controls whether the `Miniature Crown Master` base game achievement should be tracked or not. Defaults to `true`.
---@field giant_crown_collector boolean The option that controls whether the `Giant Crown Collector` base game achievement should be tracked or not. Defaults to `true`.
---@field giant_crown_master boolean The option that controls whether the `Giant Crown Master` base game achievement should be tracked or not. Defaults to `true`.
---@field eastward_wings boolean The option that controls whether the `Eastward Wings` base game achievement should be tracked or not. Defaults to `true`.
local achievement_tracking_config = {}

---
--- Creates a new default instance of the achievement tracking config.
---
---@return achievement_tracking_config achievement_tracking_config The newly created achievement tracking config.
function achievement_tracking_config:new()
    self = setmetatable({}, self)

    -- Base Game
    self.a_true_hunter = true
    self.hunters_united_forever = true
    self.someone_worth_following = true
    self.capture_pro = true
    self.monster_slayer = true
    self.seasoned_hunter = true
    self.top_of_the_food_chain = true
    self.east_to_west = true
    self.a_fish_ionado = true
    self.campmaster = true
    self.bourgeois_hunter = true
    self.gossip_hunter = true
    self.impregnable_defense = true
    self.power_is_everything = true
    self.explorer_of_the_eastlands = true
    self.monster_phd = true
    self.mini_crown_collector = true
    self.mini_crown_master = true
    self.giant_crown_collector = true
    self.giant_crown_master = true
    self.eastward_wings = true

    -- Ascendance DLC
    -- TODO: Add new Ascendance DLC achievements here.

    return self
end

return achievement_tracking_config