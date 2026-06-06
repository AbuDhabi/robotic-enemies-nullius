local vanilla_grenade = data.raw.capsule["grenade"]

local grenade = table.deepcopy(vanilla_grenade)
grenade.name = "nullius-grenade"
grenade.localised_name = { "item-name.nullius-grenade" }
grenade.localised_description = { "item-description.nullius-grenade" }
grenade.subgroup = "demolitions"
grenade.order = "nullius-xa"
grenade.hidden = false
grenade.hidden_in_factoriopedia = false

data:extend({
  grenade,
  {
    type = "recipe",
    name = "nullius-grenade",
    localised_name = { "item-name.nullius-grenade" },
    icons = {
      {
        icon = "__base__/graphics/icons/grenade.png",
        icon_size = 64,
      },
    },
    subgroup = "demolitions",
    order = "nullius-xa",
    enabled = false,
    always_show_made_in = true,
    category = "small-crafting",
    energy_required = 8,
    ingredients = {
      { type = "item", name = "processed-fuel", amount = 1 },
      { type = "item", name = "nullius-iron-plate", amount = 1 },
    },
    results = {
      { type = "item", name = "nullius-grenade", amount = 1 },
    },
  },
  {
    type = "recipe",
    name = "nullius-magazine-improvised",
    localised_name = { "recipe-name.nullius-magazine-improvised" },
    icons = {
      {
        icon = "__base__/graphics/icons/piercing-rounds-magazine.png",
        icon_size = 64,
      },
      {
        icon = "__core__/graphics/icons/mip/slot-item-in-hand.png",
        icon_size = 64,
        scale = 0.3,
        shift = { -7, -7 },
      },
    },
    subgroup = "demolitions",
    order = "nullius-ea",
    enabled = false,
    always_show_made_in = true,
    show_amount_in_title = false,
    always_show_products = true,
    category = "hand-crafting",
    energy_required = 5,
    ingredients = {
      { type = "item", name = "cliff-explosives", amount = 1 },
      { type = "item", name = "nullius-steel-rod", amount = 6 },
    },
    results = {
      { type = "item", name = "nullius-magazine", amount = 10 },
    },
  },
})
