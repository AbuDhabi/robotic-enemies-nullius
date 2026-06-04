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

-- Placeholder: wire future defense tech branch after demolitions exists.
if data.raw.technology["nullius-demolitions-1"] then
  -- add_prerequisite("nullius-robotic-defense-1", "nullius-demolitions-1")
end
