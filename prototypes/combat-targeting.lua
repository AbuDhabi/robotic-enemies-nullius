-- Nullius demolition ammo can use target_type = "position" (shoot the ground). Entity targeting
-- enables auto-aim against robotic enemies.

local MAGAZINE_AMMO = {
  "nullius-magazine",
  "nullius-magazine-2",
}

local function apply_entity_targeting()
  for _, name in ipairs(MAGAZINE_AMMO) do
    local ammo = data.raw.ammo[name]
    if ammo and ammo.ammo_type then
      ammo.ammo_type.target_type = "entity"
    end
  end
end

local function apply_demolition_targeting()
  for _, name in ipairs(MAGAZINE_AMMO) do
    local ammo = data.raw.ammo[name]
    if ammo and ammo.ammo_type then
      ammo.ammo_type.target_type = "position"
    end
  end
end

return {
  apply_entity_targeting = apply_entity_targeting,
  apply_demolition_targeting = apply_demolition_targeting,
}
