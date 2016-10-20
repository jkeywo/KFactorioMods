require("stdlib.event.event")

remote.call("k-monuments", "register_monument", {
    name = "default-pyramid",
    entity_name = "default-pyramid-vines",
    position = {
      offset = { 10, 15},
    },
    upgrades = {
      {
        entity_name = "default-pyramid",
        upgrade_item = "restored-pyramid",
        attract_biters = {
          chance = { 0.0, 1.0 },
          cycle = 300,
          count = { 1, 30 },
        }
      }
    }
  })

remote.call("k-monuments", "register_monument", {
    name = "default-statue",
    entity_name = "default-statue-vines",
    position = {
      offset = { 20, 25},
    },
    upgrades = {
      {
        entity_name = "default-statue",
        upgrade_item = "restored-statue",
        attract_biters = {
          chance = { 0.0, 1.0 },
          cycle = 300,
          count = { 1, 30 },
        }
      }
    }
  })

remote.call("k-monuments", "register_monument", {
    name = "default-temple",
    entity_name = "default-temple-vines",
    position = {
      offset = { 30, 35},
    },
    upgrades = {
      entity_name = "default-temple",
      upgrade_item = "restored-temple",
      attract_biters = {
        chance = { 0.0, 1.0 },
        cycle = 300,
        count = { 1, 30 },
      }
    }
  })

Event.register(defines.events.on_tick, function(event)
  local _event_queue = remote.call("k-monuments", "get_events")
  if not _event_queue then return end
  for _, _event in pairs(_event_queue) do
    if _event.type == "upgrade" then
      if _event.name == "default-pyramid" then
        _event.entity.force.character_running_speed_modifier = _event.entity.force.character_running_speed_modifier + 1
        game.print( "The pyramid has been restored! It acts as a powerful beacon and grants a speed bonus." )
      elseif _event.name == "default-statue" then
        _event.entity.force.character_health_bonus = _event.entity.force.character_health_bonus + 100
        game.print( "The statue has been restored! It acts as a powerful beacon and grants a health bonus." )
      elseif _event.name == "default-temple" then
        _event.entity.force.character_inventory_slots_bonus = _event.entity.force.character_inventory_slots_bonus + 20
        game.print( "The temple has been restored! It acts as a powerful beacon and grants a inventory bonus." )
      end
    elseif _event.type == "downgrade" then
      if _event.name == "default-pyramid" then
        _event.entity.force.character_running_speed_modifier = _event.entity.force.character_running_speed_modifier - 1
        game.print( "The pyramid has been destroyed! Rebuild it to regain your bonuses." )
      elseif _event.name == "default-statue" then
        _event.entity.force.character_health_bonus = _event.entity.force.character_health_bonus - 100
        game.print( "The statue has been destroyed! Rebuild it to regain your bonuses." )
      elseif _event.name == "default-temple" then
        _event.entity.force.character_inventory_slots_bonus = _event.entity.force.character_inventory_slots_bonus - 20
        game.print( "The temple has been destroyed! Rebuild it to regain your bonuses." )
      end
    end
  end
  remote.call("k-monuments", "clear_events" )
end)

Event.register(defines.events.on_research_finished, function(event)
  local _ingredients = event.research.research_unit_ingredients
  for _, _ingredient in pairs(_ingredients) do
    if _ingredient.name == "science-pack-1" then
      remote.call("k-monuments", "reveal_monument", "default-pyramid")
    elseif _ingredient.name == "science-pack-2" then
      remote.call("k-monuments", "reveal_monument", "default-statue")
    elseif _ingredient.name == "science-pack-3" then
      remote.call("k-monuments", "reveal_monument", "default-temple")
    end
  end
end)