local M = {}

local DEMOLITIONS_1 = "nullius-demolitions-1"
local IMPROVISED_MAGAZINE = "nullius-magazine-improvised"

function M.sync_force(force)
  if force.name == "enemy" or force.name == "neutral" then
    return
  end

  local demolitions = force.technologies[DEMOLITIONS_1]
  local recipe = force.recipes[IMPROVISED_MAGAZINE]
  if not demolitions or not recipe then
    return
  end

  if demolitions.researched then
    recipe.enabled = false
  end
end

function M.sync_all_forces()
  for _, force in pairs(game.forces) do
    M.sync_force(force)
  end
end

function M.register()
  script.on_event(defines.events.on_research_finished, function(event)
    if event.research.name == DEMOLITIONS_1 then
      M.sync_force(event.research.force)
    end
  end)
end

return M
