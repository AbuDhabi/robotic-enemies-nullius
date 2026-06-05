-- Enemy land mines: slow the player instead of a full stun (vanilla uses stun-sticker at speed 0).

data:extend({
  {
    type = "sticker",
    name = "ren-slowdown-sticker",
    flags = { "not-on-map" },
    hidden = true,
    duration_in_ticks = 3 * 60,
    target_movement_modifier = 0.5,
    vehicle_speed_modifier = 0.5,
  },
})

local function replace_stun_sticker(effect)
  if not effect then
    return
  end
  if effect.type == "create-sticker" and effect.sticker == "stun-sticker" then
    effect.sticker = "ren-slowdown-sticker"
  end
  if effect.target_effects then
    for _, nested in pairs(effect.target_effects) do
      replace_stun_sticker(nested)
    end
  end
  if effect.source_effects then
    for _, nested in pairs(effect.source_effects) do
      replace_stun_sticker(nested)
    end
  end
  if effect.action_delivery then
    replace_stun_sticker(effect.action_delivery)
    if effect.action_delivery.target_effects then
      for _, nested in pairs(effect.action_delivery.target_effects) do
        replace_stun_sticker(nested)
      end
    end
    if effect.action_delivery.source_effects then
      for _, nested in pairs(effect.action_delivery.source_effects) do
        replace_stun_sticker(nested)
      end
    end
    if effect.action_delivery.action then
      replace_stun_sticker(effect.action_delivery.action)
    end
  end
  if effect.action then
    replace_stun_sticker(effect.action)
  end
end

local mine = table.deepcopy(data.raw["land-mine"]["land-mine"])
mine.name = "ren-land-mine"
mine.localised_name = { "entity-name.ren-land-mine" }
mine.localised_description = { "entity-description.ren-land-mine" }
mine.minable = nil
mine.fast_replaceable_group = nil
replace_stun_sticker(mine.action)

data:extend({ mine })
