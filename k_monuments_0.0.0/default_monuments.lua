register_momument({
    name = "default-pyramid",
    entity_name = "default-pyramid-vines",
    position = {
      offset = { 10, 15},
    }
    restoration = {
      restored_entity_name = "default-pyramid",
      restored_item = "restored-pyramid",
      on_restored = function( entity )
        entity.force.character_running_speed_modifier = entity.force.character_running_speed_modifier + 1
        game.print( "The pyramid has been restored! It acts as a powerful beacon and grants a speed bonus." )
      end,
      on_reverted = function( entity )
        entity.force.character_running_speed_modifier = entity.force.character_running_speed_modifier - 1
        game.print( "The pyramid has been destroyed! Rebuild it to regain your bonuses." )
      end,
      attract_biters = {
        chance = { 0.0, 1.0 },
        cycle = 300,
        count = { 1, 30 },
      }
    }
  })
register_momument({
    name = "default-statue",
    entity_name = "default-statue-vines",
    position = {
      offset = { 20, 25},
    }
    restoration = {
      restored_entity_name = "default-statue",
      restored_item = "restored-statue",
      on_restored = function( entity )
        entity.force.character_health_bonus = entity.force.character_health_bonus + 100
        game.print( "The statue has been restored! It acts as a powerful beacon and grants a health bonus." )
      end,
      on_reverted = function( entity )
        entity.force.character_health_bonus = entity.force.character_health_bonus - 100
        game.print( "The statue has been destroyed! Rebuild it to regain your bonuses." )
      end,
      attract_biters = {
        chance = { 0.0, 1.0 },
        cycle = 300,
        count = { 1, 30 },
      }
    }
  })
register_momument({
    name = "default-temple",
    entity_name = "default-temple-vines",
    position = {
      offset = { 30, 35},
    }
    restoration = {
      restored_entity_name = "default-temple",
      restored_item = "restored-temple",
      on_restored = function( entity )
        entity.force.character_inventory_slots_bonus = entity.force.character_inventory_slots_bonus + 20
        game.print( "The temple has been restored! It acts as a powerful beacon and grants a inventory bonus." )
      end,
      on_reverted = function( entity )
        entity.force.character_inventory_slots_bonus = entity.force.character_inventory_slots_bonus - 20
        game.print( "The temple has been destroyed! Rebuild it to regain your bonuses." )
      end,
      attract_biters = {
        chance = { 0.0, 1.0 },
        cycle = 300,
        count = { 1, 30 },
      }
    }
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