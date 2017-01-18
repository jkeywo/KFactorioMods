
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

script.on_configuration_changed( function( change_data )
  -- rescan technology unlocks
  for _, _force in pairs(game.forces) do
    for _, _tech in pairs(_force.technologies) do
      if _tech.enabled then
        for _, _effect in pairs(_tech.effects) do
          if _effect.type == "unlock-recipe" and string.sub(_effect.recipe, 1, 10) == "preloaded-" then
            _force.recipes[_effect.recipe].enabled = true
          end
        end
      end
    end
  end
end)