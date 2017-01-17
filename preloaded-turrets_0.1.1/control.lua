
require("config")

local function on_built( entity )
  local _recipe = entity.force.recipes[entity.name]
  if not _recipe or not _recipe.ingredients[2] then return end
  local _ammo_name = _recipe.ingredients[2].name
  local _ammo_count = _recipe.ingredients[2].amount
  
  if not entity.get_inventory(defines.inventory.turret_ammo) then return end
  entity.get_inventory(defines.inventory.turret_ammo).insert( { name=_ammo_name, count=_ammo_count} )
end

script.on_event(defines.events.on_built_entity, function(event)
    if string.sub(event.created_entity.name, 1, 10) == "preloaded-" then
      on_built( event.created_entity )
    end
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
    if string.sub(event.created_entity.name, 1, 10) == "preloaded-" then
      on_built( event.created_entity )
    end
end)