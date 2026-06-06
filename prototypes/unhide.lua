-- Nullius hidden.lua runs before this file; keep robotic enemy prototypes placeable and visible in Factoriopedia.

local function clear_hidden(prototype)
  if prototype then
    prototype.hidden = false
    prototype.hidden_in_factoriopedia = false
    if prototype.flags then
      for i = #prototype.flags, 1, -1 do
        if prototype.flags[i] == "temphidden" or prototype.flags[i] == "hidden" then
          table.remove(prototype.flags, i)
        end
      end
    end
  end
end

for _, prototype in pairs(data.raw["unit-spawner"]) do
  if string.sub(prototype.name, 1, 4) == "ren-" then
    clear_hidden(prototype)
  end
end

for _, prototype in pairs(data.raw["unit"]) do
  if string.sub(prototype.name, 1, 4) == "ren-" then
    clear_hidden(prototype)
  end
end

for _, prototype in pairs(data.raw["spider-unit"] or {}) do
  if string.sub(prototype.name, 1, 4) == "ren-" then
    clear_hidden(prototype)
  end
end

for _, entity_type in pairs({ "ammo-turret", "electric-turret", "fluid-turret", "roboport", "solar-panel", "electric-pole", "land-mine" }) do
  for _, prototype in pairs(data.raw[entity_type] or {}) do
    if string.sub(prototype.name, 1, 9) == "ren-enemy-" or string.sub(prototype.name, 1, 4) == "ren-" then
      clear_hidden(prototype)
    end
  end
end

clear_hidden(data.raw.technology["nullius-robotic-defense-1"])
clear_hidden(data.raw.technology["nullius-self-defense-1"])
clear_hidden(data.raw.capsule["nullius-grenade"])
