-- Nullius demolition ammo uses target_type = "position" (shoot the ground). That disables
-- enemy auto-targeting for guns and rocket launchers. Switch to entity targeting for combat.

local COMBAT_AMMO = {
  "nullius-magazine",
  "nullius-magazine-2",
  "nullius-missile-1",
  "nullius-missile-2",
}

local function apply()
  for _, name in ipairs(COMBAT_AMMO) do
    local ammo = data.raw.ammo[name]
    if ammo and ammo.ammo_type then
      ammo.ammo_type.target_type = "entity"
    end
  end
end

return {
  apply = apply,
}
