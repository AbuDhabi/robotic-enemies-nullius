local M = {}

M.SURFACE = "nauvis"
M.SPAWNER = "ren-data-collector"
M.ANDROID = "ren-enemy-android"
M.BUGGY = "ren-enemy-buggy"
M.TANK = "ren-enemy-tank"
M.KAMIKAZE = "ren-enemy-kamikaze"
M.SPIDER = "ren-enemy-spider"
M.VEHICLE_UNITS = { M.ANDROID, M.BUGGY, M.TANK, M.KAMIKAZE, M.SPIDER }
M.POLLUTANT = "ren-data"

-- Enemy bases never generate within this distance of map origin (spawn).
M.MIN_BASE_SPAWN_DISTANCE = 600

M.EVOLUTION_UNLOCK = {
  [M.ANDROID] = 0,
  [M.BUGGY] = 0.1,
  [M.TANK] = 0.35,
  [M.KAMIKAZE] = 0.5,
  [M.SPIDER] = 0.65,
}

-- Enemy damage scales 1x at evolution 0, 4x at evolution 1 (+300%).
M.EVOLUTION_DAMAGE_FACTOR = 3

function M.evolution_combat_multiplier(evolution)
  return 1 + M.EVOLUTION_DAMAGE_FACTOR * evolution
end

function M.is_vehicle_unit(name)
  return M.EVOLUTION_UNLOCK[name] ~= nil
end

function M.on_nauvis(surface)
  return surface and surface.name == M.SURFACE
end

function M.nauvis_exists()
  if not game then
    return true
  end
  return game.surfaces[M.SURFACE] ~= nil
end

return M
