-- Nullius disables pollution in data.lua; robotic enemies need it for ren-data absorption and attacks.

local map_settings = data.raw["map-settings"]["map-settings"]
if map_settings and map_settings.pollution then
  map_settings.pollution.enabled = true
end

local nauvis = data.raw.planet and data.raw.planet["nauvis"]
if nauvis then
  nauvis.pollutant_type = "ren-data"
end
