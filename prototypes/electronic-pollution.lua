-- Zero ren-data / pollution emissions for entities whose construction recipes never
-- require electronics (processors, circuits, sensors, modules, wires, etc.), including
-- indirect dependencies through intermediate items.

local electronic_pollution = {}

local SEED_ITEMS = {
  ["arithmetic-combinator"] = true,
  ["constant-combinator"] = true,
  ["decider-combinator"] = true,
  ["programmable-speaker"] = true,
  ["copper-cable"] = true,
  ["electronic-circuit"] = true,
  ["advanced-circuit"] = true,
  ["processing-unit"] = true,
  ["small-lamp"] = true,
  ["rail-signal"] = true,
  ["rail-chain-signal"] = true,
}

local SEED_PATTERNS = {
  "processor",
  "coprocessor",
  "sensor",
  "module",
  "circuit",
  "memory",
  "display",
  "antenna",
  "signal",
  "capacitor",
  "relay",
  "combinator",
  "speaker",
  "robot%-frame",
  "construction%-bot",
  "logistic%-bot",
  "grid%-battery",
  "battery",
  "solar%-panel",
  "transformer",
  "sensor%-node",
  "optical",
  "roboport",
  "beacon",
  "radar",
  "accumulator",
  "green%-wire",
  "red%-wire",
  "copper%-wire",
  "copper%-cable",
  "transponder",
  "transceiver",
  "lamp%-",
  "%-lamp",
  "drone%-launcher",
}

local function is_electronic_seed(name)
  if SEED_ITEMS[name] then
    return true
  end
  for _, pattern in ipairs(SEED_PATTERNS) do
    if name:find(pattern) then
      return true
    end
  end
  return false
end

local function is_classification_recipe(recipe)
  if not recipe or not recipe.name then
    return false
  end
  if recipe.category == "packaging" then
    return false
  end
  if recipe.name:match("^nullius%-unbox%-") then
    return false
  end
  if recipe.name:match("^nullius%-box%-") and not recipe.name:match("^nullius%-boxed%-") then
    return false
  end
  return true
end

local function unbox_item_name(name)
  local base = name:match("^nullius%-box%-(.+)$")
  if base then
    return "nullius-" .. base
  end
  return nil
end

local function ingredient_requires_electronics(name, requires_electronics)
  if requires_electronics[name] then
    return true
  end
  local nullius_name = unbox_item_name(name)
  if nullius_name and requires_electronics[nullius_name] then
    return true
  end
  return false
end

local function recipe_requires_electronics(recipe, requires_electronics)
  for _, ingredient in ipairs(recipe.ingredients or {}) do
    if ingredient.type == "item" and ingredient.name and ingredient_requires_electronics(ingredient.name, requires_electronics) then
      return true
    end
  end
  return false
end

local function build_recipes_by_product()
  local recipes_by_product = {}
  for _, recipe in pairs(data.raw.recipe or {}) do
    if is_classification_recipe(recipe) then
      for _, result in ipairs(recipe.results or {}) do
        if result.type == "item" and result.name then
          local recipes = recipes_by_product[result.name]
          if not recipes then
            recipes = {}
            recipes_by_product[result.name] = recipes
          end
          table.insert(recipes, recipe)
        end
      end
    end
  end
  return recipes_by_product
end

local function compute_requires_electronics(name, requires_electronics, recipes_by_product)
  if is_electronic_seed(name) then
    return true
  end

  local recipes = recipes_by_product[name]
  if not recipes then
    return false
  end

  for _, recipe in ipairs(recipes) do
    if not recipe_requires_electronics(recipe, requires_electronics) then
      return false
    end
  end

  return true
end

local function build_requires_electronics_set()
  local requires_electronics = {}
  local recipes_by_product = build_recipes_by_product()

  for name in pairs(data.raw.item or {}) do
    requires_electronics[name] = is_electronic_seed(name)
  end

  local changed = true
  while changed do
    changed = false
    for name in pairs(data.raw.item or {}) do
      local new_value = compute_requires_electronics(name, requires_electronics, recipes_by_product)
      if requires_electronics[name] ~= new_value then
        requires_electronics[name] = new_value
        changed = true
      end
    end
  end

  return requires_electronics
end

local function build_entity_items()
  local entity_items = {}

  for _, item in pairs(data.raw.item or {}) do
    if item.place_result then
      entity_items[item.place_result] = item.name
    end
  end

  for _, prototypes in pairs(data.raw) do
    if type(prototypes) == "table" then
      for name, entity in pairs(prototypes) do
        if type(entity) == "table" and entity.minable and entity.minable.result then
          entity_items[name] = entity.minable.result
        end
      end
    end
  end

  return entity_items
end

local function has_data_emissions(emissions)
  if not emissions then
    return false
  end
  local pollution = emissions.pollution or emissions["ren-data"]
  return pollution ~= nil and pollution ~= 0
end

local function clear_data_emissions(emissions)
  if not emissions then
    return
  end
  emissions.pollution = nil
  emissions["ren-data"] = nil
end

local function entity_has_data_emissions(entity)
  if has_data_emissions(entity.emissions_per_minute) then
    return true
  end
  if entity.energy_source and has_data_emissions(entity.energy_source.emissions_per_minute) then
    return true
  end
  if entity.burner and has_data_emissions(entity.burner.emissions) then
    return true
  end
  return false
end

local function clear_entity_data_emissions(entity)
  clear_data_emissions(entity.emissions_per_minute)
  if entity.energy_source then
    clear_data_emissions(entity.energy_source.emissions_per_minute)
  end
  if entity.burner then
    clear_data_emissions(entity.burner.emissions)
  end
end

function electronic_pollution.apply()
  local requires_electronics = build_requires_electronics_set()
  local entity_items = build_entity_items()
  local cleared = 0
  local cleared_enemy = 0
  local kept_electronic = 0
  local kept_unknown = 0

  for _, prototypes in pairs(data.raw) do
    if type(prototypes) == "table" then
      for name, entity in pairs(prototypes) do
        if type(entity) == "table" and name:sub(1, 4) == "ren-" then
          clear_entity_data_emissions(entity)
          cleared_enemy = cleared_enemy + 1
        end
      end
    end
  end

  for _, prototypes in pairs(data.raw) do
    if type(prototypes) == "table" then
      for name, entity in pairs(prototypes) do
        if type(entity) == "table" and name:sub(1, 4) ~= "ren-" and entity_has_data_emissions(entity) then
          local item_name = entity_items[name]
            if not item_name then
              kept_unknown = kept_unknown + 1
            elseif requires_electronics[item_name] then
              kept_electronic = kept_electronic + 1
            else
              clear_entity_data_emissions(entity)
              cleared = cleared + 1
            end
        end
      end
    end
  end

  log(string.format(
    "[robotic-enemies-nullius] Data emissions: cleared %d non-electronic, %d enemy, kept %d electronic, %d unknown item",
    cleared,
    cleared_enemy,
    kept_electronic,
    kept_unknown
  ))
end

return electronic_pollution
