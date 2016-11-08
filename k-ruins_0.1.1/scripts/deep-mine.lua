-- register data
remote.call("k-monuments", "register_monument", {
    name = "deep-mine",
    entity_name = "deep-mine-ruined",
    parent_mod_name = "k-ruins",
    position = {
      offset = { 500, 800 },
    },
    upgrades = {
      ["restored-deep-mine"] = {
        entity_name = "deep-mine",
        attract_biters = {
          chance = 0.5,
          cycle = 90 * Time.SECOND,
          count = { 2, 40 },
        }
      }
    }
  })

remote.call( "k-composite-entities", "register_composite", {
      base_entity = "deep-mine-ruined",
      destroy_origional = false,
      component_entities = {
        { entity_name = "invisible-label-1x1", offset = { x=0, y=0 }, operable=false, lable="Ruined Mine" },
      }
    })

local iron_chest_offset = { x=-1, y=0 }
local copper_chest_offset = { x=1, y=0 }
remote.call( "k-composite-entities", "register_composite", {
      base_entity = "deep-mine",
      destroy_origional = false,
      component_entities = {
        { entity_name = "underground-belt", offset = iron_chest_offset, operable=false, type="output", direction=4 },
        { entity_name = "underground-belt", offset = copper_chest_offset, operable=false, type="output", direction=4 }
      }
    })
  
Event.register(defines.events.on_tick, function(event)
  if game.tick % 60 == 0 then
    -- iron
    local _surface = game.surfaces["nauvis"]
    local _global_data = remote.call("k-monuments", "get_global_data", "deep-mine")
    local _position = Tile.from_position( Position.add( _global_data.position, iron_chest_offset ) )
    local _entity = _surface.find_entity("underground-belt", _position)
    if _entity then
      _entity.insert( {name="iron-ore", count=40} )
    end
  elseif game.tick % 60 == 30 then
    -- copper
    local _surface = game.surfaces["nauvis"]
    local _global_data = remote.call("k-monuments", "get_global_data", "deep-mine")
    local _position = Position.add( _global_data.position, copper_chest_offset )
    local _entity = _surface.find_entity("wooden-chest",_position)
    if _entity then
      _entity.insert( {name="copper-ore", count=40} )
    end
  end
end)