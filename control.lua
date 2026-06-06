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

local function find_nearby_collector(position, range)
  for _, collector in pairs(storage.ren.dataCollectors or {}) do
    if collector.valid then
      local dx = collector.position.x - position.x
      local dy = collector.position.y - position.y
      if dx * dx + dy * dy < range * range then
        return collector
      end
    end
  end
end

local function give_vehicle_unit_command(unit, selection)
  if not unit.valid then
    return
  end
  local rand = selection or math.random()
  if rand < 0.80 then
    unit.commandable.set_command {
      type = defines.command.wander,
      distraction = defines.distraction.by_anything,
      ticks_to_wait = math.random(600, 5000),
    }
    return
  elseif rand < 0.85 then
    if not find_nearby_collector(unit.position, 32) then
      local area = {
        left_top = { x = unit.position.x - 15, y = unit.position.y - 15 },
        right_bottom = { x = unit.position.x + 15, y = unit.position.y + 15 },
      }
      base_generator.create_enemy_base(area)
    end
    unit.commandable.set_command {
      type = defines.command.wander,
      distraction = defines.distraction.by_anything,
      ticks_to_wait = math.random(600, 5000),
    }
    return
  elseif rand < 0.95 then
    local collectors = storage.ren.dataCollectors or {}
    if #collectors > 0 then
      local target = collectors[math.random(1, #collectors)]
      if target.valid then
        unit.commandable.set_command {
          type = defines.command.go_to_location,
          destination = target.position,
          distraction = defines.distraction.by_anything,
        }
        return
      end
    end
  elseif rand < 0.99 then
    local entities = unit.surface.find_entities_filtered {
      force = "player",
      area = { { unit.position.x - 100, unit.position.y - 100 }, { unit.position.x + 100, unit.position.y + 100 } },
    }
    for _, entity in pairs(entities) do
      if entity.valid and entity.is_military_target then
        unit.commandable.set_command {
          type = defines.command.attack_area,
          destination = entity.position,
          radius = 8,
          distraction = defines.distraction.by_anything,
        }
        return
      end
    end
  else
    local closest = unit.surface.find_nearest_enemy { position = unit.position, force = unit.force, max_distance = 500 }
    if closest then
      unit.commandable.set_command {
        type = defines.command.attack_area,
        destination = closest.position,
        radius = 8,
        distraction = defines.distraction.by_anything,
      }
      return
    end
  end
  unit.commandable.set_command {
    type = defines.command.wander,
    distraction = defines.distraction.by_anything,
    ticks_to_wait = math.random(600, 5000),
  }
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
  enemy_cache.build_cache_if_needed()
  storage.ren.lastEnemyDamageMultiplier = nil
  evolution_scaling.sync_force_damage_modifiers()
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
  if (#resources > 0 or math.random() < 0.04 * math.log(math.max(distance, 40) / 40, 5)) and distance > 200 then
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
    return
  end
  give_vehicle_unit_command(event.entity, nil)
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
    storage.ren = storage.ren or {}
    storage.ren.dataCollectors = storage.ren.dataCollectors or {}
    for i = #storage.ren.dataCollectors, 1, -1 do
      if not storage.ren.dataCollectors[i].valid then
        table.remove(storage.ren.dataCollectors, i)
      end
    end
    if #storage.ren.dataCollectors == 0 then
      return
    end
    local surface = game.surfaces[ren.SURFACE]
    local collector = storage.ren.dataCollectors[math.random(1, #storage.ren.dataCollectors)]
    local units = surface.find_entities_filtered {
      name = ren.VEHICLE_UNITS,
      area = {
        { collector.position.x - 100, collector.position.y - 100 },
        { collector.position.x + 100, collector.position.y + 100 },
      },
    }
    for _, unit in pairs(units) do
      if unit.valid and unit.commandable and unit.commandable.command
          and unit.commandable.command.type == defines.command.wander then
        give_vehicle_unit_command(unit, math.random() < 0.5 and 0.97 or (math.random() < 0.5 and 1 or nil))
      end
    end
  end
end)
