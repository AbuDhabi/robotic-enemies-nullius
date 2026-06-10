require("prototypes.emissions-patch")
require("prototypes.electronic-pollution").apply()
require("prototypes.ammo-balance").apply()

local combat_targeting = require("prototypes.combat-targeting")
if settings.startup["ren-enable-auto-targeting"].value then
  combat_targeting.apply_entity_targeting()
else
  combat_targeting.apply_demolition_targeting()
end

local spawner = data.raw["unit-spawner"]["ren-data-collector"]
local ENEMY_HEALING_FACTOR = 0.2

local function scale_enemy_healing(prototype)
  if prototype and prototype.healing_per_tick and prototype.healing_per_tick > 0 then
    prototype.healing_per_tick = prototype.healing_per_tick * ENEMY_HEALING_FACTOR
  end
end

if spawner then
  local rate = 0.5
  spawner.max_health = spawner.max_health * rate
  spawner.healing_per_tick = spawner.healing_per_tick * rate
  for _, resistance in ipairs(spawner.resistances or {}) do
    if resistance.type == "physical" or resistance.type == "explosion" or resistance.type == "laser" then
      if resistance.decrease then
        resistance.decrease = resistance.decrease * rate
      end
      if resistance.percent then
        resistance.percent = resistance.percent * rate
      end
    end
  end
  scale_enemy_healing(spawner)
end

for _, prototype in pairs(data.raw.unit) do
  if string.sub(prototype.name, 1, 9) == "ren-enemy-" then
    prototype.healing_per_tick = 0
  end
end

for _, prototype in pairs(data.raw["spider-unit"] or {}) do
  if string.sub(prototype.name, 1, 9) == "ren-enemy-" then
    prototype.healing_per_tick = 0
  end
end
