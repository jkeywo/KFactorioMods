
-- register data
remote.call("k-monuments", "register_monument", {
    name = "default-temple",
    entity_name = "default-temple-vines",
    parent_mod_name = "k-monuments-ruins",
    position = {
      offset = { 1200, 1600},
    },
    upgrades = {
      ["restored-temple"] = {
        entity_name = "default-temple",
        attract_biters = {
          chance = { 0.5, 1.0 },
          cycle = 300,
          count = { 1, 30 }
        }
      }
    }
  })

-- set event callbacks
event_callbacks["default-temple"] = {
  ["upgrade"] = function(event)
    event.entity.force.character_inventory_slots_bonus = event.entity.force.character_inventory_slots_bonus + 16
  end,
  ["downgrade"] = function(event)
    event.entity.force.character_inventory_slots_bonus = event.entity.force.character_inventory_slots_bonus - 16
  end
}

-- reveal on research
Event.register(defines.events.on_research_finished, function(event)
  local _ingredients = event.research.research_unit_ingredients
  for _, _ingredient in pairs(_ingredients) do
    if _ingredient.name == "science-pack-3" then
      remote.call("k-monuments", "reveal_monument", "default-temple")
    end
  end
end)