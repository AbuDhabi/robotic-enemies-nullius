-- Adapted from Castra Prime (GPL-3.0). Robotic bases on Nauvis for Nullius.

local enemy_cache = require("scripts.enemy-cache")
local base_generator = require("scripts.base-generator")
local evolution_scaling = require("scripts.evolution-scaling")
local ren = require("scripts.constants")

local function enemies_enabled()
  return settings.startup["ren-enable-robotic-enemies"].value
end

local function ensure_pollution_system()
  if game.map_settings.pollution then
    game.map_settings.pollution.enabled = true
  end
end

local function track_collector(entity)
  if not entity.valid or entity.name ~= ren.SPAWNER or entity.force.name ~= "enemy" then
    return
  end
  storage.ren = storage.ren or {}
  storage.ren.dataCollectors = storage.ren.dataCollectors or {}
  table.insert(storage.ren.dataCollectors, entity)
end

local function untrack_collector(entity)
  if not entity or entity.name ~= ren.SPAWNER then
    return
  end
  storage.ren = storage.ren or {}
  if not storage.ren.dataCollectors then
    return
  end
  for i = #storage.ren.dataCollectors, 1, -1 do
    if storage.ren.dataCollectors[i] == entity or not storage.ren.dataCollectors[i].valid then
      table.remove(storage.ren.dataCollectors, i)
    end
  end
  if entity.unit_number and storage.ren.dataCollectorsPollution then
    storage.ren.dataCollectorsPollution[entity.unit_number] = nil
  end
end

local function prune_invalid_collectors()
  storage.ren = storage.ren or {}
  storage.ren.dataCollectors = storage.ren.dataCollectors or {}
  for i = #storage.ren.dataCollectors, 1, -1 do
    if not storage.ren.dataCollectors[i].valid then
      table.remove(storage.ren.dataCollectors, i)
    end
  end
end

local function migrate_self_defense_tech()
  storage.ren = storage.ren or {}
  if storage.ren.self_defense_tech_migrated then
    return
  end

  for _, force in pairs(game.forces) do
    if force.name == "enemy" or force.name == "neutral" then
      goto continue
    end

    local grenade_tech = force.technologies["nullius-self-defense-1"]
    local legacy_grenade_tech = force.technologies["nullius-self-defense-2"]
    if not grenade_tech then
      goto continue
    end

    if legacy_grenade_tech and legacy_grenade_tech.researched then
      grenade_tech.researched = true
    elseif grenade_tech.researched and (not legacy_grenade_tech or not legacy_grenade_tech.researched) then
      grenade_tech.researched = false
    end

    ::continue::
  end

  storage.ren.self_defense_tech_migrated = true
end

local function clear_vehicle_unit_commands()
  local surface = game.surfaces[ren.SURFACE]
  if not surface then
    return
  end
  for _, unit in pairs(surface.find_entities_filtered { name = ren.VEHICLE_UNITS }) do
    if unit.valid and unit.commandable and unit.commandable.command then
      unit.commandable.set_command { type = defines.command.stop }
    end
  end
end

script.on_init(function()
  ensure_pollution_system()
  storage.ren = storage.ren or {}
  storage.ren.dataCollectors = storage.ren.dataCollectors or {}
  enemy_cache.build_cache_if_needed()
  evolution_scaling.sync_force_damage_modifiers()
end)

script.on_configuration_changed(function()
  ensure_pollution_system()
  storage.ren = storage.ren or {}
  storage.ren.dataCollectors = storage.ren.dataCollectors or {}
  migrate_self_defense_tech()
  enemy_cache.build_cache_if_needed()
  storage.ren.lastEnemyDamageMultiplier = nil
  evolution_scaling.sync_force_damage_modifiers()
  clear_vehicle_unit_commands()
end)

script.on_event(defines.events.on_chunk_generated, function(event)
  if not enemies_enabled() then
    return
  end
  if not ren.on_nauvis(event.surface) then
    return
  end
  enemy_cache.build_cache_if_needed()

  local resources = event.surface.find_entities_filtered { type = "resource", area = event.area }
  local distance = math.sqrt(event.area.left_top.x ^ 2 + event.area.left_top.y ^ 2)
  if (#resources > 0 or math.random() < 0.04 * math.log(math.max(distance, 40) / 40, 5))
      and distance > ren.MIN_BASE_SPAWN_DISTANCE then
    base_generator.create_enemy_base(event.area)
  end
end)

script.on_event(defines.events.on_entity_spawned, function(event)
  local unlock_evolution = ren.EVOLUTION_UNLOCK[event.entity.name]
  if not unlock_evolution then
    return
  end
  if not event.spawner or event.spawner.name ~= ren.SPAWNER then
    return
  end

  enemy_cache.build_cache_if_needed()
  local evolution = game.forces.enemy.get_evolution_factor(event.entity.surface)
  if evolution < unlock_evolution then
    event.entity.destroy()
  end
end)

local function built_event(event)
  if not event.entity or not event.entity.valid then
    return
  end
  if ren.on_nauvis(event.entity.surface) then
    track_collector(event.entity)
  end
end

local function destroyed_event(event)
  if not event.entity then
    return
  end
  if ren.on_nauvis(event.entity.surface) then
    untrack_collector(event.entity)
  end
end

script.on_event(defines.events.on_built_entity, built_event)
script.on_event(defines.events.on_robot_built_entity, built_event)
script.on_event(defines.events.script_raised_built, built_event)
script.on_event(defines.events.script_raised_revive, built_event)
script.on_event(defines.events.on_entity_died, destroyed_event)
script.on_event(defines.events.on_player_mined_entity, destroyed_event)
script.on_event(defines.events.on_robot_mined_entity, destroyed_event)
script.on_event(defines.events.script_raised_destroy, destroyed_event)

script.on_event(defines.events.on_tick, function(event)
  if not enemies_enabled() or not enemy_cache.nauvis_exists() then
    return
  end

  if event.tick % 60 == 0 then
    evolution_scaling.sync_force_damage_modifiers()
  end

  if event.tick % 2000 == 1277 then
    prune_invalid_collectors()
  end
end)
