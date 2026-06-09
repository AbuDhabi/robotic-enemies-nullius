local ICON = "__base__/graphics/technology/physical-projectile-damage-1.png"

local SELF_DEFENSE_2_PACKS = {
  { "nullius-geology-pack", 1 },
  { "nullius-climatology-pack", 1 },
  { "nullius-mechanical-pack", 1 },
  { "nullius-electrical-pack", 1 },
}

local DEMOLITIONS_1_PACKS = {
  { "nullius-geology-pack", 1 },
  { "nullius-climatology-pack", 1 },
  { "nullius-mechanical-pack", 1 },
  { "nullius-electrical-pack", 1 },
  { "nullius-chemical-pack", 1 },
}

local DEMOLITIONS_2_PACKS = {
  { "nullius-geology-pack", 1 },
  { "nullius-climatology-pack", 1 },
  { "nullius-mechanical-pack", 1 },
  { "nullius-electrical-pack", 1 },
  { "nullius-chemical-pack", 1 },
  { "nullius-physics-pack", 1 },
}

local function bullet_upgrade_effects()
  return {
    {
      type = "gun-speed",
      ammo_category = "bullet",
      modifier = 0.1,
    },
    {
      type = "ammo-damage",
      ammo_category = "bullet",
      modifier = 0.25,
    },
  }
end

local function projectile_improvements_tech(options)
  return {
    type = "technology",
    name = options.name,
    localised_name = { "technology-name.nullius-projectile-improvements" },
    localised_description = { "technology-description.nullius-projectile-improvements" },
    order = options.order,
    icon = ICON,
    icon_size = 256,
    upgrade = true,
    effects = bullet_upgrade_effects(),
    prerequisites = options.prerequisites,
    unit = options.unit,
    max_level = options.max_level,
    ignore_tech_cost_multiplier = options.ignore_tech_cost_multiplier,
  }
end

data:extend({
  projectile_improvements_tech({
    name = "nullius-projectile-improvements-1",
    order = "nullius-cj",
    prerequisites = { "nullius-self-defense-2" },
    ignore_tech_cost_multiplier = true,
    unit = {
      count = 25,
      ingredients = SELF_DEFENSE_2_PACKS,
      time = 15,
    },
  }),
  projectile_improvements_tech({
    name = "nullius-projectile-improvements-2",
    order = "nullius-ck",
    prerequisites = { "nullius-projectile-improvements-1" },
    ignore_tech_cost_multiplier = true,
    unit = {
      count = 75,
      ingredients = SELF_DEFENSE_2_PACKS,
      time = 15,
    },
  }),
  projectile_improvements_tech({
    name = "nullius-projectile-improvements-3",
    order = "nullius-cl",
    prerequisites = { "nullius-projectile-improvements-2", "nullius-demolitions-1" },
    unit = {
      count = 200,
      ingredients = DEMOLITIONS_1_PACKS,
      time = 30,
    },
  }),
  projectile_improvements_tech({
    name = "nullius-projectile-improvements-4",
    order = "nullius-cm",
    prerequisites = { "nullius-projectile-improvements-3" },
    unit = {
      count = 500,
      ingredients = DEMOLITIONS_1_PACKS,
      time = 30,
    },
  }),
  projectile_improvements_tech({
    name = "nullius-projectile-improvements-5",
    order = "nullius-cn",
    prerequisites = { "nullius-projectile-improvements-4", "nullius-demolitions-2" },
    max_level = "infinite",
    unit = {
      count_formula = "3600*(2^(L-5))",
      ingredients = DEMOLITIONS_2_PACKS,
      time = 55,
    },
  }),
})
