

-- register data
remote.call("k-monuments", "register_monument", {
    name = "default-statue",
    entity_name = "default-statue-vines",
    parent_mod_name = "k-monuments-ruins",
    position = {
      offset = { 600, 800},
    },
    upgrades = {
      {
        entity_name = "default-statue",
        upgrade_item = "restored-statue",
        attract_biters = {
          chance = { 0.25, 0.75 },
          cycle = 300,
          count = { 1, 20 },
        }
      }
    }
  })

-- set event callbacks
event_callbacks["default-statue"] = {
  ["upgrade"] = function (event)
    event.entity.force.character_health_bonus = event.entity.force.character_health_bonus + 100
  end,
  ["downgrade"] = function (event)
    event.entity.force.character_health_bonus = event.entity.force.character_health_bonus - 100
  end
}

-- reveal on research
Event.register(defines.events.on_research_finished, function(event)
  local _ingredients = event.research.research_unit_ingredients
  for _, _ingredient in pairs(_ingredients) do
    if _ingredient.name == "science-pack-2" then
      remote.call("k-monuments", "reveal_monument", "default-statue")
    end
  end
end)