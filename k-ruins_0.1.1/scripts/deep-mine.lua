-- register data
local _data = {
    name = "deep-mine",
    entity_name = "deep-mine-ruined",
    parent_mod_name = "k-ruins",
    position = {
      offset = { 50, 80 },
    },
    upgrades = {
      ["restored-deep-mine"] = {
        entity_name = "deep-mine",
        attract_biters = {
          chance = 0.5,
          cycle = 90 * Time.SECOND,
          count = { 2, 40 },
        },
        on_placed = script.generate_event_name(),
        on_removed = script.generate_event_name()
      }
    }
  }
  
remote.call( "k-monuments", "register_monument", _data )
Event.register( _data.upgrades["restored-deep-mine"].on_placed, function(event)
  global.deep_mine = global.deep_mine or {}
  -- add underground belts to global data
  global.deep_mine.iron = event.entities[2]
  global.deep_mine.copper = event.entities[3]
end)
Event.register( _data.upgrades["restored-deep-mine"].on_removed, function(event)
  -- remove underground belts from global data
  global.deep_mine = nil
end)

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "deep-mine-ruined",
      destroy_origional = false,
      component_entities = {
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Ruined Mine" },
      }
    })

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "deep-mine",
      destroy_origional = false,
      component_entities = {
        { entity_name = "steel-chest", offset = { x=-1, y=0 }, operable=false },
        { entity_name = "steel-chest", offset = { x=1, y=0 }, operable=false }
      }
    })
  
Event.register(defines.events.on_tick, function(event)
  if game.tick % 9 == 0 and global.deep_mine then
    -- iron
    if global.deep_mine.iron then
      global.deep_mine.iron.insert( {name="iron-ore", count=2} )
    end
    -- copper
    if global.deep_mine.copper then
      global.deep_mine.copper.insert( {name="copper-ore", count=2} )
    end
  end
end)