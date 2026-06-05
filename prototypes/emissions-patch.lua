-- Nullius machines declare emissions as { pollution = N }; Nauvis uses ren-data as pollutant_type.

local function mirror_pollution_emissions(emissions)
  if emissions and emissions.pollution and emissions["ren-data"] == nil then
    emissions["ren-data"] = emissions.pollution
  end
end

local function patch_entity(entity)
  if not entity then
    return
  end
  mirror_pollution_emissions(entity.emissions_per_minute)
  if entity.energy_source then
    mirror_pollution_emissions(entity.energy_source.emissions_per_minute)
  end
  if entity.burner then
    mirror_pollution_emissions(entity.burner.emissions)
  end
end

for _, prototypes in pairs(data.raw) do
  if type(prototypes) == "table" then
    for _, prototype in pairs(prototypes) do
      if type(prototype) == "table" then
        patch_entity(prototype)
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
