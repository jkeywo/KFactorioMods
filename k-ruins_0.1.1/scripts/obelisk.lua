
-- register data
for i = 1, #Config.obelisks do
  local _data = {
    name = "obelisk-"..i,
    localised_name="obelisk"
    entity_name = "obelisk-ruined",
    parent_mod_name = "k-ruins",
    position = {
      offset = { 300, 1200 },
    },
    upgrades = {
      ["restored-obelisk"] = {
        entity_name = "obelisk",
        attract_biters = {
          chance = { 0.0, 0.75 },
          cycle = 300,
          count = { 1, 20 },
        },
        on_placed = script.generate_event_name(),
        on_removed = script.generate_event_name()
      }
    }
  }
  remote.call( "k-monuments", "register_monument", _data )
  
  Event.register( _data.upgrades["restored-obelisk"].on_placed, function(event)
    global.obelisk_modifiers = global.obelisk_modifiers or {}
    global.obelisk_modifiers[event.entity.force] = (global.obelisk_modifiers[event.entity.force] + 1) or 1
    local _restored = global.obelisk_modifiers[event.entity.force]
    event.entity.force[Config.obelisks[_restored].modifier] = event.entity.force[Config.obelisks[_restored].modifier] + Config.obelisks[_restored].amount
  end)

  Event.register( _data.upgrades["restored-obelisk"].on_removed, function(event)
    global.obelisk_modifiers = global.obelisk_modifiers or {}
    local _lost = global.obelisk_modifiers[event.entity.force]
    if _lost then
      event.entity.force[Config.obelisks[_lost].modifier] = event.entity.force[Config.obelisks[_lost].modifier] - Config.obelisks[_lost].amount
      global.obelisk_modifiers[event.entity.force] = global.obelisk_modifiers[event.entity.force] - 1
    end
  end)
end

-- reveal on research
Event.register(defines.events.on_research_finished, function(event)
  local _ingredients = event.research.research_unit_ingredients
  for _, _ingredient in pairs(_ingredients) do
    if _ingredient.name == "science-pack-2" then
      for i = 1, #Config.obelisks do
        remote.call("k-monuments", "reveal_monument", "obelisk-"..i)
      end
    end
  end
end)
