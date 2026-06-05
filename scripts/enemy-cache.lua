-- Enemy capability cache (simplified vs Castra Prime; no parallel enemy research tree yet).

local ren = require("scripts.constants")

local function default_ammo()
  if prototypes.item["nullius-magazine"] then
    return "nullius-magazine"
  end
  if prototypes.item["piercing-rounds-magazine"] then
    return "piercing-rounds-magazine"
  end
  return "firearm-magazine"
end

local function build_default_enemy_table()
  return {
    speed_module_tier = 0,
    productivity_module_tier = 0,
    quality_module_tier = 0,
    best_power_pole = "medium-electric-pole",
    wall_tier = "stone-wall",
    ammo_tier = default_ammo(),
    gun_turret = prototypes.entity["gun-turret"] ~= nil,
    laser_turret = prototypes.entity["laser-turret"] ~= nil,
    flamethrower_turret = prototypes.entity["flamethrower-turret"] ~= nil,
    solar_panel = prototypes.entity["solar-panel"] ~= nil,
    repair_pack = prototypes.item["repair-pack"] ~= nil,
    roboport = prototypes.entity["roboport"] ~= nil,
    construction_robot = prototypes.item["construction-robot"] ~= nil,
    tank = true,
    land_mine = prototypes.entity["ren-land-mine"] ~= nil,
    quality_tier = prototypes.quality["normal"],
  }
end

local function refresh_quality_tier()
  if not game then
    return
  end
  local best = prototypes.quality["normal"]
  for _, quality in pairs(prototypes.quality) do
    if quality and not quality.hidden and game.forces.enemy.is_quality_unlocked(quality) then
      if quality.level > best.level then
        best = quality
      end
    end
  end
  storage.ren.enemy.quality_tier = best
end

local function build_cache_if_needed()
  storage.ren = storage.ren or {}
  if not storage.ren.enemy then
    storage.ren.enemy = build_default_enemy_table()
  end
  if game then
    refresh_quality_tier()
  end
end

return {
  build_cache_if_needed = build_cache_if_needed,
  nauvis_exists = ren.nauvis_exists,
}
