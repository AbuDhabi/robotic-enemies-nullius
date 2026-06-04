-- Castra Prime spawns enemy bases on surface "castra" in on_chunk_generated.
-- This mod will use surface "nauvis" instead (Nullius has no separate enemy planet).

-- local base_gen = require("scripts.base-generator")

-- script.on_event(defines.events.on_chunk_generated, function(event)
--   if event.surface.name ~= "nauvis" then
--     return
--   end
--   -- TODO: port base-generator.create_enemy_base from Castra Prime
-- end)
