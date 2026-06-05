local function hyphen_to_underscore(str)
  return string.gsub(str, "-", "_")
end

return {
  hyphen_to_underscore = hyphen_to_underscore,
  BASE_CHECK_RADIUS = 30,
  BASE_PLACE_RADIUS = 10,
  TURRET_FILL_RADIUS = 20,
  -- Wall ring sits this many tiles outside the base convex hull (room for spawner + vehicles).
  WALL_HULL_EXPANSION = 5,
  -- Clear opening width on each hull face so buggies/tanks can leave the compound.
  WALL_GATE_WIDTH = 5,
  TURRET_TYPES = {
    "gun-turret",
    "laser-turret",
    "flamethrower-turret",
  },
}
