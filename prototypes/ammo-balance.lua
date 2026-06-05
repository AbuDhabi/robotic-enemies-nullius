-- Nullius demolition ammo uses area bursts far above vanilla combat values. Realign with base game.

local VANILLA_BULLET_AMMO = {
  ["nullius-magazine"] = "piercing-rounds-magazine",
  ["nullius-magazine-2"] = "uranium-rounds-magazine",
}

local function apply()
  for nullius_name, vanilla_name in pairs(VANILLA_BULLET_AMMO) do
    local ammo = data.raw.ammo[nullius_name]
    local vanilla = data.raw.ammo[vanilla_name]
    if ammo and vanilla and vanilla.ammo_type then
      ammo.ammo_type = table.deepcopy(vanilla.ammo_type)
    end
  end

  local missile = data.raw.ammo["nullius-missile-1"]
  local rocket = data.raw.ammo["explosive-rocket"]
  if missile and rocket and rocket.ammo_type then
    missile.ammo_type = table.deepcopy(rocket.ammo_type)
  end
end

return {
  apply = apply,
}
