local vanilla_gun_turret = data.raw["ammo-turret"]["gun-turret"]

local gun_turret = table.deepcopy(vanilla_gun_turret)
gun_turret.name = "nullius-gun-turret"
gun_turret.localised_name = { "entity-name.nullius-gun-turret" }
gun_turret.localised_description = { "entity-description.nullius-gun-turret" }
gun_turret.icon = "__base__/graphics/icons/gun-turret.png"
gun_turret.icon_size = 64
gun_turret.minable = { mining_time = 0.5, result = "nullius-gun-turret" }
gun_turret.fast_replaceable_group = "nullius-gun-turret"
gun_turret.hidden = false
gun_turret.hidden_in_factoriopedia = false
gun_turret.heating_energy = nil
gun_turret.energy_per_shot = "10J"
gun_turret.energy_source = {
  type = "electric",
  buffer_capacity = "1kJ",
  input_flow_limit = "10kW",
  usage_priority = "secondary-input",
}

data:extend({
  gun_turret,
  {
    type = "item",
    name = "nullius-gun-turret",
    localised_name = { "item-name.nullius-gun-turret" },
    localised_description = { "item-description.nullius-gun-turret" },
    icon = "__base__/graphics/icons/gun-turret.png",
    icon_size = 64,
    subgroup = "demolitions",
    order = "nullius-cc",
    place_result = "nullius-gun-turret",
    stack_size = 50,
    hidden = false,
    hidden_in_factoriopedia = false,
  },
  {
    type = "recipe",
    name = "nullius-gun-turret",
    localised_name = { "item-name.nullius-gun-turret" },
    enabled = false,
    always_show_made_in = true,
    category = "medium-crafting",
    subgroup = "demolitions",
    order = "nullius-cc",
    energy_required = 15,
    ingredients = {
      { type = "item", name = "nullius-motor-1", amount = 2 },
      { type = "item", name = "nullius-iron-gear", amount = 2 },
      { type = "item", name = "nullius-sensor-1", amount = 1 },
      { type = "item", name = "nullius-steel-plate", amount = 2 },
      { type = "item", name = "nullius-steel-rod", amount = 1 },
    },
    results = {
      { type = "item", name = "nullius-gun-turret", amount = 1 },
    },
  },
})

local vanilla_flamethrower_turret = data.raw["fluid-turret"]["flamethrower-turret"]

local flamethrower_turret = table.deepcopy(vanilla_flamethrower_turret)
flamethrower_turret.name = "nullius-flamethrower-turret"
flamethrower_turret.localised_name = { "entity-name.nullius-flamethrower-turret" }
flamethrower_turret.localised_description = { "entity-description.nullius-flamethrower-turret" }
flamethrower_turret.icon = "__base__/graphics/icons/flamethrower-turret.png"
flamethrower_turret.icon_size = 64
flamethrower_turret.minable = { mining_time = 0.5, result = "nullius-flamethrower-turret" }
flamethrower_turret.fast_replaceable_group = "nullius-flamethrower-turret"
flamethrower_turret.hidden = false
flamethrower_turret.hidden_in_factoriopedia = false
flamethrower_turret.attack_parameters.fluids = {
  { type = "nullius-benzene" },
}

data:extend({
  flamethrower_turret,
  {
    type = "item",
    name = "nullius-flamethrower-turret",
    localised_name = { "item-name.nullius-flamethrower-turret" },
    localised_description = { "item-description.nullius-flamethrower-turret" },
    icon = "__base__/graphics/icons/flamethrower-turret.png",
    icon_size = 64,
    subgroup = "demolitions",
    order = "nullius-cd",
    place_result = "nullius-flamethrower-turret",
    stack_size = 50,
    hidden = false,
    hidden_in_factoriopedia = false,
  },
  {
    type = "recipe",
    name = "nullius-flamethrower-turret",
    localised_name = { "item-name.nullius-flamethrower-turret" },
    enabled = false,
    always_show_made_in = true,
    category = "medium-crafting",
    subgroup = "demolitions",
    order = "nullius-cd",
    energy_required = 20,
    ingredients = {
      { type = "item", name = "nullius-motor-1", amount = 2 },
      { type = "item", name = "nullius-iron-gear", amount = 2 },
      { type = "item", name = "nullius-sensor-1", amount = 1 },
      { type = "item", name = "nullius-steel-plate", amount = 3 },
      { type = "item", name = "nullius-pipe-2", amount = 3 },
    },
    results = {
      { type = "item", name = "nullius-flamethrower-turret", amount = 1 },
    },
  },
})
