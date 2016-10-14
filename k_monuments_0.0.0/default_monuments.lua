register_momument({
    name = "default-pyramid",
    distance = { 10, 15},
    entity_name = "default-pyramid-vines",
    use_renovation_behaviour = true,
    renovated_entity_name = "default-pyramid",
    renovate_item = "restored-pyramid",
    on_restored = function( entity )
      entity.force.character_running_speed_modifier = entity.force.character_running_speed_modifier + 1
      -- TODO schedule biter attacks
      game.print( "The pyramid has been restored! It acts as a powerful beacon and grants a speed bonus." )
    end,
    on_reverted = function( entity )
      entity.force.character_running_speed_modifier = entity.force.character_running_speed_modifier - 1
      -- TODO unschedule biter attacks
      game.print( "The pyramid has been destroyed! Rebuild it to regain your bonuses." )
    end
  })
register_momument({
    name = "default-statue",
    distance = { 20, 25},
    entity_name = "default-statue-vines",
    use_renovation_behaviour = true,
    renovated_entity_name = "default-statue",
    renovate_item = "restored-statue",
    on_restored = function( entity )
      entity.force.character_health_bonus = entity.force.character_health_bonus + 100
      -- TODO schedule biter attacks
      game.print( "The statue has been restored! It acts as a powerful beacon and grants a health bonus." )
    end,
    on_reverted = function( entity )
      entity.force.character_health_bonus = entity.force.character_health_bonus - 100
      -- TODO unschedule biter attacks
      game.print( "The statue has been destroyed! Rebuild it to regain your bonuses." )
    end
  })
register_momument({
    name = "default-temple",
    distance = { 30, 35},
    entity_name = "default-temple-vines",
    use_renovation_behaviour = true,
    renovated_entity_name = "default-temple",
    renovate_item = "restored-temple",
    on_restored = function( entity )
      entity.force.character_inventory_slots_bonus = entity.force.character_inventory_slots_bonus + 20
      -- TODO schedule biter attacks
      game.print( "The temple has been restored! It acts as a powerful beacon and grants a inventory bonus." )
    end,
    on_reverted = function( entity )
      entity.force.character_inventory_slots_bonus = entity.force.character_inventory_slots_bonus - 20
      -- TODO unschedule biter attacks
      game.print( "The temple has been destroyed! Rebuild it to regain your bonuses." )
    end
  })

Event.register(defines.events.on_research_finished, function(event)
  local _ingredients = event.research.research_unit_ingredients
  for _, _ingredient in pairs(_ingredients) do
    if _ingredient.name == "science-pack-1" then
      reveal_momument("default-pyramid")
    elseif _ingredient.name == "science-pack-2" then
      reveal_momument("default-statue")
    elseif _ingredient.name == "science-pack-3" then
      reveal_momument("default-temple")
    end
  end
end)