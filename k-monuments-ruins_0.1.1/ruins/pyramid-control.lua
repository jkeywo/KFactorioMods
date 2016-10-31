
-- register data
remote.call("k-monuments", "register_monument", {
    name = "default-pyramid",
    entity_name = "default-pyramid-vines",
    parent_mod_name = "k-monuments-ruins",
    position = {
      offset = { 300, 400 },
    },
    upgrades = {
      ["restored-pyramid"] = {
        entity_name = "default-pyramid",
        attract_biters = {
          chance = { 0.0, 0.5 },
          cycle = 300,
          count = { 1, 10 },
        }
      }
    }
  })

-- set event callbacks
event_callbacks["default-pyramid"] = {
  ["upgrade"] = function (event)
    event.entity.force.character_running_speed_modifier = event.entity.force.character_running_speed_modifier + 0.2
  end,
  ["downgrade"] = function (event)
    event.entity.force.character_running_speed_modifier = event.entity.force.character_running_speed_modifier - 0.2
  end
}

-- reveal on research
Event.register(defines.events.on_research_finished, function(event)
  local _ingredients = event.research.research_unit_ingredients
  for _, _ingredient in pairs(_ingredients) do
    if _ingredient.name == "science-pack-1" then
      remote.call("k-monuments", "reveal_monument", "default-pyramid")
    end
  end
end)
