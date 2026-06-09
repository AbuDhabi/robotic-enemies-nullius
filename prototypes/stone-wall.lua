local WALL_TINT = { 0.72, 0.62, 0.48 }

local function tint_sprite(sprite, tint)
  if sprite and not sprite.draw_as_shadow and not sprite.draw_as_glow then
    sprite.tint = tint
  end
end

local function tint_wall_graphics(graphic)
  if graphic.layers then
    for _, layer in ipairs(graphic.layers) do
      tint_sprite(layer, WALL_TINT)
    end
  elseif graphic.sheets then
    for _, sheet in ipairs(graphic.sheets) do
      tint_sprite(sheet, WALL_TINT)
    end
  elseif graphic.filename then
    tint_sprite(graphic, WALL_TINT)
  end
end

local function tint_wall_pictures(pictures)
  for _, graphic in pairs(pictures) do
    tint_wall_graphics(graphic)
  end
end

local vanilla_wall = data.raw.wall["stone-wall"]
local stone_wall = table.deepcopy(vanilla_wall)
stone_wall.name = "nullius-stone-wall"
stone_wall.localised_name = { "entity-name.nullius-stone-wall" }
stone_wall.localised_description = { "entity-description.nullius-stone-wall" }
stone_wall.max_health = vanilla_wall.max_health * 0.5
stone_wall.minable = { mining_time = 0.4, result = "nullius-stone-wall" }
stone_wall.visual_merge_group = 1
if stone_wall.pictures then
  tint_wall_pictures(stone_wall.pictures)
end

data:extend({
  {
    type = "item",
    name = "nullius-stone-wall",
    localised_name = { "item-name.nullius-stone-wall" },
    localised_description = { "item-description.nullius-stone-wall" },
    icons = {
      {
        icon = "__base__/graphics/icons/wall.png",
        icon_size = 64,
      },
      {
        icon = "__base__/graphics/icons/stone-brick.png",
        icon_size = 64,
        tint = WALL_TINT,
        scale = 0.25,
        shift = { -12, -12 },
      },
    },
    subgroup = "concrete",
    order = "nullius-dd",
    place_result = "nullius-stone-wall",
    stack_size = 200,
  },
  stone_wall,
  {
    type = "recipe",
    name = "nullius-stone-wall",
    localised_name = { "item-name.nullius-stone-wall" },
    icons = {
      {
        icon = "__base__/graphics/icons/wall.png",
        icon_size = 64,
      },
      {
        icon = "__base__/graphics/icons/stone-brick.png",
        icon_size = 64,
        tint = WALL_TINT,
        scale = 0.25,
        shift = { -12, -12 },
      },
    },
    subgroup = "concrete",
    order = "nullius-dd",
    enabled = false,
    category = "medium-crafting",
    always_show_made_in = true,
    energy_required = 4,
    ingredients = {
      { type = "item", name = "stone-brick", amount = 5 },
    },
    results = {
      { type = "item", name = "nullius-stone-wall", amount = 1 },
    },
  },
})
