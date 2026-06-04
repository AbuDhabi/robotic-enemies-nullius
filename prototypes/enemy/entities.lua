-- Enemy entities adapted from Castra Prime (GPL-3.0).

require("__base__.prototypes.entity.biter-animations")

local gfx = require("prototypes.graphics")
local spawner_graphics = gfx.spawner_graphics_set()
local spawner_icon = gfx.spawner_icon()

local function create_collector_unit(item_name, icon)
  return {
    type = "unit",
    name = "ren-data-collector-" .. item_name,
    icons = {
      {
        icon = spawner_icon,
        scale = 0.7,
        shift = { 0, -10 },
      },
      {
        icon = icon,
        scale = 0.5,
        shift = { -10, 10 },
      },
    },
    loot = {
      {
        item = item_name,
        probability = 1,
        count_min = 1,
        count_max = 1,
      },
    },
    flags = { "placeable-player", "placeable-enemy", "placeable-off-grid", "not-repairable", "breaths-air" },
    max_health = 1,
    order = "n-a-a",
    subgroup = "enemies",
    resistances = {},
    healing_per_tick = 0.01,
    collision_box = { { -0.2, -0.2 }, { 0.2, 0.2 } },
    selection_box = { { -0.4, -0.7 }, { 0.4, 0.4 } },
    impact_category = "metal",
    vision_distance = 30,
    distance_per_frame = 0.125,
    distraction_cooldown = 300,
    absorptions_to_join_attack = { ["ren-data"] = 100 },
    movement_speed = 0,
    run_animation = {
      layers = {
        {
          filename = icon,
          priority = "high",
          width = 64,
          height = 64,
          frame_count = 1,
          direction_count = 1,
          shift = { 0, 0 },
          scale = 1,
        },
      },
    },
    attack_parameters = {
      type = "projectile",
      range = 0,
      cooldown = 0,
      cooldown_deviation = 0.15,
      ammo_category = "melee",
      ammo_type = {
        target_type = "entity",
        action = {
          type = "direct",
          action_delivery = {
            type = "instant",
            target_effects = {
              type = "damage",
              damage = { amount = 0, type = "physical" },
            },
          },
        },
      },
      animation = biterattackanimation(small_biter_scale, small_biter_tint1, small_biter_tint2),
      range_mode = "bounding-box-to-bounding-box",
    },
  }
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
      { "ren-data-collector-decider-combinator", { { 0.0, 0.15 }, { 0.6, 0.1 }, { 1.0, 0.05 } } },
      { "ren-data-collector-nullius-motor-1", { { 0.0, 0.1 }, { 0.5, 0.1 }, { 1.0, 0.1 } } },
      { "ren-data-collector-nullius-steel-plate", { { 0.0, 0.5 }, { 0.7, 0.2 }, { 1.0, 0.0 } } },
      { "ren-enemy-tank", { { 0.0, 0.0 }, { 0.5, 0.0 }, { 1.0, 0.08 } } },
    },
    loot = {
      { item = "decider-combinator", probability = 0.8, count_min = 1, count_max = 4 },
      { item = "nullius-steel-plate", probability = 1, count_min = 5, count_max = 15 },
      { item = "nullius-motor-1", probability = 0.6, count_min = 1, count_max = 3 },
    },
  },
  create_collector_unit("decider-combinator", (function()
    local item = data.raw.item["decider-combinator"]
    if item.icon then
      return item.icon
    end
    if item.icons and item.icons[1] then
      return item.icons[1].icon
    end
    return "__base__/graphics/icons/decider-combinator.png"
  end)()),
  create_collector_unit("nullius-motor-1", "__nullius__/graphics/icons/motor1.png"),
  create_collector_unit("nullius-steel-plate", "__base__/graphics/icons/steel-plate.png"),
})

local tank = table.deepcopy(data.raw["unit"]["medium-spitter"])
tank.name = "ren-enemy-tank"
tank.icon = "__base__/graphics/icons/tank.png"
tank.max_health = data.raw["car"]["tank"].max_health
tank.factoriopedia_simulation = nil
tank.resistances = {
  { type = "physical", decrease = 10, percent = 50 },
  { type = "explosion", decrease = 10, percent = 50 },
  { type = "fire", percent = 90 },
  { type = "poison", percent = 99 },
  { type = "laser", decrease = 20, percent = 90 },
  { type = "electric", decrease = 10, percent = 60 },
}
tank.absorptions_to_join_attack = { ["ren-data"] = 1000 }
tank.run_animation = data.raw["car"]["tank"].animation
tank.run_animation.tint = { r = 0, g = 0.5, b = 0.2, a = 1 }
tank.working_sound = data.raw["car"]["tank"].working_sound
tank.rotation_speed = data.raw["car"]["tank"].rotation_speed
tank.alternative_attacking_frame_sequence = nil
tank.corpse = data.raw["car"]["tank"].corpse
tank.dying_explosion = data.raw["car"]["tank"].dying_explosion
tank.dying_sound = nil
tank.walking_sound = nil
tank.water_reflection = nil
tank.movement_speed = 0.08
tank.collision_box = data.raw["car"]["tank"].collision_box
tank.selection_box = data.raw["car"]["tank"].selection_box
tank.attack_parameters = {
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
  animation = tank.run_animation,
  range_mode = "bounding-box-to-bounding-box",
}
data:extend({ tank })

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
