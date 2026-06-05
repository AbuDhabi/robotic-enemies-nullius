require("prototypes.emissions-patch")

local spawner = data.raw["unit-spawner"]["ren-data-collector"]
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
end
