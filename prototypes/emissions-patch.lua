-- Nullius machines declare emissions as { pollution = N }; Nauvis uses ren-data as pollutant_type.

local function convert_pollution_emissions(emissions)
  if not emissions or not emissions.pollution then
    return
  end
  if emissions["ren-data"] == nil then
    emissions["ren-data"] = emissions.pollution
  end
  emissions.pollution = nil
end

local function patch_entity(name, entity)
  if not entity or (name and name:sub(1, 4) == "ren-") then
    return
  end
  convert_pollution_emissions(entity.emissions_per_minute)
  if entity.energy_source then
    convert_pollution_emissions(entity.energy_source.emissions_per_minute)
  end
  if entity.burner then
    convert_pollution_emissions(entity.burner.emissions)
  end
end

for _, prototypes in pairs(data.raw) do
  if type(prototypes) == "table" then
    for name, prototype in pairs(prototypes) do
      if type(prototype) == "table" then
        patch_entity(name, prototype)
      end
    end
  end
end

-- Let ren-data spread across the map (Castra uses a tiny coefficient on tiles).
for _, tile in pairs(data.raw.tile) do
  tile.absorptions_per_second = tile.absorptions_per_second or {}
  if tile.absorptions_per_second["ren-data"] == nil then
    tile.absorptions_per_second["ren-data"] = 0.000001
  end
end
