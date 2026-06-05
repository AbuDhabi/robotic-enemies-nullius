-- Enemy entities adapted from Castra Prime (GPL-3.0).

require("__base__.prototypes.entity.biter-animations")

local gfx = require("prototypes.graphics")
local spawner_graphics = gfx.spawner_graphics_set()
local spawner_icon = gfx.spawner_icon()

local enemy_tint = { r = 0, g = 0.5, b = 0.2, a = 1 }

local function tint_animation(animation, tint)
  if not animation then
    return animation
  end
  local copy = table.deepcopy(animation)
  copy.tint = tint
  return copy
end

local function create_vehicle_enemy_unit(options)
  local vehicle = options.vehicle
  local unit = table.deepcopy(data.raw["unit"][options.spitter_base or "medium-spitter"])
  unit.name = options.name
  unit.icon = options.icon
  unit.max_health = vehicle.max_health
  unit.factoriopedia_simulation = nil
  unit.resistances = options.resistances or vehicle.resistances or {}
  unit.absorptions_to_join_attack = { [options.pollutant or "ren-data"] = options.absorption_cost }
  unit.run_animation = tint_animation(options.animation, enemy_tint)
  unit.working_sound = options.working_sound
  unit.rotation_speed = options.rotation_speed
  unit.alternative_attacking_frame_sequence = nil
  unit.corpse = vehicle.corpse
  unit.dying_explosion = vehicle.dying_explosion
  unit.dying_sound = nil
  unit.walking_sound = nil
  unit.water_reflection = nil
  unit.movement_speed = options.movement_speed
  unit.collision_box = vehicle.collision_box
  unit.selection_box = vehicle.selection_box
  unit.attack_parameters = options.attack_parameters
  unit.attack_parameters.animation = unit.run_animation
  return unit
end

data:extend({
  {
    type = "unit-spawner",
    name = "ren-data-collector",
    icon = spawner_icon,
    flags = { "placeable-player", "placeable-enemy", "not-repairable" },
    max_health = 12000,
    order = "f-g-b",
    subgroup = "enemies",
    resistances = {
      { type = "physical", decrease = 20, percent = 10 },
      { type = "explosion", decrease = 10, percent = 95 },
      { type = "laser", decrease = 20, percent = 90 },
      { type = "poison", percent = 100 },
    },
    working_sound = {
      audible_distance_modifier = 0.5,
      fade_in_ticks = 4,
      fade_out_ticks = 20,
      sound = {
        filename = "__base__/sound/assembling-machine-t3-1.ogg",
        volume = 0.45,
      },
    },
    healing_per_tick = 20 / 60.0,
    collision_box = { { -2.7, -2.7 }, { 2.7, 2.7 } },
    map_generator_bounding_box = { { -3.7, -3.2 }, { 3.7, 3.2 } },
    selection_box = { { -3, -3 }, { 3, 3 } },
    impact_category = "metal",
    absorptions_per_second = { ["ren-data"] = { absolute = 20, proportional = 0.01 } },
    max_count_of_owned_units = 10,
    max_friends_around_to_spawn = 5,
    graphics_set = spawner_graphics,
    peaceful_unit_spawn_factor = 1,
    spawning_cooldown = { 480, 960 },
    spawning_radius = 6,
    spawning_spacing = 2,
    max_spawn_shift = 0,
    max_richness_for_spawn_shift = 100,
    call_for_help_radius = 0,
    result_units = {
      { "ren-enemy-buggy", { { 0.0, 0.10 }, { 0.3, 0.12 }, { 0.5, 0.08 }, { 1.0, 0.05 } } },
      { "ren-enemy-tank", { { 0.0, 0.0 }, { 0.35, 0.0 }, { 0.45, 0.08 }, { 1.0, 0.10 } } },
      { "ren-enemy-spider", { { 0.0, 0.0 }, { 0.65, 0.0 }, { 0.75, 0.05 }, { 1.0, 0.08 } } },
    },
  },
})

local car = data.raw["car"]["car"]
local tank_car = data.raw["car"]["tank"]
local spidertron = data.raw["spider-vehicle"]["spidertron"]

local spider_animation = table.deepcopy(spidertron.graphics_set.animation)
if spidertron.graphics_set.shadow_animation then
  local shadow = table.deepcopy(spidertron.graphics_set.shadow_animation)
  shadow.draw_as_shadow = true
  table.insert(spider_animation.layers, shadow)
end

data:extend({
  create_vehicle_enemy_unit({
    name = "ren-enemy-buggy",
    icon = "__base__/graphics/icons/car.png",
    vehicle = car,
    animation = car.animation,
    working_sound = car.working_sound,
    rotation_speed = car.rotation_speed,
    movement_speed = 0.15,
    absorption_cost = 400,
    attack_parameters = {
      type = "projectile",
      range = 15,
      cooldown = 15,
      cooldown_deviation = 0.15,
      ammo_category = "bullet",
      ammo_type = {
        target_type = "entity",
        action = {
          type = "direct",
          action_delivery = {
            type = "instant",
            source_effects = {
              type = "create-explosion",
              entity_name = "explosion-gunshot",
            },
            target_effects = {
              { type = "create-entity", entity_name = "explosion-hit", offsets = { { 0, 1 } }, offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } } },
              { type = "damage", damage = { amount = 8, type = "physical" } },
              { type = "activate-impact", deliver_category = "bullet" },
            },
          },
        },
      },
      range_mode = "bounding-box-to-bounding-box",
    },
  }),
  create_vehicle_enemy_unit({
    name = "ren-enemy-tank",
    icon = "__base__/graphics/icons/tank.png",
    vehicle = tank_car,
    animation = tank_car.animation,
    working_sound = tank_car.working_sound,
    rotation_speed = tank_car.rotation_speed,
    movement_speed = 0.08,
    absorption_cost = 1000,
    resistances = {
      { type = "physical", decrease = 10, percent = 50 },
      { type = "explosion", decrease = 10, percent = 50 },
      { type = "fire", percent = 90 },
      { type = "poison", percent = 99 },
      { type = "laser", decrease = 20, percent = 90 },
      { type = "electric", decrease = 10, percent = 60 },
    },
    attack_parameters = {
      type = "projectile",
      range = 10,
      cooldown = 30,
      cooldown_deviation = 0.15,
      ammo_category = "bullet",
      ammo_type = {
        target_type = "entity",
        action = {
          type = "direct",
          action_delivery = {
            type = "instant",
            source_effects = {
              type = "create-explosion",
              entity_name = "explosion-gunshot",
            },
            target_effects = {
              { type = "create-entity", entity_name = "explosion-hit", offsets = { { 0, 1 } }, offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } } },
              { type = "damage", damage = { amount = 24, type = "physical" } },
              { type = "activate-impact", deliver_category = "bullet" },
            },
          },
        },
      },
      range_mode = "bounding-box-to-bounding-box",
    },
  }),
  create_vehicle_enemy_unit({
    name = "ren-enemy-spider",
    icon = "__base__/graphics/icons/spidertron.png",
    vehicle = spidertron,
    spitter_base = "behemoth-spitter",
    animation = spider_animation,
    working_sound = spidertron.working_sound,
    rotation_speed = spidertron.torso_rotation_speed,
    movement_speed = 0.05,
    absorption_cost = 2000,
    resistances = table.deepcopy(spidertron.resistances),
    attack_parameters = {
      type = "projectile",
      range = 18,
      min_attack_distance = 4,
      cooldown = 120,
      cooldown_deviation = 0.2,
      ammo_category = "rocket",
      ammo_type = {
        target_type = "position",
        action = {
          type = "direct",
          action_delivery = {
            type = "projectile",
            projectile = "explosive-rocket",
            starting_speed = 0.3,
            max_range = 18,
          },
        },
      },
      range_mode = "bounding-box-to-bounding-box",
    },
  }),
})

local function multiply_energy_amount(energy_string, multiplier)
  local number, unit = energy_string:match("^(%d+%.?%d*)(%a*)$")
  if not number or not unit then
    return energy_string
  end
  number = tonumber(number) * multiplier
  return number .. unit
end

local function create_enemy_version(entity)
  if not entity then
    return nil
  end
  local mult = 0.05
  local enemy_entity = table.deepcopy(entity)
  enemy_entity.name = "ren-enemy-" .. entity.name
  enemy_entity.minable = enemy_entity.minable and { mining_time = enemy_entity.minable.mining_time } or nil
  if enemy_entity.minable then
    enemy_entity.minable.result = nil
  end
  enemy_entity.is_military_target = true
  enemy_entity.next_upgrade = nil
  local source = enemy_entity.energy_source
  if source and source.type == "electric" then
    if source.buffer_capacity then
      source.buffer_capacity = multiply_energy_amount(source.buffer_capacity, mult)
    end
    if source.input_flow_limit then
      source.input_flow_limit = multiply_energy_amount(source.input_flow_limit, mult)
    end
    if source.output_flow_limit then
      source.output_flow_limit = multiply_energy_amount(source.output_flow_limit, mult)
    end
    if source.drain then
      source.drain = multiply_energy_amount(source.drain, mult)
    end
  end
  if enemy_entity.energy_per_shot then
    enemy_entity.energy_per_shot = multiply_energy_amount(enemy_entity.energy_per_shot, mult)
  end
  local attack_param = enemy_entity.attack_parameters
  if attack_param then
    if attack_param.fluid_consumption then
      attack_param.fluid_consumption = attack_param.fluid_consumption * 0.01
    end
    if attack_param.ammo_type and attack_param.ammo_type.energy_consumption then
      attack_param.ammo_type.energy_consumption = multiply_energy_amount(attack_param.ammo_type.energy_consumption, mult)
    end
  end
  return enemy_entity
end

local enemy_turrets = {}
if data.raw["electric-turret"]["laser-turret"] then
  table.insert(enemy_turrets, create_enemy_version(data.raw["electric-turret"]["laser-turret"]))
end
if data.raw["fluid-turret"]["flamethrower-turret"] then
  table.insert(enemy_turrets, create_enemy_version(data.raw["fluid-turret"]["flamethrower-turret"]))
end
data:extend(enemy_turrets)

local infrastructure_types = {
  { type = "roboport", name = "roboport" },
  { type = "solar-panel", name = "solar-panel" },
  { type = "electric-pole", name = "small-electric-pole" },
  { type = "electric-pole", name = "medium-electric-pole" },
  { type = "electric-pole", name = "big-electric-pole" },
  { type = "electric-pole", name = "substation" },
}
local enemy_infrastructure = {}
for _, entry in ipairs(infrastructure_types) do
  local entity = data.raw[entry.type][entry.name]
  if entity then
    local e = table.deepcopy(entity)
    e.name = "ren-enemy-" .. entry.name
    if e.minable then
      e.minable.result = nil
    end
    e.is_military_target = true
    e.next_upgrade = nil
    table.insert(enemy_infrastructure, e)
  end
end
data:extend(enemy_infrastructure)
