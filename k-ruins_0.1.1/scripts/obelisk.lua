
for i = 1, Config.obelisks do
  local _data = {
    name = "obelisk-"..i,
    localised_name="obelisk",
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
          cycle = 300 * Time.SECOND,
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
    
    local _force = event.entities[1].force
    local _id = _force.name
    
    local _restored = global.obelisk_modifiers[_id] or 0
    _restored = _restored + 1
    global.obelisk_modifiers[_id] = _restored
  
    remote.call("k-abilities", "add_ability", _force, obelisk_abilities[_restored].name )
  end)

  Event.register( _data.upgrades["restored-obelisk"].on_removed, function(event)
    global.obelisk_modifiers = global.obelisk_modifiers or {}
    
    local _force = event.entities[1].force
    local _id = _force.name
    
    local _lost = global.obelisk_modifiers[_id]
    if _lost then
      remote.call("k-abilities", "remove_ability", _force, obelisk_abilities[_lost].name )
      global.obelisk_modifiers[_id] = _lost - 1
    end
  end)
end

Event.register( obelisk_abilities[1].on_trigger, function(event)
    event.player.teleport(event.target)
end)

Event.register( obelisk_abilities[2].on_trigger, function(event)
  global.bubbles = global.bubbles or {}
  table.insert( global.bubbles, { entity = event.player.entity, timer = 300 } )
  event.player.entity.damagable = false
end)

Event.register( obelisk_abilities[3].on_trigger, function(event)
  for i = 1, 10 do
    event.player.surface.create_entity { name = "destroyer", position = event.player.position, force = event.player.force }
  end
end)

remote.call( "k-composite-entities", "register_composite", {
    base_entity = "obelisk-ruined",
    destroy_origional = false,
    component_entities = {
      { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Ruined Obelisk" }
    }
  })

Event.register(defines.events.on_tick, function(event)
  global.bubbles = global.bubbles or {}
  for _index, _bubble in pairs(global.bubbles) do
    _bubble.timer = _bubble.timer - 1
    if _bubble.timer >= 0 then
      _bubble.entity.damagable = true
      table.remove(_index)
    end
  end
end)

-- reveal on research
Event.register(defines.events.on_research_finished, function(event)
  local _ingredients = event.research.research_unit_ingredients
  for _, _ingredient in pairs(_ingredients) do
    if _ingredient.name == "science-pack-2" then
      for i = 1, Config.obelisks do
        remote.call("k-monuments", "reveal_monument", "obelisk-"..i)
      end
    end
  end
end)
