local function hyphen_to_underscore(str)
  return string.gsub(str, "-", "_")
end

return {
  hyphen_to_underscore = hyphen_to_underscore,
  BASE_CHECK_RADIUS = 30,
  BASE_PLACE_RADIUS = 10,
  TURRET_FILL_RADIUS = 20,
  TURRET_TYPES = {
    "gun-turret",
    "laser-turret",
    "flamethrower-turret",
  },
}
