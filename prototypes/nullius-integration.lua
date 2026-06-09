-- Nullius hides non-nullius items/recipes/techs in prototypes/hidden.lua (data-updates).
-- Anything we add for players or enemies must either:
--   * use a nullius- name and nullius- order on recipes/technologies, or
--   * be produced by a nullius- recipe so temphidden is cleared.
--
-- Do NOT unhide vanilla pistol: nullius-gun fills that production-chain role.
-- Extend nullius-demolitions-* and add nullius-robotic-defense-* techs for combat gear.

local function add_prerequisite(tech_name, prerequisite)
  local tech = data.raw.technology[tech_name]
  if tech and tech.prerequisites then
    for _, name in ipairs(tech.prerequisites) do
      if name == prerequisite then
        return
      end
    end
    table.insert(tech.prerequisites, prerequisite)
  end
end

local function add_unlock_recipe(tech_name, recipe_name)
  local tech = data.raw.technology[tech_name]
  if not tech then
    return
  end
  for _, effect in ipairs(tech.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      return
    end
  end
  tech.effects = tech.effects or {}
  table.insert(tech.effects, { type = "unlock-recipe", recipe = recipe_name })
end

local function remove_unlock_recipe(tech_name, recipe_name)
  local tech = data.raw.technology[tech_name]
  if not tech or not tech.effects then
    return
  end
  for index = #tech.effects, 1, -1 do
    local effect = tech.effects[index]
    if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
      table.remove(tech.effects, index)
    end
  end
end

remove_unlock_recipe("nullius-demolitions-1", "nullius-gun")
add_prerequisite("nullius-demolitions-1", "nullius-self-defense-2")
add_unlock_recipe("nullius-masonry-2", "nullius-stone-wall")
