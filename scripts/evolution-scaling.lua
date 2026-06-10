-- Scale ren-enemy combat damage with Nauvis evolution (1x at 0, 4x at 1).
-- Uses the enemy force ammo damage modifier so turrets and units pick it up in combat and tooltips.

local ren = require("scripts.constants")

local M = {}

local AMMO_CATEGORIES = {
  "melee",
  "bullet",
  "cannon-shell",
  "rocket",
  "laser",
  "flamethrower",
}

function M.combat_multiplier(evolution)
  return ren.evolution_combat_multiplier(evolution)
end

function M.sync_force_damage_modifiers()
  if not game or not ren.nauvis_exists() then
    return
  end

  local surface = game.surfaces[ren.SURFACE]
  local evolution = game.forces.enemy.get_evolution_factor(surface)
  local multiplier = M.combat_multiplier(evolution)

  storage.ren = storage.ren or {}
  local last = storage.ren.lastEnemyDamageMultiplier
  if last and math.abs(last - multiplier) < 0.0001 then
    return
  end
  storage.ren.lastEnemyDamageMultiplier = multiplier

  local enemy_force = game.forces.enemy
  for _, ammo_category in ipairs(AMMO_CATEGORIES) do
    enemy_force.set_ammo_damage_modifier(ammo_category, multiplier)
  end
end

return M
