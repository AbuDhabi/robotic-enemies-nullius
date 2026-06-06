data:extend({
  {
    type = "technology",
    name = "nullius-robotic-defense-1",
    localised_name = { "technology-name.nullius-robotic-defense-1" },
    localised_description = { "technology-description.nullius-robotic-defense-1" },
    order = "nullius-ei",
    icon = "__base__/graphics/technology/laser-turret.png",
    icon_size = 256,
    prerequisites = { "nullius-demolitions-1" },
    effects = {
      { type = "unlock-recipe", recipe = "nullius-rifle" },
      { type = "unlock-recipe", recipe = "nullius-turret" },
      { type = "unlock-recipe", recipe = "nullius-magazine-2" },
    },
    unit = {
      count = 400,
      ingredients = {
        { "nullius-geology-pack", 1 },
        { "nullius-mechanical-pack", 1 },
        { "nullius-electrical-pack", 1 },
        { "nullius-chemical-pack", 1 },
      },
      time = 45,
    },
  },
  {
    type = "technology",
    name = "nullius-self-defense-1",
    localised_name = { "technology-name.nullius-self-defense-1" },
    localised_description = { "technology-description.nullius-self-defense-1" },
    order = "nullius-cf",
    icon = "__base__/graphics/icons/grenade.png",
    icon_size = 64,
    prerequisites = { "nullius-energy-storage-1", "nullius-hydrocarbon-combustion-2" },
    effects = {
      { type = "unlock-recipe", recipe = "nullius-grenade" },
    },
    unit = {
      count = 10,
      ingredients = {
        { "nullius-climatology-pack", 1 },
        { "nullius-mechanical-pack", 1 },
      },
      time = 6,
    },
    ignore_tech_cost_multiplier = true,
  },
})
