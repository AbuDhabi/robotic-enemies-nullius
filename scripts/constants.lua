local M = {}

M.SURFACE = "nauvis"
M.SPAWNER = "ren-data-collector"
M.TANK = "ren-enemy-tank"
M.POLLUTANT = "ren-data"

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
